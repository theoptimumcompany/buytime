import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stripe_state.g.dart';

enum PaymentType {
  card,
  native,
  room,
  applePay,
  googlePay,
  onSite,
  noPaymentMethod
}


@JsonSerializable(explicitToJson: true)
class StripeState {
  List<Map<String, dynamic>> paymentMethodList;
  var date;
  var position;
  double total = 0.0;
  StripeCardResponse stripeCard;
  String URL = "";
  String error = "";
  @JsonKey(ignore: true)
  bool stripeCustomerCreated = false;
  @JsonKey(ignore: true)
  String chosenPaymentMethod = Utils.enumToString(PaymentType.noPaymentMethod);


  StripeState({
    this.paymentMethodList,
    this.position,
    this.date,
    this.total,
    this.stripeCard,
    this.URL,
    this.error,
    this.chosenPaymentMethod = "noPaymentMethod",
    this.stripeCustomerCreated = false,
  });

  StripeState.fromState(StripeState state) {
    this.paymentMethodList = state.paymentMethodList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.stripeCard = state.stripeCard;
    this.URL = state.URL;
    this.error = state.error;
    this.chosenPaymentMethod = state.chosenPaymentMethod;
    this.stripeCustomerCreated = state.stripeCustomerCreated;
  }

  StripeState copyWith({
    List<Map<String, dynamic>> paymentMethodList,
    var date,
    var position,
    double total,
    StripeCardResponse stripeCard,
    String URL,
    String error,
    String chosenPaymentMethod,
    String stripeCustomerCreated,
  }) {
    return StripeState(
      paymentMethodList: paymentMethodList ?? this.paymentMethodList,
      date: date ?? this.date,
      position: position ?? this.position,
      total: total ?? this.total,
      stripeCard: stripeCard ?? this.stripeCard,
      URL: URL ?? this.URL,
      error: error ?? this.error,
      chosenPaymentMethod: chosenPaymentMethod ?? this.chosenPaymentMethod,
      stripeCustomerCreated: stripeCustomerCreated ?? this.stripeCustomerCreated,
    );
  }

  StripeState toEmpty() {
    return StripeState(
      position: "",
      date: "",
      paymentMethodList: null,
      total: 0.0,
      stripeCard: StripeCardResponse(),
      URL: "",
      error: "",
      chosenPaymentMethod: "noPaymentMethod",
      stripeCustomerCreated: false,
    );
  }

  factory StripeState.fromJson(Map<String, dynamic> json) => _$StripeStateFromJson(json);
  Map<String, dynamic> toJson() => _$StripeStateToJson(this);
}