// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessSnippetState _$BusinessSnippetStateFromJson(Map<String, dynamic> json) {
  return BusinessSnippetState(
    businessId: json['businessId'] as String,
    businessName: json['businessName'] as String,
    businessImage: json['businessImage'] as String,
    serviceTakenNumber: json['serviceTakenNumber'] as int,
    serviceGivenNumber: json['serviceGivenNumber'] as int,
  );
}

Map<String, dynamic> _$BusinessSnippetStateToJson(
        BusinessSnippetState instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'businessName': instance.businessName,
      'businessImage': instance.businessImage,
      'serviceTakenNumber': instance.serviceTakenNumber,
      'serviceGivenNumber': instance.serviceGivenNumber,
    };
