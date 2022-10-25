// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Finance _$FinanceFromJson(Map<String, dynamic> json) {
  return Finance(
    year: json['year'] == null
        ? null
        : Year.fromJson(json['year'] as Map<String, dynamic>),
    week: json['week'] == null
        ? null
        : Week.fromJson(json['week'] as Map<String, dynamic>),
    monthlyExternalServiceGiveback:
        json['monthlyExternalServiceGiveback'] as int,
    month: json['month'] == null
        ? null
        : Month.fromJson(json['month'] as Map<String, dynamic>),
    monthlyExternalServiceRevenue: json['monthlyExternalServiceRevenue'] as int,
    activeUserMonthly: json['activeUserMonthly'] as int,
    today: json['day'] == null
        ? null
        : Today.fromJson(json['day'] as Map<String, dynamic>),
    monthlyGiveback: json['monthlyGiveback'] as int,
  );
}

Map<String, dynamic> _$FinanceToJson(Finance instance) => <String, dynamic>{
      'year': instance.year?.toJson(),
      'week': instance.week?.toJson(),
      'monthlyExternalServiceGiveback': instance.monthlyExternalServiceGiveback,
      'month': instance.month?.toJson(),
      'monthlyExternalServiceRevenue': instance.monthlyExternalServiceRevenue,
      'activeUserMonthly': instance.activeUserMonthly,
      'day': instance.today?.toJson(),
      'monthlyGiveback': instance.monthlyGiveback,
    };
