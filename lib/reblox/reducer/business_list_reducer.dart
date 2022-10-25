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
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:flutter/cupertino.dart';

class BusinessListRequest {
  String _userId;
  Role _role;
  int _limit;
  BusinessListRequest(this._userId, this._role, this._limit);
  String get userId => _userId;
  Role get role => _role;
  int get limit => _limit;
}

class BusinessServiceSnippetListRequest {
  String _businessId;
  BusinessServiceSnippetListRequest(this._businessId);
  String get businessId => _businessId;
}

class BusinessServiceSnippetListReturned {
  List<ServiceSnippetState> _businessServiceSnippetList;
  BusinessServiceSnippetListReturned(this._businessServiceSnippetList);
  List<ServiceSnippetState> get businessServiceSnippetList => _businessServiceSnippetList;
}



class BusinessListReturned {
  List<BusinessState> _businessListState;
  BusinessListReturned(this._businessListState);
  List<BusinessState> get businessListState => _businessListState;
}

class SetBusinessListToEmpty {
  String _something;
  SetBusinessListToEmpty();
  String get something => _something;
}

BusinessListState businessListReducer(BusinessListState state, action) {
  BusinessListState businessListState = new BusinessListState.fromState(state);
  if (action is SetBusinessListToEmpty) {
    businessListState = BusinessListState().toEmpty();
    return businessListState;
  }
  if (action is BusinessListReturned) {
    businessListState = BusinessListState(businessListState: action.businessListState).copyWith();
    debugPrint("business_list_reducer => Nel reducer business List");
    return businessListState;
  }
  return state;
}