// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_slot_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SquareSlotState _$IntervalSlotStateFromJson(Map<String, dynamic> json) {
  return SquareSlotState(
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    startTime: json['startTime'] as String,
    stopTime: json['stopTime'] as String,
    price: (json['price'] as num)?.toDouble(),
    availablePlaces: json['availablePlaces'] as int,
    maxAvailablePlace: json['maxAvailablePlace'] as int,
    parallelDelivery: json['parallelDelivery'] as int,
    visibility: json['visibility'] as bool ?? true,
  );
}

Map<String, dynamic> _$IntervalSlotStateToJson(SquareSlotState instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'startTime': instance.startTime,
      'stopTime': instance.stopTime,
      'price': instance.price,
      'availablePlaces': instance.availablePlaces,
      'maxAvailablePlace': instance.maxAvailablePlace,
      'parallelDelivery': instance.parallelDelivery,
      'visibility': instance.visibility,
    };
