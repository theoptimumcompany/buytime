


import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:redux_epics/redux_epics.dart';

class CategoryInviteRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteRequest>().asyncMap((event) async {
      // String categoryId = event.id;
      //
      // var query = await FirebaseFirestore.instance
      //     .collection("business")
      //     .doc(store.state.business.id_firestore)
      //     .collection("category")
      //     .where("id", isEqualTo: categoryId)
      //     .get();
      //
      // CategoryState categoryState = new CategoryState();
      //
      // query.docs.forEach((snapshot) {
      //   categoryState = CategoryState.fromJson(snapshot.data());
      // });
      // print("CategoryState return " + categoryState.name);
      // return new CategoryRequestResponse(categoryState);
    }).takeUntil(actions.whereType<UnlistenCategoryInvite>());
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
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateCategoryInvite>().asyncMap((event) {
      CategoryInviteState categoryInviteState = event.categoryInviteState;
      DocumentReference docReference = FirebaseFirestore.instance
          .collection('categoryInvitation')
          .doc();
      categoryInviteState.id = docReference.id;
      categoryInviteState.id_business = store.state.business.id_firestore;
      categoryInviteState.id_category = store.state.category.id;
      categoryInviteState.timestamp = DateTime.now();
      return docReference.set(categoryInviteState.toJson()).then((value) {
        print("CategoryInviteService has created new invite " + docReference.id);

        return new CreatedCategoryInvite(categoryInviteState);
      }).catchError((error) {
        print(error);
      }).then((value) {
        return null;
      });
    });
  }
}

class CategoryInviteDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryInvite>().asyncMap((event) {
      // String idCategoryToDelete = event.idCategory;
      // return FirebaseFirestore.instance
      //     .collection('business')
      //     .doc(store.state.business.id_firestore)
      //     .collection('category')
      //     .doc(idCategoryToDelete)
      //     .delete();
    });
  }
}
