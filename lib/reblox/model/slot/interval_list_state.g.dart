// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntervalListState _$IntervalListStateFromJson(Map<String, dynamic> json) {
  return IntervalListState(
    slot: (json['slot'] as List)
        ?.map((e) => e == null
            ? null
            : SquareSlotState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$IntervalListStateToJson(IntervalListState instance) =>
    <String, dynamic>{
      'slot': instance.slot?.map((e) => e?.toJson())?.toList(),
    };
