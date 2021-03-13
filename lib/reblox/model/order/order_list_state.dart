import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory OrderListState.fromJson(Map<String, dynamic> json) => _$OrderListStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderListStateToJson(this);
}
