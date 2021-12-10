// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Month _$MonthFromJson(Map<String, dynamic> json) {
  return Month(
    mediumRevenue: json['mediumRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
    day: (json['day'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$MonthToJson(Month instance) => <String, dynamic>{
      'mediumRevenue': instance.mediumRevenue,
      'realRevenue': instance.realRevenue,
      'day': instance.day,
    };
