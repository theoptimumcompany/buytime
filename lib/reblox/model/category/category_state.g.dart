// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryState _$CategoryStateFromJson(Map<String, dynamic> json) {
  return CategoryState(
    name: json['name'] as String,
    id: json['id'] as String,
    level: json['level'] as int,
    children: json['children'] as int,
    categoryRootId: json['categoryRootId'] as String,
    parent: json['parent'] == null
        ? null
        : Parent.fromJson(json['parent'] as Map<String, dynamic>),
    manager: (json['manager'] as List)
        ?.map((e) =>
            e == null ? null : Manager.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    managerMailList:
        (json['managerMailList'] as List)?.map((e) => e as String)?.toList(),
    businessId: json['businessId'] as String,
    worker: (json['worker'] as List)
        ?.map((e) =>
            e == null ? null : Worker.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    workerMailList:
        (json['workerMailList'] as List)?.map((e) => e as String)?.toList(),
    categorySnippet: json['categorySnippet'] == null
        ? null
        : CategorySnippet.fromJson(
            json['categorySnippet'] as Map<String, dynamic>),
    categoryImage: json['categoryImage'] as String,
    customTag: json['customTag'] as String,
  );
}

Map<String, dynamic> _$CategoryStateToJson(CategoryState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'level': instance.level,
      'children': instance.children,
      'categoryRootId': instance.categoryRootId,
      'parent': instance.parent?.toJson(),
      'manager': instance.manager?.map((e) => e?.toJson())?.toList(),
      'managerMailList': instance.managerMailList,
      'businessId': instance.businessId,
      'worker': instance.worker?.map((e) => e?.toJson())?.toList(),
      'workerMailList': instance.workerMailList,
      'categorySnippet': instance.categorySnippet?.toJson(),
      'categoryImage': instance.categoryImage,
      'customTag': instance.customTag,
    };
