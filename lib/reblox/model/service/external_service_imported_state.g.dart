// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_service_imported_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalServiceImportedState _$ExternalServiceImportedStateFromJson(
    Map<String, dynamic> json) {
  return ExternalServiceImportedState(
    externalBusinessId: json['externalBusinessId'] as String,
    externalBusinessName: json['externalBusinessName'] as String,
    externalCategoryName: json['externalCategoryName'] as String,
    externalServiceId: json['externalServiceId'] as String,
    internalBusinessId: json['internalBusinessId'] as String,
    internalBusinessName: json['internalBusinessName'] as String,
    importTimestamp: Utils.getDate(json['importTimestamp'] as Timestamp),
    imported: json['imported'] as bool ?? false,
  );
}

Map<String, dynamic> _$ExternalServiceImportedStateToJson(
        ExternalServiceImportedState instance) =>
    <String, dynamic>{
      'externalBusinessId': instance.externalBusinessId,
      'externalBusinessName': instance.externalBusinessName,
      'externalCategoryName': instance.externalCategoryName,
      'externalServiceId': instance.externalServiceId,
      'internalBusinessId': instance.internalBusinessId,
      'internalBusinessName': instance.internalBusinessName,
      'importTimestamp': Utils.setDate(instance.importTimestamp),
      'imported': instance.imported,
    };
