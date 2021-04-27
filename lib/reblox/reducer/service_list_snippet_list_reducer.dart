import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_list_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ServiceListSnippetListRequest {
  List<dynamic> _businessesId;

  ServiceListSnippetListRequest(this._businessesId);

  List<dynamic> get businessesId => _businessesId;
}

class ServiceListSnippetListRequestNavigate {
  List<dynamic> _businessesId;

  ServiceListSnippetListRequestNavigate(this._businessesId);

  List<dynamic> get businessesId => _businessesId;
}

class ServiceListSnippetListRequestResponse {
  List<ServiceListSnippetState> _serviceListSnippetList;

  ServiceListSnippetListRequestResponse(this._serviceListSnippetList);

  List<ServiceListSnippetState> get serviceListSnippetList => _serviceListSnippetList;
}


ServiceListSnippetListState serviceListSnippetListReducer(ServiceListSnippetListState state, action) {
  ServiceListSnippetListState serviceListSnippetListState= new ServiceListSnippetListState.fromState(state);

  if (action is ServiceListSnippetListRequestResponse) {
    serviceListSnippetListState = ServiceListSnippetListState(serviceListSnippetListState: action.serviceListSnippetList).copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return serviceListSnippetListState;
  }
  return state;
}
