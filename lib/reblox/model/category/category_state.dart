import 'package:BuyTime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:BuyTime/reusable/snippet/generic.dart';
import 'package:BuyTime/reusable/snippet/manager.dart';
import 'package:BuyTime/reusable/snippet/parent.dart';
import 'package:BuyTime/reusable/snippet/worker.dart';

class CategoryState {
  String name;
  String id;
  int level;
  int children;
  Parent parent;
  List<Manager> manager;
  List<String> managerMailList;
  String businessId;
  List<Worker> worker;
  List<String> workerMailList;
  CategorySnippet categorySnippet;

  CategoryState({
    this.name,
    this.id,
    this.level,
    this.children,
    this.parent,
    this.manager,
    this.managerMailList,
    this.businessId,
    this.worker,
    this.workerMailList,
    this.categorySnippet,
  });

  CategoryState toEmpty() {
    return CategoryState(
      name: "",
      id: "",
      level: 0,
      children: 0,
      parent: Parent(name: "No Parent", id: "no_parent"),
      manager: [],
      managerMailList: [],
      businessId: "",
      worker: [],
      workerMailList: [],
      categorySnippet: CategorySnippet().toEmpty(),
    );
  }

  CategoryState.fromState(CategoryState category) {
    this.name = category.name;
    this.id = category.id;
    this.level = category.level;
    this.children = category.children;
    this.parent = category.parent;
    this.manager = category.manager;
    this.managerMailList = category.managerMailList;
    this.businessId = category.businessId;
    this.worker = category.worker;
    this.workerMailList = category.workerMailList;
    this.categorySnippet = category.categorySnippet;
  }

  categoryStateFieldUpdate(
      String name,
      String id,
      int level,
      int children,
      Parent parent,
      List<Manager> manager,
      List<String> managerMailList,
      String businessId,
      List<Worker> worker,
      List<String> workerMailList,
      CategorySnippet categorySnippet) {
    CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      managerMailList: managerMailList ?? this.managerMailList,
      businessId: businessId ?? this.businessId,
      worker: worker ?? this.worker,
      workerMailList: workerMailList ?? this.workerMailList,
      categorySnippet: categorySnippet ?? this.categorySnippet,
    );
  }

  CategoryState copyWith(
      {String name,
      String id,
      int level,
      int children,
      GenericState parent,
      List<Manager> manager,
      List<String> managerMailList,
      String businessId,
      List<Worker> worker,
      List<String> workerMailList,
      CategorySnippet categorySnippet}) {
    return CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      managerMailList: managerMailList ?? this.managerMailList,
      businessId: businessId ?? this.businessId,
      worker: worker ?? this.worker,
      workerMailList: workerMailList ?? this.workerMailList,
      categorySnippet: categorySnippet ?? this.categorySnippet,
    );
  }

  List<dynamic> convertManagerToJson(List<Manager> objectStateList) {
    List<dynamic> list = List<dynamic>();
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  List<dynamic> convertWorkerToJson(List<Worker> objectStateList) {
    List<dynamic> list = List<dynamic>();
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  CategoryState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        level = json['level'],
        children = json['children'],
        parent = Parent.fromJson(json["parent"]),
        manager = List<Manager>.from(json["manager"].map((item) {
          return new Manager(
            name: item["name"],
            id: item["id"],
          );
        })),
        managerMailList = List<String>.from(json['managerMailList']),
        businessId = json['businessId'],
        worker = List<Worker>.from(json["worker"].map((item) {
          return new Worker(
            name: item["name"],
            id: item["id"],
          );
        })),
        workerMailList = List<String>.from(json['workerMailList']),
        categorySnippet = CategorySnippet.fromJson(json['snippet']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'level': level,
        'children': children,
        'parent': parent.toJson(),
        'manager': convertManagerToJson(manager),
        'managerMailList': managerMailList,
        'businessId': businessId,
        'worker': convertWorkerToJson(worker),
        'workerMailList': workerMailList,
        'snippet': categorySnippet.toJson(),
      };
}
