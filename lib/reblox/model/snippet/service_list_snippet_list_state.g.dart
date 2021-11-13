// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_list_snippet_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceListSnippetListState _$ServiceListSnippetListStateFromJson(
    Map<String, dynamic> json) {
  return ServiceListSnippetListState(
    serviceListSnippetListState: (json['serviceListSnippetListState'] as List)
        ?.map((e) => e == null
            ? null
            : ServiceListSnippetState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ServiceListSnippetListStateToJson(
        ServiceListSnippetListState instance) =>
    <String, dynamic>{
      'serviceListSnippetListState': instance.serviceListSnippetListState
          ?.map((e) => e?.toJson())
          ?.toList(),
    };
