/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
      debugPrint("BOOKING_SERVICE_EPIC - BookingCreateRequestService => DOCUMENT ID: ${event.bookingState.business_id}");

      // create a unique booking code for this booking
      String randomBookingCodeCandidate;
      bool foundRandomCode = false;
      int bookingCodeCollisionDocs = 0;
      int read = 0;
      for (int i = 0; i < 5; i++) {
        // WARNING, every booking we do tops 5 reads to mitigate collisions.
        // This has a really low chance of generating a booking without a code. this is on purpose, to avoid infinite loop risk in a read statement.
        randomBookingCodeCandidate = Utils.getRandomBookingCode(6);
        debugPrint('booking_service_epic => BookingCreateRequestService => GENERATE BOOKING CODE| Random booking code candidate: $randomBookingCodeCandidate');
        // search if the code already exists
        QuerySnapshot bookingCodeCollision = await FirebaseFirestore.instance /// ? READ - ? DOC
            .collection("booking")
            .where("booking_code", isEqualTo: randomBookingCodeCandidate)
            .get();
        bookingCodeCollisionDocs = bookingCodeCollisionDocs + bookingCodeCollision.docs.length;
        ++read;
        if (bookingCodeCollision.size > 0) {
          debugPrint('booking_service_epic => BookingCreateRequestService => GENERATE BOOKING CODE| Code collision happening for code: $randomBookingCodeCandidate');
        } else {
          // the candidate is ok, we can break and use it
          foundRandomCode = true;
          break;
        }
      }
      if (foundRandomCode) {
        debugPrint('booking_service_epic => BookingCreateRequestService => GENERATE BOOKING CODE| Creating booking for business: ${event.bookingState.business_id}');
        event.bookingState.booking_code = randomBookingCodeCandidate;
        // create a booking
        DocumentReference addingReturn = await FirebaseFirestore.instance /// 1 WRITE
            .collection("booking")
            .add(event.bookingState.toJson());
        bookingId = addingReturn.id;
        debugPrint('booking_service_epic => BookingCreateRequestService =>  $addingReturn');
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
      debugPrint('booking_service_epic => BookingCreateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      writes = writes + 2;
      documents = documents + bookingCodeCollisionDocs;
      debugPrint('booking_service_epic => BookingCreateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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

class SelfBookingCreateRequestService implements EpicClass<AppState> {

  BookingState bookingState;
  BookingListState tmpBookingList;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateSelfBookingRequest>().asyncMap((event) async {
      debugPrint("booking_service_epic => SelfBookingCreateRequestService => DOCUMENT ID: ${event.bookingState.business_id}");

      // create a unique booking code for this booking
      String randomBookingCodeCandidate;
      bool foundRandomCode = false;
      int bookingCodeCollisionDocs = 0;
      int read = 0;
      for (int i = 0; i < 5; i++) {
        // WARNING, every booking we do tops 5 reads to mitigate collisions.
        // This has a really low chance of generating a booking without a code. this is on purpose, to avoid infinite loop risk in a read statement.
        randomBookingCodeCandidate = Utils.getRandomBookingCode(6);
        debugPrint('booking_service_epic => SelfBookingCreateRequestService => GENERATE BOOKING CODE| Random booking code candidate: $randomBookingCodeCandidate');
        // search if the code already exists
        QuerySnapshot bookingCodeCollision = await FirebaseFirestore.instance /// ? READ - ? DOC
            .collection("booking")
            .where("booking_code", isEqualTo: randomBookingCodeCandidate)
            .get();
        bookingCodeCollisionDocs = bookingCodeCollisionDocs + bookingCodeCollision.docs.length;
        ++read;
        if (bookingCodeCollision.size > 0) {
          debugPrint('booking_service_epic => SelfBookingCreateRequestService => GENERATE BOOKING CODE| Code collision happening for code: $randomBookingCodeCandidate');
        } else {
          // the candidate is ok, we can break and use it
          foundRandomCode = true;
          break;
        }
      }
      if (foundRandomCode) {
        debugPrint('booking_service_epic => SelfBookingCreateRequestService => GENERATE BOOKING CODE| Creating booking for business: ${event.bookingState.business_id}');
        event.bookingState.booking_code = randomBookingCodeCandidate;
        // create a booking
        DocumentReference addingReturn = await FirebaseFirestore.instance /// 1 WRITE
            .collection("booking")
            .add(event.bookingState.toJson());
        bookingId = addingReturn.id;
        debugPrint('booking_service_epic => SelfBookingCreateRequestService =>  $addingReturn');
      } else {
        // TODO notify the user something went wrong and he has to try again.
        // example: return new ErrorInBookingCreation(event.bookingState);
      }

      bookingState = event.bookingState;
      bookingState.business_id = event.idBusiness;
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
      debugPrint('booking_service_epic => BookingCreateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      writes = writes + 2;
      documents = documents + bookingCodeCollisionDocs;
      debugPrint('booking_service_epic => BookingCreateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingCreateRequestServiceRead = reads;
      statisticsState.bookingCreateRequestServiceWrite = writes;
      statisticsState.bookingCreateRequestServiceDocuments = documents;

    }).expand((element) => [
      AddBooking(bookingState),
      ClosedRequestBooking('Request success'),
      UpdateStatistics(statisticsState),
      BookingRequestResponse(bookingState),
      BusinessServiceListAndNavigateRequest(bookingState.business_id),
    ]);
  }
}

class BookingRequestService implements EpicClass<AppState> {
  BookingState bookingState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BookingRequest>().asyncMap((event) async {
      debugPrint("booking_service_epic => BookingRequestService => DOCUMENT ID: ${event.bookingId}");

      QuerySnapshot bookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          //.where("userEmail", arrayContains: store.state.user.email)
          .where('booking_code', isEqualTo: event.bookingId)
          //.where('status', isEqualTo: 'sent')
          .get();

      int bookingSnapshotDocs = bookingSnapshot.docs.length;
      debugPrint("booking_service_epic => BookingRequestService => BOOKINGS LENGTH: $bookingSnapshotDocs");
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
      debugPrint('booking_service_epic => BookingRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + bookingSnapshotDocs;
      debugPrint('booking_service_epic => BookingRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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
      debugPrint("booking_service_epic => UserBookingListRequestService => USER EMAIL: ${ event.userEmail}");
      fromConfirm = event.fromConfirm;

      QuerySnapshot openedBookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'opened')
          .get();

      int openedBookingSnapshotDocs = openedBookingSnapshot.docs.length;
      debugPrint("booking_service_epic => UserBookingListRequestService => OPENED BOOKING LIST: $openedBookingSnapshotDocs");
      QuerySnapshot closedBookingSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("userEmail", arrayContains: event.userEmail)
          .where('status', isEqualTo: 'closed')
          .get();

      int closedBookingSnapshotDocs = closedBookingSnapshot.docs.length;
      debugPrint("booking_service_epic => UserBookingListRequestService => CLOSED BOOKING LIST: $closedBookingSnapshotDocs");
      bookingListState = [];
      List<BookingState> openedBookingListState = [];
      List<BookingState> closedBookingListState = [];

      openedBookingSnapshot.docs.forEach((element) {
        openedBookingListState.add(BookingState.fromJson(element.data()));
        debugPrint("booking_service_epic => UserBookingListRequestService => BOOKING: ${openedBookingListState.last.start_date}");
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
      debugPrint('booking_service_epic => UserBookingListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + 2;
      documents = documents + openedBookingSnapshotDocs + closedBookingSnapshotDocs;
      debugPrint('booking_service_epic => UserBookingListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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
      debugPrint("booking_service_epic => BookingListRequestService => BUSINESS ID: ${event.businessId}");
      QuerySnapshot bookingListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("booking")
          .where("business_id", isEqualTo: event.businessId) // TODO check that arrayContains is ok here
          .get();

      int bookingListFromFirebaseDocs = bookingListFromFirebase.docs.length;

      //debugPrint('booking_service_epic: list lenght: ${bookingListFromFirebase.docs.length}');
      bookingListFromFirebase.docs.forEach((element) {
        BookingState bookingState = BookingState.fromJson(element.data());
        debugPrint('booking_service_epic => BookingListRequestService =>  USER: ${bookingState.user.first.name} ${bookingState.user.first.surname} ${bookingState.user.first.email}');
        bookingStateList.add(bookingState);
      });

      debugPrint('booking_service_epic => BookingListRequestService => BOOKING LIST LENGHT ${bookingStateList.length}');

      statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('booking_service_epic => BookingListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + bookingListFromFirebaseDocs;
      debugPrint('booking_service_epic => BookingListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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

      debugPrint("booking_service_epic => BookingUpdateRequestService => BOOKING ID: ${event.bookingState.booking_id}");
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
      debugPrint('booking_service_epic => BookingUpdateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('booking_service_epic => BookingUpdateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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

      debugPrint("booking_service_epic => BookingUpdateAndNavigateRequestService => BOOKING ID: ${event.bookingState.booking_id}");

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
      debugPrint('booking_service_epic => BookingUpdateAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('booking_service_epic => BookingUpdateAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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


