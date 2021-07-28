import 'package:Buytime/reblox/model/stripe/stripe_state.dart';

class StripeCardListRequest {
  String _firebaseUserId;
  StripeCardListRequest(this._firebaseUserId);
  String get firebaseUserId => _firebaseUserId;
}

class StripeCardListRequestAndNavigate {
  String _firebaseUserId;
  StripeCardListRequestAndNavigate(this._firebaseUserId);
  String get firebaseUserId => _firebaseUserId;
}

class StripeCardListRequestAndPop{
  String _firebaseUserId;
  StripeCardListRequestAndPop(this._firebaseUserId);
  String get firebaseUserId => _firebaseUserId;
}

class StripeCardListResult {
  List<StripeState> _stripeCardResponse;
  StripeCardListResult(this._stripeCardResponse);
  List<StripeState> get stripeCardResponse => _stripeCardResponse;
}