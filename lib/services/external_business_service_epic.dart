import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/file_upload_service.dart'
    if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class ExternalBusinessListRequestService implements EpicClass<AppState> {
  List<ExternalBusinessState> businessStateList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessListRequest>().asyncMap((event) async {
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestService => USER ID: ${event.userId}");
      businessStateList = [];
      QuerySnapshot businessListFromFirebase;
      int businessListFromFirebaseDocs = 0;
      if (event.userId == "any") {
        businessListFromFirebase = await FirebaseFirestore.instance /// 1 read - ? DOC
            .collection("business")
            .where("draft", isEqualTo: false)
            .where("id_firestore", isNotEqualTo: store.state.business.id_firestore)
            .limit(20)
            .get();
      } else {
        if (event.role == Role.manager || event.role == Role.worker) {
          businessListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
              .collection("business")
              .where("hasAccess", arrayContains: store.state.user.email)
              .where("id_firestore", isNotEqualTo: store.state.business.id_firestore)
              .limit(20)
              .get();
        } else if (event.role == Role.owner) {
          businessListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
              .collection("business")
              .where("ownerId", isEqualTo: store.state.user.uid)
              .where("id_firestore", isNotEqualTo: store.state.business.id_firestore)
              .limit(20)
              .get();
        } else if (event.role == Role.salesman) {
          businessListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
              .collection("business")
              .where("salesmanId", isEqualTo: store.state.user.uid)
              .where("id_firestore", isNotEqualTo: store.state.business.id_firestore)
              .limit(20)
              .get();
        } else if (event.role == Role.admin) {
          businessListFromFirebase = await FirebaseFirestore.instance /// 1 READ - ? DOC
              .collection("business")
              .where("id_firestore", isNotEqualTo: store.state.business.id_firestore)
              .limit(20)
              .get();
        }
      }

      businessListFromFirebaseDocs = businessListFromFirebase.docs.length;

      if(businessListFromFirebase.docs.isEmpty)
        businessStateList.add(ExternalBusinessState());

      businessListFromFirebase.docs.forEach((element) {
        ExternalBusinessState businessState = ExternalBusinessState.fromJson(element.data());
        businessState.id_firestore = element.id;
        businessStateList.add(businessState);
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessListRequestServiceRead;
      int writes = statisticsState.businessListRequestServiceWrite;
      int documents = statisticsState.businessListRequestServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + businessListFromFirebaseDocs;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessListRequestServiceRead = reads;
      statisticsState.businessListRequestServiceWrite = writes;
      statisticsState.businessListRequestServiceDocuments = documents;

      ///Return
      //return new ExternalBusinessListReturned(businessStateList);
    }).expand((element) => [
      ExternalBusinessListReturned(businessStateList),
      ServiceListSnippetListRequest(businessStateList),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalBusinessListRequestByIdsService implements EpicClass<AppState> {
  List<ExternalBusinessState> businessStateList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessListByIdsRequest>().asyncMap((event) async {
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestByIdsService => BUSINESS IDS LENGTH: ${event.businessIds.length}");
      businessStateList = [];

      int businessListFromFirebaseDocs = 0;

      for(int i = 0; i < event.businessIds.length; i++){
        QuerySnapshot businessListFromFirebase = await FirebaseFirestore.instance /// 1 read - ? DOC
            .collection("business")
            .where("id_firestore", isEqualTo: event.businessIds[i])
            .get();

        businessListFromFirebaseDocs += businessListFromFirebase.docs.length;

        businessListFromFirebase.docs.forEach((element) {
          ExternalBusinessState businessState = ExternalBusinessState.fromJson(element.data());
          businessState.id_firestore = element.id;
          businessStateList.add(businessState);
        });
      }


      statisticsState = store.state.statistics;
      int reads = statisticsState.businessListRequestServiceRead;
      int writes = statisticsState.businessListRequestServiceWrite;
      int documents = statisticsState.businessListRequestServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestByIdsService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + businessListFromFirebaseDocs;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessListRequestByIdsService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessListRequestServiceRead = reads;
      statisticsState.businessListRequestServiceWrite = writes;
      statisticsState.businessListRequestServiceDocuments = documents;

      if(businessStateList.isEmpty)
        businessStateList.add(ExternalBusinessState());
      ///Return
      //return new ExternalBusinessListReturned(businessStateList);
    }).expand((element) => [
      ExternalBusinessListReturned(businessStateList),
      ServiceListSnippetListRequest(businessStateList),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalBusinessServiceSnippetListRequestService implements EpicClass<AppState> {
  List<ServiceSnippetState> businessServiceSnippetList;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessServiceSnippetListRequest>().asyncMap((event) async {
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessServiceSnippetListRequest => EXTERNAL_BUSINESS ID: ${event.businessId}");
      int serviceSnippetListFromFirebaseDocs = 0;
      businessServiceSnippetList = [];
      QuerySnapshot serviceSnippetListFromFirebase = await FirebaseFirestore.instance 
            .collection("business/" + event.businessId + "serviceListSnapshot")
            .limit(1)
            .get();

      serviceSnippetListFromFirebaseDocs = serviceSnippetListFromFirebase.docs.length;

      serviceSnippetListFromFirebase.docs.forEach((element) {
        ServiceSnippetState serviceSnippet = ServiceSnippetState.fromJson(element.data());
        businessServiceSnippetList.add(serviceSnippet);
      });

      statisticsExternalBusinessServiceSnippetList(store, serviceSnippetListFromFirebaseDocs);

    }).expand((element) => [
      ExternalBusinessServiceSnippetListReturned(businessServiceSnippetList),
      UpdateStatistics(statisticsState),
    ]);
  }

  void statisticsExternalBusinessServiceSnippetList(EpicStore<AppState> store, int serviceSnippetListFromFirebaseDocs) {
    statisticsState = store.state.statistics;
    int reads = statisticsState.businessServiceSnippetListRequestServiceRead;
    int writes = statisticsState.businessServiceSnippetListRequestServiceWrite;
    int documents = statisticsState.businessServiceSnippetListRequestServiceDocuments;
    debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessServiceSnippetListRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
    ++reads;
    documents = documents + serviceSnippetListFromFirebaseDocs;
    debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessServiceSnippetListRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
    statisticsState.businessServiceSnippetListRequestServiceRead = reads;
    statisticsState.businessServiceSnippetListRequestServiceWrite = writes;
    statisticsState.businessServiceSnippetListRequestServiceDocuments = documents;
  }
}

class ExternalBusinessAndNavigateRequestService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessServiceListAndNavigateRequest>().asyncMap((event) async {
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateRequestService => DOCUMENT ID: ${event.businessStateId}");

      DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance /// 1 READ - 1 DOC
          .collection("business")
          .doc(event.businessStateId)
          .get();

     businessState =  ExternalBusinessState.fromJson(businessSnapshot.data());
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateRequestService => DOCUMENT ID from Request: ${businessState.id_firestore}");
      statisticsState = store.state.statistics;
      int reads = statisticsState.businessAndNavigateRequestServiceRead;
      int writes = statisticsState.businessAndNavigateRequestServiceWrite;
      int documents = statisticsState.businessAndNavigateRequestServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessAndNavigateRequestServiceRead = reads;
      statisticsState.businessAndNavigateRequestServiceWrite = writes;
      statisticsState.businessAndNavigateRequestServiceDocuments = documents;

    }).expand((element) => [
      ExternalBusinessRequestResponse(businessState),
      UpdateStatistics(statisticsState),
      ServiceListAndNavigateRequest(businessState.id_firestore, store.state.user.getRole().toString().split('.').last)
    ]);
  }
}

class ExternalBusinessAndNavigateOnConfirmRequestService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessAndNavigateOnConfirmRequest>().asyncMap((event) async {
      debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateOnConfirmRequestService => DOCUMENT ID: ${event.businessStateId}");

      DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance /// 1 READ - 1 DOC
          .collection("business")
          .doc(event.businessStateId)
          .get();

      businessState =  ExternalBusinessState.fromJson(businessSnapshot.data());

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessAndNavigateOnConfirmRequestServiceRead;
      int writes = statisticsState.businessAndNavigateOnConfirmRequestServiceWrite;
      int documents = statisticsState.businessAndNavigateOnConfirmRequestServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateOnConfirmRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessAndNavigateOnConfirmRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessAndNavigateOnConfirmRequestServiceRead = reads;
      statisticsState.businessAndNavigateOnConfirmRequestServiceWrite = writes;
      statisticsState.businessAndNavigateOnConfirmRequestServiceDocuments = documents;

    }).expand((element) => [
      ExternalBusinessRequestResponse(businessState),
      UpdateStatistics(statisticsState),
      ServiceListAndNavigateOnConfirmRequest(businessState.id_firestore, store.state.user.getRole().toString().split('.').last)
    ]);
  }
}

class ExternalBusinessRequestService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessRequest>().asyncMap((event) async {
      businessState =  await ExternalBusinessRequestMethod(event, store, businessState, statisticsState);
    }).expand((element) => [
      ExternalBusinessRequestResponse(businessState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class ExternalBusinessRequestAndNavigateService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ExternalBusinessRequestAndNavigate>().asyncMap((event) async {
      businessState = await ExternalBusinessRequestMethod(event, store, businessState, statisticsState);
    }).expand((element) => [
      ExternalBusinessRequestResponse(businessState),
      UpdateStatistics(statisticsState),
      NavigatePushAction(AppRoutes.business)
    ]);
  }
}



Future ExternalBusinessRequestMethod(dynamic event, EpicStore<AppState> store, ExternalBusinessState businessState, StatisticsState statisticsState) async {
  debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessRequestService => DOCUMENT ID: ${event.businessStateId}");

  DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance /// 1 READ - 1 DOC
      .collection("business")
      .doc(event.businessStateId)
      .get();

  businessState =  ExternalBusinessState.fromJson(businessSnapshot.data());

  statisticsState = store.state.statistics;
  int reads = statisticsState.businessRequestServiceRead;
  int writes = statisticsState.businessRequestServiceWrite;
  int documents = statisticsState.businessRequestServiceDocuments;
  debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
  ++reads;
  ++documents;
  debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
  statisticsState.businessRequestServiceRead = reads;
  statisticsState.businessRequestServiceWrite = writes;
  statisticsState.businessRequestServiceDocuments = documents;
  return businessState;
}

ExternalBusinessState businessStateImageLinksUpdate(
    ExternalBusinessState businessState, OptimumFileToUpload fileToUpload, String fileUrl) {
  return businessState;
}

Future<ExternalBusinessState> uploadFiles(List<OptimumFileToUpload> fileToUploadList, ExternalBusinessState businessState) async {
  await Future.forEach(
      fileToUploadList,
      (fileToUpload) => uploadToFirebaseStorage(fileToUpload).then((fileUrl) {
            if (fileToUpload.remoteFolder.contains("logo")) {
              businessState.logo = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("wide")) {
              businessState.wide = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("profile")) {
              businessState.profile = fileUrl.toString();
            } else if (fileToUpload.remoteFolder.contains("gallery")) {
              businessState.gallery[0] = fileUrl.toString();
            }
            return businessState;
          }));
  return businessState;
}

class ExternalBusinessUpdateService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessUpdateService => CALL OF UPDATE");
    return actions.whereType<UpdateExternalBusiness>().asyncMap((event) async {
      businessState = event.businessState;

      if (businessState.fileToUploadList != null) {
        // TODO at the moment the upload error is not managed
        businessState = await uploadFiles(businessState.fileToUploadList, businessState); /// ? WRITE
      }

      await FirebaseFirestore.instance /// 1 WRITE
          .collection("business")
          .doc(businessState.id_firestore)
          .update(businessState.toJson())
          .then((value) {
        debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessUpdateService => Should be updated online");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessUpdateServiceRead;
      int writes = statisticsState.businessUpdateServiceWrite;
      int documents = statisticsState.businessUpdateServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessUpdateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessUpdateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessUpdateServiceRead = reads;
      statisticsState.businessUpdateServiceWrite = writes;
      statisticsState.businessUpdateServiceDocuments = documents;

    }).expand((element) => [
      UpdatedExternalBusiness(businessState),
      UpdateStatistics(statisticsState),
      NavigatePushAction(AppRoutes.business),
    ]);
  }
}

class ExternalBusinessCreateService implements EpicClass<AppState> {
  ExternalBusinessState businessState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateExternalBusiness>().asyncMap((event) async {
      businessState = event.businessState;
      DocumentReference docReference = FirebaseFirestore.instance.collection("business").doc(); /// 1 READ - 1 DOC

      if (businessState.business_type.isNotEmpty && businessState.business_type[0].toString().isEmpty &&
          businessState.business_type.length > 1) {
        businessState.business_type = businessState.business_type.sublist(1);
      }

      businessState.id_firestore = docReference.id;

      if (store.state.user.salesman) {
        businessState.salesmanId = store.state.user.uid;
      } else {
        businessState.ownerId = store.state.user.uid;
      }

      if (event.businessState.fileToUploadList != null) {
        businessState = await uploadFiles(event.businessState.fileToUploadList, event.businessState); /// ? WRITE
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessCreateServiceRead;
      int writes = statisticsState.businessCreateServiceWrite;
      int documents = statisticsState.businessCreateServiceDocuments;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessCreateServiceRead = reads;
      statisticsState.businessCreateServiceWrite = writes;
      statisticsState.businessCreateServiceDocuments = documents;

      return docReference.set(businessState.toJson()).then((value) async{ /// 1 WRITE
        debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessCreateService => Has created new ExternalBusiness!");
      }).catchError((error) {
        debugPrint("EXTERNAL_BUSINESS_SERVICE_EPIC - ExternalBusinessCreateService => ERROR: $error");
      }).then((value) {
        return null;
      });

    }).expand((element) => [
      CreatedExternalBusiness(businessState),
      UpdateStatistics(statisticsState),
      NavigatePushAction(AppRoutes.businessList),
    ]);
  }
}

Future<CreatedExternalBusiness> createExternalBusiness(ExternalBusinessState businessState) {
  var docReference = FirebaseFirestore.instance.collection("business").doc();
  businessState.id_firestore = docReference.id;
  return docReference.set(businessState.toJson()).then((value) {
    print("ExternalBusinessService has created new ExternalBusiness! ");
    return new CreatedExternalBusiness(businessState);
  });
}

Future<UpdatedExternalBusiness> updateExternalBusiness(ExternalBusinessState businessState) {
  return FirebaseFirestore.instance
      .collection("business")
      .doc(businessState.id_firestore)
      .update(businessState.toJson())
      .then((value) {
    print("ExternalBusinessService should be updated online ");
    return new UpdatedExternalBusiness(businessState);
  });
}
