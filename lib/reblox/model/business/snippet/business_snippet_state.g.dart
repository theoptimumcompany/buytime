// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessSnippet _$BusinessSnippetFromJson(Map<String, dynamic> json) {
  return BusinessSnippet(
    id: json['id'] as String,
    name: json['name'] as String,
    thumbnail: json['thumbnail'] as String,
  );
}

Map<String, dynamic> _$BusinessSnippetToJson(BusinessSnippet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
    };
