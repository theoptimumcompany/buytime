/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
