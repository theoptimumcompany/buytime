import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class ExternalBusinessImportedListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalBusinessImportedListState externalBusinessImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<ExternalBusinessImportedListRequest>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedListRequestService => Business ID: ${event.businessId} ");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.businessId)
          .collection('external_business_imported').get();

     if(querySnapshot.docs.isNotEmpty)
       externalBusinessImportedListState = ExternalBusinessImportedListState.fromJson(querySnapshot.docs.first.data());
     else
       externalBusinessImportedListState = ExternalBusinessImportedListState().toEmpty();

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
      ExternalBusinessImportedListRequestResponse(externalBusinessImportedListState.externalBusinessImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalBusinessImportedCreateService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalBusinessImportedListState externalBusinessImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<CreateExternalBusinessImported>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedCreateService => Business ID: ${event.externalBusinessImportedState.internalBusinessId} ");

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.externalBusinessImportedState.internalBusinessId)
          .collection('external_business_imported').get();

      DocumentReference documentReference;
     
      if(querySnapshot.docs.isEmpty){
        documentReference = FirebaseFirestore.instance.collection('business')
            .doc(event.externalBusinessImportedState.internalBusinessId)
            .collection('external_business_imported').doc();
        externalBusinessImportedListState = ExternalBusinessImportedListState(externalBusinessImported: []);
        List<ExternalBusinessImportedState> eBILS = [];
        eBILS.add(event.externalBusinessImportedState);
        externalBusinessImportedListState.externalBusinessImported = eBILS;

        await documentReference.set(externalBusinessImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedCreateService => ERROR: $error');
          externalBusinessImportedListState.externalBusinessImported.removeLast();
        });
      }else{
        documentReference = querySnapshot.docs.first.reference;
        externalBusinessImportedListState = ExternalBusinessImportedListState.fromJson(querySnapshot.docs.first.data());
        List<ExternalBusinessImportedState> eBILS = [];
        eBILS.add(event.externalBusinessImportedState);
        externalBusinessImportedListState.externalBusinessImported.addAll(eBILS);

        await documentReference.set(externalBusinessImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_BUSINESS_IMPORTED_LIST_SERVICE_EPIC - ExternalBusinessImportedCreateService => ERROR: $error');
          externalBusinessImportedListState.externalBusinessImported.removeLast();
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
      ServiceListSnippetRequest(store.state.business.id_firestore),
      ExternalBusinessImportedListRequestResponse(externalBusinessImportedListState.externalBusinessImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}