import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:BuyTime/reblox/reducer/category_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("CategoryListService catched action");
    return actions.whereType<RequestListCategory>().asyncMap((event) {
      return Firestore.instance
          .collection("business")
          .document(event.businessId)
          .collection("category")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        print("CategoryListService firestore request");
        List<CategoryState> categoryStateList = List<CategoryState>();
        snapshot.documents.forEach((element) {
          CategoryState categoryState = CategoryState.fromJson(element.data());
          categoryState.businessId = event.businessId;
          categoryState.id = element.documentID;
          categoryStateList.add(categoryState);
        });
        print(categoryStateList.length);
        print("CategoryListService return list with " + categoryStateList.length.toString());
        return new CategoryListReturned(categoryStateList);
      });
    }).takeUntil(actions.whereType<UnlistenCategory>());
  }
}

class CategoryRootListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("CategoryRootListService catched action");
    return actions.whereType<RequestRootListCategory>().asyncMap((event) {
      return FirebaseFirestore.instance
          .collection("business")
          .doc(event.businessId)
          .collection("category")
          .where("level", isEqualTo: 0)
          .get()
          .then((QuerySnapshot snapshot) {
        print("CategoryRootListService firestore request");
        List<CategoryState> categoryStateList = List<CategoryState>();
        snapshot.docs.forEach((element) {
          CategoryState categoryState = CategoryState.fromJson(element.data());
          categoryState.businessId = event.businessId;
          categoryState.id = element.id;
          categoryStateList.add(categoryState);
        });
        print(categoryStateList.length);
        print("CategoryRootListService return list with " + categoryStateList.length.toString());
        return new CategoryListReturned(categoryStateList);
      });
    }).takeUntil(actions.whereType<UnlistenCategory>());
  }
}

class CategoryRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryRequest>().asyncMap((event) async {
      String categoryId = event.id;

      var query = await FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .where("id", isEqualTo: categoryId)
          .get();

      CategoryState categoryState = new CategoryState();

      query.docs.forEach((snapshot) {
        categoryState = CategoryState.fromJson(snapshot.data());
      });
      print("CategoryState return " + categoryState.name);
      return new CategoryRequestResponse(categoryState);
    }).takeUntil(actions.whereType<UnlistenCategory>());
  }
}

class CategoryInviteManagerService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteManager>().asyncMap((event) async {
      ///In questa epic devo gestire invito del manager
      ///Inserisco nella categoria il manager alla lista dei manager
      ///In seguito partirà una cloud function che fa gli opportuni controlli sui permessi dell'utente che aggiunge la nuova mail, e scrive i permessi della mail aggiunta per quella categoria

      ObjectState manager = event.manager;
      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "manager": FieldValue.arrayUnion([manager])
      }).then((value) {
        print("Category Service updated Manager List with new manager");
        return new UpdatedCategory(null);
      });
    });
  }
}

class CategoryInviteWorkerService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteWorker>().asyncMap((event) async {
      // ObjectState worker = event.worker;
      // FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category").doc(store.state.category.id).update({
      //   "worker": FieldValue.arrayUnion([worker])
      // }).then((value) {
      //   print("Category Service should be updated online ");
      //   return new UpdatedCategory(null);
      // });
    }).takeUntil(actions.whereType<UnlistenCategory>());
  }
}

class CategoryUpdateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateCategory>().asyncMap((event) {
      print("CategoryService updating category: " + event.categoryState.name);
      return FirebaseFirestore.instance
          .collection("business")
          .doc(event.categoryState.businessId)
          .collection("category")
          .doc(event.categoryState.id)
          .update(event.categoryState.toJson())
          .then((value) {
        print("Category Service should be updated online ");
        return new UpdatedCategory(null);
      });
    }).takeUntil(actions.whereType<UnlistenCategory>());
  }
}

class CategoryCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateCategory>().asyncMap((event) {
      CategoryState categoryState = event.categoryState;
      DocumentReference docReference = Firestore.instance
          .collection('business')
          .doc(store.state.business.id_firestore)
          .collection('category')
          .doc();
      categoryState.id = docReference.id;
      store.state.category.id = docReference.id;
      categoryState.businessId = store.state.business.id_firestore;
      ServiceSnippet serviceState = ServiceSnippet().toEmpty();
      categoryState.categorySnippet.mostSoldService = serviceState;
      return docReference.set(categoryState.toJson()).then((value) {
        print("CategoryService has created new category " + docReference.documentID);

        return new CreatedCategory(categoryState);
      }).catchError((error) {
        print(error);
      }).then((value) {
        return null;
      });
    });
  }
}

class CategoryDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategory>().asyncMap((event) {
      String idCategoryToDelete = event.idCategory;
      return FirebaseFirestore.instance
          .collection('business')
          .doc(store.state.business.id_firestore)
          .collection('category')
          .doc(idCategoryToDelete)
          .delete();
    });
  }
}
