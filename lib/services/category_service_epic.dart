import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
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

class CategoryListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    print("CategoryListService catched action");
    return actions.whereType<RequestListCategory>().asyncMap((event) {
      return FirebaseFirestore.instance
          .collection("business")
          .doc(event.businessId)
          .collection("category")
          .get()
          .then((QuerySnapshot snapshot) {
        print("CategoryListService firestore request");
        List<CategoryState> categoryStateList = List<CategoryState>();
        snapshot.docs.forEach((element) {
          CategoryState categoryState = CategoryState.fromJson(element.data());
          categoryState.businessId = event.businessId;
          categoryState.id = element.id;
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
      ///Inserisco nella categoria il manager alla lista dei manager e nella lista mailManager
      ///In seguito partirà una cloud function che fa gli opportuni controlli sui permessi dell'utente che aggiunge la nuova mail, e scrive i permessi della mail aggiunta per quella categoria

      print("Inizia elaborazione per inserire Oggetto Manager nel Database");
      Manager manager = event.manager;
      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "manager": FieldValue.arrayUnion([manager.toJson()])
      }).then((value) {
        print("Category Service added Manager to field manager");
      });


      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "managerMailList": FieldValue.arrayUnion([manager.mail])
      }).then((value) {
        print("Category Service added manager's mail to field managerMailList");
      });

      return;
    });
  }
}

class CategoryInviteWorkerService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryInviteWorker>().asyncMap((event) async {
      ///In questa epic devo gestire invito del manager
      ///Inserisco nella categoria il manager alla lista dei manager e nella lista mailManager
      ///In seguito partirà una cloud function che fa gli opportuni controlli sui permessi dell'utente che aggiunge la nuova mail, e scrive i permessi della mail aggiunta per quella categoria

      Worker worker = event.worker;
      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "worker": FieldValue.arrayUnion([worker.toJson()])
      }).then((value) {
        print("Category Service added Worker to field worker");
      });

      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "workerMailList": FieldValue.arrayUnion([worker.mail])
      }).then((value) {
        print("Category Service added worker's mail to field workerMailList");
      });

      return;
    });
  }
}

class CategoryDeleteManagerService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryManager>().asyncMap((event) async {

      Manager manager = event.manager;
      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "manager": FieldValue.arrayRemove([manager.toJson()])
      }).then((value) {
        print("Category Service deleted Manager to field manager");
      });

      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "managerMailList": FieldValue.arrayRemove([manager.mail])
      }).then((value) {
        print("Category Service deleted manager's mail to field managerMailList");
      });

      return;
    });
  }
}

class CategoryDeleteWorkerService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryWorker>().asyncMap((event) async {

      Worker worker = event.worker;
      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "worker": FieldValue.arrayRemove([worker.toJson()])
      }).then((value) {
        print("Category Service deleted Worker to field worker");
      });

      FirebaseFirestore.instance
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category")
          .doc(store.state.category.id)
          .update({
        "workerMailList": FieldValue.arrayRemove([worker.mail])
      }).then((value) {
        print("Category Service deleted worker's mail to field workerMailList");
      });

      return;
    });
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
      DocumentReference docReference = FirebaseFirestore.instance
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
        print("CategoryService has created new category " + docReference.id);

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
