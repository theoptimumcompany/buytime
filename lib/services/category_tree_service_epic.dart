import 'dart:convert';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CategoryTreeCreateIfNotExistsService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryTreeCreateIfNotExists>().asyncMap((event) {
      print("CategoryNodeCreateIfNotExistsService CategoryNode exists?");
      CollectionReference collectionReference = FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree");
      collectionReference.get().then((value) {
        if (value.docs.length == 0) {
          print("CategoryNodeCreateIfNotExistsService CategoryNode not exists!");
          CategoryTree newCategoryNode = CategoryTree().toEmpty();
          DocumentReference doc = FirebaseFirestore.instance.collection('business').doc(event.idFirestore).collection('category_tree').doc();
          newCategoryNode = CategoryTree(nodeName: "root", nodeId: doc.id, nodeLevel: 0, numberOfCategories: 0, categoryNodeList: null);
          doc.set(newCategoryNode.toJson());
        }
        else{
          print("CategoryNodeCreateIfNotExistsService CategoryNode exists!");
        }
      });
    }).expand((element) => [CategoryTreeRequest()]);
  }
}

class CategoryTreeRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    CategoryTree categoryNode = CategoryTree();

    return actions.whereType<CategoryTreeRequest>().asyncMap((event) async {
      print("CategoryTree Epic : business name : " + store.state.business.name);
      var query = await FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree").get();
      if(query.docs.length != 0){
        query.docs.forEach((snapshot) {
          categoryNode = CategoryTree.fromJson(snapshot.data());
        });
      }
      else{
        categoryNode  = CategoryTree().toEmpty();
      }



      print("CategoryTree Epic : category tree Number of Categories : " + categoryNode.numberOfCategories.toString());

    }).expand((element) => [CategoryTreeRequestResponse(categoryNode)]);
  }
}

class CategoryTreeAddService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;

  addTree(List<dynamic> list, String id, EpicStore<AppState> store) {
    if (id == "no_parent") {
      print("Dentro No Parent");
      List<dynamic> newNode = [];
      Map<dynamic, dynamic> newNodeMap = {
        "nodeName": store.state.category.name,
        "nodeId": store.state.category.id,
        "level": 0,
        "nodeCategory": null,
        "categoryRootId": store.state.category.parent.parentRootId,
      };
      updateNumberOfCategories = updateNumberOfCategories + 1;

      if (list == null) {
        newNode.add(newNodeMap);
        print("New Node no_parent");
        print(newNode);
        list = [];
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
              "categoryRootId": store.state.category.parent.parentRootId,
            };
            updateLevel = updateLevel < store.state.category.level ? store.state.category.level : updateLevel;
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
              List<dynamic> attach = addTree(list[i]['nodeCategory'], id, store);
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
    return actions.whereType<AddCategoryTree>().asyncMap((event) async {
      if (store.state.categoryTree.categoryNodeList != null && store.state.categoryTree.categoryNodeList.isNotEmpty) {
        updateLevel = store.state.categoryTree.nodeLevel;
        updateNumberOfCategories = store.state.categoryTree.numberOfCategories;
      } else {
        updateLevel = 0;
        updateNumberOfCategories = 0;
      }

      print("CategorySnippetService adding category tree");
      print(event.selectedParent);
      Parent selected = event.selectedParent;
      List<dynamic> listNode = store.state.categoryTree.categoryNodeList;
      CategoryTree categoryTree = store.state.categoryTree;
      print("Lista Iniziale " + listNode.toString());
      print("Parent : " + selected.name + " " + selected.id + " " + selected.level.toString());
      List<dynamic> newlistNode = addTree(listNode, selected.id, store);
      print("*******");
      print(newlistNode);
      print("*******");
      CategoryTree newCategoryNode = CategoryTree(nodeName: "root", nodeId: "root", nodeLevel: updateLevel, numberOfCategories: updateNumberOfCategories, categoryNodeList: newlistNode);
      print("dopo creazione category node");
      print(store.state.business.id_firestore);

      var query = await FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree").get();

      query.docs.forEach((document) {
        document.reference.update(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be updated online ");
          return new UpdatedCategoryTree(null);
        });
        ;
      });
    }).takeUntil(actions.whereType<UnlistenCategoryTree>());
  }
}

