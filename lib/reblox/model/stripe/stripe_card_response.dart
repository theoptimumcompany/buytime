class StripeCardResponse {
  String firestore_id;
  String last4;
  int expMonth;
  int expYear;
  String secretToken;
  String brand;

  StripeCardResponse({this.firestore_id, this.last4, this.expYear, this.expMonth, this.secretToken, this.brand});

  StripeCardResponse.fromJson(Map<String, dynamic> json)
      : firestore_id = json['firestore_id'],
        last4 = json['last4'],
        expMonth = json['expMonth'],
        expYear = json['expYear'],
        secretToken = json['secretToken'],
        brand = json['brand'];

  Map<String, dynamic> toJson() => {
    'firestore_id': firestore_id,
    'last4': last4,
    'expMonth': expMonth,
    'expYear': expYear,
    'secretToken': secretToken,
    'brand': brand,
  };
}