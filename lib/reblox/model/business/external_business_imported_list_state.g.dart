// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_business_imported_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalBusinessImportedListState _$ExternalBusinessImportedListStateFromJson(
    Map<String, dynamic> json) {
  return ExternalBusinessImportedListState(
    externalBusinessImported: (json['externalBusinessImported'] as List)
        ?.map((e) => e == null
            ? null
            : ExternalBusinessImportedState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExternalBusinessImportedListStateToJson(
        ExternalBusinessImportedListState instance) =>
    <String, dynamic>{
      'externalBusinessImported':
          instance.externalBusinessImported?.map((e) => e?.toJson())?.toList(),
    };
