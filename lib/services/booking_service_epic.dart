import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String bookingId = '';

class BookingCreateRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  BookingListState tmpBookingList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBookingRequest>().asyncMap((event) async {
      print("BOOKING_SERVICE_EPIC - BookingCreateRequestService => DOCUMENT ID: ${event.bookingState.business_id}");

      // create a unique booking code for this booking
      String randomBookingCodeCandidate;
      bool foundRandomCode = false;
      int bookingCodeCollisionDocs = 0;
      int read = 0;
      for (int i = 0; i < 5; i++) {
        // WARNING, every booking we do tops 5 reads to mitigate collisions.
        // This has a really low chance of generating a booking without a code. this is on purpose, to avoid infinite loop risk in a read statement.
        randomBookingCodeCandidate = Utils.getRandomBookingCode(6);
        debugPrint('BOOKING_SERVICE_EPIC - BookingCreateRequestService => GENERATE BOOKING CODE| Random booking code candidate: $randomBookingCodeCandidate');
        // search if the code already exists
        QuerySnapshot bookingCodeCollision = await FirebaseFirestore.instance /// ? READ - ? DOC
            .collection("booking")
            .where("booking_code", isEqualTo: randomBookingCodeCandidate)
            .get();
        bookingCodeCollisionDocs = bookingCodeCollisionDocs + bookingCodeCollision.docs.length;
        ++read;
        if (bookingCodeCollision.size > 0) {
          debugPrint('BOOKING_SERVICE_EPIC - BookingCreateRequestService => GENERATE BOOKING CODE| Code collision happening for code: $randomBookingCodeCandidate');
        } else {
          // the candidate is ok, we can break and use it
          foundRandomCode = true;
          break;
        }
      }
      if (foundRandomCode) {
        print('BOOKING_SERVICE_EPIC - BookingCreateRequestService => GENERATE BOOKING CODE| Creating booking for business: ${event.bookingState.business_id}');
        event.bookingState.booking_code = randomBookingCodeCandidate;
        // create a booking
        DocumentReference addingReturn = await FirebaseFirestore.instance /// 1 WRITE
            .collection("booking")
            .add(event.bookingState.toJson());
        bookingId = addingReturn.id;
        print('BOOKING_SERVICE_EPIC - BookingCreateRequestService =>  $addingReturn');
      } else {
        // TODO notify the user something went wrong and he has to try again.
        // example: return new ErrorInBookingCreation(event.bookingState);
      }

      bookingState = event.bookingState;
      bookingState.booking_id = bookingId;

      await FirebaseFirestore.instance /// 1 WRITE
          .collection("booking")
          .doc(bookingState.booking_id)
          .update(event.bookingState.toJson());

      debugPrint('BOOKING_SERVICE_EPIC => Start date: ${bookingState.start_date}');
      debugPrint('BOOKING_SERVICE_EPIC => End date: ${bookingState.end_date}');

      tmpBookingList = store.state.bookingList.copyWith();
      tmpBookingList.bookingListState.add(bookingState);

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingCreateRequestServiceRead;
      int writes = statisticsState.bookingCreateRequestServiceWrite;
      int documents = statisticsState.bookingCreateRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingCreateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      writes = writes + 2;
      documents = documents + bookingCodeCollisionDocs;
      debugPrint('BOOKING_SERVICE_EPIC - BookingCreateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingCreateRequestServiceRead = reads;
      statisticsState.bookingCreateRequestServiceWrite = writes;
      statisticsState.bookingCreateRequestServiceDocuments = documents;

    }).expand((element) => [
          AddBooking(bookingState),
          ClosedRequestBooking('Request success'),
          UpdateStatistics(statisticsState),
          BookingListReturned(tmpBookingList.bookingListState),
          NavigatePushAction(AppRoutes.bookingDetails),
        ]);
  }
}

///TODO: EPIC ON SELF CREATE BOOKING NAVIGATE TO BookingPage

class BookingRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BookingRequest>().asyncMap((event) async {
      print("BOOKING_SERVICE_EPIC - BookingRequestService => DOCUMENT ID: ${event.bookingId}");

      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          //.where("userEmail", arrayContains: store.state.user.email)
          .where('booking_code', isEqualTo: event.bookingId)
          //.where('status', isEqualTo: 'sent')
          .get();

      int bookingSnapshotDocs = bookingSnapshot.docs.length;
      print("BOOKING_SERVICE_EPIC - BookingRequestService => BOOKINGS LENGTH: $bookingSnapshotDocs");
      if(bookingSnapshot.docs.isNotEmpty)
        bookingState =  BookingState.fromJson(bookingSnapshot.docs.first.data());
      else{
        bookingState = BookingState().toEmpty();
        bookingState.booking_code = 'error';
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingRequestServiceRead;
      int writes = statisticsState.bookingRequestServiceWrite;
      int documents = statisticsState.bookingRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + bookingSnapshotDocs;
      debugPrint('BOOKING_SERVICE_EPIC - BookingRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingRequestServiceRead = reads;
      statisticsState.bookingRequestServiceWrite = writes;
      statisticsState.bookingRequestServiceDocuments = documents;

    }).expand((element) => [
      BookingRequestResponse(bookingState),
      UpdateStatistics(statisticsState),
      bookingState.booking_code != 'error' ? NavigatePushAction(AppRoutes.confirmBooking)/*BusinessAndNavigateOnConfirmRequest(bookingState.business_id)*/ : null,
    ]);
  }
}

class UserBookingListRequestService implements EpicClass<AppState> {
  List<BookingState> bookingListState;
  String route;
  StatisticsState statisticsState;
  bool fromConfirm = false;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UserBookingListRequest>().asyncMap((event) async {
      print("BOOKING_SERVICE_EPIC - UserBookingListRequestService => USER EMAIL: ${ event.userEmail}");
      fromConfirm = event.fromConfirm;

      QuerySnapshot openedBookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'opened')
          .get();

      int openedBookingSnapshotDocs = openedBookingSnapshot.docs.length;
      print("BOOKING_SERVICE_EPIC - UserBookingListRequestService => OPENED BOOKING LIST: $openedBookingSnapshotDocs");
      QuerySnapshot closedBookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'closed')
          .get();

      int closedBookingSnapshotDocs = closedBookingSnapshot.docs.length;
      print("BOOKING_SERVICE_EPIC - UserBookingListRequestService => CLOSED BOOKING LIST: $closedBookingSnapshotDocs");
      bookingListState = [];
      List<BookingState> openedBookingListState = [];
      List<BookingState> closedBookingListState = [];

      openedBookingSnapshot.docs.forEach((element) {
        openedBookingListState.add(BookingState.fromJson(element.data()));
        print("BOOKING_SERVICE_EPIC - UserBookingListRequestService => BOOKING: ${openedBookingListState.last.start_date}");
      });
      openedBookingListState.sort((a,b) => a.start_date.isBefore(b.start_date) ? -1 : a.start_date.isAtSameMomentAs(b.start_date) ? 0 : 1);
      //DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date))
      closedBookingSnapshot.docs.forEach((element) {
        closedBookingListState.add(BookingState.fromJson(element.data()));
      });

      closedBookingListState.sort((a,b) => a.start_date.isBefore(b.start_date) ? -1 : a.start_date.isAtSameMomentAs(b.start_date) ? 0 : 1);

      bookingListState.addAll(openedBookingListState);
      bookingListState.addAll(closedBookingListState);

      statisticsState = store.state.statistics;
      int reads = statisticsState.userBookingListRequestServiceRead;
      int writes = statisticsState.userBookingListRequestServiceWrite;
      int documents = statisticsState.userBookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - UserBookingListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + 2;
      documents = documents + openedBookingSnapshotDocs + closedBookingSnapshotDocs;
      debugPrint('BOOKING_SERVICE_EPIC - UserBookingListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userBookingListRequestServiceRead = reads;
      statisticsState.userBookingListRequestServiceWrite = writes;
      statisticsState.userBookingListRequestServiceDocuments = documents;

      if(bookingListState.isEmpty)
        bookingListState.add(BookingState());

    }).expand((element) => [
      UserBookingListReturned(bookingListState),
      UpdateStatistics(statisticsState),
      fromConfirm ? NavigatePushAction(AppRoutes.myBookings) : null,
    ]);
  }
}

