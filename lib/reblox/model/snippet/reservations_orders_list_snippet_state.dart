import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservations_orders_list_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ReservationsOrdersListSnippetState {
  OrderState order;
  @JsonKey(defaultValue: '')
  String orderId;

  ReservationsOrdersListSnippetState({
    this.order,
    this.orderId,
  });

  ReservationsOrdersListSnippetState.fromState(ReservationsOrdersListSnippetState reservationsOrdersListSnippetState) {
    this.order = reservationsOrdersListSnippetState.order;
    this.orderId = reservationsOrdersListSnippetState.orderId;
  }

  ReservationsOrdersListSnippetState copyWith({
    OrderState order,
    String orderId,
  }) {
    return ReservationsOrdersListSnippetState(
      order: order ?? this.order,
      orderId: orderId ?? this.orderId,
    );
  }

  factory ReservationsOrdersListSnippetState.fromJson(Map<String, dynamic> json) => _$ReservationsOrdersListSnippetStateFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationsOrdersListSnippetStateToJson(this);

  ReservationsOrdersListSnippetState toEmpty() {
    return ReservationsOrdersListSnippetState(
      order: OrderState().toEmpty(),
      orderId: '',
    );
  }
}