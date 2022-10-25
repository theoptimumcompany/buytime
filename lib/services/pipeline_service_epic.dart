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
import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';


class PipelineListRequestService implements EpicClass<AppState> {
  List<Pipeline> pipelineList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("PIPELINE_SERVICE_EPIC - PipelineListRequestService => CATCHED ACTION");
    return actions.whereType<RequestListPipeline>().asyncMap((event) async {

      pipelineList = [];
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("pipeline").get(); /// 1 READ - ? DOC

      int snapshotDocs = snapshot.docs.length;

      debugPrint("PIPELINE_SERVICE_EPIC - PipelineListRequestService => PipelineListService firestore request");
      snapshot.docs.forEach((element) {
        Pipeline pipeline = Pipeline.fromJson(element.data());
        pipelineList.add(pipeline);
      });
      debugPrint("PIPELINE_SERVICE_EPIC - PipelineListRequestService => PipelineListService return list with " + pipelineList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryDeleteServiceRead;
      int writes = statisticsState.categoryDeleteServiceWrite;
      int documents = statisticsState.categoryDeleteServiceDocuments;
      debugPrint('PIPELINE_SERVICE_EPIC - PipelineListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + snapshotDocs;
      debugPrint('PIPELINE_SERVICE_EPIC - PipelineListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryDeleteServiceRead = reads;
      statisticsState.categoryDeleteServiceWrite = writes;
      statisticsState.categoryDeleteServiceDocuments = documents;
      //return new PipelineListReturned(pipelineList);
    }).expand((element) => [
      PipelineListReturned(pipelineList),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class PipelineCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreatePipeline>().asyncMap((event) {

    });
  }
}

class PipelineRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<PipelineRequest>().asyncMap((event) {

     /* return Firestore.instance.collection("pipeline").document(store.state.business.id_firestore).collection("category_tree").document(store.state.business.idCategoryTree).get().then((snapshot) {
        Pipeline pipeline = Pipeline(
          name: snapshot.data["name"],
          description: snapshot.data["description"],
        );
        return new PipelineRequestResponse(pipeline);
      });*/
    }).takeUntil(actions.whereType<UnlistenPipeline>());
  }
}

class PipelineUpdateService implements EpicClass<AppState> {

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdatePipeline>().asyncMap((event) {

   /*   return Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree")
          .document(store.state.business.idCategoryTree)
          .updateData(.toJson())
          .then((value) {
        print("Pipeline Service should be updated online ");
        return new UpdatedPipeline(null);
      });*/
    }).takeUntil(actions.whereType<UnlistenPipeline>());
  }
}
