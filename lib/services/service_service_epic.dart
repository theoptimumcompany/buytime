import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';

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
    }).expand((element) => [
      UpdateStatistics(statisticsState),
      UpdatedService(serviceState),
      SetEditedService(true),
      NavigatePushAction(AppRoutes.managerServiceList),
    ]);
  }
}

Future<ServiceState> uploadFiles(List<OptimumFileToUpload> fileToUploadList, ServiceState serviceState) async {
  for (int index = 0; index < fileToUploadList.length; index++) {
    await uploadToFirebaseStorage(fileToUploadList[index]).then((fileUrl) {
      if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_1')) {
        serviceState.image1 = fileUrl.toString();
      } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_2')) {
        serviceState.image2 = fileUrl.toString();
      } else if (Uri.decodeFull(fileUrl).contains(serviceState.name + '_3')) {
        serviceState.image3 = fileUrl.toString();
      }
    });
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
    }).expand((element) => [UpdateStatistics(statisticsState), ServiceListReturned(serviceList)]);
  }
}
