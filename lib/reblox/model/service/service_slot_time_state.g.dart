// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_slot_time_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSlot _$ServiceSlotFromJson(Map<String, dynamic> json) {
  return ServiceSlot(
    numberOfInterval: json['numberOfInterval'] as int,
    switchWeek: (json['switchWeek'] as List)?.map((e) => e as bool)?.toList(),
    daysInterval: (json['daysInterval'] as List)
        ?.map((e) =>
            e == null ? null : EveryDay.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    startTime: (json['startTime'] as List)?.map((e) => e as String)?.toList(),
    stopTime: (json['stopTime'] as List)?.map((e) => e as String)?.toList(),
    checkIn: json['checkIn'] as String,
    checkOut: json['checkOut'] as String,
    hour: json['hour'] as int ?? 0,
    minute: json['minute'] as int ?? 0,
    limitBooking: json['limitBooking'] as int ?? 1,
    noLimitBooking: json['noLimitBooking'] as bool ?? false,
    price: (json['price'] as num)?.toDouble() ?? 0.0,
    maxQuantity: json['maxQuantity'] as int ?? 1,
    intervalVisibility:
        (json['intervalVisibility'] as List)?.map((e) => e as bool)?.toList() ??
            [true],
    day: json['day'] as int ?? 0,
  );
}

Map<String, dynamic> _$ServiceSlotToJson(ServiceSlot instance) =>
    <String, dynamic>{
      'numberOfInterval': instance.numberOfInterval,
      'switchWeek': instance.switchWeek,
      'daysInterval': instance.daysInterval?.map((e) => e?.toJson())?.toList(),
      'intervalVisibility': instance.intervalVisibility,
      'startTime': instance.startTime,
      'stopTime': instance.stopTime,
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'hour': instance.hour,
      'minute': instance.minute,
      'day': instance.day,
      'maxQuantity': instance.maxQuantity,
      'limitBooking': instance.limitBooking,
      'noLimitBooking': instance.noLimitBooking,
      'price': instance.price,
    };
