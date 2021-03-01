import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:flutter/foundation.dart';


class StripeListState {
  List<StripeState> stripeListState;

  StripeListState({
    @required this.stripeListState,
  });

  StripeListState.fromState(StripeListState state) {
    this.stripeListState = state.stripeListState ;
  }

  companyStateFieldUpdate(List<StripeState> stripeListState) {
    StripeListState(
        stripeListState: stripeListState ?? this.stripeListState
    );
  }

  StripeListState copyWith({stripeListState}) {
    return StripeListState(
        stripeListState: stripeListState ?? this.stripeListState
    );
  }

  StripeListState.fromJson(Map json)
      : stripeListState = json['cardListState'];

  Map<String, dynamic> toJson() => {
    'cardListState': stripeListState
  };

  StripeListState toEmpty() {
    return StripeListState(stripeListState: []);
  }

}