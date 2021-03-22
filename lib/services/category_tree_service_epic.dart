import 'dart:convert';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CategoryTreeCreateIfNotExistsService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CategoryTreeCreateIfNotExists>().asyncMap((event) {
      debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeCreateIfNotExistsService => CategoryNode exists?");
      CollectionReference collectionReference = FirebaseFirestore.instance.collection("business").doc(store.state.business.id_firestore).collection("category_tree");

      /// 1 READ - ? DOC
      int docs = 0;
      int write = 0;
      int read = 1;
      collectionReference.get().then((value) {
        docs = value.docs.length;
        if (value.docs.length == 0) {
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeCreateIfNotExistsService => CategoryNode not exists!");
          CategoryTree newCategoryNode = CategoryTree().toEmpty();
          DocumentReference doc = FirebaseFirestore.instance

              /// 1 READ - 1 DOC
              .collection('business')
              .doc(event.idFirestore)
              .collection('category_tree')
              .doc();
          newCategoryNode = CategoryTree(nodeName: "root", nodeId: doc.id, nodeLevel: 0, numberOfCategories: 0, categoryNodeList: null);
          doc.set(newCategoryNode.toJson());

          /// 1 WRITE
          ++read;
          ++write;
          ++docs;
        } else {
          print("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeCreateIfNotExistsService => CategoryNodeCreateIfNotExistsService CategoryNode exists!");
        }
      });

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryTreeCreateIfNotExistsServiceRead;
      int writes = statisticsState.categoryTreeCreateIfNotExistsServiceWrite;
      int documents = statisticsState.categoryTreeCreateIfNotExistsServiceDocuments;
      debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeCreateIfNotExistsService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      writes = writes + write;
      documents = documents + docs;
      debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeCreateIfNotExistsService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryTreeCreateIfNotExistsServiceRead = reads;
      statisticsState.categoryTreeCreateIfNotExistsServiceWrite = writes;
      statisticsState.categoryTreeCreateIfNotExistsServiceDocuments = documents;
    }).expand((element) => [
          CategoryTreeRequest(),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryTreeRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    CategoryTree categoryNode = CategoryTree();
    return actions.whereType<CategoryTreeRequest>().asyncMap((event) async {
      debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeRequestService => BUSINESS NAME: ${store.state.business.name}");
      QuerySnapshot query = await FirebaseFirestore.instance

          /// 1 READ - ? DOC
          .collection("business")
          .doc(store.state.business.id_firestore)
          .collection("category_tree")
          .get();

      int queryDocs = query.docs.length;

      if (query.docs.length != 0) {
        query.docs.forEach((snapshot) {
          categoryNode = CategoryTree.fromJson(snapshot.data());
        });
      } else {
        categoryNode = CategoryTree().toEmpty();
      }
      debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeRequestService => Category tree Number of Categories: " + categoryNode.numberOfCategories.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.categoryTreeRequestServiceRead;
      int writes = statisticsState.categoryTreeRequestServiceWrite;
      int documents = statisticsState.categoryTreeRequestServiceDocuments;
      debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++reads;
      documents = documents + queryDocs;
      debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.categoryTreeRequestServiceRead = reads;
      statisticsState.categoryTreeRequestServiceWrite = writes;
      statisticsState.categoryTreeRequestServiceDocuments = documents;
    }).expand((element) => [
          CategoryTreeRequestResponse(categoryNode),
          UpdateStatistics(statisticsState),
        ]);
  }
}

