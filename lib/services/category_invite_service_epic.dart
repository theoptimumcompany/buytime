/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
      /*debugPrint("CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteRequestService => CATEGORY ID: ${event.id}");
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

      debugPrint("CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteRequestService => CATEGORY NAME: ${categoryState.name}");

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteRequestServiceRead;
      int writes = statisticsState.categoryInviteRequestServiceWrite;
      int documents = statisticsState.categoryInviteRequestServiceDocuments;
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + queryDocs;
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
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
//       print("CategoryService updating category: " + event.categoryState.name);
//       return FirebaseFirestore.instance
//           .collection("business")
//           .doc(event.categoryState.businessId)
//           .collection("category")
//           .doc(event.categoryState.id)
//           .update(event.categoryState.toJson())
//           .then((value) {
//         print("Category Service should be updated online ");
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
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      ++writes;
      ++documents;
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteCreateServiceRead = reads;
      statisticsState.categoryInviteCreateServiceWrite = writes;
      statisticsState.categoryInviteCreateServiceDocuments = documents;

      await docReference.set(categoryInviteState.toJson()).then((value) { /// 1 WRITE
        debugPrint("CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteCreateService => Has created new invite| DOCUMENT ID: ${docReference.id}");
        //return new CreatedCategoryInvite(categoryInviteState);
      }).catchError((error) {
        print(error);
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
            debugPrint("CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteDeleteService => Has deleted invite| ELEMENT: ${element.id}");
          });
        });
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryInviteDeleteServiceRead;
      int writes = statisticsState.categoryInviteDeleteServiceWrite;
      int documents = statisticsState.categoryInviteDeleteServiceDocuments;
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteDeleteService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + 4;
      documents = documents + docs;
      debugPrint('CATEGORY_INVITE_SERVICE_EPIC - CategoryInviteDeleteService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryInviteDeleteServiceRead = reads;
      statisticsState.categoryInviteDeleteServiceWrite = writes;
      statisticsState.categoryInviteDeleteServiceDocuments = documents;

    }).expand((element) => [
      UpdateStatistics(statisticsState),
    ]);
  }
}
