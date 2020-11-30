class StripeCardResponse {
  String firestore_id;
  String last4;
  int expMonth;
  int expYear;
  String secretToken;
  String brand;

  StripeCardResponse({this.firestore_id, this.last4, this.expYear, this.expMonth, this.secretToken, this.brand});
}