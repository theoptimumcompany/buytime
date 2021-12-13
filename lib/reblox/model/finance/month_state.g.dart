// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map<String, dynamic> json) {
  return Month(
    hour: (json['hour'] as List)?.map((e) => e as int)?.toList(),
    mediumRevenue: json['mediumRevenue'] as int,
    orderNumber: json['orderNumber'] as int,
    totalRevenue: json['totalRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
    day: (json['day'] as List)?.map((e) => e as int)?.toList(),
    month: (json['month'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'hour': instance.hour,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
      'day': instance.day,
      'month': instance.month,
    };