class CategoryTreeAddService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;
  StatisticsState statisticsState;

  addTree(List<dynamic> list, String id, EpicStore<AppState> store) {
    if (id == "no_parent") {
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
              return list;
            } else {
              list[i]['nodeCategory'].add(newNodeMap);

              return list;
            }
          } else {
            if (list[i]['nodeCategory'] != null) {
              List<dynamic> attach = addTree(list[i]['nodeCategory'], id, store);
              list[i]['nodeCategory'] = attach;
            }
          }
        }
      }

      return list;
    }
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .whereType<AddCategoryTree>()
        .asyncMap((event) async {
          if (store.state.categoryTree.categoryNodeList != null && store.state.categoryTree.categoryNodeList.isNotEmpty) {
            updateLevel = store.state.categoryTree.nodeLevel;
            updateNumberOfCategories = store.state.categoryTree.numberOfCategories;
          } else {
            updateLevel = 0;
            updateNumberOfCategories = 0;
          }

          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => CategorySnippetService adding category tree");
          print('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => ${event.selectedParent}');
          Parent selected = event.selectedParent;
          List<dynamic> listNode = store.state.categoryTree.categoryNodeList;
          CategoryTree categoryTree = store.state.categoryTree;
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => Lista Iniziale " + listNode.toString());
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => Parent : " + selected.name + " " + selected.id + " " + selected.level.toString());
          List<dynamic> newlistNode = addTree(listNode, selected.id, store);
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => *******");
          print(newlistNode);
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => *******");
          CategoryTree newCategoryNode = CategoryTree(nodeName: "root", nodeId: "root", nodeLevel: updateLevel, numberOfCategories: updateNumberOfCategories, categoryNodeList: newlistNode);
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => Dopo creazione category node");
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => ${store.state.business.id_firestore}');

          QuerySnapshot query = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .doc(store.state.business.id_firestore)
              .collection("category_tree")
              .get();

          int queryDocs = query.docs.length;
          int write = 0;
          query.docs.forEach((document) {
            ++write;
            document.reference.update(newCategoryNode.toJson()).then((value) {
              /// ? WRITE
              debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => Category Node Service should be updated online ");
              return new UpdatedCategoryTree(null);
            });
          });

          statisticsState = store.state.statistics;
          int reads = statisticsState.categoryTreeAddServiceRead;
          int writes = statisticsState.categoryTreeAddServiceWrite;
          int documents = statisticsState.categoryTreeAddServiceDocuments;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          ++reads;
          writes = writes + write;
          documents = documents + queryDocs;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeAddService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          statisticsState.categoryTreeAddServiceRead = reads;
          statisticsState.categoryTreeAddServiceWrite = writes;
          statisticsState.categoryTreeAddServiceDocuments = documents;
        })
        .takeUntil(actions.whereType<UnlistenCategoryTree>())
        .expand((element) => [
              UpdateStatistics(statisticsState),
            ]);
  }
}

class CategoryTreeDeleteService implements EpicClass<AppState> {
  int updateLevel;
  int updateNumberOfCategories;
  StatisticsState statisticsState;

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
          print("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService => Trovato ID Nodo da eliminare");
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
    return actions
        .whereType<DeleteCategoryTree>()
        .asyncMap((event) async {
          updateLevel = store.state.categoryTree.nodeLevel;
          updateNumberOfCategories = store.state.categoryTree.numberOfCategories;

          print("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService => CategorySnippetService updating delete node");
          print("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService => Nodo da cancellare " + event.selectedNodeId);
          List<dynamic> listNode = store.state.categoryTree.categoryNodeList;
          List<dynamic> newlistNode = deleteTree(listNode, event.selectedNodeId, store);
          updateLevel = 0;
          updateCategoryTreeLevel(newlistNode);
          CategoryTree newCategoryNode = CategoryTree(nodeName: "root", nodeId: "root", nodeLevel: updateLevel, numberOfCategories: updateNumberOfCategories, categoryNodeList: newlistNode);
          QuerySnapshot query = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .doc(store.state.business.id_firestore)
              .collection("category_tree")
              .get();

          int queryDocs = query.docs.length;
          int write = 0;
          query.docs.forEach((document) {
            ++write;
            document.reference.update(newCategoryNode.toJson()).then((value) {
              /// ? WRITE
              print("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService => Category Node Service should be delete online ");
              return new DeletedCategoryTree(null);
            });
          });

          statisticsState = store.state.statistics;
          int reads = statisticsState.categoryTreeDeleteServiceRead;
          int writes = statisticsState.categoryTreeDeleteServiceWrite;
          int documents = statisticsState.categoryTreeDeleteServiceDocuments;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          ++reads;
          writes = writes + write;
          documents = documents + queryDocs;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeDeleteService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          statisticsState.categoryTreeDeleteServiceRead = reads;
          statisticsState.categoryTreeDeleteServiceWrite = writes;
          statisticsState.categoryTreeDeleteServiceDocuments = documents;
        })
        .takeUntil(actions.whereType<UnlistenCategoryTree>())
        .expand((element) => [
              UpdateStatistics(statisticsState),
            ]);
  }
}

class CategoryTreeUpdateService implements EpicClass<AppState> {
  List<dynamic> nodeToSave = [];

  int updateLevel;
  int updateNumberOfCategories;
  int localLevel;

  StatisticsState statisticsState;

