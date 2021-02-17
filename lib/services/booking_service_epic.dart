import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
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

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBookingRequest>().asyncMap((event) async {
      print("BookingServiceEpic document id:" + event.bookingState.business_id);

      // create a unique booking code for this booking
      String randomBookingCodeCandidate;
      bool foundRandomCode = false;
      for (int i = 0; i < 5; i++) {
        // WARNING, every booking we do tops 5 reads to mitigate collisions.
        // This has a really low chance of generating a booking without a code. this is on purpose, to avoid infinite loop risk in a read statement.
        randomBookingCodeCandidate = Utils.getRandomBookingCode(6);
        print('generateBookingCode random booking code candidate: ' +
            randomBookingCodeCandidate);
        // search if the code already exists
        var bookingCodeCollision = await FirebaseFirestore.instance
            .collection("booking")
            .where("booking_code", isEqualTo: randomBookingCodeCandidate)
            .get();
        if (bookingCodeCollision.size > 0) {
          print('generateBookingCode code collision happening for code: ' +
              randomBookingCodeCandidate);
        } else {
          // the candidate is ok, we can break and use it
          foundRandomCode = true;
          break;
        }
      }
      if (foundRandomCode) {
        print('generateBookingCode creating booking for business: ' +
            event.bookingState.business_id);
        event.bookingState.booking_code = randomBookingCodeCandidate;
        // create a booking
        var addingReturn = await FirebaseFirestore.instance
            .collection("booking")
            .add(event.bookingState.toJson());
        bookingId = addingReturn.id;
        print('BookingServiceEpic: $addingReturn');
      } else {
        // TODO notify the user something went wrong and he has to try again.
        // example: return new ErrorInBookingCreation(event.bookingState);
      }
      bookingState = event.bookingState;
      bookingState.booking_id = bookingId;

      tmpBookingList = store.state.bookingList.copyWith();
      tmpBookingList.bookingListState.add(bookingState);
    }).expand((element) => [
          AddBooking(bookingState),
          ClosedRequestBooking('Request success'),
          NavigatePushAction(AppRoutes.bookingDetails),
          BookingListReturned(tmpBookingList.bookingListState)
        ]);
  }
}

class BookingRequestService implements EpicClass<AppState> {
  BookingState bookingState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BookingRequest>().asyncMap((event) async {
      print("BookingService document id:" + event.bookingId);

      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection("booking")
          .where("userEmail", arrayContains: store.state.user.email)
          .where('booking_code', isEqualTo: event.bookingId)
          .where('status', isEqualTo: 'sent')
          .get();

      if(bookingSnapshot.docs.isNotEmpty)
        bookingState =  BookingState.fromJson(bookingSnapshot.docs.first.data());
      else{
        bookingState = BookingState().toEmpty();
        bookingState.booking_code = 'error';
      }
    }).expand((element) => [
      BookingRequestResponse(bookingState),
      bookingState.booking_code != 'error' ? BusinessAndNavigateOnConfirmRequest(bookingState.business_id) : null
    ]);
  }
}

class UserBookingListRequestService implements EpicClass<AppState> {
  List<BookingState> bookingListState;
  String route;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UserBookingListRequest>().asyncMap((event) async {
      print("UserBookingListService user email:" + event.userEmail);

      QuerySnapshot openedBookingSnapshot = await FirebaseFirestore.instance // TODO we have to be sure about this
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'opened')
          .get();

      QuerySnapshot closedBookingSnapshot = await FirebaseFirestore.instance // TODO we have to be sure about this
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'closed')
          .get();

      bookingListState = [];
      List<BookingState> openedBookingListState = [];
      List<BookingState> closedBookingListState = [];

      openedBookingSnapshot.docs.forEach((element) {
        openedBookingListState.add(BookingState.fromJson(element.data()));
      });
      openedBookingListState.sort((a,b) => DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));

      closedBookingSnapshot.docs.forEach((element) {
        closedBookingListState.add(BookingState.fromJson(element.data()));
      });

      closedBookingListState.sort((a,b) => DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));

      bookingListState.addAll(openedBookingListState);
      bookingListState.addAll(closedBookingListState);

    }).expand((element) => [
      UserBookingListReturned(bookingListState),
      NavigatePushAction(AppRoutes.myBookings),
    ]);
  }
}

class BookingListRequestService implements EpicClass<AppState> {
  List<BookingState> bookingStateList = [];

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BookingListRequest>().asyncMap((event) async {
      bookingStateList.clear();
      print("booking_service_epic: business id:" + event.businessId);
      var bookingListFromFirebase;
      bookingListFromFirebase = await FirebaseFirestore
          .instance // TODO we have to be sure about this
          .collection("booking")
          .where("business_id",
              isEqualTo:
                  event.businessId) // TODO check that arrayContains is ok here
          .get();

      //debugPrint('booking_service_epic: list lenght: ${bookingListFromFirebase.docs.length}');
      bookingListFromFirebase.docs.forEach((element) {
        BookingState bookingState = BookingState.fromJson(element.data());
        debugPrint(
            'booking_service_epic: User: ${bookingState.user.first.name} ${bookingState.user.first.surname} ${bookingState.user.first.email}');
        bookingStateList.add(bookingState);
      });

      debugPrint('booking_service_epic: ${bookingStateList.length}');
    }).expand((element) => [BookingListReturned(bookingStateList)]);
  }
}

class BookingUpdateRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  BookingListState tmpBookingList;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateBooking>().asyncMap((event) async {

      print("booking_service_epic: booking id:" + event.bookingState.booking_id);
      await FirebaseFirestore.instance
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

    }).expand((element) => [
      UpdatedBooking(bookingState),
      BookingListReturned(tmpBookingList.bookingListState)
    ]);
  }
}

class BookingUpdateAndNavigateRequestService implements EpicClass<AppState> {
  BookingState bookingState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateBookingNavigate>().asyncMap((event) async {

      print("booking_service_epic: booking id:" + event.bookingState.booking_id);

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

      await FirebaseFirestore.instance
          .collection("booking")
          .doc(event.bookingState.booking_id)
          .update(event.bookingState.toJson());

    }).expand((element) => [
      UpdatedBooking(bookingState),
      NavigatePushAction(AppRoutes.bookingPage),
    ]);
  }
}


