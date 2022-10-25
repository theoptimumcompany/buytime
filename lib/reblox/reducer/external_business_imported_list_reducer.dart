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
import 'package:Buytime/reblox/model/business/external_business_imported_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';


class ExternalBusinessImportedListRequest {
  String _businessId;

  ExternalBusinessImportedListRequest(this._businessId);

  String get businessId => _businessId;
}

class ExternalBusinessImportedListRequestNavigate {
  String _businessId;

  ExternalBusinessImportedListRequestNavigate(this._businessId);

  String get businessId => _businessId;
}

class ExternalBusinessImportedListRequestResponse {
  List<ExternalBusinessImportedState> _externalBusinessImportedList;

  ExternalBusinessImportedListRequestResponse(this._externalBusinessImportedList);

  List<ExternalBusinessImportedState> get externalBusinessImportedList => _externalBusinessImportedList;
}


ExternalBusinessImportedListState externalBusinessImportedListReducer(ExternalBusinessImportedListState state, action) {
  ExternalBusinessImportedListState externalBusinessImportedListState = new ExternalBusinessImportedListState.fromState(state);

  if (action is ExternalBusinessImportedListRequestResponse) {
    externalBusinessImportedListState = ExternalBusinessImportedListState(externalBusinessImported: action.externalBusinessImportedList).copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return externalBusinessImportedListState;
  }
  return state;
}
