// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_reservable_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderReservableListState _$OrderReservableListStateFromJson(
    Map<String, dynamic> json) {
  return OrderReservableListState(
    orderReservableListState: (json['orderReservableListState'] as List)
        ?.map((e) => e == null
            ? null
            : OrderReservableState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrderReservableListStateToJson(
        OrderReservableListState instance) =>
    <String, dynamic>{
      'orderReservableListState':
          instance.orderReservableListState?.map((e) => e?.toJson())?.toList(),
    };
