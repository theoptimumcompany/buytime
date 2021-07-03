import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/default_category_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/file_upload_service.dart' if (dart.library.html) 'package:Buytime/services/file_upload_service_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class BusinessListRequestService implements EpicClass<AppState> {
  List<BusinessState> businessStateList;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessListRequest>().asyncMap((event) async {
      debugPrint("BUSINESS_SERVICE_EPIC - BusinessListRequestService => USER ID: ${event.userId}");
      businessStateList = [];
      QuerySnapshot businessListFromFirebase;
      int businessListFromFirebaseDocs = 0;
      int limit = 20;
      if (event.limit > 20) {
        limit = event.limit;
      }
      if (event.userId == "any") {
        businessListFromFirebase = await FirebaseFirestore.instance

            /// 1 read - ? DOC
            .collection("business")
            .where("draft", isEqualTo: false)
            .limit(limit)
            .get();
      } else {
        if (event.role == Role.manager || event.role == Role.worker) {
          businessListFromFirebase = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .where("hasAccess", arrayContains: store.state.user.email)
              .limit(limit)
              .get();
        } else if (event.role == Role.owner) {
          businessListFromFirebase = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .where("ownerId", isEqualTo: store.state.user.uid)
              .limit(limit)
              .get();
        } else if (event.role == Role.salesman) {
          businessListFromFirebase = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .where("salesmanId", isEqualTo: store.state.user.uid)
              .limit(limit)
              .get();
        } else if (event.role == Role.admin) {
          businessListFromFirebase = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .limit(limit)
              .get();
        }
      }

      businessListFromFirebaseDocs = businessListFromFirebase.docs.length;

      if (businessListFromFirebase.docs.isEmpty) businessStateList.add(BusinessState());

      businessListFromFirebase.docs.forEach((element) {
        BusinessState businessState = BusinessState.fromJson(element.data());
        businessState.id_firestore = element.id;
        businessStateList.add(businessState);
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessListRequestServiceRead;
      int writes = statisticsState.businessListRequestServiceWrite;
      int documents = statisticsState.businessListRequestServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + businessListFromFirebaseDocs;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessListRequestServiceRead = reads;
      statisticsState.businessListRequestServiceWrite = writes;
      statisticsState.businessListRequestServiceDocuments = documents;

      ///Return
      //return new BusinessListReturned(businessStateList);
    }).expand((element) => [
          BusinessListReturned(businessStateList),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class BusinessServiceSnippetListRequestService implements EpicClass<AppState> {
  List<ServiceSnippetState> businessServiceSnippetList;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessServiceSnippetListRequest>().asyncMap((event) async {
      debugPrint("BUSINESS_SERVICE_EPIC - BusinessServiceSnippetListRequest => BUSINESS ID: ${event.businessId}");
      int serviceSnippetListFromFirebaseDocs = 0;
      businessServiceSnippetList = [];
      QuerySnapshot serviceSnippetListFromFirebase = await FirebaseFirestore.instance.collection("business/" + event.businessId + "serviceListSnapshot").limit(1).get();

      serviceSnippetListFromFirebaseDocs = serviceSnippetListFromFirebase.docs.length;

      serviceSnippetListFromFirebase.docs.forEach((element) {
        ServiceSnippetState serviceSnippet = ServiceSnippetState.fromJson(element.data());
        businessServiceSnippetList.add(serviceSnippet);
      });

      statisticsBusinessServiceSnippetList(store, serviceSnippetListFromFirebaseDocs);
    }).expand((element) => [
          BusinessServiceSnippetListReturned(businessServiceSnippetList),
          UpdateStatistics(statisticsState),
        ]);
  }

  void statisticsBusinessServiceSnippetList(EpicStore<AppState> store, int serviceSnippetListFromFirebaseDocs) {
    statisticsState = store.state.statistics;
    int reads = statisticsState.businessServiceSnippetListRequestServiceRead;
    int writes = statisticsState.businessServiceSnippetListRequestServiceWrite;
    int documents = statisticsState.businessServiceSnippetListRequestServiceDocuments;
    debugPrint('BUSINESS_SERVICE_EPIC - BusinessServiceSnippetListRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
    ++reads;
    documents = documents + serviceSnippetListFromFirebaseDocs;
    debugPrint('BUSINESS_SERVICE_EPIC - BusinessServiceSnippetListRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
    statisticsState.businessServiceSnippetListRequestServiceRead = reads;
    statisticsState.businessServiceSnippetListRequestServiceWrite = writes;
    statisticsState.businessServiceSnippetListRequestServiceDocuments = documents;
  }
}

class BusinessAndNavigateRequestService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessServiceListAndNavigateRequest>().asyncMap((event) async {
      debugPrint("BUSINESS_SERVICE_EPIC - BusinessAndNavigateRequestService => DOCUMENT ID: ${event.businessStateId}");

      DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance

          /// 1 READ - 1 DOC
          .collection("business")
          .doc(event.businessStateId)
          .get();

      businessState = BusinessState.fromJson(businessSnapshot.data());
      debugPrint("BUSINESS_SERVICE_EPIC - BusinessAndNavigateRequestService => DOCUMENT ID from Request: ${businessState.id_firestore}");
      statisticsState = store.state.statistics;
      int reads = statisticsState.businessAndNavigateRequestServiceRead;
      int writes = statisticsState.businessAndNavigateRequestServiceWrite;
      int documents = statisticsState.businessAndNavigateRequestServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessAndNavigateRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessAndNavigateRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessAndNavigateRequestServiceRead = reads;
      statisticsState.businessAndNavigateRequestServiceWrite = writes;
      statisticsState.businessAndNavigateRequestServiceDocuments = documents;
    }).expand((element) => [
          BusinessRequestResponse(businessState),
          UpdateStatistics(statisticsState),
          //NavigatePushAction(AppRoutes.bookingPage),
          ServiceListSnippetRequestNavigate(businessState.id_firestore)
          //ServiceListAndNavigateRequest(businessState.id_firestore, store.state.user.getRole().toString().split('.').last)
        ]);
  }
}

class BusinessAndNavigateOnConfirmRequestService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessAndNavigateOnConfirmRequest>().asyncMap((event) async {
      debugPrint("BUSINESS_SERVICE_EPIC - BusinessAndNavigateOnConfirmRequestService => DOCUMENT ID: ${event.businessStateId}");

      DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance

          /// 1 READ - 1 DOC
          .collection("business")
          .doc(event.businessStateId)
          .get();

      businessState = BusinessState.fromJson(businessSnapshot.data());

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessAndNavigateOnConfirmRequestServiceRead;
      int writes = statisticsState.businessAndNavigateOnConfirmRequestServiceWrite;
      int documents = statisticsState.businessAndNavigateOnConfirmRequestServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessAndNavigateOnConfirmRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++documents;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessAndNavigateOnConfirmRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessAndNavigateOnConfirmRequestServiceRead = reads;
      statisticsState.businessAndNavigateOnConfirmRequestServiceWrite = writes;
      statisticsState.businessAndNavigateOnConfirmRequestServiceDocuments = documents;
    }).expand((element) => [BusinessRequestResponse(businessState), UpdateStatistics(statisticsState), ServiceListAndNavigateOnConfirmRequest(businessState.id_firestore, store.state.user.getRole().toString().split('.').last)]);
  }
}

class BusinessRequestService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessRequest>().asyncMap((event) async {
      businessState = await BusinessRequestMethod(event, store, businessState, statisticsState);
    }).expand((element) => [
          BusinessRequestResponse(businessState),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class BusinessRequestAndNavigateService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BusinessRequestAndNavigate>().asyncMap((event) async {
      businessState = await BusinessRequestMethod(event, store, businessState, statisticsState);
    }).expand((element) => [BusinessRequestResponse(businessState), UpdateStatistics(statisticsState), NavigatePushAction(AppRoutes.business)]);
  }
}

Future BusinessRequestMethod(dynamic event, EpicStore<AppState> store, BusinessState businessState, StatisticsState statisticsState) async {
  debugPrint("BUSINESS_SERVICE_EPIC - BusinessRequestService => DOCUMENT ID: ${event.businessStateId}");

  DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance

      /// 1 READ - 1 DOC
      .collection("business")
      .doc(event.businessStateId)
      .get();

  businessState = BusinessState.fromJson(businessSnapshot.data());

  statisticsState = store.state.statistics;
  int reads = statisticsState.businessRequestServiceRead;
  int writes = statisticsState.businessRequestServiceWrite;
  int documents = statisticsState.businessRequestServiceDocuments;
  debugPrint('BUSINESS_SERVICE_EPIC - BusinessRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
  ++reads;
  ++documents;
  debugPrint('BUSINESS_SERVICE_EPIC - BusinessRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
  statisticsState.businessRequestServiceRead = reads;
  statisticsState.businessRequestServiceWrite = writes;
  statisticsState.businessRequestServiceDocuments = documents;
  return businessState;
}

BusinessState businessStateImageLinksUpdate(BusinessState businessState, OptimumFileToUpload fileToUpload, String fileUrl) {
  return businessState;
}

Future<BusinessState> uploadFiles(List<OptimumFileToUpload> fileToUploadList, BusinessState businessState) async {
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

class BusinessUpdateService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;
  var actionArray = [];

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("BUSINESS_SERVICE_EPIC - BusinessUpdateService => CALL OF UPDATE");
    return actions.whereType<UpdateBusiness>().asyncMap((event) async {
      businessState = event.businessState;

      if (businessState.fileToUploadList != null) {
        // TODO at the moment the upload error is not managed
        businessState = await uploadFiles(businessState.fileToUploadList, businessState);

        /// ? WRITE
      }

      var refBusiness = await FirebaseFirestore.instance.collection("business").doc(businessState.id_firestore);

      //  if(refBusiness.s)

      refBusiness.update(businessState.toJson()).then((value) {
        debugPrint("BUSINESS_SERVICE_EPIC - BusinessUpdateService => Should be updated online");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessUpdateServiceRead;
      int writes = statisticsState.businessUpdateServiceWrite;
      int documents = statisticsState.businessUpdateServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessUpdateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessUpdateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessUpdateServiceRead = reads;
      statisticsState.businessUpdateServiceWrite = writes;
      statisticsState.businessUpdateServiceDocuments = documents;
    }).expand((element) {
      actionArray.add(UpdatedBusiness(businessState));
      actionArray.add(UpdateStatistics(statisticsState));
      actionArray.add(NavigatePushAction(AppRoutes.business));
      //   actionArray.add(UpdateDefaultCategory(businessState));
      return actionArray;
    });
  }
}

class BusinessCreateService implements EpicClass<AppState> {
  BusinessState businessState;
  StatisticsState statisticsState;
  var actionArray = [];

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBusiness>().asyncMap((event) async {
      actionArray.clear();
      businessState = event.businessState;
      DocumentReference docReference = FirebaseFirestore.instance.collection("business").doc();
     // await FirebaseFirestore.instance.collection("defaultCategory").where("businessType", arrayContains: event.businessState.business_type).orderBy('category.level').get();
      /// 1 READ - 1 DOC
      ///
      if (businessState.business_type.isNotEmpty && businessState.business_type[0].toString().isEmpty && businessState.business_type.length > 1) {
        businessState.business_type = businessState.business_type;
      }

      businessState.id_firestore = docReference.id;

      if (store.state.user.salesman) {
        businessState.salesmanId = store.state.user.uid;
      } else {
        businessState.ownerId = store.state.user.uid;
      }

      if (event.businessState.fileToUploadList != null) {
        businessState = await uploadFiles(event.businessState.fileToUploadList, event.businessState);

        /// ? WRITE
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.businessCreateServiceRead;
      int writes = statisticsState.businessCreateServiceWrite;
      int documents = statisticsState.businessCreateServiceDocuments;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('BUSINESS_SERVICE_EPIC - BusinessCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.businessCreateServiceRead = reads;
      statisticsState.businessCreateServiceWrite = writes;
      statisticsState.businessCreateServiceDocuments = documents;

      return docReference.set(businessState.toJson()).then((value) async {
        /// 1 WRITE
        debugPrint("BUSINESS_SERVICE_EPIC - BusinessCreateService => Has created new Business!");
        actionArray.add(CreatedBusiness(businessState));
        actionArray.add(UpdateStatistics(statisticsState));
        actionArray.add(NavigatePushAction(AppRoutes.businessList));

       // actionArray.add(GenerateDefaultCategory(businessState));
      }).catchError((error) {
        debugPrint("BUSINESS_SERVICE_EPIC - BusinessCreateService => ERROR: $error");
      }).then((value) {
        return null;
      });
    }).expand((element) {
      return actionArray;
    });
  }
}

Future<CreatedBusiness> createBusiness(BusinessState businessState) {
  var docReference = FirebaseFirestore.instance.collection("business").doc();
  businessState.id_firestore = docReference.id;
  return docReference.set(businessState.toJson()).then((value) {
    print("BusinessService has created new Business! ");
    return new CreatedBusiness(businessState);
  });
}

Future<UpdatedBusiness> updateBusiness(BusinessState businessState) {
  return FirebaseFirestore.instance.collection("business").doc(businessState.id_firestore).update(businessState.toJson()).then((value) {
    print("BusinessService should be updated online ");
    return new UpdatedBusiness(businessState);
  });
}

/*
class BusinessGenerateDefaultCategoryService implements EpicClass<AppState> {
  var actionArray = [];
  DefaultCategoryState defaultCategory;
  BuildContext context;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<GenerateDefaultCategory>().asyncMap((event) async {
      actionArray.clear();
      DefaultCategoryState defaultCategory;
      await FirebaseFirestore.instance.collection("defaultCategory").where("businessType", arrayContainsAny: event.businessState.business_type).orderBy('category.level').get().then((querySnapshot) => {
            actionArray.add(CategoryTreeCreateIfNotExists(event.businessState.id_firestore)),
            for (var z = 0; z < querySnapshot.docs.length; z++)
              {
                defaultCategory = DefaultCategoryState.fromJson(querySnapshot.docs[z].data()),
                actionArray.add(CreateDefaultCategory(defaultCategory.category, event.businessState.id_firestore)),
              },
          });

      actionArray.add(BeforeConvertBusinessToSnippet(event.businessState));
      
    }).expand((element) {
      return actionArray;
    });
  }
}

class BeforeConvertBusinessToSnippetService implements EpicClass<AppState> {
  var actionArray = [];
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<BeforeConvertBusinessToSnippet>().asyncMap((event) async {
      actionArray.clear();
      actionArray.add(ConvertBusinessToSnippet(event.business));

    }).expand((element) {
      return actionArray;
    }).delay(Duration(seconds: 7));
  }
}


class ConvertBusinessToSnippetService implements EpicClass<AppState> {
  var actionArray = [];
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ConvertBusinessToSnippet>().asyncMap((event) async {
      actionArray.clear();
      print("START EPIC CONVERTING BUSINESS TO SNIPPET");
      await FirebaseFirestore.instance.collection("convertionTrigger").doc("convertionTriggerDocument").update({'businessIdToSnippet': event.business.id_firestore,'businessNameToSnippet': event.business.name,'businessProfileToSnippet': event.business.profile});
      actionArray.add(NavigatePushAction(AppRoutes.businessList));

    }).expand((element) {
      return actionArray;
    });
  }
}
*/
/*class BusinessUpdateDefaultCategoryService implements EpicClass<AppState> {
  var actionArray = [];
  DefaultCategoryState defaultCategory;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateDefaultCategory>().asyncMap((event) async {
      DefaultCategoryState defaultCategory;
      await FirebaseFirestore.instance.collection("defaultCategory").where("businessType", arrayContainsAny: event.businessState.business_type).orderBy('category.level').get().then((querySnapshot) => {
            for (var z = 0; z < querySnapshot.docs.length; z++)
              {
                defaultCategory = DefaultCategoryState.fromJson(querySnapshot.docs[z].data()),
                // actionArray.add(CreateDefaultCategory(defaultCategory.category, event.businessState.id_firestore)),
              },
          });

      // actionArray.add(ConvertBusinessToSnippet(event.businessState.id_firestore));
    }).expand((element) {
      return actionArray;
    });
  }
}
*/