// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_service_imported_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalServiceImportedListState _$ExternalServiceImportedListStateFromJson(
    Map<String, dynamic> json) {
  return ExternalServiceImportedListState(
    externalServiceImported: (json['externalServiceImported'] as List)
        ?.map((e) => e == null
            ? null
            : ExternalServiceImportedState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExternalServiceImportedListStateToJson(
        ExternalServiceImportedListState instance) =>
    <String, dynamic>{
      'externalServiceImported':
          instance.externalServiceImported?.map((e) => e?.toJson())?.toList(),
    };
