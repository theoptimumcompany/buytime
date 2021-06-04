import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservations_orders_list_snippet_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ReservationsOrdersListSnippetListState {
  @JsonKey(name: 'orderList')
  List<ReservationsOrdersListSnippetState> reservationsOrdersListSnippetListState;

  ReservationsOrdersListSnippetListState({
    @required this.reservationsOrdersListSnippetListState,
  });

  ReservationsOrdersListSnippetListState.fromState(ReservationsOrdersListSnippetListState state) {
    this.reservationsOrdersListSnippetListState = state.reservationsOrdersListSnippetListState ;
  }

  ReservationsOrdersListSnippetListState copyWith({reservationsOrdersListSnippetListState}) {
    return ReservationsOrdersListSnippetListState(
        reservationsOrdersListSnippetListState: reservationsOrdersListSnippetListState ?? this.reservationsOrdersListSnippetListState
    );
  }

  ReservationsOrdersListSnippetListState toEmpty() {
    return ReservationsOrdersListSnippetListState(reservationsOrdersListSnippetListState: []);
  }

  factory ReservationsOrdersListSnippetListState.fromJson(Map<String, dynamic> json) => _$ReservationsOrdersListSnippetListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationsOrdersListSnippetListStateToJson(this);
}