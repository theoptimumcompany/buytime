// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderListState _$OrderListStateFromJson(Map<String, dynamic> json) {
  return OrderListState(
    orderListState: (json['orderListState'] as List)
        ?.map((e) =>
            e == null ? null : OrderState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderListStateToJson(OrderListState instance) =>
    <String, dynamic>{
      'orderListState':
          instance.orderListState?.map((e) => e?.toJson())?.toList(),
    };
