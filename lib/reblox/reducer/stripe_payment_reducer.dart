import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:flutter/material.dart';

class SetStripeState {
  StripeState _stripeState;
  SetStripeState(this._stripeState);
  StripeState get stripeState => _stripeState;
}

class StripeCardListRequest {
  String _firebaseUserId;
  StripeCardListRequest(this._firebaseUserId);
  String get firebaseUserId => _firebaseUserId;
}

class StripeCardListResult {
  StripeCardResponse _stripeCardResponse;
  StripeCardListResult(this._stripeCardResponse);
  StripeCardResponse get stripeCardResponse => _stripeCardResponse;
}

class AddStripePaymentMethod
{
  Map<String, dynamic> _stripePaymentMethod;
  String _userId;
  AddStripePaymentMethod(this._stripePaymentMethod, this._userId);
  Map<String, dynamic> get stripePaymentMethod => _stripePaymentMethod;
  String get userId => _userId;
}
class CreateDisposePaymentMethodIntent
{
  StripeCardResponse _stripePaymentMethodResponse;
  String _userId;
  CreateDisposePaymentMethodIntent(this._stripePaymentMethodResponse, this._userId);
  StripeCardResponse get stripePaymentMethodResponse => _stripePaymentMethodResponse;
  String get userId => _userId;
}
class DisposedPaymentMethodIntent
{
  DisposedPaymentMethodIntent();
}
class ErrorDisposePaymentMethodIntent
{
  String _error;
  ErrorDisposePaymentMethodIntent(this._error);
  String get error => _error;
}
class RequestStripeIntentSecret
{
  String _userId;
  Map<String, dynamic> _paymentMethod;
  RequestStripeIntentSecret(this._paymentMethod, this._userId);
  Map<String, dynamic> get paymentMethod => _paymentMethod;
  String get userId => _userId;
}

class ConfirmedStripeIntent
{
  Map<String, dynamic> _paymentMethod;
  ConfirmedStripeIntent(this._paymentMethod);
  Map<String, dynamic> get paymentMethod => _paymentMethod;
}

class AddedPaymentMethodToConfirm
{
  Map<String, dynamic> _paymentMethod;
  AddedPaymentMethodToConfirm(this._paymentMethod);
  Map<String, dynamic> get paymentMethod => _paymentMethod;
}

class SetStripeToEmpty {
  String _something;
  SetStripeToEmpty();
  String get something => _something;
}

StripeState stripePaymentReducer(StripeState state, action) {
  StripeState stripeState = new StripeState.fromState(state);
  if (action is SetStripeToEmpty) {
    stripeState = StripeState().toEmpty();
    return stripeState;
  }
  if (action is ConfirmedStripeIntent) {
    // TODO: set the stripe card locally
    return stripeState;
  }
  if (action is SetStripeState) {
    stripeState = action.stripeState.copyWith();
    return stripeState;
  }

  if (action is StripeCardListResult) {
    stripeState.stripeCard = action.stripeCardResponse;
    stripeState.copyWith();
    debugPrint('stripe_payment_reducer => CARD BRANC: ${stripeState.stripeCard.brand}');
    return stripeState;
  }

  if (action is DisposedPaymentMethodIntent) {
    stripeState.stripeCard = null;
    stripeState.error = 'none';
    return stripeState.copyWith();
  }
  if (action is ErrorDisposePaymentMethodIntent) {
    stripeState.error = 'error';
    return stripeState.copyWith();
  }

  return stripeState;
}