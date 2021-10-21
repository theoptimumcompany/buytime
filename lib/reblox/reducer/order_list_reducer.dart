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
