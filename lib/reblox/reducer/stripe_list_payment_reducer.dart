/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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