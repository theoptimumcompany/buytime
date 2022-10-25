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
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
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

class ExternalServiceImportedListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalServiceImportedListState externalServiceImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<ExternalServiceImportedListRequest>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => Business ID: ${event.businessId} ");
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('business')
          .doc(event.businessId)
          .collection('external_service_imported').get();

     if(querySnapshot.docs.isNotEmpty)
       externalServiceImportedListState = ExternalServiceImportedListState.fromJson(querySnapshot.docs.first.data());
     else
       externalServiceImportedListState = ExternalServiceImportedListState().toEmpty();

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
      ExternalServiceImportedListRequestResponse(externalServiceImportedListState.externalServiceImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalServiceImportedCreateService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalServiceImportedListState externalServiceImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<CreateExternalServiceImported>().asyncMap((event) async {
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
        List<ExternalServiceImportedState> eSILS = [];
        eSILS.add(event.externalServiceImportedState);
        externalServiceImportedListState.externalServiceImported.addAll(eSILS);

        await documentReference.set(externalServiceImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCreateService => ERROR: $error');
          externalServiceImportedListState.externalServiceImported.removeLast();
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
      ExternalServiceImportedListRequestResponse(externalServiceImportedListState.externalServiceImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalServiceImportedCanceledService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ExternalServiceImportedListState externalServiceImportedListState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {

    return actions.whereType<CancelExternalServiceImported>().asyncMap((event) async {
      //ServiceState serviceState = event.serviceState;
      debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCanceledService => Business ID: ${event.externalServiceImportedState.internalBusinessId} ");
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
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCanceledService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCanceledService => ERROR: $error');
          externalServiceImportedListState.externalServiceImported.removeLast();
        });
      }else{
        documentReference = querySnapshot.docs.first.reference;
        externalServiceImportedListState = ExternalServiceImportedListState.fromJson(querySnapshot.docs.first.data());
        externalServiceImportedListState.externalServiceImported.forEach((element) {
          if(element.externalBusinessId == event.externalServiceImportedState.externalBusinessId && element.externalServiceId == event.externalServiceImportedState.externalServiceId && element.imported == true){
            //element.deleteTimestamp = DateTime.now();
            element.imported = false;
          }
        });
        externalServiceImportedListState.externalServiceImported.add(event.externalServiceImportedState);

        await documentReference.set(externalServiceImportedListState.toJson()).then((value) {
          debugPrint("EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCanceledService => CREATED! ");
        }).catchError((error) {
          debugPrint('EXTERNAL_SERVICE_IMPORTED_LIST_SERVICE_EPIC - ExternalServiceImportedCanceledService => ERROR: $error');
          externalServiceImportedListState.externalServiceImported.removeLast();
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
      ExternalServiceImportedListRequestResponse(externalServiceImportedListState.externalServiceImported),
      UpdateStatistics(statisticsState),
    ]);
  }
}