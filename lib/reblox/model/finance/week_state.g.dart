// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Week _$WeekFromJson(Map<String, dynamic> json) {
  return Week(
    hour: (json['hour'] as List)?.map((e) => e as int)?.toList(),
    mediumRevenue: json['mediumRevenue'] as int,
    orderNumber: json['orderNumber'] as int,
    totalRevenue: json['totalRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
    day: (json['day'] as List)?.map((e) => e as int)?.toList(),
    month: (json['month'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'hour': instance.hour,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
      'day': instance.day,
      'month': instance.month,
    };