class BookingListRequestService implements EpicClass<AppState> {
  List<BookingState> bookingStateList = [];
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BookingListRequest>().asyncMap((event) async {
      bookingStateList.clear();
      print("BOOKING_SERVICE_EPIC - BookingListRequestService => BUSINESS ID: ${event.businessId}");
      QuerySnapshot bookingListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("business_id", isEqualTo: event.businessId) // TODO check that arrayContains is ok here
          .get();

      int bookingListFromFirebaseDocs = bookingListFromFirebase.docs.length;

      //debugPrint('booking_service_epic: list lenght: ${bookingListFromFirebase.docs.length}');
      bookingListFromFirebase.docs.forEach((element) {
        BookingState bookingState = BookingState.fromJson(element.data());
        debugPrint('BOOKING_SERVICE_EPIC - BookingListRequestService =>  USER: ${bookingState.user.first.name} ${bookingState.user.first.surname} ${bookingState.user.first.email}');
        bookingStateList.add(bookingState);
      });

      debugPrint('BOOKING_SERVICE_EPIC - BookingListRequestService => BOOKING LIST LENGHT ${bookingStateList.length}');

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + bookingListFromFirebaseDocs;
      debugPrint('BOOKING_SERVICE_EPIC - BookingListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingListRequestServiceRead = reads;
      statisticsState.bookingListRequestServiceWrite = writes;
      statisticsState.bookingListRequestServiceDocuments = documents;

    }).expand((element) => [
      BookingListReturned(bookingStateList),
      UpdateStatistics(statisticsState),
      NavigatePushAction(AppRoutes.bookingList)
    ]);
  }
}

class BookingUpdateRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  BookingListState tmpBookingList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateBooking>().asyncMap((event) async {

      print("BOOKING_SERVICE_EPIC - BookingUpdateRequestService => BOOKING ID: ${event.bookingState.booking_id}");
      await FirebaseFirestore.instance /// 1 WRITE
          .collection("booking")
          .doc(event.bookingState.booking_id)
          .update(event.bookingState.toJson());

      bookingState = event.bookingState;
      /*UserState userState = store.state.user;
      bookingState.user.forEach((user) {
        // find the right user
        if (userState.email == user.email) {
          // update the id
          user.id = userState.uid;
          // add user email to the list if not present
          if(bookingState.userEmail == null){
            bookingState.userEmail = [];
          }
          if (!bookingState.userEmail.contains(userState.email)){
            bookingState.userEmail.add(userState.email);
          }
        }
      });*/

      tmpBookingList = store.state.bookingList.copyWith();
      tmpBookingList.bookingListState.removeWhere((item) => item.booking_id == bookingState.booking_id);
      tmpBookingList.bookingListState.add(bookingState);

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingListRequestServiceRead = reads;
      statisticsState.bookingListRequestServiceWrite = writes;
      statisticsState.bookingListRequestServiceDocuments = documents;

    }).expand((element) => [
      UpdatedBooking(bookingState),
      UpdateStatistics(statisticsState),
      BookingListReturned(tmpBookingList.bookingListState),
    ]);
  }
}

class BookingUpdateAndNavigateRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateBookingOnConfirm>().asyncMap((event) async {

      print("BOOKING_SERVICE_EPIC - BookingUpdateAndNavigateRequestService => BOOKING ID: ${event.bookingState.booking_id}");

      bookingState = event.bookingState;

      UserState userState = store.state.user;

      bookingState.user.forEach((user) {
        // find the right user
        if (userState.email == user.email) {
          // update the id
          user.id = userState.uid;
        }
      });

      // add user email to the list if not present
      if(bookingState.userEmail == null){
        bookingState.userEmail = [];
      }
      if (!bookingState.userEmail.contains(userState.email)){
        bookingState.userEmail.add(userState.email);
      }

      await FirebaseFirestore.instance /// 1 WRITE
          .collection("booking")
          .doc(event.bookingState.booking_id)
          .update(event.bookingState.toJson());

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingListRequestServiceRead = reads;
      statisticsState.bookingListRequestServiceWrite = writes;
      statisticsState.bookingListRequestServiceDocuments = documents;

    }).expand((element) => [
      UpdatedBooking(bookingState),
      UpdateStatistics(statisticsState),
      //NavigatePushAction(AppRoutes.bookingPage),
    ]);
  }
}


