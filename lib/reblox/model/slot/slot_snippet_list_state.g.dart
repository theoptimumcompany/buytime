// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_snippet_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotSnippetListState _$SlotSnippetListStateFromJson(Map<String, dynamic> json) {
  return SlotSnippetListState(
    slotSnippetListState: (json['slotSnippetListState'] as List)
        ?.map((e) => e == null
            ? null
            : SlotListState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SlotSnippetListStateToJson(
        SlotSnippetListState instance) =>
    <String, dynamic>{
      'slotSnippetListState':
          instance.slotSnippetListState?.map((e) => e?.toJson())?.toList(),
    };
