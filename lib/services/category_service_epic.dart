import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/file_upload_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<CategoryState> categoryStateList;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("CATEGORY_SERVICE_EPIC - CategoryListRequestService => CATCHED ACTION");
    return actions.whereType<RequestListCategory>().asyncMap((event) async {


      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("business")
          .doc(event.businessId)
          .collection("category")
          .get();
      int snapshotDocs = snapshot.docs.length;
      categoryStateList = [];
      snapshot.docs.forEach((element) {
        CategoryState categoryState = CategoryState.fromJson(element.data());
        categoryState.businessId = event.businessId;
        categoryState.id = element.id;
        categoryStateList.add(categoryState);
      });

      debugPrint('CATEGORY_SERVICE_EPIC - CategoryListRequestService => CATEGORY LENGHT: ${categoryStateList.length}');
      debugPrint("CATEGORY_SERVICE_EPIC - CategoryListRequestService => Return list with ${categoryStateList.length}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryListRequestServiceRead;
      int writes = statisticsState.categoryListRequestServiceWrite;
      int documents = statisticsState.categoryListRequestServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + snapshotDocs;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryListRequestServiceRead = reads;
      statisticsState.categoryListRequestServiceWrite = writes;
      statisticsState.categoryListRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryListReturned(categoryStateList),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class AllCategoryListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<CategoryState> categoryStateList;
  List<ServiceState> serviceStateList;
  List<BusinessState> businessStateList;
  List<ServiceListSnippetState> serviceListSnippetListState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("AllCategoryListRequestService - AllCategoryListRequestService => CATCHED ACTION");
    return actions.whereType<AllRequestListCategory>().asyncMap((event) async {
      QuerySnapshot businessListFromFirebase;
      businessStateList = [];
      businessListFromFirebase = await FirebaseFirestore.instance
          .collection("business")
          .where("draft", isEqualTo: false)
          .get();

      List<QuerySnapshot> queryList = [];
      categoryStateList = [];
      serviceStateList = [];
      serviceListSnippetListState = [];
      List<String> tmpBusinessIdList = [];

      CollectionReference servicesFirebase = FirebaseFirestore.instance.collection("service");
      Query query;

      if (store.state.area != null && store.state.area.areaId != null && store.state.area.areaId.isNotEmpty) {
        query = servicesFirebase
            .where("tag", arrayContains: store.state.area.areaId)
            .where("visibility", isEqualTo: 'Active');
      } else {
        query = servicesFirebase
            .where("visibility", isEqualTo: 'Active');
      }

      await query.get().then((value) {
        value.docs.forEach((element) {
          ServiceState serviceState = ServiceState.fromJson(element.data());
          serviceStateList.add(serviceState);
        });
      });

      for (int i = 0; i < businessListFromFirebase.docs.length; i++) {
        /// TODO: replace with category from snippet
        BusinessState businessState = BusinessState.fromJson(businessListFromFirebase.docs[i].data());
        businessStateList.add(businessState);
        /*QuerySnapshot snapshot = await FirebaseFirestore.instance
            /// 1 READ - ? DOC
            .collection("business")
            .doc(businessListFromFirebase.docs[i].id)
            .collection("category")
            //.where("level", isEqualTo: 0)
            .limit(10)
            .get();
        snapshot.docs.forEach((element) {
          CategoryState categoryState = CategoryState.fromJson(element.data());
          categoryState.businessId = businessListFromFirebase.docs[i].id;
          categoryState.id = element.id;
          categoryStateList.add(categoryState);
        });*/
        /// END TODO
        tmpBusinessIdList.add(businessListFromFirebase.docs[i].id);
        var servicesFirebaseShadow = await FirebaseFirestore.instance.collection("business").doc(businessListFromFirebase.docs[i].id).collection('service_list_snippet').get();
        if (servicesFirebaseShadow.docs.isNotEmpty){
          ServiceListSnippetState tmp = ServiceListSnippetState.fromJson(servicesFirebaseShadow.docs.first.data());
          serviceListSnippetListState.add(tmp);
          tmp.businessSnippet.forEach((category) {
            //String categoryId = category.categoryAbsolutePath.split('/')[1];
            String businessId = category.categoryAbsolutePath.split('/')[0];
            if(businessId == businessState.id_firestore){
              CategoryState categoryState = CategoryState().toEmpty();
              categoryState.businessId = businessId;
              categoryState.id = category.categoryAbsolutePath.split('/').last;
              categoryState.name = category.categoryName;
              categoryState.categoryImage = category.categoryImage;
              if(category.categoryAbsolutePath.split('/').length == 2){
                categoryState.level = 0;
                categoryState.parent = Parent(id: 'no_parent');
              }else{
                categoryState.level = 1;
                categoryState.parent = Parent(id: category.categoryAbsolutePath.split('/')[1]);
              }
              categoryState.customTag = category.tags.isNotEmpty ? category.tags.first : '';
              categoryStateList.add(categoryState);
            }
          });
        }
      }
      debugPrint('CATEGORY_SERVICE_EPIC - AllCategoryListRequestService => CATEGORY LENGHT: ${categoryStateList.length}');
      debugPrint("CATEGORY_SERVICE_EPIC - AllCategoryListRequestService => Return list with ${categoryStateList.length}");
      if (categoryStateList.isEmpty) categoryStateList.add(CategoryState());
      if (serviceStateList.isEmpty) serviceStateList.add(ServiceState());
    }).expand((element) => [
          BusinessListReturned(businessStateList),
          CategoryListReturned(categoryStateList),
          ServiceListReturned(serviceStateList),
          ServiceListSnippetListRequestResponse(serviceListSnippetListState),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class UserCategoryListRequestService implements EpicClass<AppState> {
  List<CategoryState> categoryStateList;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => CATCHED ACTION");
    return actions.whereType<UserRequestListCategory>().asyncMap((event) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance

          /// 1 READ - ? DOC
          .collection("business")
          .doc(event.businessId)
          .collection("category")
          .where("customTag", isEqualTo: 'showcase')
          .get();

      int snapshotDocs = snapshot.docs.length;

      debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => Firestore request");
      categoryStateList = [];
      snapshot.docs.forEach((element) {
        CategoryState categoryState = CategoryState.fromJson(element.data());
        categoryState.businessId = event.businessId;
        categoryState.id = element.id;
        categoryStateList.add(categoryState);
      });

      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => CATEGORY LIST LENGTH: ${categoryStateList.length}');
      debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => Return list with ${categoryStateList.length}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.userCategoryListRequestServiceRead;
      int writes = statisticsState.userCategoryListRequestServiceWrite;
      int documents = statisticsState.userCategoryListRequestServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + snapshotDocs;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userCategoryListRequestServiceRead = reads;
      statisticsState.userCategoryListRequestServiceWrite = writes;
      statisticsState.userCategoryListRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryListReturned(categoryStateList),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.bookingPage),
        ]);
  }
}

class UserCategoryListByIdsRequestService implements EpicClass<AppState> {
  List<CategoryState> categoryStateList;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService => CATCHED ACTION");
    return actions.whereType<UserRequestListByIdsCategory>().asyncMap((event) async {
      int read = 0;
      int snapshotDocs = 0;
      categoryStateList = [];

      for (int i = 0; i < event.categoryIds.length; i++) {
        String businesId = '';
        store.state.serviceListSnippetState.businessSnippet.forEach((bS) {
          if (bS.categoryAbsolutePath.split('/').last == event.categoryIds[i]) {
            businesId = bS.categoryAbsolutePath.split('/').first;
          }
        });

        QuerySnapshot snapshot = await FirebaseFirestore.instance

            /// 1 READ - ? DOC
            .collection("business")
            .doc(businesId)
            .collection("category")
            .where("id", isEqualTo: event.categoryIds[i])
            .get();

        snapshotDocs += snapshot.docs.length;

        debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService => Firestore request");
        snapshot.docs.forEach((element) {
          CategoryState categoryState = CategoryState.fromJson(element.data());
          categoryState.businessId = businesId;
          categoryState.id = element.id;
          categoryStateList.add(categoryState);
        });
        ++read;
      }

      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService => CATEGORY LIST LENGTH: ${categoryStateList.length}');
      debugPrint("CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService => Return list with ${categoryStateList.length}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.userCategoryListRequestServiceRead;
      int writes = statisticsState.userCategoryListRequestServiceWrite;
      int documents = statisticsState.userCategoryListRequestServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + snapshotDocs;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListByIdsRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.userCategoryListRequestServiceRead = reads;
      statisticsState.userCategoryListRequestServiceWrite = writes;
      statisticsState.userCategoryListRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryListReturned(categoryStateList),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.bookingPage),
        ]);
  }
}

class CategoryRootListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<CategoryState> categoryStateList;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("CATEGORY_SERVICE_EPIC - CategoryRootListRequestService => CATCHED ACTION");
    return actions.whereType<RequestRootListCategory>().asyncMap((event) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance

          /// 1 READ - ? DOC
          .collection("business")
          .doc(event.businessId)
          .collection("category")
          .where("level", isEqualTo: 0)
          .get();
      int snapshotDocs = snapshot.docs.length;

      debugPrint("CATEGORY_SERVICE_EPIC - CategoryRootListRequestService => Firestore request");
      categoryStateList = [];
      snapshot.docs.forEach((element) {
        CategoryState categoryState = CategoryState.fromJson(element.data());
        categoryState.businessId = event.businessId;
        categoryState.id = element.id;
        categoryStateList.add(categoryState);
      });
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryRootListRequestService => LENGTH: ${categoryStateList.length}');
      debugPrint("CATEGORY_SERVICE_EPIC - CategoryRootListRequestService => Return list with ${categoryStateList.length}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryRootListRequestServiceRead;
      int writes = statisticsState.categoryRootListRequestServiceWrite;
      int documents = statisticsState.categoryRootListRequestServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + snapshotDocs;
      debugPrint('CATEGORY_SERVICE_EPIC - UserCategoryListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryRootListRequestServiceRead = reads;
      statisticsState.categoryRootListRequestServiceWrite = writes;
      statisticsState.categoryRootListRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryListReturned(categoryStateList),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryRequestService implements EpicClass<AppState> {
  CategoryState categoryState = CategoryState().toEmpty();
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryRequest>().asyncMap((event) async {
      debugPrint("CATEGORY_SERVICE_EPIC - CategoryRequestService => CATEGORY ID: ${event.id}");
      String categoryId = event.id;

      QuerySnapshot query = await FirebaseFirestore.instance

          /// 1 READ - ? DOC
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .where("id", isEqualTo: categoryId)
          .get();

      int queryDocs = query.docs.length;
      query.docs.forEach((snapshot) {
        categoryState = CategoryState.fromJson(snapshot.data());
      });
      debugPrint("CATEGORY_SERVICE_EPIC - CategoryRequestService => CATEGORY NAME: ${categoryState.name}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryRequestServiceRead;
      int writes = statisticsState.categoryRequestServiceWrite;
      int documents = statisticsState.categoryRequestServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + queryDocs;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryRequestServiceRead = reads;
      statisticsState.categoryRequestServiceWrite = writes;
      statisticsState.categoryRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryRequestResponse(categoryState),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryInviteManagerService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteManager>().asyncMap((event) async {
      ///In questa epic devo gestire invito del manager
      ///Inserisco nella categoria il manager alla lista dei manager e nella lista mailManager
      ///In seguito partirà una cloud function che fa gli opportuni controlli sui permessi dell'utente che aggiunge la nuova mail, e scrive i permessi della mail aggiunta per quella categoria

      debugPrint("CATEGORY_SERVICE_EPIC - CategoryInviteManagerService => Inizia elaborazione per inserire Oggetto Manager nel Database");
      Manager manager = event.manager;
      int write = 0;
      FirebaseFirestore.instance

          /// ? WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "manager": FieldValue.arrayUnion([manager.toJson()])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryInviteManagerService => Category Service added Manager to field manager");
      });

      FirebaseFirestore.instance

          /// ? WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "managerMailList": FieldValue.arrayUnion([manager.mail])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryInviteManagerService => Category Service added manager's mail to field managerMailList");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteManagerServiceRead;
      int writes = statisticsState.categoryInviteManagerServiceWrite;
      int documents = statisticsState.categoryInviteManagerServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryInviteManagerService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + 2; //TODO check writes
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryInviteManagerService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteManagerServiceRead = reads;
      statisticsState.categoryInviteManagerServiceWrite = writes;
      statisticsState.categoryInviteManagerServiceDocuments = documents;
    }).expand((element) => [
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryInviteWorkerService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteWorker>().asyncMap((event) async {
      ///In questa epic devo gestire invito del manager
      ///Inserisco nella categoria il manager alla lista dei manager e nella lista mailManager
      ///In seguito partirà una cloud function che fa gli opportuni controlli sui permessi dell'utente che aggiunge la nuova mail, e scrive i permessi della mail aggiunta per quella categoria

      Worker worker = event.worker;
      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "worker": FieldValue.arrayUnion([worker.toJson()])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryInviteWorkerService => Category Service added Worker to field worker");
      });

      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "workerMailList": FieldValue.arrayUnion([worker.mail])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryInviteWorkerService => Category Service added worker's mail to field workerMailList");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteWorkerServiceRead;
      int writes = statisticsState.categoryInviteWorkerServiceWrite;
      int documents = statisticsState.categoryInviteWorkerServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryInviteWorkerService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + 2; //TODO check writes
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryInviteWorkerService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteWorkerServiceRead = reads;
      statisticsState.categoryInviteWorkerServiceWrite = writes;
      statisticsState.categoryInviteWorkerServiceDocuments = documents;
    }).expand((element) => [
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryDeleteManagerService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryManager>().asyncMap((event) async {
      Manager manager = event.manager;
      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "manager": FieldValue.arrayRemove([manager.toJson()])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryDeleteManagerService => Category Service deleted Manager to field manager");
      });

      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "managerMailList": FieldValue.arrayRemove([manager.mail])
      }).then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryDeleteManagerService => Category Service deleted manager's mail to field managerMailList");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryDeleteManagerServiceRead;
      int writes = statisticsState.categoryDeleteManagerServiceWrite;
      int documents = statisticsState.categoryDeleteManagerServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteManagerService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + 2;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteManagerService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryDeleteManagerServiceRead = reads;
      statisticsState.categoryDeleteManagerServiceWrite = writes;
      statisticsState.categoryDeleteManagerServiceDocuments = documents;

      //return;
    }).expand((element) => [
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryDeleteWorkerService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryWorker>().asyncMap((event) async {
      Worker worker = event.worker;
      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "worker": FieldValue.arrayRemove([worker.toJson()])
      }).then((value) {
        print("CATEGORY_SERVICE_EPIC - CategoryDeleteWorkerService => Category Service deleted Worker to field worker");
      });

      FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "workerMailList": FieldValue.arrayRemove([worker.mail])
      }).then((value) {
        print("CATEGORY_SERVICE_EPIC - CategoryDeleteWorkerService => Category Service deleted worker's mail to field workerMailList");
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryDeleteWorkerServiceRead;
      int writes = statisticsState.categoryDeleteWorkerServiceWrite;
      int documents = statisticsState.categoryDeleteWorkerServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteWorkerService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + 2; //TODO check writes
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteManagerService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryDeleteWorkerServiceRead = reads;
      statisticsState.categoryDeleteWorkerServiceWrite = writes;
      statisticsState.categoryDeleteWorkerServiceDocuments = documents;

      //return;
    }).expand((element) => [
          UpdateStatistics(statisticsState),
        ]);
  }
}

///Scorro Albero e una volta trovato nodo con id passato, controllo se ha figli, se li ha modifico il parent nuovo
// seekNode(List<dynamic> list, String id, String id_business, String rootId, int level, String oldRootId) {
//   if (list != null) {
//     for (int i = 0; i < list.length; i++) {
//       if(list[i].categoryAbsolutePath.split('/').contains(id))
//       {
//         openTreeToUpdateSon(list[i].categoryAbsolutePath.split('/').last, id_business, rootId, level, oldRootId);
//       }
//     }
//   }
// }

/*openTreeToUpdateSon(List<dynamic> list, String id_business, String rootId, int level, String oldRootId) async {
  for (int i = 0; i < list.length; i++) {
    ///Qui ho il figlio da aggiornare nelle categorie
    FirebaseFirestore.instance.collection("business").doc(id_business).collection("category").doc(list[i]['nodeId']).update({"categoryRootId": rootId, "parent.parentRootId": rootId, "level": level + 1});

    print("Root Nuova " + rootId);
    print("Root Vecchia " + oldRootId);
    print("Id  categoria da cercare " + list[i]['nodeId']);

    ///Qui ho il figlio da aggiornare nei servizi
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("service").where("categoryId", arrayContains: list[i]['nodeId']).get();

    ///Qui ho agganciato i servizi con categoryId a cui è variato il categoryRootId
    snapshot.docs.forEach((element) {
      FirebaseFirestore.instance.collection("service").doc(element.id).update({
        "categoryRootId": FieldValue.arrayUnion([rootId]),
      });
      FirebaseFirestore.instance.collection("service").doc(element.id).update({
        "categoryRootId": FieldValue.arrayRemove([oldRootId]),
      });
    });

    print("Firebase-Update : categoryServiceEpic");

    if (list[i]['nodeCategory'] != null) {
      openTreeToUpdateSon(list[i]['nodeCategory'], id_business, rootId, level, oldRootId);
    }
  }
}
*/

class CategoryUpdateService implements EpicClass<AppState> {
  CategoryState categoryState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateCategory>().asyncMap((event) async {
      categoryState = event.categoryState;

      if (event.categoryState.fileToUpload != null) {
        categoryState = await uploadFile(event.categoryState.fileToUpload, event.categoryState).catchError((error, stackTrace) {
          /// ? WRITE
          debugPrint("CATEGORY_SERVICE_EPIC - CategoryUpdateService => category_service_epic: uploadFiles failed: $error");
          return null;
        });
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryUpdateService => category_service_epic: uploadFiles executed.");
        debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => category_service_epic: categoryImage in: ${categoryState.categoryImage}');
      }

      await FirebaseFirestore.instance

          /// 1 WRITE
          .collection("business")
          .doc(event.categoryState.businessId)
          .collection("category")
          .doc(event.categoryState.id)
          .update(event.categoryState.toJson())
          .then((value) {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryUpdateService => Category Service should be updated online ");
        String parentPath = '';
        store.state.serviceListSnippetState.businessSnippet.forEach((element) {
          List<String> tmp = element.categoryAbsolutePath.split('/');
          if (tmp.last == categoryState.parent.id) {
            debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => P1: ${tmp.last} | P2: ${categoryState.parent.id}');
            parentPath = element.categoryAbsolutePath;
            debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => P1: PARENT PATH: ${element.categoryAbsolutePath}');
          }
          if (tmp.last == categoryState.id) {
            debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => MATCH');
            debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => CURRENT PATH: ${element.categoryAbsolutePath}');
            if (categoryState.parent.id != 'no_parent')
              element.categoryAbsolutePath = parentPath + '/' + categoryState.id;
            else
              element.categoryAbsolutePath = categoryState.businessId + '/' + categoryState.id;
            debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => NEW PATH: ${element.categoryAbsolutePath}');
            element.categoryImage = categoryState.categoryImage;
            element.categoryName = categoryState.name;
            element.tags = [categoryState.customTag];
          }
        });
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryUpdateServiceRead;
      int writes = statisticsState.categoryUpdateServiceWrite;
      int documents = statisticsState.categoryUpdateServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes; //TODO check writes
      ++documents;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryUpdateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryUpdateServiceRead = reads;
      statisticsState.categoryUpdateServiceWrite = writes;
      statisticsState.categoryUpdateServiceDocuments = documents;
    }).expand((element) => [
          ServiceListSnippetRequestResponse(store.state.serviceListSnippetState),
          UpdatedCategory(categoryState),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.categories),
        ]);
  }
}

///Epic che aggiorna un categoria figlia quando viene spostato il padre

class CategoryCreateService implements EpicClass<AppState> {
  CategoryState categoryState;
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateCategory>().asyncMap((event) async {
      categoryState = event.categoryState;
      DocumentReference docReference = FirebaseFirestore.instance

          /// 1 READ - 1 DOC
          .collection('business')
          .doc(store.state.business.id_firestore)
          .collection('category')
          .doc();

      store.state.category.id = docReference.id;
      if (categoryState.parent.id == 'no_parent') {
        // categoryState.categoryRootId = docReference.id;
        // categoryState.parent.parentRootId = docReference.id;
      } else {
        //  categoryState.categoryRootId = categoryState.parent.parentRootId;
      }
      //categoryState.categoryImage = store.state.category.categoryImage;
      categoryState.businessId = store.state.business.id_firestore;
      categoryState.id = docReference.id;

      if (event.categoryState.fileToUpload != null) {
        categoryState = await uploadFile(event.categoryState.fileToUpload, event.categoryState).catchError((error, stackTrace) {
          /// ? WRITE
          debugPrint("CATEGORY_SERVICE_EPIC - CategoryCreateService => Category_service_epic: uploadFiles failed: $error");
          return null;
        });
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryCreateService => category_service_epic: uploadFiles executed.");
        debugPrint('CATEGORY_SERVICE_EPIC - CategoryCreateService => category_service_epic: categoryImage in: ${categoryState.categoryImage}');
      }

      await docReference.set(categoryState.toJson()).then((value) async {
        /// 1 WRITE
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryCreateService => CategoryService has created new category " + docReference.id);
        store.state.serviceListSnippetState.businessSnippet.add(CategorySnippetState(
            categoryAbsolutePath: store.state.business.id_firestore + '/' + categoryState.id,
            categoryName: categoryState.name,
            categoryImage: categoryState.categoryImage,
            serviceNumberExternal: 0,
            serviceNumberInternal: 0,
            serviceList: [],
            tags: [categoryState.customTag]));
      }).catchError((error) {
        debugPrint('CATEGORY_SERVICE_EPIC - CategoryCreateService => ERROR: $error');
      }).then((value) {
        return null;
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryCreateServiceRead;
      int writes = statisticsState.categoryCreateServiceWrite;
      int documents = statisticsState.categoryCreateServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes; //TODO check writes
      ++documents;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryCreateServiceRead = reads;
      statisticsState.categoryCreateServiceWrite = writes;
      statisticsState.categoryCreateServiceDocuments = documents;
    }).expand((element) => [
          CreatedCategory(categoryState),
          UpdateStatistics(statisticsState),
          NavigatePushAction(AppRoutes.categories),
        ]);
  }
}

Future<CategoryState> uploadFile(OptimumFileToUpload fileToUpload, CategoryState categoryState) async {
  String fileUrl = await uploadToFirebaseStorage(fileToUpload);

  debugPrint('category_service_epic: fileUrl: $fileUrl');
  categoryState.categoryImage = fileUrl.toString();
  debugPrint('category_service_epic: categoryImage: ${categoryState.categoryImage}');
  return categoryState;
}

class CategoryDeleteService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategory>().asyncMap((event) async {
      String idCategoryToDelete = event.idCategory;
      await FirebaseFirestore.instance

          /// 1 DELETE
          .collection('business')
          .doc(store.state.business.id_firestore)
          .collection('category')
          .doc(idCategoryToDelete)
          .delete();

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryDeleteServiceRead;
      int writes = statisticsState.categoryDeleteServiceWrite;
      int documents = statisticsState.categoryDeleteServiceDocuments;
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      debugPrint('CATEGORY_SERVICE_EPIC - CategoryDeleteService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryDeleteServiceRead = reads;
      statisticsState.categoryDeleteServiceWrite = writes;
      statisticsState.categoryDeleteServiceDocuments = documents;
    }).expand((element) => [
          UpdateStatistics(statisticsState),
        ]);
  }
}

/*
class DefaultCategoryCreateService implements EpicClass<AppState> {
  CategoryState categoryState;
  StatisticsState statisticsState;
  var actionArray = [];

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateDefaultCategory>().asyncMap((event) async {
      actionArray.clear();
      categoryState = event.categoryState;
      DocumentReference docReference = FirebaseFirestore.instance.collection('business').doc(event.businessId).collection('category').doc();

      store.state.category.id = docReference.id;
      if (categoryState.parent.id == 'no_parent') {
        categoryState.categoryRootId = docReference.id;
        categoryState.parent.parentRootId = docReference.id;
      } else {
        ///Cerco nelle categorie zero già create il padre giusto
        await FirebaseFirestore.instance.collection("business").doc(event.businessId).collection('category').where("name", isEqualTo: categoryState.parent.name).get().then((querySnapshot) => {
              querySnapshot.docs.forEach((element) {
                CategoryState categoryFather = CategoryState.fromJson(element.data());
                categoryState.categoryRootId = categoryFather.id;
                categoryState.parent.id = categoryFather.id;
                categoryState.parent.parentRootId = categoryFather.id;
              }),
            });
      }
      categoryState.businessId = event.businessId;
      categoryState.id = docReference.id;

      await docReference.set(categoryState.toJson()).then((value) async {
        debugPrint("CATEGORY_SERVICE_EPIC - CategoryCreateService => CategoryService has created new category " + docReference.id);
        store.state.serviceListSnippetState.businessSnippet.add(CategorySnippetState(categoryAbsolutePath: store.state.business.id_firestore + '/' + categoryState.id, categoryName: categoryState.name, categoryImage: categoryState.categoryImage, serviceNumberExternal: 0, serviceNumberInternal: 0, serviceList: [], tags: [categoryState.customTag]));
        actionArray.add(CreatedCategory(categoryState));
        actionArray.add(AddDefaultCategoryTree(categoryState));
      }).catchError((error) {
        debugPrint('CATEGORY_SERVICE_EPIC - CategoryCreateService => ERROR: $error');
      }).then((value) {
        return null;
      });
    }).expand((element) {
      return actionArray;
    });

    /* .expand((element) => [
      CreatedCategory(categoryState),
      UpdateStatistics(statisticsState),
      AddCategoryTree(categoryState.parent)
    ]); */
  }
}
*/
