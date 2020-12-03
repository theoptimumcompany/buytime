import 'package:BuyTime/reblox/model/object_state.dart';

class CategoryState {
  String name;
  String id;
  int level;
  int children;
  ObjectState parent;
  List<ObjectState> manager;
  String businessId;
  List<ObjectState> notificationTo;

  CategoryState({
    this.name,
    this.id,
    this.level,
    this.children,
    this.parent,
    this.manager,
    this.businessId,
    this.notificationTo,
  });

  CategoryState toEmpty() {
    return CategoryState(
      name: "",
      id: "",
      level: 0,
      children: 0,
      parent: ObjectState(name: "No Parent", id: "no_parent"),
      manager: [ObjectState()],
      businessId: "",
      notificationTo: [ObjectState()],
    );
  }

  CategoryState.fromState(CategoryState category) {
    this.name = category.name;
    this.id = category.id;
    this.level = category.level;
    this.children = category.children;
    this.parent = category.parent;
    this.manager = category.manager;
    this.businessId = category.businessId;
    this.notificationTo = category.notificationTo;
  }

  categoryStateFieldUpdate(String name, String id, int level, int children, ObjectState parent, List<ObjectState> manager, String businessId, List<ObjectState> notificationTo) {
    CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      businessId: businessId ?? this.businessId,
      notificationTo: notificationTo ?? this.notificationTo,
    );
  }

  CategoryState copyWith({String name, String id, int level, int children, ObjectState parent, List<ObjectState> manager, String businessId, List<ObjectState> notificationTo}) {
    return CategoryState(
      name: name ?? this.name,
      id: id ?? this.id,
      level: level ?? this.level,
      children: children ?? this.children,
      parent: parent ?? this.parent,
      manager: manager ?? this.manager,
      businessId: businessId ?? this.businessId,
      notificationTo: notificationTo ?? this.notificationTo,
    );
  }

  List<dynamic> convertToJson(List<ObjectState> objectStateList) {
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
        parent = ObjectState.fromJson(json["parent"]),
        manager = List<ObjectState>.from(json["manager"].map((item) {
          return new ObjectState(
            name: item["name"],
            id: item["id"],
          );
        })),
        businessId = json['businessId'],
        notificationTo = List<ObjectState>.from(json["notificationTo"].map((item) {
          return new ObjectState(
            name: item["name"],
            id: item["id"],
          );
        }));

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'level': level,
        'children': children,
        'parent': parent.toJson(),
        'manager': convertToJson(manager),
        'businessId': businessId,
        'notificationTo': convertToJson(notificationTo),
      };
}
