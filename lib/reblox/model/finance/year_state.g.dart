// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Year _$YearFromJson(Map<String, dynamic> json) {
  return Year(
    month: (json['month'] as List)?.map((e) => e as int)?.toList(),
    mediumRevenue: json['mediumRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
  );
}

Map<String, dynamic> _$YearToJson(Year instance) => <String, dynamic>{
      'month': instance.month,
      'mediumRevenue': instance.mediumRevenue,
      'realRevenue': instance.realRevenue,
    };
