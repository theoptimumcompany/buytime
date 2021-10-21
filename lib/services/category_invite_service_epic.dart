import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';

class CategoryInviteRequestService implements EpicClass<AppState> {
  CategoryState categoryState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteRequest>().asyncMap((event) async {
      /*debugPrint("category_invite_service_epic => CategoryInviteRequestService => CATEGORY ID: ${event.id}");
      String categoryId = event.id;

      QuerySnapshot query = await FirebaseFirestore.instance /// 1 READ - ? DOC
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .where("id", isEqualTo: categoryId)
          .get();

      int queryDocs = query.docs.length;

      categoryState = new CategoryState();

      query.docs.forEach((snapshot) {
        categoryState = CategoryState.fromJson(snapshot.data());
      });

      debugPrint("category_invite_service_epic => CategoryInviteRequestService => CATEGORY NAME: ${categoryState.name}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteRequestServiceRead;
      int writes = statisticsState.categoryInviteRequestServiceWrite;
      int documents = statisticsState.categoryInviteRequestServiceDocuments;
      debugPrint('category_invite_service_epic => CategoryInviteRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + queryDocs;
      debugPrint('category_invite_service_epic => CategoryInviteRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteRequestServiceRead = reads;
      statisticsState.categoryInviteRequestServiceWrite = writes;
      statisticsState.categoryInviteRequestServiceDocuments = documents;*/

      ///Return
      //return new CategoryRequestResponse(categoryState);
    }).expand((element) => [
      //CategoryRequestResponse(categoryState)
      UpdateStatistics(statisticsState),
    ]);
  }
}


// class CategoryInviteUpdateService implements EpicClass<AppState> {
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     return actions.whereType<UpdateCategoryInvite>().asyncMap((event) {
//       debugPrint("CategoryService updating category: " + event.categoryState.name);
//       return FirebaseFirestore.instance
//           .collection("business")
//           .doc(event.categoryState.businessId)
//           .collection("category")
//           .doc(event.categoryState.id)
//           .update(event.categoryState.toJson())
//           .then((value) {
//         debugPrint("Category Service should be updated online ");
//         return new UpdatedCategory(null);
//       });
//     }).takeUntil(actions.whereType<UnlistenCategory>());
//   }
// }

class CategoryInviteCreateService implements EpicClass<AppState> {
  CategoryInviteState categoryInviteState;
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateCategoryInvite>().asyncMap((event) async{
      categoryInviteState = event.categoryInviteState;
      DocumentReference docReference = FirebaseFirestore.instance /// 1 READ - 1 DOC
          .collection('categoryInvitation')
          .doc();

      categoryInviteState.id = docReference.id;
      categoryInviteState.id_business = store.state.business.id_firestore;
      categoryInviteState.id_category = store.state.category.id;
      categoryInviteState.timestamp = DateTime.now();

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteCreateServiceRead;
      int writes = statisticsState.categoryInviteCreateServiceWrite;
      int documents = statisticsState.categoryInviteCreateServiceDocuments;
      debugPrint('category_invite_service_epic => CategoryInviteCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('category_invite_service_epic => CategoryInviteCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteCreateServiceRead = reads;
      statisticsState.categoryInviteCreateServiceWrite = writes;
      statisticsState.categoryInviteCreateServiceDocuments = documents;

      await docReference.set(categoryInviteState.toJson()).then((value) { /// 1 WRITE
        debugPrint("category_invite_service_epic => CategoryInviteCreateService => Has created new invite| DOCUMENT ID: ${docReference.id}");
        //return new CreatedCategoryInvite(categoryInviteState);
      }).catchError((error) {
        debugPrint('category_invite_service_epic => $error');
      }).then((value) {
        return null;
      });

    }).expand((element) => [
      CreatedCategoryInvite(categoryInviteState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class CategoryInviteDeleteService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  CategoryInviteState categoryInviteState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryInvite>().asyncMap((event) async {
      categoryInviteState = event.categoryInviteState;
      CollectionReference categoryInvitationRef = FirebaseFirestore.instance.collection("categoryInvitation"); /// 1 READ - ? DOC
      Query query = categoryInvitationRef.where("mail", isEqualTo: categoryInviteState.mail); /// 1 READ
      query = query.where("role", isEqualTo: categoryInviteState.role); /// 1 READ
      query = query.where("id_category", isEqualTo: categoryInviteState.id_category); /// 1 READ

      int docs = 0;
      await query.get().then((value){
        docs = docs + value.docs.length;
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("categoryInvitation").doc(element.id).delete().then((value){ /// ? DELETE
            debugPrint("category_invite_service_epic => CategoryInviteDeleteService => Has deleted invite| ELEMENT: ${element.id}");
          });
        });
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteDeleteServiceRead;
      int writes = statisticsState.categoryInviteDeleteServiceWrite;
      int documents = statisticsState.categoryInviteDeleteServiceDocuments;
      debugPrint('category_invite_service_epic => CategoryInviteDeleteService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + 4;
      documents = documents + docs;
      debugPrint('category_invite_service_epic => CategoryInviteDeleteService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteDeleteServiceRead = reads;
      statisticsState.categoryInviteDeleteServiceWrite = writes;
      statisticsState.categoryInviteDeleteServiceDocuments = documents;

    }).expand((element) => [
      UpdateStatistics(statisticsState),
    ]);
  }
}
