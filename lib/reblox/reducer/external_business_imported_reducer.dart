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
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';

class CreateExternalBusinessImported {
  ExternalBusinessImportedState _externalBusinessImportedState;

  CreateExternalBusinessImported(this._externalBusinessImportedState);

  ExternalBusinessImportedState get externalBusinessImportedState => _externalBusinessImportedState;
}

class CancelExternalBusinessImported {
  ExternalBusinessImportedState _externalBusinessImportedState;

  CancelExternalBusinessImported(this._externalBusinessImportedState);

  ExternalBusinessImportedState get externalBusinessImportedState => _externalBusinessImportedState;
}

class CreatedExternalBusinessImported {
  ExternalBusinessImportedState _externalBusinessImportedState;

  CreatedExternalBusinessImported(this._externalBusinessImportedState);

  ExternalBusinessImportedState get externalBusinessImportedState => _externalBusinessImportedState;
}

class CanceledExternalBusinessImported {
  ExternalBusinessImportedState _externalBusinessImportedState;

  CanceledExternalBusinessImported(this._externalBusinessImportedState);

  ExternalBusinessImportedState get externalBusinessImportedState => _externalBusinessImportedState;
}

class ExternalBusinessImportedRequest {
  String _businessId;

  ExternalBusinessImportedRequest(this._businessId);

  String get businessId => _businessId;
}

class ExternalBusinessImportedRequestNavigate {
  String _businessId;

  ExternalBusinessImportedRequestNavigate(this._businessId);

  String get businessId => _businessId;
}

class ExternalBusinessImportedRequestResponse {
  ExternalBusinessImportedState _externalBusinessImportedState;

  ExternalBusinessImportedRequestResponse(this._externalBusinessImportedState);

  ExternalBusinessImportedState get externalBusinessImportedState => _externalBusinessImportedState;
}


ExternalBusinessImportedState externalBusinessImportedReducer(ExternalBusinessImportedState state, action) {
  ExternalBusinessImportedState externalBusinessImportedState = new ExternalBusinessImportedState.fromState(state);
  if (action is CreateExternalBusinessImported) {
    externalBusinessImportedState = action.externalBusinessImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer: ${externalBusinessImportedState.internalBusinessId}');
    return externalBusinessImportedState;
  }

  if (action is CreatedExternalBusinessImported) {
    externalBusinessImportedState = action.externalBusinessImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer: ${externalBusinessImportedState.internalBusinessId}');
    return externalBusinessImportedState;
  }
  if (action is CanceledExternalBusinessImported) {
    externalBusinessImportedState = action.externalBusinessImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer: ${externalBusinessImportedState.internalBusinessId}');
    return externalBusinessImportedState;
  }
  if (action is ExternalBusinessImportedRequestResponse) {
    externalBusinessImportedState = action.externalBusinessImportedState.copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return externalBusinessImportedState;
  }
  return state;
}
