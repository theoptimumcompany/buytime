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


import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:flutter/cupertino.dart';

class ExternalBusinessListRequest {
  String _userId;
  Role _role;
  ExternalBusinessListRequest(this._userId, this._role);
  String get userId => _userId;
  Role get role => _role;
}

class ExternalBusinessListByIdsRequest {
  List<String> _businessIds;
  ExternalBusinessListByIdsRequest(this._businessIds);
  List<String> get businessIds => _businessIds;
}

class ExternalBusinessServiceSnippetListRequest {
  String _businessId;
  ExternalBusinessServiceSnippetListRequest(this._businessId);
  String get businessId => _businessId;
}

class ExternalBusinessServiceSnippetListReturned {
  List<ServiceSnippetState> _businessServiceSnippetList;
  ExternalBusinessServiceSnippetListReturned(this._businessServiceSnippetList);
  List<ServiceSnippetState> get businessServiceSnippetList => _businessServiceSnippetList;
}



class ExternalBusinessListReturned {
  List<ExternalBusinessState> _businessListState;
  ExternalBusinessListReturned(this._businessListState);
  List<ExternalBusinessState> get businessListState => _businessListState;
}

class SetExternalBusinessListToEmpty {
  String _something;
  SetExternalBusinessListToEmpty();
  String get something => _something;
}

ExternalBusinessListState externalBusinessListReducer(ExternalBusinessListState state, action) {
  ExternalBusinessListState externalBusinessListState = new ExternalBusinessListState.fromState(state);
  if (action is SetExternalBusinessListToEmpty) {
    externalBusinessListState = ExternalBusinessListState().toEmpty();
    return externalBusinessListState;
  }
  if (action is ExternalBusinessListReturned) {
    externalBusinessListState = ExternalBusinessListState(externalBusinessListState: action.businessListState).copyWith();
    debugPrint("external_business-list_reducer => Nel reducer business List");
    return externalBusinessListState;
  }
  return state;
}