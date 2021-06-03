// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_orders_list_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationsOrdersListSnippetState _$ReservationsOrdersListSnippetStateFromJson(
    Map<String, dynamic> json) {
  return ReservationsOrdersListSnippetState(
    order: json['order'] == null
        ? null
        : OrderState.fromJson(json['order'] as Map<String, dynamic>),
    orderId: json['orderId'] as String ?? '',
  );
}

Map<String, dynamic> _$ReservationsOrdersListSnippetStateToJson(
        ReservationsOrdersListSnippetState instance) =>
    <String, dynamic>{
      'order': instance.order?.toJson(),
      'orderId': instance.orderId,
    };
