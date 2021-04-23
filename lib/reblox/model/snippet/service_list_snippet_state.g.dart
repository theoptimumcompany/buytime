// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_list_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceListSnippetState _$ServiceListSnippetStateFromJson(
    Map<String, dynamic> json) {
  return ServiceListSnippetState(
    givenConnectedBusinessIds: (json['givenConnectedBusinessIds'] as List)
            ?.map((e) => e == null
                ? null
                : BusinessSnippetState.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    takenConnectedBusinessIds: (json['takenConnectedBusinessIds'] as List)
            ?.map((e) => e == null
                ? null
                : BusinessSnippetState.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    businessId: json['businessId'] as String,
    businessName: json['businessName'] as String,
    businessImage: json['businessImage'] as String,
    businessServiceNumberInternal:
        json['businessServiceNumberInternal'] as int ?? 0,
    businessServiceNumberExternal:
        json['businessServiceNumberExternal'] as int ?? 0,
    businessSnippet: (json['businessSnippet'] as List)
            ?.map((e) => e == null
                ? null
                : CategorySnippetState.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$ServiceListSnippetStateToJson(
        ServiceListSnippetState instance) =>
    <String, dynamic>{
      'givenConnectedBusinessIds':
          instance.givenConnectedBusinessIds?.map((e) => e?.toJson())?.toList(),
      'takenConnectedBusinessIds':
          instance.takenConnectedBusinessIds?.map((e) => e?.toJson())?.toList(),
      'businessId': instance.businessId,
      'businessName': instance.businessName,
      'businessImage': instance.businessImage,
      'businessServiceNumberInternal': instance.businessServiceNumberInternal,
      'businessServiceNumberExternal': instance.businessServiceNumberExternal,
      'businessSnippet':
          instance.businessSnippet?.map((e) => e?.toJson())?.toList(),
    };
