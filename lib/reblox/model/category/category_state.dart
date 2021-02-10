import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';

enum CustomTag {
  showcase,
  external,
  other,
}

class CategoryState {
  String name;
  String id;
  int level;
  int children;
  String categoryRootId;
  Parent parent;
  List<Manager> manager;
  List<String> managerMailList;
  String businessId;
  List<Worker> worker;
  List<String> workerMailList;
  CategorySnippet categorySnippet;
  OptimumFileToUpload fileToUpload;
  String categoryImage;
  String customTag;

  CategoryState({
    this.name,
    this.id,
    this.level,
    this.children,
    this.categoryRootId,
    this.parent,
    this.manager,
    this.managerMailList,
    this.businessId,
    this.worker,
    this.workerMailList,
    this.categorySnippet,
    this.fileToUpload,
    this.categoryImage,
    this.customTag
  });

  CategoryState toEmpty() {
    return CategoryState(
      name: "",
      id: "",
      level: 0,
      children: 0,
      categoryRootId: "",
      parent: Parent(name: "No Parent", id: "no_parent"),
      manager: [],
      managerMailList: [],
      businessId: "",
      worker: [],
      workerMailList: [],
      categorySnippet: CategorySnippet().toEmpty(),
      fileToUpload: null,
        categoryImage: '',
      customTag: ''
    );
  }

  CategoryState.fromState(CategoryState category) {
    this.name = category.name;
    this.id = category.id;
    this.level = category.level;
    this.children = category.children;
    this.categoryRootId = category.categoryRootId;
    this.parent = category.parent;
    this.manager = category.manager;
    this.managerMailList = category.managerMailList;
    this.businessId = category.businessId;
    this.worker = category.worker;
    this.workerMailList = category.workerMailList;
    this.categorySnippet = category.categorySnippet;
    this.fileToUpload = category.fileToUpload;
    this.categoryImage = category.categoryImage;
    this.customTag = category.customTag;
  }

  String enumToString(CustomTag customTag){
    return customTag.toString().split('.').last;
  }

  categoryStateFieldUpdate(
      String name,
          String id,
      int level,
          int children,
      String categoryRootId,
      Parent parent,
      List<Manager> manager,
      List<String> managerMailList,
      String businessId,
      List<Worker> worker,
      List<String> workerMailList,
      CategorySnippet categorySnippet,
      OptimumFileToUpload fileToUpload,
      String categoryImage,
      String customTag
      ) {
    CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      categoryRootId: categoryRootId ?? this.categoryRootId,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      managerMailList: managerMailList ?? this.managerMailList,
      businessId: businessId ?? this.businessId,
      worker: worker ?? this.worker,
      workerMailList: workerMailList ?? this.workerMailList,
      categorySnippet: categorySnippet ?? this.categorySnippet,
      fileToUpload: fileToUpload ?? this.fileToUpload,
        categoryImage: categoryImage ?? this.categoryImage,
      customTag: customTag ?? this.customTag
    );
  }

  CategoryState copyWith(
      {String name,
      String id,
      int level,
      int children,
      String categoryRootId,
      GenericState parent,
      List<Manager> manager,
      List<String> managerMailList,
      String businessId,
      List<Worker> worker,
      List<String> workerMailList,
      CategorySnippet categorySnippet,
        OptimumFileToUpload fileToUpload,
        String categoryImage,
        String customTag
      }) {
    return CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      categoryRootId: categoryRootId ?? this.categoryRootId,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      managerMailList: managerMailList ?? this.managerMailList,
      businessId: businessId ?? this.businessId,
      worker: worker ?? this.worker,
      workerMailList: workerMailList ?? this.workerMailList,
      categorySnippet: categorySnippet ?? this.categorySnippet,
      fileToUpload: fileToUpload ?? this.fileToUpload,
        categoryImage: categoryImage ?? this.categoryImage,
        customTag:  customTag ?? this.customTag
    );
  }

  List<dynamic> convertManagerToJson(List<Manager> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  List<dynamic> convertWorkerToJson(List<Worker> objectStateList) {
    List<dynamic> list = [];
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
        categoryRootId = json['categoryRootId'],
        parent = Parent.fromJson(json["parent"]),
        manager = List<Manager>.from(json["manager"].map((item) {
          return new Manager(
            id: item["id"],
            mail: item["mail"],
            name: item["name"],
            surname: item["surname"],
          );
        })),
        managerMailList = List<String>.from(json['managerMailList']),
        businessId = json['businessId'],
        worker = List<Worker>.from(json["worker"].map((item) {
          return new Worker(
            id: item["id"],
            mail: item["mail"],
            name: item["name"],
            surname: item["surname"],
          );
        })),
        workerMailList = List<String>.from(json['workerMailList']),
        categorySnippet = CategorySnippet.fromJson(json['snippet']),
        categoryImage = json['categoryImage'],
        customTag = json['customTag'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'level': level,
        'children': children,
        'categoryRootId': categoryRootId,
        'parent': parent.toJson(),
        'manager': convertManagerToJson(manager),
        'managerMailList': managerMailList,
        'businessId': businessId,
        'worker': convertWorkerToJson(worker),
        'workerMailList': workerMailList,
        'snippet': categorySnippet.toJson(),
        'categoryImage': categoryImage,
        'customTag': customTag,
      };
}
