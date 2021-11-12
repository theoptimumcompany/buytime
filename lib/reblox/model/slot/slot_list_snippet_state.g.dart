// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_list_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotListSnippetState _$SlotListSnippetStateFromJson(Map<String, dynamic> json) {
  return SlotListSnippetState(
    slotListSnippet: (json['slotListSnippet'] as List)
        ?.map((e) => e == null
            ? null
            : IntervalListState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SlotListSnippetStateToJson(
        SlotListSnippetState instance) =>
    <String, dynamic>{
      'slotListSnippet':
          instance.slotListSnippet?.map((e) => e?.toJson())?.toList(),
    };