class CategoryTreeDeleteService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;

  updateCategoryTreeLevel(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      updateLevel = updateLevel < list[i]['level'] ? list[i]['level'] : updateLevel;

      if (list[i]['nodeCategory'] != null) {
        updateCategoryTreeLevel(list[i]['nodeCategory']);
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

  deleteTree(List<dynamic> categoryNodeList, String selectedNodeId, EpicStore<AppState> store) {
    print("Actual Number of Categories : " + updateNumberOfCategories.toString());
    if (categoryNodeList != null) {
      for (int i = 0; i < categoryNodeList.length; i++) {
        if (categoryNodeList[i]['nodeId'] == selectedNodeId) {
          print("Trovato ID Nodo da eliminare");
          print(categoryNodeList[i]['nodeId'] + " " + categoryNodeList[i]['nodeName']);

          //Parte commentata si fa quando si gestisce la eliminazione annidata
          /*  if (categoryNodeList[i]['nodeCategory'] != null) {
            deleteBranch(categoryNodeList[i]['nodeCategory'], store);
          }*/

          updateNumberOfCategories = updateNumberOfCategories - 1;
          categoryNodeList.removeAt(i);
        } else {
          if (categoryNodeList[i]['nodeCategory'] != null) {
            List<dynamic> attach = deleteTree(categoryNodeList[i]['nodeCategory'], selectedNodeId, store);
            categoryNodeList[i]['nodeCategory'] = attach;
          }
        }
      }
    }

    return categoryNodeList;
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteCategoryTree>().asyncMap((event) async {
      updateLevel = store.state.categoryTree.nodeLevel;
      updateNumberOfCategories = store.state.categoryTree.numberOfCategories;

      print("CategorySnippetService updating delete node");
      print("Nodo da cancellare " + event.selectedNodeId);
      List<dynamic> listNode = store.state.categoryTree.categoryNodeList;
      List<dynamic> newlistNode = deleteTree(listNode, event.selectedNodeId, store);
      updateLevel = 0;
      updateCategoryTreeLevel(newlistNode);
      CategoryTree newCategoryNode = CategoryTree(nodeName: "root", nodeId: "root", nodeLevel: updateLevel, numberOfCategories: updateNumberOfCategories, categoryNodeList: newlistNode);
      var query = await FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree").get();
      query.docs.forEach((document) {
        document.reference.update(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be delete online ");
          return new DeletedCategoryTree(null);
        });
      });
    }).takeUntil(actions.whereType<UnlistenCategoryTree>());
  }
}

class CategoryTreeUpdateService implements EpicClass<AppState> {
  List<dynamic> nodeToSave = [];

  int updateLevel;
  int updateNumberOfCategories;
  int localLevel;

  updateCategoryTreeLevel(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      updateLevel = updateLevel < list[i]['level'] ? list[i]['level'] : updateLevel;

      if (list[i]['nodeCategory'] != null) {
        updateCategoryTreeLevel(list[i]['nodeCategory']);
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
              List<dynamic> attach = addNodeToTree(list[i]['nodeCategory'], id, store);
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

  updateTree(List<dynamic> list, String selectedNewParentId, EpicStore<AppState> store, String currentParentId) {
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i]['nodeId'] == store.state.category.id) {
          print("Trovato ID");
          print(list[i]['nodeId'] + " " + list[i]['nodeName']);
          if (currentParentId == selectedNewParentId) {
            print("Vecchio parent come nuovo");
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
            list[i]['categoryRootId'] = store.state.category.parent.parentRootId;
          } else {
            print("Vecchio parent diverso dal  nuovo");
            print("-----");
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
            list[i]['categoryRootId'] = store.state.category.parent.parentRootId;
            nodeToSave.add(list[i]);
            print(nodeToSave);
            print("-----");
            list.removeAt(i);
          }
        } else {
          if (list[i]['nodeCategory'] != null) {
            List<dynamic> attach = updateTree(list[i]['nodeCategory'], selectedNewParentId, store, list[i]['nodeId']);
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
    return actions.whereType<UpdateCategoryTree>().asyncMap((event) async {
      updateLevel = store.state.categoryTree.nodeLevel;
      updateNumberOfCategories = store.state.categoryTree.numberOfCategories;

      print("CategoryNodeService updating category tree");
      print(event.selectedParent);
      Parent selectedParent = event.selectedParent;
      print("Selected New Parent ID: " + selectedParent.id);
      List<dynamic> listNode = store.state.categoryTree.categoryNodeList;
      CategoryState category = store.state.category;

      List<dynamic> newlistNode = updateTree(listNode, selectedParent.id, store, "no_parent");
      if (nodeToSave.length > 0) {
        newlistNode = addNodeToTree(newlistNode, selectedParent.id, store);
      }
      updateLevel = 0;
      updateCategoryTreeLevel(newlistNode);
      nodeToSave = [];
      CategoryTree newCategoryNode = CategoryTree(nodeName: "root", nodeId: "root", nodeLevel: updateLevel, numberOfCategories: updateNumberOfCategories, categoryNodeList: newlistNode);
      print("dopo creazione category node");
      print(store.state.business.id_firestore);

      var query = await FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree").get();

      query.docs.forEach((document) {
        document.reference.update(newCategoryNode.toJson()).then((value) {
          print("Category Node Service should be updated online ");
          return new UpdatedCategoryTree(null);
        });
      });
    }).takeUntil(actions.whereType<UnlistenCategoryTree>());
  }
}