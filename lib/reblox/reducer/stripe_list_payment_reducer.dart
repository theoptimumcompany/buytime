import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_list_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:flutter/material.dart';

class StripeListCardListRequest {
  String _firebaseUserId;
  StripeListCardListRequest(this._firebaseUserId);
  String get firebaseUserId => _firebaseUserId;
}

class StripeListCardListResult {
  List<StripeState> _stripeCardResponse;
  StripeListCardListResult(this._stripeCardResponse);
  List<StripeState> get stripeCardResponse => _stripeCardResponse;
}


StripeListState stripeListPaymentReducer(StripeListState state, action) {
  StripeListState stripeListState = new StripeListState.fromState(state);


  if (action is StripeListCardListResult) {
    stripeListState = StripeListState(stripeListState: action.stripeCardResponse).copyWith();
    debugPrint('stripe__list_payment_reducer => LENGTH: ${stripeListState.stripeListState.length}');
    return stripeListState;
  }


  return stripeListState;
}