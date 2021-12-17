// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Year _$YearFromJson(Map<String, dynamic> json) {
  return Year(
    data: json['data'],
    mediumRevenue: (json['mediumRevenue'] as num)?.toDouble(),
    orderNumber: (json['orderNumber'] as num)?.toDouble(),
    totalRevenue: json['totalRevenue'] as int,
    realRevenue: (json['realRevenue'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$YearToJson(Year instance) => <String, dynamic>{
      'data': instance.data,
      'mediumRevenue': instance.mediumRevenue,
      'orderNumber': instance.orderNumber,
      'totalRevenue': instance.totalRevenue,
      'realRevenue': instance.realRevenue,
    };
