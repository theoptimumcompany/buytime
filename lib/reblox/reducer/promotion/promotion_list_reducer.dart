import 'package:Buytime/reblox/model/promotion/promotion_list_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';

class PromotionListRequest {
  PromotionListRequest();
}

class PromotionListReturned {
  List<PromotionState> _promotionListState;

  PromotionListReturned(this._promotionListState);

  List<PromotionState> get promotionListState => _promotionListState;
}

class SetPromotionListToEmpty {
  SetPromotionListToEmpty();
}

class SetPromotionList {
  List<PromotionState> _promotionListState;

  SetPromotionList(this._promotionListState);

  List<PromotionState> get promotionListState => _promotionListState;
}

PromotionListState promotionListReducer(PromotionListState state, action) {
  PromotionListState promotionListState = PromotionListState.fromState(state);
  if (action is SetPromotionListToEmpty) {
    promotionListState = PromotionListState().toEmpty();
    return promotionListState;
  }

  if (action is SetPromotionList) {
    promotionListState = PromotionListState(promotionListState: action.promotionListState).copyWith();
    return promotionListState;
  }
  if (action is PromotionListReturned) {
    promotionListState = PromotionListState(promotionListState: action.promotionListState).copyWith();
    return promotionListState;
  }
  return state;
}
