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

import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:flutter/cupertino.dart';

class PromotionRequest {
  PromotionState _promotionState;

  PromotionRequest(this._promotionState);

  PromotionState get promotionState => _promotionState;
}

class SetPromotion {
  PromotionState _promotionState;

  SetPromotion(this._promotionState);

  PromotionState get promotionState => _promotionState;
}

class SetPromotionToEmpty {
  SetPromotionToEmpty();
}

class PromotionRequestResponse {
  PromotionState _promotionState;

  PromotionRequestResponse(this._promotionState);

  PromotionState get promotionState => _promotionState;
}

PromotionState promotionReducer(PromotionState state, action) {
  PromotionState promotionState = PromotionState.fromState(state);

  if (action is PromotionRequestResponse) {
    debugPrint("promotion_reducer => copyWith");
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }
  if (action is SetPromotionToEmpty) {
    debugPrint("promotion_reducer => toEmpty");
    promotionState = PromotionState().toEmpty();
    return promotionState;
  }
  if (action is SetPromotion) {
    debugPrint("promotion_reducer => set promotion " +  action.promotionState.timesUsed.toString());
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }
  return state;
}

