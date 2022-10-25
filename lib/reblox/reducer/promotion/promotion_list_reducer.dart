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
