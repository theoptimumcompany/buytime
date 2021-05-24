import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class NotificationRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  NotificationListState notificationListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<RequestNotification>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => Business ID: ${event.businessId} ");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.businessId)
          .collection('external_service_imported').get();

     if(querySnapshot.docs.isNotEmpty)
       notificationListState = NotificationListState.fromJson(querySnapshot.docs.first.data());
     else
       notificationListState = NotificationListState().toEmpty();

      //await Future.delayed(Duration(seconds: 3));
      /*statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;*/
    }).expand((element) => [
      //CreatedExternalServiceImported(_externalServiceImportedState)
      RequestedNotificationList(notificationListState.notificationListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class NotificationListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<NotificationState> notificationListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<RequestNotificationList>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      //notificationListState = NotificationListState().toEmpty();
      debugPrint("NOTIFICATION_SERVICE_EPIC - NotificationListRequestService => User ID: ${event.userId} ");
      DateTime currentTime = DateTime.now();
      //currentTime = currentTime.subtract(Duration(days: 5));
      int time = int.parse(Timestamp.fromDate(currentTime).seconds.toString());
      // debugPrint("NOTIFICATION_SERVICE_EPIC - NotificationListRequestService => TIMESTAMP: $time");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('notification')
          .where("userId", isEqualTo: event.userId)
          //.where("businessId", isEqualTo: event.businessId)
          .where("timestamp", isGreaterThanOrEqualTo: time)
          .get();

      notificationListState = [];
     if(querySnapshot.docs.isNotEmpty){
       debugPrint("NOTIFICATION_SERVICE_EPIC - NotificationListRequestService => List not empty: ${querySnapshot.docs.length}");
       querySnapshot.docs.forEach((element) {
         // debugPrint("NOTIFICATION_SERVICE_EPIC - NotificationListRequestService => data: ${element.data()}");
         notificationListState.add(NotificationState.fromJson(element.data()));
         notificationListState.last.notificationId = element.id;
       });
       //notificationListState = NotificationListState.fromJson();
     }

      //await Future.delayed(Duration(seconds: 3));
      /*statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;*/
      if(notificationListState.isEmpty){
        notificationListState.add(NotificationState().toEmpty());
      }
    }).expand((element) => [
      //CreatedExternalServiceImported(_externalServiceImportedState)
      RequestedNotificationList(notificationListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class NotificationUpdateRequestService implements EpicClass<AppState> {
  NotificationState notificationState;
  List<NotificationState> notificationListState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateNotification>().asyncMap((event) async {

      print("NOTIFICATION_SERVICE_EPIC - NotificationUpdateRequestService => Notification ID: ${event.notificationState.notificationId}");
      await FirebaseFirestore.instance /// 1 WRITE
          .collection("notification")
          .doc(event.notificationState.notificationId)
          .update(event.notificationState.toJson());

      notificationState = event.notificationState;

      notificationListState = store.state.notificationListState.notificationListState;
      NotificationState tmp;
      notificationListState.forEach((element) {
        if(element.notificationId != null && element.notificationId.isNotEmpty && element.notificationId == notificationState.notificationId)
          tmp = element;
      });
      notificationListState.remove(tmp);
      notificationListState.add(notificationState);

      notificationListState.forEach((element) {
        //print("NOTIFICATION_SERVICE_EPIC - NotificationUpdateRequestService => Opened: ${event.notificationState.opened}");
      });

      /*statisticsState = store.state.statistics;
      int reads = statisticsState.bookingListRequestServiceRead;
      int writes = statisticsState.bookingListRequestServiceWrite;
      int documents = statisticsState.bookingListRequestServiceDocuments;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('BOOKING_SERVICE_EPIC - BookingUpdateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.bookingListRequestServiceRead = reads;
      statisticsState.bookingListRequestServiceWrite = writes;
      statisticsState.bookingListRequestServiceDocuments = documents;*/

    }).expand((element) => [
      UpdatedNotification(notificationState),
      UpdateStatistics(statisticsState),
      RequestedNotificationList(notificationListState),
    ]);
  }
}

/*class NotificationCreateService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  NotificationListState notificationListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<CreateNotification>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => Business ID: ${event.notificationState.ids.businessId} ");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.notificationState.ids.businessId)
          .collection('notifications').get();

      DocumentReference documentReference;
     
      if(querySnapshot.docs.isEmpty){
        documentReference = FirebaseFirestore.instance.collection('business')
            .doc(event.notificationState.ids.businessId)
            .collection('notifications').doc();
        notificationListState = NotificationListState(notificationListState: []);
        List<NotificationState> nS = [];
        nS.add(event.notificationState);
        notificationListState.notificationListState = nS;

        await documentReference.set(notificationListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => ERROR: $error');
          notificationListState.notificationListState.removeLast();
        });
      }else{
        documentReference = querySnapshot.docs.first.reference;
        notificationListState = NotificationListState.fromJson(querySnapshot.docs.first.data());
        List<NotificationState> eSILS = [];
        eSILS.add(event.notificationState);
        notificationListState.notificationListState.addAll(eSILS);

        await documentReference.set(notificationListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => ERROR: $error');
          notificationListState.notificationListState.removeLast();
        });
      }

      //await Future.delayed(Duration(seconds: 3));
      *//*statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;*//*
    }).expand((element) => [
      //CreatedExternalServiceImported(externalServiceImportedListState),
      //ServiceListSnippetRequest(store.state.business.id_firestore),
      RequestedNotificationList(notificationListState.notificationListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}*/

/*
class ExternalServiceImportedCanceledService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalServiceImportedListState externalServiceImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<CancelExternalServiceImported>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => Business ID: ${event.externalServiceImportedState.internalBusinessId} ");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.externalServiceImportedState.internalBusinessId)
          .collection('external_service_imported').get();

      DocumentReference documentReference;

      if(querySnapshot.docs.isEmpty){
        documentReference = FirebaseFirestore.instance.collection('business')
            .doc(event.externalServiceImportedState.internalBusinessId)
            .collection('external_service_imported').doc();
        externalServiceImportedListState = ExternalServiceImportedListState(externalServiceImported: []);
        List<ExternalServiceImportedState> eSILS = [];
        eSILS.add(event.externalServiceImportedState);
        externalServiceImportedListState.externalServiceImported = eSILS;

        await documentReference.set(externalServiceImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => ERROR: $error');
          externalServiceImportedListState.externalServiceImported.removeLast();
        });
      }else{
        documentReference = querySnapshot.docs.first.reference;
        externalServiceImportedListState = ExternalServiceImportedListState.fromJson(querySnapshot.docs.first.data());
        externalServiceImportedListState.externalServiceImported.forEach((element) {
          if(element.externalBusinessId == event.externalServiceImportedState.externalBusinessId && element.externalServiceId == event.externalServiceImportedState.externalServiceId && element.imported == true)
            element = event.externalServiceImportedState;
        });

        await documentReference.set(externalServiceImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => ERROR: $error');
          externalServiceImportedListState.externalServiceImported.removeLast();
        });
      }

      //await Future.delayed(Duration(seconds: 3));
      */
/*statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;*//*

    }).expand((element) => [
      //CreatedExternalServiceImported(externalServiceImportedListState),
      ServiceListSnippetRequest(store.state.business.id_firestore),
      ExternalServiceImportedListRequestResponse(externalServiceImportedListState.externalServiceImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}*/
