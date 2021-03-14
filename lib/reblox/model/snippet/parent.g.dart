// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parent _$ParentFromJson(Map<String, dynamic> json) {
  return Parent(
    id: json['id'] as String,
    level: json['level'] as int,
    name: json['name'] as String,
    parentRootId: json['parentRootId'] as String,
  );
}

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'name': instance.name,
      'parentRootId': instance.parentRootId,
    };
