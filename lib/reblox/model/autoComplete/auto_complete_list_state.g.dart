// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_complete_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutoCompleteListState _$AutoCompleteListStateFromJson(
    Map<String, dynamic> json) {
  return AutoCompleteListState(
    autoCompleteListState: (json['autoCompleteListState'] as List)
        ?.map((e) => e == null
            ? null
            : AutoCompleteState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AutoCompleteListStateToJson(
        AutoCompleteListState instance) =>
    <String, dynamic>{
      'autoCompleteListState':
          instance.autoCompleteListState?.map((e) => e?.toJson())?.toList(),
    };
