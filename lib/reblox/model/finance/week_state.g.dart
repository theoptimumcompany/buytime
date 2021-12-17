// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Week _$WeekFromJson(Map<String, dynamic> json) {
  return Week(
    data: json['data'],
    mediumRevenue: (json['mediumRevenue'] as num)?.toDouble(),
    orderNumber: json['orderNumber'] as int,
    totalRevenue: (json['totalRevenue'] as num)?.toDouble(),
    realRevenue: (json['realRevenue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'data': instance.data,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
    };
