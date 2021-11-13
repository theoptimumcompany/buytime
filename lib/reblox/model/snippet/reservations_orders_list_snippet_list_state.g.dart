// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservations_orders_list_snippet_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationsOrdersListSnippetListState
    _$ReservationsOrdersListSnippetListStateFromJson(
        Map<String, dynamic> json) {
  return ReservationsOrdersListSnippetListState(
    reservationsOrdersListSnippetListState: (json['orderList'] as List)
        ?.map((e) => e == null
            ? null
            : ReservationsOrdersListSnippetState.fromJson(
                e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReservationsOrdersListSnippetListStateToJson(
        ReservationsOrdersListSnippetListState instance) =>
    <String, dynamic>{
      'orderList': instance.reservationsOrdersListSnippetListState
          ?.map((e) => e?.toJson())
          ?.toList(),
    };
