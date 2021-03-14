// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSnippet _$ServiceSnippetFromJson(Map<String, dynamic> json) {
  return ServiceSnippet(
    id: json['id'] as String,
    name: json['name'] as String,
    timesSold: json['timesSold'] as int,
    image1: json['image1'] as String,
    visibility: json['visibility'] as String,
  );
}

Map<String, dynamic> _$ServiceSnippetToJson(ServiceSnippet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'timesSold': instance.timesSold,
      'image1': instance.image1,
      'visibility': instance.visibility,
    };
