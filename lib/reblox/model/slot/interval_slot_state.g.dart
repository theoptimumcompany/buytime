// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_slot_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SquareSlotState _$SquareSlotStateFromJson(Map<String, dynamic> json) {
  return SquareSlotState(
    date: json['date'] as String,
    on: json['on'] as String,
    off: json['off'] as String,
    uid: json['uid'] as String,
    free: json['free'] as int,
    max: json['max'] as int,
  );
}

Map<String, dynamic> _$SquareSlotStateToJson(SquareSlotState instance) =>
    <String, dynamic>{
      'date': instance.date,
      'on': instance.on,
      'off': instance.off,
      'uid': instance.uid,
      'free': instance.free,
      'max': instance.max,
    };
