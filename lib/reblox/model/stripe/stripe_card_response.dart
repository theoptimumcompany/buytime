import 'package:json_annotation/json_annotation.dart';
part 'stripe_card_response.g.dart';

@JsonSerializable(explicitToJson: true)
class StripeCardResponse {
  String firestore_id;
  String last4;
  int expMonth;
  int expYear;
  String secretToken;
  String brand;
  String paymentMethodId;

  StripeCardResponse({this.firestore_id, this.last4, this.expYear, this.expMonth, this.secretToken, this.brand, this.paymentMethodId});

  factory StripeCardResponse.fromJson(Map<String, dynamic> json) => _$StripeCardResponseFromJson(json);
  Map<String, dynamic> toJson() => _$StripeCardResponseToJson(this);
}