import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';

class ServiceListSnippetRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState();

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListSnippetRequest>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => Business Id: ${event.businessId}");
      int docs = 0;
      int read = 0;
      var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business")
          .doc(event.businessId)
          .collection('service_list_snippet').get();

      read++;
      docs++;
      //debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
      serviceListSnippetState = ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data());

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => Epic ServiceListService return list with " + servicesFirebaseShadow.docs.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceStateList.isEmpty)
        serviceStateList.add(ServiceState());

    }).expand((element) => [
      ServiceListSnippetRequestResponse(serviceListSnippetState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ServiceListSnippetListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<ServiceListSnippetState> serviceListSnippetListState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListSnippetListRequest>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => Business length: ${event.businessesId.length}");
      int docs = 0;
      int read = 0;
      serviceListSnippetListState = [];
      for(int i = 0; i < event.businessesId.length; i++){
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business")
            .doc(event.businessesId[i].id_firestore)
            .collection('service_list_snippet').get();

        if(servicesFirebaseShadow.docs.isNotEmpty)
          serviceListSnippetListState.add(ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data()));
      }

      read++;
      docs++;
      //debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
      //serviceListSnippetState = ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data());

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => Epic ServiceListService return list with " + serviceListSnippetListState.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceListSnippetListState.isEmpty)
        serviceListSnippetListState.add(ServiceListSnippetState());

    }).expand((element) => [
      ServiceListSnippetListRequestResponse(serviceListSnippetListState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ServiceListSnippetRequestServiceNavigate implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState();
  List<String> serviceIds;
  List<String> businessIds;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListSnippetRequestNavigate>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate => Business Id: ${event.businessId}");
      int docs = 0;
      int read = 0;
      var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business")
          .doc(event.businessId)
          .collection('service_list_snippet').get();

      read++;
      docs++;
      //debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequest => MAP " + servicesFirebaseShadow.docs.first.data().toString());
      if (servicesFirebaseShadow.docs != null && servicesFirebaseShadow.docs.isNotEmpty) {
        serviceListSnippetState = ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs?.first?.data());
      }

      businessIds = [];
      serviceIds = [];
      serviceListSnippetState.businessSnippet.forEach((bS) {
        bS.serviceList.forEach((sL) {
          if(sL.serviceVisibility == 'Deactivated' || sL.serviceVisibility == 'Active'){
            serviceIds.add(sL.serviceAbsolutePath.split('/').last);
            if(!businessIds.contains(sL.serviceAbsolutePath.split('/').first) && sL.serviceAbsolutePath.split('/').first != store.state.business.id_firestore){
              businessIds.add(sL.serviceAbsolutePath.split('/').first);
            }
          }
        });
      });
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate => Epic ServiceListService return list with " + servicesFirebaseShadow.docs.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListSnippetRequestServiceNavigate =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceStateList.isEmpty)
        serviceStateList.add(ServiceState());

    }).expand((element) => [
      ServiceListSnippetRequestResponse(serviceListSnippetState),
      UpdateStatistics(statisticsState),
      //NavigatePushAction(AppRoutes.categories),
      ExternalBusinessListByIdsRequest(businessIds),
      ServiceListRequestByIdsNavigate(serviceIds)
    ]);
  }
}

class ServiceListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListRequest>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => Business Id: ${event.businessId}");
      int docs = 0;
      int read = 0;
      if (event.permission == "user") {
        serviceStateList.clear();
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get();

        /// 1 READ - ? DOC
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseVisible = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get();

        /// 1 READ - ? DOC
        docs = docs + servicesFirebaseVisible.docs.length;
        servicesFirebaseVisible.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());

          serviceStateList.add(serviceState);
        });

        read = 2;
      } else {
        CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
        Query query = servicesFirebase.where("businessId", isEqualTo: event.businessId);

        /// 1 READ - ? DOC
        //   query = query.where("id_category", isEqualTo: categoryInviteState.id_category);
        serviceStateList.clear();
        await query.get().then((value) {
          docs = value.docs.length;
          value.docs.forEach((element) {
            ServiceState serviceState = ServiceState.fromJson(element.data());

            serviceStateList.add(serviceState);
          });
        });

        read = 1;
      }

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListRequestService => Epic ServiceListService return list with " + serviceStateList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceStateList.isEmpty)
        serviceStateList.add(ServiceState());

    }).expand((element) => [
          ServiceListReturned(serviceStateList),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class ServiceListByIdsRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListRequestByIds>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService => Service Ids Length: ${event.serviceIds.length}");
      int docs = 0;
      int read = 0;
      serviceStateList.clear();
      for(int i = 0; i < event.serviceIds.length; i++){
        CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
        Query query = servicesFirebase.where("serviceId", isEqualTo: event.serviceIds[i]);

        /// 1 READ - ? DOC
        //   query = query.where("id_category", isEqualTo: categoryInviteState.id_category);

        await query.get().then((value) {
          docs = value.docs.length;
          value.docs.forEach((element) {
            ServiceState serviceState = ServiceState.fromJson(element.data());

            serviceStateList.add(serviceState);
          });
        });

        ++read;
      }


      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService => Epic ServiceListService return list with " + serviceStateList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListByIdsRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceStateList.isEmpty)
        serviceStateList.add(ServiceState());

    }).expand((element) => [
      ServiceListReturned(serviceStateList),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ServiceListByIdsRequestNavigateService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<String> categoryIds;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService => ServiceListService CATCHED ACTION");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListRequestByIdsNavigate>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService => ServiceListService Firestore request");
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService => Service Ids Length: ${event.serviceIds.length}");
      int docs = 0;
      int read = 0;
      serviceStateList.clear();

      for(int i = 0; i < event.serviceIds.length; i++){
        CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
        Query query = servicesFirebase.where("serviceId", isEqualTo: event.serviceIds[i]);

        /// 1 READ - ? DOC
        //   query = query.where("id_category", isEqualTo: categoryInviteState.id_category);

        await query.get().then((value) {
          docs = value.docs.length;
          value.docs.forEach((element) {
            ServiceState serviceState = ServiceState.fromJson(element.data());

            serviceStateList.add(serviceState);
          });
        });

        ++read;
      }

      categoryIds = [];
      store.state.serviceListSnippetState.businessSnippet.forEach((bS) {
        /*if(bS.tags.contains('showcase')){
          categoryIds.add(bS.categoryAbsolutePath.split('/').last);
        }*/
        categoryIds.add(bS.categoryAbsolutePath.split('/').last);
      });

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService => Epic ServiceListService return list with " + serviceStateList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListRequestServiceRead;
      int writes = statisticsState.serviceListRequestServiceWrite;
      int documents = statisticsState.serviceListRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListByIdsRequestNavigateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListRequestServiceRead = reads;
      statisticsState.serviceListRequestServiceWrite = writes;
      statisticsState.serviceListRequestServiceDocuments = documents;

      if(serviceStateList.isEmpty)
        serviceStateList.add(ServiceState());

    }).expand((element) => [
      ServiceListReturned(serviceStateList),
      UpdateStatistics(statisticsState),
      UserRequestListByIdsCategory(categoryIds)
    ]);
  }
}

class ServiceListAndNavigateRequestService implements EpicClass<AppState> {
  List<ServiceState> serviceStateList;
  String businessId;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => CATCHED ACTION");
    return actions.whereType<ServiceListAndNavigateRequest>().asyncMap((event) async {
      businessId = event.businessId;
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => Firestore request business Id: ${event.businessId}, permission: ${event.permission}");
      serviceStateList = [];
      int docs = 0;
      int read = 0;
      if (event.permission == "user") {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => Permission as user");
        var servicesFirebaseShadow = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("service")
            .where("businessId", isEqualTo: event.businessId)
            .where("visibility", isEqualTo: 'Deactivated')
            .limit(50)
            .get();
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("service")
            .where("businessId", isEqualTo: event.businessId)
            .where("visibility", isEqualTo: 'Active')
            .limit(50)
            .get();
        docs = docs + servicesFirebaseActive.docs.length;
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });

        read = 2;
      } else {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => Permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("service")
            .where("businessId", isEqualTo: event.businessId)
            .limit(50)
            .get();
        docs = servicesFirebase.docs.length;
        servicesFirebase.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        ++read;
      }

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => ServiceListAndNavigateRequestService return list with " + serviceStateList.length.toString());
      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListAndNavigateRequestServiceRead;
      int writes = statisticsState.serviceListAndNavigateRequestServiceWrite;
      int documents = statisticsState.serviceListAndNavigateRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListAndNavigateRequestServiceRead = reads;
      statisticsState.serviceListAndNavigateRequestServiceWrite = writes;
      statisticsState.serviceListAndNavigateRequestServiceDocuments = documents;
    }).expand((element) => [ServiceListReturned(serviceStateList), UpdateStatistics(statisticsState), UserRequestListCategory(businessId)]);
  }
}

