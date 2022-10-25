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
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/material.dart';

class CreateExternalServiceImported {
  ExternalServiceImportedState _externalServiceImportedState;

  CreateExternalServiceImported(this._externalServiceImportedState);

  ExternalServiceImportedState get externalServiceImportedState => _externalServiceImportedState;
}
class CancelExternalServiceImported {
  ExternalServiceImportedState _externalServiceImportedState;

  CancelExternalServiceImported(this._externalServiceImportedState);

  ExternalServiceImportedState get externalServiceImportedState => _externalServiceImportedState;
}

class CreatedExternalServiceImported {
  ExternalServiceImportedState _externalServiceImportedState;

  CreatedExternalServiceImported(this._externalServiceImportedState);

  ExternalServiceImportedState get externalServiceImportedState => _externalServiceImportedState;
}

class CanceledExternalServiceImported {
  ExternalServiceImportedState _externalServiceImportedState;

  CanceledExternalServiceImported(this._externalServiceImportedState);

  ExternalServiceImportedState get externalServiceImportedState => _externalServiceImportedState;
}

class ExternalServiceImportedRequest {
  String _businessId;

  ExternalServiceImportedRequest(this._businessId);

  String get businessId => _businessId;
}

class ExternalServiceImportedRequestNavigate {
  String _businessId;

  ExternalServiceImportedRequestNavigate(this._businessId);

  String get businessId => _businessId;
}

class ExternalServiceImportedRequestResponse {
  ExternalServiceImportedState _externalServiceImportedState;

  ExternalServiceImportedRequestResponse(this._externalServiceImportedState);

  ExternalServiceImportedState get externalServiceImportedState => _externalServiceImportedState;
}


ExternalServiceImportedState externalServiceImportedReducer(ExternalServiceImportedState state, action) {
  ExternalServiceImportedState externalServiceImportedState = new ExternalServiceImportedState.fromState(state);

  if (action is CreateExternalServiceImported) {
    externalServiceImportedState = action.externalServiceImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer => ${externalServiceImportedState.internalBusinessId}');
    return externalServiceImportedState;
  }

  if (action is CreatedExternalServiceImported) {
    externalServiceImportedState = action.externalServiceImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer => ${externalServiceImportedState.internalBusinessId}');
    return externalServiceImportedState;
  }
  if (action is CanceledExternalServiceImported) {
    externalServiceImportedState = action.externalServiceImportedState.copyWith();
    debugPrint('external_service_imported_state_reducer => ${externalServiceImportedState.internalBusinessId}');
    return externalServiceImportedState;
  }

  if (action is ExternalServiceImportedRequestResponse) {
    externalServiceImportedState = action.externalServiceImportedState.copyWith();
    //debugPrint('external_service_imported_state_reducer => ${bookingState.user.first.name}');
    return externalServiceImportedState;
  }
  return state;
}
