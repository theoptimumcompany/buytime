// import 'package:Buytime/reblox/model/app_state.dart';
// import 'package:Buytime/reblox/model/order/order_state.dart';
// import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
// import 'package:Buytime/reblox/model/statistics_state.dart';
// import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_list_reducer.dart';
// import 'package:Buytime/reblox/reducer/reservations_orders_list_snippet_reducer.dart';
// import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:redux_epics/redux_epics.dart';
// import 'package:rxdart/rxdart.dart';
//
// class ReservationsAndOrdersListSnippetRequestService implements EpicClass<AppState> {
//   StatisticsState statisticsState;
//
//   ReservationsOrdersListSnippetState reservationsOrdersListSnippetState = ReservationsOrdersListSnippetState();
//
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => ServiceListService CATCHED ACTION");
//     List<OrderState> orderStateList = [];
//     return actions.whereType<ReservationAndOrdersListSnippetRequest>().asyncMap((event) async {
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => ServiceListService Firestore request");
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => Business Id: ${event.businessId}");
//       int docs = 0;
//       int read = 0;
//    /*   var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business")
//           .doc(event.businessId)
//           .collection('service_list_snippet').get();
//
//       read++;
//       docs++;
//       //debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
//       reservationsOrdersListSnippetState = ReservationsOrdersListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data());
// */
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => Epic ServiceListService return list with " + servicesFirebaseShadow.docs.length.toString());
//
//       statisticsState = store.state.statistics;
//       int reads = statisticsState.serviceListRequestServiceRead;
//       int writes = statisticsState.serviceListRequestServiceWrite;
//       int documents = statisticsState.serviceListRequestServiceDocuments;
//       debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       reads = reads + read;
//       documents = documents + docs;
//       debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       statisticsState.serviceListRequestServiceRead = reads;
//       statisticsState.serviceListRequestServiceWrite = writes;
//       statisticsState.serviceListRequestServiceDocuments = documents;
//
//       if(orderStateList.isEmpty)
//         orderStateList.add(OrderState());
//
//     }).expand((element) => [
//       ReservationAndOrdersListSnippetRequestResponse(reservationsOrdersListSnippetState),
//       UpdateStatistics(statisticsState),
//     ]);
//   }
// }
//
// class ReservationsAndOrdersListSnippetListRequestService implements EpicClass<AppState> {
//   StatisticsState statisticsState;
//   List<ReservationsOrdersListSnippetState> reservationsOrdersListSnippetListState;
//
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => ServiceListService CATCHED ACTION");
//     List<OrderState> orderStateList = [];
//     return actions.whereType<ReservationAndOrdersListSnippetListRequest>().asyncMap((event) async {
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => ServiceListService Firestore request");
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => Business length: ${event.businessesId.length}");
//       int docs = 0;
//       int read = 0;
//       reservationsOrdersListSnippetListState = [];
//      /* for(int i = 0; i < event.businessesId.length; i++){
//         var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business")
//             .doc(event.businessesId[i].id_firestore)
//             .collection('service_list_snippet').get();
//
//         if(servicesFirebaseShadow.docs.isNotEmpty)
//           serviceListSnippetListState.add(ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data()));
//       }*/
//
//       read++;
//       docs++;
//       //debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
//       //serviceListSnippetState = ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data());
//
//       debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => Epic ServiceListService return list with " + serviceListSnippetListState.length.toString());
//
//       statisticsState = store.state.statistics;
//       int reads = statisticsState.serviceListRequestServiceRead;
//       int writes = statisticsState.serviceListRequestServiceWrite;
//       int documents = statisticsState.serviceListRequestServiceDocuments;
//       debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       reads = reads + read;
//       documents = documents + docs;
//       debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       statisticsState.serviceListRequestServiceRead = reads;
//       statisticsState.serviceListRequestServiceWrite = writes;
//       statisticsState.serviceListRequestServiceDocuments = documents;
//
//       if(reservationsOrdersListSnippetListState.isEmpty)
//         reservationsOrdersListSnippetListState.add(ReservationsOrdersListSnippetState());
//
//     }).expand((element) => [
//       ReservationsAndOrdersListSnippetListRequestResponse(reservationsOrdersListSnippetListState),
//       UpdateStatistics(statisticsState),
//     ]);
//   }
// }
//
//
