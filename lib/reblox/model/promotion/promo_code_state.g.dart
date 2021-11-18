// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_code_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromoCodeState _$PromoCodeStateFromJson(Map<String, dynamic> json) {
  return PromoCodeState(
    amount: (json['amount'] as num)?.toDouble() ?? 0,
    oneTime: json['oneTime'] as bool ?? false,
    percentage: (json['percentage'] as num)?.toDouble() ?? 0,
    used: json['used'] as bool ?? false,
  );
}

Map<String, dynamic> _$PromoCodeStateToJson(PromoCodeState instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'oneTime': instance.oneTime,
      'percentage': instance.percentage,
      'used': instance.used,
    };
