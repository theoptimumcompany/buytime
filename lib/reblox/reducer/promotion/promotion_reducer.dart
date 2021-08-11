import 'package:Buytime/reblox/model/promotion/promotion_state.dart';

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
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }
  if (action is SetPromotionToEmpty) {
    promotionState = PromotionState().toEmpty();
    return promotionState;
  }
  if (action is SetPromotion) {
    print("promotion_reducer: set promotion");
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }

  return state;
}
