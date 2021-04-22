import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ExternalServiceImportedListRequest {
  String _businessId;

  ExternalServiceImportedListRequest(this._businessId);

  String get businessId => _businessId;
}

class ExternalServiceImportedListRequestNavigate {
  String _businessId;

  ExternalServiceImportedListRequestNavigate(this._businessId);

  String get businessId => _businessId;
}

class ExternalServiceImportedListRequestResponse {
  List<ExternalServiceImportedState> _externalServiceImportedList;

  ExternalServiceImportedListRequestResponse(this._externalServiceImportedList);

  List<ExternalServiceImportedState> get externalServiceImportedList => _externalServiceImportedList;
}


ExternalServiceImportedListState externalServiceImportedListReducer(ExternalServiceImportedListState state, action) {
  ExternalServiceImportedListState externalServiceImportedListState = new ExternalServiceImportedListState.fromState(state);

  if (action is ExternalServiceImportedListRequestResponse) {
    externalServiceImportedListState = ExternalServiceImportedListState(externalServiceImported: action.externalServiceImportedList).copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return externalServiceImportedListState;
  }
  return state;
}
