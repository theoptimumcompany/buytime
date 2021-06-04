import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ReservationAndOrdersListSnippetListRequest {
  String _bookingId;

  ReservationAndOrdersListSnippetListRequest(this._bookingId);

  String get bookingId => _bookingId;
}


class ReservationsAndOrdersListSnippetListRequestResponse {
  List<ReservationsOrdersListSnippetState> _reservationsOrdersListSnippetList;

  ReservationsAndOrdersListSnippetListRequestResponse(this._reservationsOrdersListSnippetList);

  List<ReservationsOrdersListSnippetState> get reservationsOrdersListSnippetList => _reservationsOrdersListSnippetList;
}


ReservationsOrdersListSnippetListState reservationsOrdersListSnippetListReducer(ReservationsOrdersListSnippetListState state, action) {
  ReservationsOrdersListSnippetListState reservationsOrdersListSnippetListState= ReservationsOrdersListSnippetListState.fromState(state);

  if (action is ReservationsAndOrdersListSnippetListRequestResponse) {
    reservationsOrdersListSnippetListState = ReservationsOrdersListSnippetListState(reservationsOrdersListSnippetListState: action.reservationsOrdersListSnippetList).copyWith();
    return reservationsOrdersListSnippetListState;
  }
  return state;
}
