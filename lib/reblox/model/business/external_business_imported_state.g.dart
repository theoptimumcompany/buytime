// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_business_imported_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalBusinessImportedState _$ExternalBusinessImportedStateFromJson(
    Map<String, dynamic> json) {
  return ExternalBusinessImportedState(
    externalBusinessId: json['externalBusinessId'] as String,
    externalBusinessName: json['externalBusinessName'] as String,
    internalBusinessId: json['internalBusinessId'] as String,
    internalBusinessName: json['internalBusinessName'] as String,
    importTimestamp: Utils.getDate(json['importTimestamp'] as Timestamp),
    imported: json['imported'] as bool ?? false,
  );
}

Map<String, dynamic> _$ExternalBusinessImportedStateToJson(
        ExternalBusinessImportedState instance) =>
    <String, dynamic>{
      'externalBusinessId': instance.externalBusinessId,
      'externalBusinessName': instance.externalBusinessName,
      'internalBusinessId': instance.internalBusinessId,
      'internalBusinessName': instance.internalBusinessName,
      'importTimestamp': Utils.setDate(instance.importTimestamp),
      'imported': instance.imported,
    };
