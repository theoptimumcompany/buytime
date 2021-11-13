// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeState _$StripeStateFromJson(Map<String, dynamic> json) {
  return StripeState(
    paymentMethodList: (json['paymentMethodList'] as List)
        ?.map((e) => e as Map<String, dynamic>)
        ?.toList(),
    position: json['position'],
    date: json['date'],
    total: (json['total'] as num)?.toDouble(),
    stripeCard: json['stripeCard'] == null
        ? null
        : StripeCardResponse.fromJson(
            json['stripeCard'] as Map<String, dynamic>),
    URL: json['URL'] as String,
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$StripeStateToJson(StripeState instance) =>
    <String, dynamic>{
      'paymentMethodList': instance.paymentMethodList,
      'date': instance.date,
      'position': instance.position,
      'total': instance.total,
      'stripeCard': instance.stripeCard?.toJson(),
      'URL': instance.URL,
      'error': instance.error,
    };
