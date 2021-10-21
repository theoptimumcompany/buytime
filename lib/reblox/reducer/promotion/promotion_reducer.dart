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

