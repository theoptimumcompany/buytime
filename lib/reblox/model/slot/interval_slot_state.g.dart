// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interval_slot_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SquareSlotState _$SquareSlotStateFromJson(Map<String, dynamic> json) {
  return SquareSlotState(
    date: Utils.getDate(json['date'] as Timestamp),
    startTime: json['startTime'] as String,
    stopTime: json['stopTime'] as String,
    price: (json['price'] as num)?.toDouble(),
    availablePlaces: json['availablePlaces'] as int,
    maxAvailablePlace: json['maxAvailablePlace'] as int,
    parallelDelivery: json['parallelDelivery'] as int,
    visibility: json['visibility'] as bool ?? true,
  );
}

Map<String, dynamic> _$SquareSlotStateToJson(SquareSlotState instance) =>
    <String, dynamic>{
      'date': Utils.setDate(instance.date),
      'startTime': instance.startTime,
      'stopTime': instance.stopTime,
      'price': instance.price,
      'availablePlaces': instance.availablePlaces,
      'maxAvailablePlace': instance.maxAvailablePlace,
      'parallelDelivery': instance.parallelDelivery,
      'visibility': instance.visibility,
    };
