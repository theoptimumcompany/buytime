import 'package:Buytime/reblox/model/order/order_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_list_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';


class OrderReservableListRequest {
  String _userId;

  OrderReservableListRequest(this._userId);

  String get userId => _userId;
}

class OrderReservableListReturned {
  List<OrderReservableState> _orderReservableListState;

  OrderReservableListReturned(this._orderReservableListState);

  List<OrderReservableState> get orderReservableListState => _orderReservableListState;
}

class SetOrderReservableListToEmpty {
  String _something;
  SetOrderReservableListToEmpty();
  String get something => _something;
}

OrderReservableListState orderReservableListReducer(OrderReservableListState state, action) {
  OrderReservableListState orderReservableListState = new OrderReservableListState.fromState(state);
  if (action is SetOrderReservableListToEmpty) {
    orderReservableListState = OrderReservableListState().toEmpty();
    return orderReservableListState;
  }
  if (action is OrderReservableListReturned) {
    orderReservableListState = OrderReservableListState(orderReservableListState: action.orderReservableListState).copyWith();
    print("Nel Reducer dell'OrderReservableListState ");
    return orderReservableListState;
  }
  return state;
}
