import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class SlotListSnippetRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  SlotListSnippetState slotSnippetListState = SlotListSnippetState(slotListSnippet: []);

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("slot_service_epic => SlotListSnippetRequestService => ServiceListService CATCHED ACTION");
    //List<ServiceState> serviceStateList = [];
    return actions.whereType<SlotListSnippetRequest>().asyncMap((event) async {
      //debugPrint("slot_service_epic => SlotListSnippetRequestService => ServiceListService Firestore request");
      debugPrint("slot_service_epic => SlotListSnippetRequestService => Service Id: ${event.serviceId}");
      int docs = 0;
      int read = 0;
      var slotFirebaseShadow = await FirebaseFirestore.instance.collection("service")
          .doc(event.serviceId)
          .collection('slotSnippet').get();

      read++;
      docs++;
      //debugPrint("slot_service_epic => ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
      slotSnippetListState = SlotListSnippetState.fromJson(slotFirebaseShadow.docs.first.data());

      debugPrint("slot_service_epic => SlotListSnippetRequestService => Epic ServiceListService return list with " + slotFirebaseShadow.docs.length.toString());

      /*statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('slot_service_epic => SlotListSnippetRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('slot_service_epic => SlotListSnippetRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;*/

    }).expand((element) => [
      SlotListSnippetRequestResponse(slotSnippetListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}