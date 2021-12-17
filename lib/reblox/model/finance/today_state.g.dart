// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Today _$TodayFromJson(Map<String, dynamic> json) {
  return Today(
    hour: (json['hour'] as List)?.map((e) => e as int)?.toList(),
    mediumRevenue: json['mediumRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
    orderNumber: json['orderNumber'] as int,
    totalRevenue: json['totalRevenue'] as int,
  );
}

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
      'hour': instance.hour,
      'mediumRevenue': instance.mediumRevenue,
      'realRevenue': instance.realRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
    };
