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
class DecreasePromotionLimit {
  int _amountOfItems;
  DecreasePromotionLimit(this._amountOfItems);
  int get amountOfItems => _amountOfItems;
}

class IncreasePromotionLimit {
  int _amountOfItems;
  IncreasePromotionLimit(this._amountOfItems);
  int get amountOfItems => _amountOfItems;
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
  if (action is DecreasePromotionLimit) {
    promotionState.limit -= action.amountOfItems;
    return promotionState;
  }
  if (action is IncreasePromotionLimit) {
    promotionState.limit += action.amountOfItems;
    return promotionState;
  }
  return state;
}

