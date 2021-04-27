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

class NotificationCreateService implements EpicClass<AppState> {
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
      //CreatedExternalServiceImported(externalServiceImportedListState),
      //ServiceListSnippetRequest(store.state.business.id_firestore),
      RequestedNotificationList(notificationListState.notificationListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

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
