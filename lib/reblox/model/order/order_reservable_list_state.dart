import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_reservable_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderReservableListState {
  List<OrderReservableState> orderReservableListState;

  OrderReservableListState({
    @required this.orderReservableListState,
  });

  OrderReservableListState.fromState(OrderReservableListState state) {
    this.orderReservableListState = state.orderReservableListState;
  }

  OrderReservableListState copyWith({orderReservableListState}) {
    return OrderReservableListState(orderReservableListState: orderReservableListState ?? this.orderReservableListState);
  }

  OrderReservableListState toEmpty() {
    return OrderReservableListState(orderReservableListState: []);
  }

  factory OrderReservableListState.fromJson(Map<String, dynamic> json) => _$OrderReservableListStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderReservableListStateToJson(this);
}
