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
class IncreasePromotionCounter {
  int _amountOfItems;
  IncreasePromotionCounter(this._amountOfItems);
  int get amountOfItems => _amountOfItems;
}

class DecreasePromotionCounter {
  int _amountOfItems;
  DecreasePromotionCounter(this._amountOfItems);
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
    print("promotion_reducer: copyWith");
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }
  if (action is SetPromotionToEmpty) {
    print("promotion_reducer: toEmpty");
    promotionState = PromotionState().toEmpty();
    return promotionState;
  }
  if (action is SetPromotion) {
    print("promotion_reducer: set promotion " +  action.promotionState.timesUsed.toString());
    promotionState = action.promotionState.copyWith();
    return promotionState;
  }
  if (action is DecreasePromotionCounter) {

    promotionState.timesUsed -= action.amountOfItems;
    if (promotionState.timesUsed < 0) {
      promotionState.timesUsed = 0;
    }
    print("promotion_reducer: decrease " + promotionState.timesUsed.toString());
    return promotionState;
  }
  if (action is IncreasePromotionCounter) {
    print("promotion_reducer: pre increase " + promotionState.timesUsed.toString());
    promotionState.timesUsed = promotionState.timesUsed + 1;
    if (promotionState.timesUsed > promotionState.limit) {
      promotionState.timesUsed = promotionState.limit;
    }
    print("promotion_reducer: increase " + promotionState.timesUsed.toString());
    return promotionState;
  }
  return state;
}

