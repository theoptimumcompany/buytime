import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
// import 'package:stripe_sdk/stripe_sdk_ui.dart' as StripeUnofficialUI;
import 'package:flutter_stripe/flutter_stripe.dart' as StripeOfficial;




class SetStripeState {
  StripeState _stripeState;
  SetStripeState(this._stripeState);
  StripeState get stripeState => _stripeState;
}

///  Checks if the Stripe customer has been created in the backend for the user
///  triggers the corresponding epic
///  return null
class CheckStripeCustomer {
  bool _updateCardList;
  CheckStripeCustomer(this._updateCardList);
  bool get updateCardList => _updateCardList;
}

class CheckedStripeCustomer {
  bool _stripeCustomerCreated;
  CheckedStripeCustomer(this._stripeCustomerCreated);
  bool get stripeCustomerCreated => _stripeCustomerCreated;
}

class AddStripePaymentMethod
{
  StripeOfficial.Card _stripeCard;
  String _paymentMethodId;
  String _userId;
  AddStripePaymentMethod(this._stripeCard, this._userId, this._paymentMethodId);
  StripeOfficial.Card get stripeCard => _stripeCard;
  String get userId => _userId;
  String get paymentMethodId => _paymentMethodId;
}

class ChoosePaymentMethod
{
  String _chosenPaymentMethod;
  ChoosePaymentMethod(this._chosenPaymentMethod);
  String get chosenPaymentMethod => _chosenPaymentMethod;
}

class ResetPaymentMethod{}


class CreateDisposePaymentMethodIntent
{
  String _firestoreCardId;
  String _userId;
  CreateDisposePaymentMethodIntent(this._firestoreCardId, this._userId);
  String get firestoreCardId => _firestoreCardId;
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

  // if (action is StripeCardListResult) {
  //   stripeState.stripeCard = action.stripeCardResponse;
  //   stripeState.copyWith();
  //   debugPrint('stripe_payment_reducer => CARD BRANC: ${stripeState.stripeCard.brand}');
  //   return stripeState;
  // }

  if (action is DisposedPaymentMethodIntent) {
    stripeState.stripeCard = null;
    stripeState.error = 'none';
    return stripeState.copyWith();
  }
  if (action is ErrorDisposePaymentMethodIntent) {
    stripeState.error = 'error';
    return stripeState.copyWith();
  }
  if (action is CheckedStripeCustomer) {
    stripeState.stripeCustomerCreated = action.stripeCustomerCreated;
    return stripeState.copyWith();
  }
  if (action is ChoosePaymentMethod) {
    stripeState.chosenPaymentMethod = Utils.enumToString(action.chosenPaymentMethod);
    return stripeState.copyWith();
  }
  if (action is ResetPaymentMethod) {
    stripeState.chosenPaymentMethod = Utils.enumToString(PaymentType.noPaymentMethod);
    return stripeState.copyWith();
  }

  return stripeState;
}