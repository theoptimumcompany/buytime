// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeCardResponse _$StripeCardResponseFromJson(Map<String, dynamic> json) {
  return StripeCardResponse(
    firestore_id: json['firestore_id'] as String,
    last4: json['last4'] as String,
    expYear: json['expYear'] as int,
    expMonth: json['expMonth'] as int,
    secretToken: json['secretToken'] as String,
    brand: json['brand'] as String,
  );
}

Map<String, dynamic> _$StripeCardResponseToJson(StripeCardResponse instance) =>
    <String, dynamic>{
      'firestore_id': instance.firestore_id,
      'last4': instance.last4,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'secretToken': instance.secretToken,
      'brand': instance.brand,
    };
