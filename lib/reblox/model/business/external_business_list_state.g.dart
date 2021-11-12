// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_business_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalBusinessListState _$ExternalBusinessListStateFromJson(
    Map<String, dynamic> json) {
  return ExternalBusinessListState(
    externalBusinessListState: (json['externalBusinessListState'] as List)
        ?.map((e) => e == null
            ? null
            : ExternalBusinessState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ExternalBusinessListStateToJson(
        ExternalBusinessListState instance) =>
    <String, dynamic>{
      'externalBusinessListState':
          instance.externalBusinessListState?.map((e) => e?.toJson())?.toList(),
    };
