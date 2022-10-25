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

import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/cupertino.dart';


class OrderListRequest {
  String _userId;

  OrderListRequest(_userId);

  String get userId => _userId;
}
class UserOrderListRequest{
  UserOrderListRequest();
}

class OrderListReturned {
  List<OrderState> _orderListState;

  OrderListReturned(this._orderListState);

  List<OrderState> get orderListState => _orderListState;
}

class SetOrderListToEmpty {
  String _something;
  SetOrderListToEmpty();
  String get something => _something;
}

OrderListState orderListReducer(OrderListState state, action) {
  OrderListState orderListState = new OrderListState.fromState(state);
  if (action is SetOrderListToEmpty) {
    orderListState = OrderListState().toEmpty();
    return orderListState;
  }
  if (action is OrderListReturned) {
    orderListState = OrderListState(orderListState: action.orderListState).copyWith();
    debugPrint("Nel Reducer dell'OrderListState ");
    return orderListState;
  }
  return state;
}