  updateCategoryTreeLevel(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      updateLevel = updateLevel < list[i]['level'] ? list[i]['level'] : updateLevel;

      if (list[i]['nodeCategory'] != null) {
        updateCategoryTreeLevel(list[i]['nodeCategory']);
      }
    }
  }

  setUpdatedCategoryRootId(List<dynamic> list, String newCategoryRootId) {
    for (int i = 0; i < list.length; i++) {
      list[i]['categoryRootId'] = newCategoryRootId;

      if (list[i]['nodeCategory'] != null) {
        setUpdatedCategoryRootId(list[i]['nodeCategory'], newCategoryRootId);
      }
    }
  }

  searchUpdatedCategoryRootId(List<dynamic> list, String idCategory, String newCategoryRootId) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['nodeId'] == idCategory) {
        if (newCategoryRootId == "no_parent") {
          list[i]['categoryRootId'] = list[i]['nodeId'];
        } else {
          list[i]['categoryRootId'] = newCategoryRootId;
        }
        if (list[i]['nodeCategory'] != null) {
          if (newCategoryRootId == "no_parent") {
            setUpdatedCategoryRootId(list[i]['nodeCategory'], list[i]['nodeId']);
          } else {
            setUpdatedCategoryRootId(list[i]['nodeCategory'], newCategoryRootId);
          }
        }
      }
      if (list[i]['nodeCategory'] != null) {
        searchUpdatedCategoryRootId(list[i]['nodeCategory'], idCategory, newCategoryRootId);
      }
    }
  }

  addNodeToTree(List<dynamic> list, String id, EpicStore<AppState> store) {
    print("Add node to tree");
    print(id);
    if (id == "no_parent") {
      if (list == null) {
        list.add(nodeToSave[0]);
        searchUpdatedCategoryRootId(list, store.state.category.id, "no_parent");
        return list;
      } else {
        list.add(nodeToSave[0]);
        searchUpdatedCategoryRootId(list, store.state.category.id, "no_parent");
        return list;
      }
    } else {
      if (list != null) {
        for (int i = 0; i < list.length; i++) {
          if (list[i]['nodeId'] == id) {
            if (list[i]['nodeCategory'] == null) {
              list[i]['nodeCategory'] = nodeToSave;
              searchUpdatedCategoryRootId(list, id, list[i]['categoryRootId']);
              return list;
            } else {
              list[i]['nodeCategory'].add(nodeToSave[0]);
              searchUpdatedCategoryRootId(list, id, list[i]['categoryRootId']);
              return list;
            }
          } else {
            if (list[i]['nodeCategory'] != null) {
              List<dynamic> attach = addNodeToTree(list[i]['nodeCategory'], id, store);
              list[i]['nodeCategory'] = attach;
            }
          }
        }
      }
    }
    return list;
  }

  updateTree(List<dynamic> list, String selectedNewParentId, EpicStore<AppState> store, String currentParentId) {
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        if (list[i]['nodeId'] == store.state.category.id) {
          if (currentParentId == selectedNewParentId) {
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
            list[i]['categoryRootId'] = store.state.category.parent.parentRootId;
          } else {
            list[i]['nodeName'] = store.state.category.name;
            list[i]['level'] = store.state.category.level;
            list[i]['categoryRootId'] = store.state.category.parent.parentRootId;
            nodeToSave.add(list[i]);
            list.removeAt(i);
          }
        } else {
          if (list[i]['nodeCategory'] != null) {
            List<dynamic> attach = updateTree(list[i]['nodeCategory'], selectedNewParentId, store, list[i]['nodeId']);
            list[i]['nodeCategory'] = attach;
          }
        }
      }
    }

    return list;
  }

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .whereType<UpdateCategoryTree>()
        .asyncMap((event) async {
          updateLevel = store.state.categoryTree.nodeLevel;
          updateNumberOfCategories = store.state.categoryTree.numberOfCategories;

          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => CategoryNodeService updating category tree");
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => ${event.selectedParent}');
          Parent selectedParent = event.selectedParent;
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => Selected New Parent ID: " + selectedParent.id);
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
          debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => Dopo creazione category node");
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => ${store.state.business.id_firestore}');

          QuerySnapshot query = await FirebaseFirestore.instance

              /// 1 READ - ? DOC
              .collection("business")
              .doc(store.state.business.id_firestore)
              .collection("category_tree")
              .get();

          int queryDocs = query.docs.length;
          int write = 0;

          query.docs.forEach((document) {
            ++write;
            document.reference.update(newCategoryNode.toJson()).then((value) {
              /// ? WRITE
              debugPrint("CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => Category Node Service should be updated online ");
              return new UpdatedCategoryTree(null);
            });
          });

          statisticsState = store.state.statistics;
          int reads = statisticsState.categoryTreeUpdateServiceRead;
          int writes = statisticsState.categoryTreeUpdateServiceWrite;
          int documents = statisticsState.categoryTreeUpdateServiceDocuments;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          ++reads;
          writes = writes + write;
          documents = documents + queryDocs;
          debugPrint('CATEGORY_TREE_SERVICE_EPIC - CategoryTreeUpdateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
          statisticsState.categoryTreeUpdateServiceRead = reads;
          statisticsState.categoryTreeUpdateServiceWrite = writes;
          statisticsState.categoryTreeUpdateServiceDocuments = documents;
        })
        .takeUntil(actions.whereType<UnlistenCategoryTree>())
        .expand((element) => [
              UpdateStatistics(statisticsState),
            ]);
  }
}
