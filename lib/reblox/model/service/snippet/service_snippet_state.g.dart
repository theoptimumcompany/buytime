// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSnippetState _$ServiceSnippetStateFromJson(Map<String, dynamic> json) {
  return ServiceSnippetState(
    serviceAbsolutePath: json['serviceAbsolutePath'] as String ?? '',
    serviceName: json['serviceName'] as String ?? '',
    servicePrice: (json['servicePrice'] as num)?.toDouble() ?? 0.0,
    serviceTimesSold: json['serviceTimesSold'] as int ?? 0,
    serviceImage: json['serviceImage'] as String ?? '',
    serviceVisibility: json['serviceVisibility'] as String ?? '',
    connectedBusinessId: (json['connectedBusinessId'] as List)
            ?.map((e) => e as String)
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$ServiceSnippetStateToJson(
        ServiceSnippetState instance) =>
    <String, dynamic>{
      'serviceAbsolutePath': instance.serviceAbsolutePath,
      'serviceName': instance.serviceName,
      'servicePrice': instance.servicePrice,
      'serviceTimesSold': instance.serviceTimesSold,
      'serviceImage': instance.serviceImage,
      'serviceVisibility': instance.serviceVisibility,
      'connectedBusinessId': instance.connectedBusinessId,
    };
