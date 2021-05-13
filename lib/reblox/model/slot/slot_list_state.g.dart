// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotListState _$SlotListStateFromJson(Map<String, dynamic> json) {
  return SlotListState(
    slotlistState: (json['slotlistState'] as List)
        ?.map((e) => e == null
            ? null
            : IntervalListState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SlotListStateToJson(SlotListState instance) =>
    <String, dynamic>{
      'slotlistState':
          instance.slotlistState?.map((e) => e?.toJson())?.toList(),
    };
