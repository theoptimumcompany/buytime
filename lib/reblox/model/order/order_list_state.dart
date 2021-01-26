import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/foundation.dart';

class OrderListState {
  List<OrderState> orderListState;

  OrderListState({
    @required this.orderListState,
  });

  OrderListState.fromState(OrderListState state) {
    this.orderListState = state.orderListState;
  }

  OrderListState copyWith({orderListState}) {
    return OrderListState(orderListState: orderListState ?? this.orderListState);
  }

  OrderListState toEmpty() {
    return OrderListState(orderListState: List<OrderState>());
  }

  OrderListState.fromJson(Map json) : orderListState = json['orderListState'];

  Map<String, dynamic> toJson() => {'orderListState': orderListState};
}
