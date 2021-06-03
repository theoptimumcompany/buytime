import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ReservationAndOrdersListSnippetRequest {
  String _businessId;

  ReservationAndOrdersListSnippetRequest(this._businessId);

  String get businessId => _businessId;
}

class ReservationAndOrdersListSnippetRequestResponse {
  ReservationsOrdersListSnippetState _reservationsOrdersListSnippetState;

  ReservationAndOrdersListSnippetRequestResponse(this._reservationsOrdersListSnippetState);

  ReservationsOrdersListSnippetState get reservationsOrdersListSnippetState => _reservationsOrdersListSnippetState;
}


ReservationsOrdersListSnippetState reservationsOrdersListSnippetReducer(ReservationsOrdersListSnippetState state, action) {
  ReservationsOrdersListSnippetState reservationsOrdersListSnippetState = ReservationsOrdersListSnippetState.fromState(state);

  if (action is ReservationAndOrdersListSnippetRequestResponse) {
    reservationsOrdersListSnippetState = action.reservationsOrdersListSnippetState.copyWith();
    return reservationsOrdersListSnippetState;
  }
  return state;
}
