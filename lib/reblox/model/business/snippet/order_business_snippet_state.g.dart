// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_business_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderBusinessSnippetState _$OrderBusinessSnippetStateFromJson(
    Map<String, dynamic> json) {
  return OrderBusinessSnippetState(
    id: json['id'] as String,
    name: json['name'] as String,
    thumbnail: json['thumbnail'] as String,
    serviceTakenNumber: json['serviceTakenNumber'] as int,
  );
}

Map<String, dynamic> _$OrderBusinessSnippetStateToJson(
        OrderBusinessSnippetState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'serviceTakenNumber': instance.serviceTakenNumber,
    };
