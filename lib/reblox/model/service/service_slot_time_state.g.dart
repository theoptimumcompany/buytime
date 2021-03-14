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
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    limitBooking: json['limitBooking'] as int,
    noLimitBooking: json['noLimitBooking'] as bool,
    price: (json['price'] as num)?.toDouble(),
    minDuration: json['minDuration'] as int ?? 0,
    intervalVisibility:
        (json['intervalVisibility'] as List)?.map((e) => e as bool)?.toList(),
  );
}

Map<String, dynamic> _$ServiceSlotToJson(ServiceSlot instance) =>
    <String, dynamic>{
      'numberOfInterval': instance.numberOfInterval,
      'switchWeek': instance.switchWeek,
      'daysInterval': instance.daysInterval?.map((e) => e?.toJson())?.toList(),
      'startTime': instance.startTime,
      'stopTime': instance.stopTime,
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'hour': instance.hour,
      'minute': instance.minute,
      'limitBooking': instance.limitBooking,
      'noLimitBooking': instance.noLimitBooking,
      'price': instance.price,
      'minDuration': instance.minDuration,
      'intervalVisibility': instance.intervalVisibility,
    };