class ServiceListAndNavigateOnConfirmRequestService implements EpicClass<AppState> {
  List<ServiceState> serviceStateList;
  StatisticsState statisticsState;
  String businessId;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => CATCHED ACTION");
    return actions.whereType<ServiceListAndNavigateOnConfirmRequest>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Firestore request business Id: ${event.businessId}, permission: ${event.permission}");
      businessId = event.businessId;
      serviceStateList = [];
      int docs = 0;
      int read = 0;
      if (event.permission == "user") {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Permission as user");
        var servicesFirebaseShadow = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("service")
            .where("businessId", isEqualTo: event.businessId)
            .where("visibility", isEqualTo: 'Deactivated')
            .limit(50)
            .get();
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("service")
            .where("businessId", isEqualTo: event.businessId)
            .where("visibility", isEqualTo: 'Active')
            .limit(50)
            .get();
        docs = docs + servicesFirebaseActive.docs.length;
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });

        read = 2;
      } else {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).limit(50).get();
        docs = servicesFirebase.docs.length;
        servicesFirebase.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        ++read;
      }

      debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Return list with " + serviceStateList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceListAndNavigateOnConfirmRequestServiceRead;
      int writes = statisticsState.serviceListAndNavigateOnConfirmRequestServiceWrite;
      int documents = statisticsState.serviceListAndNavigateOnConfirmRequestServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + docs;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceListAndNavigateOnConfirmRequestServiceRead = reads;
      statisticsState.serviceListAndNavigateOnConfirmRequestServiceWrite = writes;
      statisticsState.serviceListAndNavigateOnConfirmRequestServiceDocuments = documents;
    }).expand((element) => [ServiceListReturned(serviceStateList), UpdateStatistics(statisticsState), UserRequestListCategory(businessId)]);
  }
}

class ServiceUpdateServiceVisibility implements EpicClass<AppState> {
  String id;
  String visibility;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<SetServiceListVisibilityOnFirebase>().asyncMap((event) async {
      id = event.serviceId;
      visibility = event.visibility;
      await FirebaseFirestore.instance.collection("service").doc(event.serviceId).update({
        /// 1 WRITE
        "visibility": event.visibility,
      }).then((value) {
        print("SERVICE_SERVICE_EPIC - ServiceUpdateServiceVisibility => ServiceService visibility should be updated online ");
      }).catchError((error) {
        print('SERVICE_SERVICE_EPIC - ServiceUpdateServiceVisibility => ERROR: $error}');
      }).then((value) {});

      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceUpdateServiceVisibilityRead;
      int writes = statisticsState.serviceUpdateServiceVisibilityWrite;
      int documents = statisticsState.serviceUpdateServiceVisibilityDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateServiceVisibility => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateServiceVisibility =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceUpdateServiceVisibilityRead = reads;
      statisticsState.serviceUpdateServiceVisibilityWrite = writes;
      statisticsState.serviceUpdateServiceVisibilityDocuments = documents;
    }).expand((element) => [UpdateStatistics(statisticsState), SetServiceListVisibility(id, visibility)]);
  }
}

class ServiceRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  ServiceState serviceState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    ServiceState returnedServiceState;
    List<ServiceState> listService;
    return actions.whereType<ServiceRequestByID>().asyncMap((event) async {
      QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("service")
      //.where("userEmail", arrayContains: store.state.user.email)
          .where('serviceId', isEqualTo: event.serviceId)
      //.where('status', isEqualTo: 'sent')
          .get();

      int serviceSnapshotDocs = serviceSnapshot.docs.length;
      print("SERVICE_SERVICE_EPIC - ServiceRequestService => BOOKINGS LENGTH: $serviceSnapshotDocs");
      if(serviceSnapshot.docs.isNotEmpty)
        serviceState =  ServiceState.fromJson(serviceSnapshot.docs.first.data());
      else{
        serviceState = ServiceState().toEmpty();
        //serviceState.booking_code = 'error';
      }

      //await Future.delayed(Duration(seconds: 3));
      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;
    }).expand((element) => [
      ServiceRequestByIDResponse(serviceState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ServiceCreateService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    ServiceState returnedServiceState;
    List<ServiceState> listService;
    return actions.whereType<CreateService>().asyncMap((event) async {
      ServiceState serviceState = event.serviceState;
      DocumentReference docReference = FirebaseFirestore.instance.collection('service').doc();

      /// 1 READ - 1 DOC
      serviceState.serviceId = docReference.id;
      serviceState.businessId = store.state.business.id_firestore;
      if (serviceState.fileToUploadList != null && serviceState.fileToUploadList.isNotEmpty) {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => erviceEpic/CreateService : Create service with images");
        await uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
          /// TODO check write
          debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => ServiceServiceEpic: uploadFiles executed.");
          docReference.set(updatedServiceState.toJson()).then((value) {
            debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => ServiceService has created new Service! ");
            returnedServiceState = updatedServiceState.copyWith();
          }).catchError((error) {
            debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService => ERROR: $error');
          });
          returnedServiceState = serviceState.copyWith();
        }).catchError((error, stackTrace) {
          debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => UploadFiles failed: $error");
        });
      } else {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => ServiceEpic/CreateService : Create service without images");
        docReference.set(serviceState.toJson()).then((value) {
          debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => ServiceService has created new Service! ");
        }).catchError((error) {
          debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService => ERROR: $error');
        });
        returnedServiceState = serviceState.copyWith();
      }
      listService = store.state.serviceList.serviceListState;
      listService.add(returnedServiceState);

      store.state.serviceListSnippetState.businessSnippet.forEach((element) {
        if(serviceState.categoryId.contains(element.categoryAbsolutePath.split('/').last)){
          debugPrint('SERVICE_SERVICE_EPIC - SERVICE NAME => ${serviceState.name}');
          debugPrint('SERVICE_SERVICE_EPIC - SERVICE DESCRIPTION =>  ${serviceState.description}');
          ServiceSnippetState tmp = ServiceSnippetState(
            serviceName: serviceState.name,
            serviceAbsolutePath: element.categoryAbsolutePath + '/' + serviceState.serviceId,
            serviceImage: serviceState.image1,
            serviceVisibility: serviceState.visibility,
            connectedBusinessId: []
          );
          element.serviceList.add(tmp);
          ++element.serviceNumberInternal;
        }
      });

      //await Future.delayed(Duration(seconds: 3));
      statisticsState = store.state.statistics;
      int reads = statisticsState.serviceCreateServiceRead;
      int writes = statisticsState.serviceCreateServiceWrite;
      int documents = statisticsState.serviceCreateServiceDocuments;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('SERVICE_SERVICE_EPIC - ServiceCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.serviceCreateServiceRead = reads;
      statisticsState.serviceCreateServiceWrite = writes;
      statisticsState.serviceCreateServiceDocuments = documents;
    }).expand((element) => [
          CreatedService(returnedServiceState),
          ServiceListSnippetRequestResponse(store.state.serviceListSnippetState),
          SetCreatedService(true),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.managerServiceList),
        ]);
  }
}

class ServiceUpdateService implements EpicClass<AppState> {
  ServiceState serviceState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateService>().asyncMap((event) async {
      if (event.serviceState.fileToUploadList != null) {
        await uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
          serviceState = updatedServiceState;
          FirebaseFirestore.instance.collection("service").doc(serviceState.serviceId).update(updatedServiceState.toJson()).then((value) {
            print("ServiceService should be updated online ");
            serviceState = updatedServiceState;

          }).catchError((error) {
            print(error);
          }).then((value) {});
        });
      } else {
        serviceState = event.serviceState;
        statisticsState = store.state.statistics;
        int reads = statisticsState.serviceUpdateServiceRead;
        int writes = statisticsState.serviceUpdateServiceWrite;
        int documents = statisticsState.serviceUpdateServiceDocuments;
        debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        statisticsState.serviceUpdateServiceRead = reads;
        statisticsState.serviceUpdateServiceWrite = writes;
        statisticsState.serviceUpdateServiceDocuments = documents;

        FirebaseFirestore.instance.collection("service").doc(serviceState.serviceId).update(serviceState.toJson()).then((value) {
          print("ServiceService should be updated online ");
        }).catchError((error) {
          print(error);
        }).then((value) {});
      }

