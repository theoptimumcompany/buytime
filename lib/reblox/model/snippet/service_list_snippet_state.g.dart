// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_list_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceListSnippet _$ServiceListSnippetFromJson(Map<String, dynamic> json) {
  return ServiceListSnippet(
    givenConnectedBusinessIds: (json['givenConnectedBusinessIds'] as List)
            ?.map((e) => e == null
                ? null
                : BusinessSnippet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    takenConnectedBusinessIds: (json['takenConnectedBusinessIds'] as List)
            ?.map((e) => e == null
                ? null
                : BusinessSnippet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    businessId: json['businessId'] as String,
    businessServiceNumberInternal:
        json['businessServiceNumberInternal'] as int ?? 0,
    businessServiceNumberExternal:
        json['businessServiceNumberExternal'] as int ?? 0,
    businessSnippet: (json['businessSnippet'] as List)
            ?.map((e) => e == null
                ? null
                : CategorySnippet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$ServiceListSnippetToJson(ServiceListSnippet instance) =>
    <String, dynamic>{
      'givenConnectedBusinessIds':
          instance.givenConnectedBusinessIds?.map((e) => e?.toJson())?.toList(),
      'takenConnectedBusinessIds':
          instance.takenConnectedBusinessIds?.map((e) => e?.toJson())?.toList(),
      'businessId': instance.businessId,
      'businessServiceNumberInternal': instance.businessServiceNumberInternal,
      'businessServiceNumberExternal': instance.businessServiceNumberExternal,
      'businessSnippet':
          instance.businessSnippet?.map((e) => e?.toJson())?.toList(),
    };
