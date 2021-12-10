// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Week _$WeekFromJson(Map<String, dynamic> json) {
  return Week(
    mediumRevenue: json['mediumRevenue'] as int,
    realRevenue: json['realRevenue'] as int,
    day: (json['day'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$WeekToJson(Week instance) => <String, dynamic>{
      'mediumRevenue': instance.mediumRevenue,
      'realRevenue': instance.realRevenue,
      'day': instance.day,
    };