      store.state.serviceListSnippetState.businessSnippet.forEach((element) {
        /*element.serviceList.forEach((element2) {
          String tmpPath = element.categoryAbsolutePath + '/' + serviceState.serviceId;
          //debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateService => P1: ${element2.serviceAbsolutePath} | P2: $tmpPath');
          if(element2.serviceAbsolutePath == tmpPath) {
            element2.serviceName = serviceState.name;
          }
        });*/
        ServiceSnippetState tmp = ServiceSnippetState().toEmpty();
        element.serviceList.forEach((element2) {
          String tmpPath = element.categoryAbsolutePath + '/' + serviceState.serviceId;
          //debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateService => P1: ${element2.serviceAbsolutePath} | P2: $tmpPath');
          if(element2.serviceAbsolutePath == tmpPath) {
            debugPrint('SERVICE_SERVICE_EPIC - ServiceUpdateService => P1: ${element2.serviceAbsolutePath} | P2: $tmpPath');
            //element2.serviceName = serviceState.name;
            //String tmpPath2 = serviceState.categoryId.first + '/' + serviceState.serviceId;
            element2.serviceName = serviceState.name;
            element2.serviceVisibility = serviceState.visibility;
            element2.serviceImage = serviceState.image1;
            element2.servicePrice = serviceState.price;
            element2.serviceAbsolutePath = tmpPath;
            //element2 = tmp;
          }
        });
        if(element.categoryAbsolutePath.split('/').last == serviceState.categoryId.first){
          bool found = false;
          element.serviceList.forEach((sL) {
            if(sL.serviceAbsolutePath.split('/').last == serviceState.serviceId){
                found = true;
            }
          });

          if(!found){
            String tmpPath = serviceState.categoryId.first + '/' + serviceState.serviceId;
            tmp.serviceName = serviceState.name;
            tmp.serviceVisibility = serviceState.visibility;
            tmp.serviceImage = serviceState.image1;
            tmp.servicePrice = serviceState.price;
            tmp.serviceAbsolutePath = tmpPath;
            element.serviceList.add(tmp);
          }

        }
        if(element.categoryAbsolutePath.split('/').last != serviceState.categoryId.first){
          bool found = false;
          int ympCount = 0;
          for(int i = 0; i < element.serviceList.length; i++){
            if(element.serviceList[i].serviceAbsolutePath.split('/').last == serviceState.serviceId){
              found = true;
              ympCount = i;
            }
          }

          if(found){
            element.serviceList.removeAt(ympCount);
          }

        }

        //element.serviceList.add(tmp);
      });
    }).expand((element) => [
      UpdateStatistics(statisticsState),
      UpdatedService(serviceState),
      ServiceListSnippetRequestResponse(store.state.serviceListSnippetState),
      SetEditedService(true),
      NavigatePushAction(AppRoutes.managerServiceList),
    ]);
  }
}

Future<ServiceState> uploadFiles(List<OptimumFileToUpload> fileToUploadList, ServiceState serviceState) async {
  debugPrint('service_service_epic => FILE TO UPLOAD LENGTH: ${fileToUploadList.length}');
  for (int index = 0; index < fileToUploadList.length; index++) {
    String fileUrl = await uploadToFirebaseStorage(fileToUploadList[index]);
    debugPrint('service_service_epic => IMAGE: ${fileUrl.toString()}');
    debugPrint('service_service_epic => URI PARSE: ${Uri.parse(fileUrl).toString()}');
    if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_1')) {
      serviceState.image1 = fileUrl.toString();
    } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_2')) {
      serviceState.image2 = fileUrl.toString();
    } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_3')) {
      serviceState.image3 = fileUrl.toString();
    }
    /*if (Uri.parse(fileUrl).toString().contains(serviceState.name + '_1')) {
      serviceState.image1 = fileUrl.toString();
    } else if (Uri.parse(fileUrl).toString().contains(serviceState.name + '_2')) {
      serviceState.image2 = fileUrl.toString();
    } else if (Uri.parse(fileUrl).toString().contains(serviceState.name + '_3')) {
      serviceState.image3 = fileUrl.toString();
    }*/

    /*await uploadToFirebaseStorage(fileToUploadList[index]).then((String fileUrl) {
      if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_1')) {
        serviceState.image1 = fileUrl.toString();
      } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_2')) {
        serviceState.image2 = fileUrl.toString();
      } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_3')) {
        serviceState.image3 = fileUrl.toString();
      }
    });*/
  }
  return serviceState;
}

class ServiceDeleteService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<ServiceState> serviceList = [];

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteService>().asyncMap((event) {
      String serviceId = event.serviceId;
      print("Deleting Service Id : " + serviceId);
      FirebaseFirestore.instance.collection('service').doc(serviceId).delete();
      serviceList = store.state.serviceList.serviceListState;
      serviceList.removeWhere((element) => element.serviceId == serviceId);

      statisticsState = StatisticsState().toEmpty();


      /// 1 DELETE
    }).expand((element) => [UpdateStatistics(statisticsState)]);
  }
}
