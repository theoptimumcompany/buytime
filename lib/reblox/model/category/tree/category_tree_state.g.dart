// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryTree _$CategoryTreeFromJson(Map<String, dynamic> json) {
  return CategoryTree(
    nodeName: json['nodeName'] as String,
    nodeId: json['nodeId'] as String,
    categoryRootId: json['categoryRootId'] as String,
    nodeLevel: json['nodeLevel'] as int,
    numberOfCategories: json['numberOfCategories'] as int,
    categoryNodeList: json['categoryNodeList'] as List,
  );
}

Map<String, dynamic> _$CategoryTreeToJson(CategoryTree instance) =>
    <String, dynamic>{
      'nodeName': instance.nodeName,
      'nodeId': instance.nodeId,
      'categoryRootId': instance.categoryRootId,
      'nodeLevel': instance.nodeLevel,
      'numberOfCategories': instance.numberOfCategories,
      'categoryNodeList': instance.categoryNodeList,
    };
