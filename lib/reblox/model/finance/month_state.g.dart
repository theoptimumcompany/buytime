// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map<String, dynamic> json) {
  return Month(
    data: json['data'],
    mediumRevenue: json['mediumRevenue'] as int,
    orderNumber: json['orderNumber'] as int,
    totalRevenue: json['totalRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
  );
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'data': instance.data,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
    };
