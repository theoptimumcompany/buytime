import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
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
      int docs = 0;
      int read = 0;
      if (event.permission == "user") {
        serviceStateList.clear();
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get(); /// 1 READ - ? DOC
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseVisible = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get(); /// 1 READ - ? DOC
        docs = docs + servicesFirebaseVisible.docs.length;
        servicesFirebaseVisible.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        read = 2;
      } else {
        CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
        Query query = servicesFirebase.where("businessId", isEqualTo: event.businessId); /// 1 READ - ? DOC
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
        var servicesFirebaseShadow = await FirebaseFirestore.instance /// 1 READ - ? DOC
            .collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get();
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance /// 1 READ - ? DOC
            .collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get();
        docs = docs + servicesFirebaseActive.docs.length;
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });

        read = 2;
      } else {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateRequestService => Permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
            .collection("service").where("businessId", isEqualTo: event.businessId).get();
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

    }).expand((element) => [
      ServiceListReturned(serviceStateList),
      UpdateStatistics(statisticsState),
      RequestListCategory(businessId)
    ]);
  }
}

class ServiceListAndNavigateOnConfirmRequestService implements EpicClass<AppState> {
  List<ServiceState> serviceStateList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => CATCHED ACTION");
    return actions.whereType<ServiceListAndNavigateOnConfirmRequest>().asyncMap((event) async {
      debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Firestore request business Id: ${event.businessId}, permission: ${event.permission}");
      serviceStateList = [];
      int docs = 0;
      int read = 0;
      if (event.permission == "user") {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Permission as user");
        var servicesFirebaseShadow = await FirebaseFirestore.instance /// 1 READ - ? DOC
            .collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get();
        docs = servicesFirebaseShadow.docs.length;
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance /// 1 READ - ? DOC
            .collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get();
        docs = docs + servicesFirebaseActive.docs.length;
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });

        read = 2;
      } else {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceListAndNavigateOnConfirmRequestService => Permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance
            .collection("service").where("businessId", isEqualTo: event.businessId).get();
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

    }).expand((element) => [
          ServiceListReturned(serviceStateList),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.confirmBooking),
        ]);
  }
}

// class ServiceRequestService implements EpicClass<AppState> {
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     return actions.whereType<ServiceRequest>().asyncMap((event) {
// //      CategoryPath categoryPath = event.categoryPath;
// //      print("CategoryService document id:" + categoryPath.categoryId);
// //      return Firestore.instance.collection("business").document(categoryPath.businessId).collection("category").document(categoryPath.categoryId).get().then((snapshot) {
// //        print("CategoryService firestore listener:" + snapshot['name']);
// //        return new CategoryRequestResponse(CategoryState(
// //          name: snapshot['name'],
// //          id: snapshot['id'],
// //          level: snapshot['level'],
// //          children: snapshot['children'],
// //          parent: snapshot['parent'],
// //          manager: snapshot['manager'],
// //          businessId: snapshot['businessId'],
// //          notificationTo: snapshot['notificationTo'],
// //        ));
// //      });
//     }).takeUntil(actions.whereType<UnlistenCategory>());
//   }
// }

class ServiceUpdateService implements EpicClass<AppState> {
  ServiceState serviceState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateService>().asyncMap((event) {

      if (event.serviceState.fileToUploadList != null) {
        // TODO at the moment the upload error is not managed
        uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) { /// TODO write
          serviceState = updatedServiceState;
          return updateService(updatedServiceState);
        });
      }
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

      return updateService(event.serviceState);
    }).expand((element) => [
      UpdateStatistics(statisticsState),
     NavigatePushAction(AppRoutes.managerServiceList),
    ]);
  }
}

class ServiceUpdateServiceVisibility implements EpicClass<AppState> {
  String id;
  String visibility;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<SetServiceListVisibilityOnFirebase>().asyncMap((event) async{
      id = event.serviceId;
      visibility = event.visibility;
      await FirebaseFirestore.instance.collection("service").doc(event.serviceId).update({ /// 1 WRITE
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

    }).expand((element) => [
      UpdateStatistics(statisticsState),
      SetServiceListVisibility(id, visibility)
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
      DocumentReference docReference = FirebaseFirestore.instance.collection('service').doc(); /// 1 READ - 1 DOC
      serviceState.serviceId = docReference.id;
      serviceState.businessId = store.state.business.id_firestore;
      if (serviceState.fileToUploadList != null && serviceState.fileToUploadList.isNotEmpty) {
        debugPrint("SERVICE_SERVICE_EPIC - ServiceCreateService => erviceEpic/CreateService : Create service with images");
        await uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) { /// TODO check write
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
      UpdateStatistics(statisticsState),
      NavigatePushAction(AppRoutes.managerServiceList),]);
  }
}

Future<ServiceState> uploadFiles(List<OptimumFileToUpload> fileToUploadList, ServiceState serviceState) async {
  for (int index = 0; index < fileToUploadList.length; index++) {
    await uploadToFirebaseStorage(fileToUploadList[index]).then((fileUrl) {
      switch (index) {
        case 0:
          serviceState.image1 = fileUrl.toString();
          break;
        case 1:
          serviceState.image2 = fileUrl.toString();
          break;
        case 2:
          serviceState.image3 = fileUrl.toString();
          break;
      }
    });
  }

  // await Future.forEach(
  //     fileToUploadList,
  //     (fileToUpload) => uploadToFirebaseStorage(fileToUpload).then((fileUrl) {
  //           serviceState.image1 = fileUrl.toString();
  //           return serviceState;
  //         }));
  return serviceState;
}

// Future<CreatedService> createService(ServiceState serviceState) {
//   DocumentReference docReference = FirebaseFirestore.instance.collection('service').doc();
//   serviceState.serviceId = docReference.id;
//   return docReference.set(serviceState.toJson()).then((value) {
//     print("ServiceService has created new Service! ");
//     return serviceState;
//   }).catchError((error) {
//     print(error);
//   }).then((value) {
//     return null;
//   });
// }

Future<UpdatedService> updateService(ServiceState serviceState) {
  print("Visibilità è : " + serviceState.visibility);
  return FirebaseFirestore.instance.collection("service").doc(serviceState.serviceId).update(serviceState.toJson()).then((value) {
    print("ServiceService should be updated online ");
    return new UpdatedService(serviceState);
  }).catchError((error) {
    print(error);
  }).then((value) {
    return null;
  });
}

class ServiceDeleteService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteService>().asyncMap((event) {
      String serviceId = event.serviceId;
      print("Deleting Service Id : " + serviceId);

      return FirebaseFirestore.instance.collection('service').doc(serviceId).delete(); /// 1 DELETE
    }).expand((element) => [
      UpdateStatistics(statisticsState),
    ]);
  }
}
