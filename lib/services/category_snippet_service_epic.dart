import 'dart:convert';

import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CategorySnippetCreateIfNotExistsService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .whereType<CategorySnippetCreateIfNotExists>()
        .asyncMap((event) {
      print("CategoryNodeCreateIfNotExistsService CategoryNode exists?");
      CollectionReference collectionReference = Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree");
      collectionReference.getDocuments().then((value) {
        print(
            "CategoryNodeCreateIfNotExistsService CategoryNode DOES NOT exists!");
        if (value.docs.length == 0) {
          DocumentReference doc = Firestore.instance
              .collection('business')
              .document(event.idFirestore)
              .collection('category_tree')
              .document();
          CategorySnippet newCategoryNode = CategorySnippet(
              nodeName: "root",
              nodeId: doc.documentID,
              nodeLevel: 0,
              numberOfCategories: 0,
              categoryNodeList: null);
          doc.setData(newCategoryNode.toJson());
          return;
        } else {
          return;
        }
      });
    });
  }
}

class CategorySnippetCreateService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateCategorySnippet>().asyncMap((event) {
      String idBusiness = event.idBusiness;
    });
  }
}

class CategorySnippetListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .whereType<RequestListCategorySnippet>()
        .asyncMap((event) async {
      /*  var query = await Firestore.instance.collection("business").getDocuments();
      print("categorySnippetListState firestore request");
      List<CategorySnippet> categorySnippetListState = List<CategorySnippet>();
      query.documents.forEach((element) {
        CategorySnippet categorySnippet = CategorySnippet.fromJson(element.data);
        categorySnippetListState.add(categorySnippet);
      });

      return new CategorySnippetListReturned(categorySnippetListState);*/
    });
  }
}

class CategorySnippetRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategorySnippetRequest>().asyncMap((event) async {
      if (store.state.business.id_firestore != null ||
          store.state.business.id_firestore != '') {
        var query = await FirebaseFirestore.instance
            .collection("business")
            .doc(store.state.business.id_firestore)
            .collection("category_tree")
            .get();
        CategorySnippet categoryNode = new CategorySnippet();

        query.docs.forEach((snapshot) {
          categoryNode = CategorySnippet.fromJson(snapshot.data());
        });
        if (categoryNode != null) {
          return new CategorySnippetRequestResponse(categoryNode);
        }
      }
    }).takeUntil(actions.whereType<UnlistenCategorySnippet>());
  }
}

class CategorySnippetAddService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;

  addTree(List<dynamic> list, String id, EpicStore<AppState> store) {
    if (id == "no_parent") {
      print("Dentro No Parent");
      List<dynamic> newNode = new List<dynamic>();
      Map<dynamic, dynamic> newNodeMap = {
        "nodeName": store.state.category.name,
        "nodeId": store.state.category.id,
        "level": 0,
        "nodeCategory": null,
      };
      updateNumberOfCategories = updateNumberOfCategories + 1;

      if (list == null) {
        newNode.add(newNodeMap);
        print("New Node no_parent");
        print(newNode);
        list = new List<dynamic>();
        list = newNode;
        return list;
      } else {
        list.add(newNodeMap);
        return list;
      }
    } else {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i]['nodeId'] == id) {
            List<dynamic> newNode = new List<dynamic>();
            Map<dynamic, dynamic> newNodeMap = {
              "nodeName": store.state.category.name,
              "nodeId": store.state.category.id,
              "level": store.state.category.level,
              "nodeCategory": null,
            };
            updateLevel = updateLevel < store.state.category.level
                ? store.state.category.level
                : updateLevel;
            updateNumberOfCategories = updateNumberOfCategories + 1;
            newNode.add(newNodeMap);

            if (list[i]['nodeCategory'] == null) {
              list[i]['nodeCategory'] = newNode;
              print("aggiungi nuova list a catena");
              print(list);
              return list;
            } else {
              list[i]['nodeCategory'].add(newNodeMap);
              print("aggiungi nuova list");
              print(list);
              return list;
            }
          } else {
            if (list[i]['nodeCategory'] != null) {
              List<dynamic> attach =
                  addTree(list[i]['nodeCategory'], id, store);
              print("attach");
              print(attach);
              list[i]['nodeCategory'] = attach;
              print("attached on " + list[i]['nodeName']);
              print(list);
            }
          }
        }
      }

      print(list);
      return list;
    }
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddCategorySnippet>().asyncMap((event) async {
      updateLevel = store.state.categorySnippet.nodeLevel;
      updateNumberOfCategories = store.state.categorySnippet.numberOfCategories;

      print("CategorySnippetService adding category snippet");
      print(event.selectedParent);
      ObjectState selected = event.selectedParent;
      List<dynamic> listNode = store.state.categorySnippet.categoryNodeList;
      CategoryState category = store.state.category;
      print("Lista Iniziale " + listNode.toString());
      print("Parent : " +
          selected.name +
          " " +
          selected.id +
          " " +
          selected.level.toString());
      List<dynamic> newlistNode = addTree(listNode, selected.id, store);
      print("*******");
      print(newlistNode);
      print("*******");
      CategorySnippet newCategoryNode = CategorySnippet(
          nodeName: "root",
          nodeId: "root",
          nodeLevel: updateLevel,
          numberOfCategories: updateNumberOfCategories,
          categoryNodeList: newlistNode);
      print("dopo creazione category node");
      print(store.state.business.id_firestore);

      var query = await Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree")
          .getDocuments();

      query.documents.forEach((document) {
        document.reference.updateData(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be updated online ");
          return new UpdatedCategorySnippet(null);
        });
        ;
      });
    }).takeUntil(actions.whereType<UnlistenCategorySnippet>());
  }
}

