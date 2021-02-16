import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';

class ServiceListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("ServiceListService catched action");
    List<ServiceState> serviceStateList = [];
    return actions.whereType<ServiceListRequest>().asyncMap((event) async {
      print("ServiceListService Firestore request");
      if (event.permission == "user") {
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Shadow').get();
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseVisible = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Visible').get();
        serviceStateList.clear();
        servicesFirebaseVisible.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());

          serviceStateList.add(serviceState);
        });
      } else {
        CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
        Query query = servicesFirebase.where("businessId", isEqualTo: event.businessId);
        //   query = query.where("id_category", isEqualTo: categoryInviteState.id_category);
        serviceStateList.clear();
        await query.get().then((value) {
          value.docs.forEach((element) {
            ServiceState serviceState = ServiceState.fromJson(element.data());

            serviceStateList.add(serviceState);
          });
        });
      }

      print("Epic ServiceListService return list with " + serviceStateList.length.toString());
    }).expand((element) => [ServiceListReturned(serviceStateList)]);
  }
}

class ServiceListAndNavigateRequestService implements EpicClass<AppState> {
  List<ServiceState> serviceStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("ServiceListAndNavigateRequestService catched action");
    return actions.whereType<ServiceListAndNavigateRequest>().asyncMap((event) async {
      print("ServiceListAndNavigateRequestService Firestore request business Id: ${event.businessId}, permission: ${event.permission}");
      serviceStateList = List<ServiceState>();
      if (event.permission == "user") {
        print("ServiceListAndNavigateRequestService: permission as user");
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get();
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get();
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
      } else {
        print("ServiceListAndNavigateRequestService: permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).get();
        servicesFirebase.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
      }

      print("ServiceListAndNavigateRequestService return list with " + serviceStateList.length.toString());
    }).expand((element) => [
      ServiceListReturned(serviceStateList),
      NavigatePushAction(AppRoutes.bookingPage),
    ]);
  }
}

class ServiceListAndNavigateOnConfirmRequestService implements EpicClass<AppState> {
  List<ServiceState> serviceStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("ServiceListAndNavigateRequestService catched action");
    return actions.whereType<ServiceListAndNavigateOnConfirmRequest>().asyncMap((event) async {
      print("ServiceListAndNavigateRequestService Firestore request business Id: ${event.businessId}, permission: ${event.permission}");
      serviceStateList = List<ServiceState>();
      if (event.permission == "user") {
        print("ServiceListAndNavigateRequestService: permission as user");
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Deactivated').get();
        servicesFirebaseShadow.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
        var servicesFirebaseActive = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).where("visibility", isEqualTo: 'Active').get();
        servicesFirebaseActive.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
      } else {
        print("ServiceListAndNavigateRequestService: permission as manager");
        var servicesFirebase = await FirebaseFirestore.instance.collection("service").where("businessId", isEqualTo: event.businessId).get();
        servicesFirebase.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
      }

      print("ServiceListAndNavigateRequestService return list with " + serviceStateList.length.toString());
    }).expand((element) => [
          ServiceListReturned(serviceStateList),
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
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateService>().asyncMap((event) {

      if (event.serviceState.fileToUploadList != null) {
        // TODO at the moment the upload error is not managed
        uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
          serviceState = updatedServiceState;
          return updateService(updatedServiceState);
        });
      }
      serviceState = event.serviceState;
      return updateService(event.serviceState);
    }).expand((element) => [
     NavigatePushAction(AppRoutes.managerServiceList),
    ]);
  }
}

class ServiceUpdateServiceVisibility implements EpicClass<AppState> {
  String id;
  String visibility;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<SetServiceListVisibilityOnFirebase>().asyncMap((event) {
      id = event.serviceId;
      visibility = event.visibility;
      return FirebaseFirestore.instance.collection("service").doc(event.serviceId).update({
        "visibility": event.visibility,
      }).then((value) {
        print("ServiceService visibility should be updated online ");
      }).catchError((error) {
        print(error);
      }).then((value) {});
    }).expand((element) => [
      SetServiceListVisibility(id, visibility)
    ]);
  }
}

class ServiceCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    ServiceState returnedServiceState;
    List<ServiceState> listService;
    return actions.whereType<CreateService>().asyncMap((event) async {
      ServiceState serviceState = event.serviceState;
      DocumentReference docReference = FirebaseFirestore.instance.collection('service').doc();
      serviceState.serviceId = docReference.id;
      serviceState.businessId = store.state.business.id_firestore;
      if (serviceState.fileToUploadList != null && serviceState.fileToUploadList.isNotEmpty) {
        print("ServiceEpic/CreateService : Create service with images");
        await uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
          print("ServiceServiceEpic: uploadFiles executed.");
          docReference.set(updatedServiceState.toJson()).then((value) {
            print("ServiceService has created new Service! ");
            returnedServiceState = updatedServiceState.copyWith();
          }).catchError((error) {
            print(error);
          });
          returnedServiceState = serviceState.copyWith();
        }).catchError((error, stackTrace) {
          print("ServiceServiceEpic: uploadFiles failed: $error");
        });
      } else {
        print("ServiceEpic/CreateService : Create service without images");
        docReference.set(serviceState.toJson()).then((value) {
          print("ServiceService has created new Service! ");
        }).catchError((error) {
          print(error);
        });
        returnedServiceState = serviceState.copyWith();
      }
      listService = store.state.serviceList.serviceListState;
      listService.add(returnedServiceState);
    }).expand((element) => [CreatedService(returnedServiceState), NavigatePushAction(AppRoutes.managerServiceList),]);
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
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteService>().asyncMap((event) {
      String serviceId = event.serviceId;
      print("Deleting Service Id : " + serviceId);
      return FirebaseFirestore.instance.collection('service').doc(serviceId).delete();
    });
  }
}
