import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ServiceListSnippetRequest {
  String _businessId;

  ServiceListSnippetRequest(this._businessId);

  String get businessId => _businessId;
}

class ServiceListSnippetRequestNavigate {
  String _businessId;

  ServiceListSnippetRequestNavigate(this._businessId);

  String get businessId => _businessId;
}

class ServiceListSnippetRequestResponse {
  ServiceListSnippetState _serviceListSnippetState;

  ServiceListSnippetRequestResponse(this._serviceListSnippetState);

  ServiceListSnippetState get serviceListSnippetState => _serviceListSnippetState;
}


ServiceListSnippetState serviceListSnippetReducer(ServiceListSnippetState state, action) {
  ServiceListSnippetState serviceListSnippetState = new ServiceListSnippetState.fromState(state);

  if (action is ServiceListSnippetRequestResponse) {
    serviceListSnippetState = action.serviceListSnippetState.copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return serviceListSnippetState;
  }
  return state;
}