class CategorySnippetDeleteService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;

  updateCategorySnippetLevel(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      updateLevel =
          updateLevel < list[i]['level'] ? list[i]['level'] : updateLevel;

      if (list[i]['nodeCategory'] != null) {
        updateCategorySnippetLevel(list[i]['nodeCategory']);
      }
    }
  }

  /* deleteBranch(List<dynamic> categoryNodeList, EpicStore<AppState> store) {
    if (categoryNodeList != null) {
      for (int i = 0; i < categoryNodeList.length; i++) {
        updateNumberOfCategories = updateNumberOfCategories - 1;
        print("Actual Number of Categories : " + updateNumberOfCategories.toString());

        if (categoryNodeList[i]['nodeCategory'] != null) {
          print("Trovato ID Nodo da eliminare");
          print(categoryNodeList[i]['nodeId'] + " " + categoryNodeList[i]['nodeName']);
          deleteBranch(categoryNodeList[i]['nodeCategory'], store);
        }
        categoryNodeList.removeAt(i);
      }
    }
  }*/

  deleteTree(List<dynamic> categoryNodeList, String selectedNodeId,
      EpicStore<AppState> store) {
    print(
        "Actual Number of Categories : " + updateNumberOfCategories.toString());
    if (categoryNodeList != null) {
      for (int i = 0; i < categoryNodeList.length; i++) {
        if (categoryNodeList[i]['nodeId'] == selectedNodeId) {
          print("Trovato ID Nodo da eliminare");
          print(categoryNodeList[i]['nodeId'] +
              " " +
              categoryNodeList[i]['nodeName']);

          //Parte commentata si fa quando si gestisce la eliminazione annidata
          /*  if (categoryNodeList[i]['nodeCategory'] != null) {
            deleteBranch(categoryNodeList[i]['nodeCategory'], store);
          }*/

          updateNumberOfCategories = updateNumberOfCategories - 1;
          categoryNodeList.removeAt(i);
        } else {
          if (categoryNodeList[i]['nodeCategory'] != null) {
            List<dynamic> attach = deleteTree(
                categoryNodeList[i]['nodeCategory'], selectedNodeId, store);
            categoryNodeList[i]['nodeCategory'] = attach;
          }
        }
      }
    }

    return categoryNodeList;
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategorySnippet>().asyncMap((event) async {
      updateLevel = store.state.categorySnippet.nodeLevel;
      updateNumberOfCategories = store.state.categorySnippet.numberOfCategories;

      print("CategorySnippetService updating delete node");
      print("Nodo da cancellare " + event.selectedNodeId);
      List<dynamic> listNode = store.state.categorySnippet.categoryNodeList;
      List<dynamic> newlistNode =
          deleteTree(listNode, event.selectedNodeId, store);
      updateLevel = 0;
      updateCategorySnippetLevel(newlistNode);
      CategorySnippet newCategoryNode = CategorySnippet(
          nodeName: "root",
          nodeId: "root",
          nodeLevel: updateLevel,
          numberOfCategories: updateNumberOfCategories,
          categoryNodeList: newlistNode);
      var query = await Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree")
          .getDocuments();
      query.documents.forEach((document) {
        document.reference.updateData(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be delete online ");
          return new DeletedCategorySnippet(null);
        });
      });
    }).takeUntil(actions.whereType<UnlistenCategorySnippet>());
  }
}

