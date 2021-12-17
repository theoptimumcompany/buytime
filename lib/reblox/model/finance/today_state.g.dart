// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Today _$TodayFromJson(Map<String, dynamic> json) {
  return Today(
    data: json['data'],
    mediumRevenue: (json['mediumRevenue'] as num)?.toDouble(),
    orderNumber: (json['orderNumber'] as num)?.toDouble(),
    totalRevenue: json['totalRevenue'] as int,
    realRevenue: (json['realRevenue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$TodayToJson(Today instance) => <String, dynamic>{
      'data': instance.data,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
    };
