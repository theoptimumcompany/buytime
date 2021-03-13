import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stripe_state.g.dart';

@JsonSerializable(explicitToJson: true)
class StripeState {
  List<Map<String, dynamic>> paymentMethodList;
  var date;
  var position;
  double total = 0.0;
  StripeCardResponse stripeCard;
  String URL = "";
  String error = "";

  StripeState({
    this.paymentMethodList,
    this.position,
    this.date,
    this.total,
    this.stripeCard,
    this.URL,
    this.error,
  });

  StripeState.fromState(StripeState state) {
    this.paymentMethodList = state.paymentMethodList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.stripeCard = state.stripeCard;
    this.URL = state.URL;
    this.error = state.error;
  }

  StripeState copyWith({
    List<Map<String, dynamic>> paymentMethodList,
    var date,
    var position,
    double total,
    StripeCardResponse stripeCard,
    String URL,
    String error,
  }) {
    return StripeState(
      paymentMethodList: paymentMethodList ?? this.paymentMethodList,
      date: date ?? this.date,
      position: position ?? this.position,
      total: total ?? this.total,
      stripeCard: stripeCard ?? this.stripeCard,
      URL: URL ?? this.URL,
      error: error ?? this.error,
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
    );
  }

  factory StripeState.fromJson(Map<String, dynamic> json) => _$StripeStateFromJson(json);
  Map<String, dynamic> toJson() => _$StripeStateToJson(this);
}