class CategorySnippetUpdateService implements EpicClass<AppState> {
  List<dynamic> nodeToSave = [];

  int updateLevel;
  int updateNumberOfCategories;
  int localLevel;

  updateCategorySnippetLevel(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      updateLevel =
          updateLevel < list[i]['level'] ? list[i]['level'] : updateLevel;

      if (list[i]['nodeCategory'] != null) {
        updateCategorySnippetLevel(list[i]['nodeCategory']);
      }
    }
  }

  addNodeToTree(List<dynamic> list, String id, EpicStore<AppState> store) {
    if (id == "no_parent") {
      print("Dentro No Parent");

      if (list == null) {
        list.add(nodeToSave[0]);
        print("Ecco la lista se null " + list.toString());
        return list;
      } else {
        list.add(nodeToSave[0]);
        print("Ecco la lista se NON null " + list.toString());
        return list;
      }
    } else {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i]['nodeId'] == id) {
            print("Trovato ID");
            print(list[i]['nodeId'] + " " + list[i]['nodeName']);

            if (list[i]['nodeCategory'] == null) {
              list[i]['nodeCategory'] = nodeToSave;
              print("aggiungi nuova list a catena");
              print(list);
              return list;
            } else {
              list[i]['nodeCategory'].add(nodeToSave[0]);
              print("aggiungi nuova list");
              print(list);
              return list;
            }
          } else {
            if (list[i]['nodeCategory'] != null) {
              List<dynamic> attach =
                  addNodeToTree(list[i]['nodeCategory'], id, store);
              list[i]['nodeCategory'] = attach;
              print(list);
            }
          }
        }
      }
    }
    print(list);
    return list;
  }

  updateTree(List<dynamic> list, String selectedNewParentId,
      EpicStore<AppState> store, String currentParentId) {
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i]['nodeId'] == store.state.category.id) {
          print("Trovato ID");
          print(list[i]['nodeId'] + " " + list[i]['nodeName']);
          if (currentParentId == selectedNewParentId) {
            print("Vecchio parent come nuovo");
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
          } else {
            print("Vecchio parent diverso dal  nuovo");
            print("-----");
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
            nodeToSave.add(list[i]);
            print(nodeToSave);
            print("-----");
            list.removeAt(i);
          }
        } else {
          if (list[i]['nodeCategory'] != null) {
            List<dynamic> attach = updateTree(list[i]['nodeCategory'],
                selectedNewParentId, store, list[i]['nodeId']);
            list[i]['nodeCategory'] = attach;
            print(list);
          }
        }
      }
    }

    return list;
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateCategorySnippet>().asyncMap((event) async {
      updateLevel = store.state.categorySnippet.nodeLevel;
      updateNumberOfCategories = store.state.categorySnippet.numberOfCategories;

      print("CategoryNodeService updating category tree");
      print(event.selectedParent);
      ObjectState selectedParent = event.selectedParent;
      print("Selected New Parent ID: " + selectedParent.id);
      List<dynamic> listNode = store.state.categorySnippet.categoryNodeList;
      CategoryState category = store.state.category;

      List<dynamic> newlistNode =
          updateTree(listNode, selectedParent.id, store, "no_parent");
      if (nodeToSave.length > 0) {
        newlistNode = addNodeToTree(newlistNode, selectedParent.id, store);
      }
      updateLevel = 0;
      updateCategorySnippetLevel(newlistNode);
      nodeToSave = [];
      CategorySnippet newCategoryNode = CategorySnippet(
          nodeName: "root",
          nodeId: "root",
          nodeLevel: updateLevel,
          numberOfCategories: updateNumberOfCategories,
          categoryNodeList: newlistNode);
      print("dopo creazione category node");
      print(store.state.business.id_firestore);

      var query = await Firestore.instance
          .collection("business")
          .document(store.state.business.id_firestore)
          .collection("category_tree")
          .getDocuments();

      query.documents.forEach((document) {
        document.reference.updateData(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be updated online ");
          return new UpdatedCategorySnippet(null);
        });
      });
    }).takeUntil(actions.whereType<UnlistenCategorySnippet>());
  }
}
