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

import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';

class ServiceListRequest {
  String _businessId;
  String _permission;

  ServiceListRequest(this._businessId, this._permission);

  String get businessId => _businessId;

  String get permission => _permission;
}

class ServiceListRequestByIds {
  List<String> _serviceIds;

  ServiceListRequestByIds(this._serviceIds);

  List<String> get serviceIds => _serviceIds;
}

class ServiceListRequestByIdsNavigate {
  List<String> _serviceIds;

  ServiceListRequestByIdsNavigate(this._serviceIds);

  List<String> get serviceIds => _serviceIds;
}
class ServiceListRequestByBusinessIds{
  List<String> _businessIds;

  ServiceListRequestByBusinessIds(this._businessIds);

  List<String> get businessIds => _businessIds;
}

class ServiceListAndNavigateRequest {
  String _businessId;
  String _permission;

  ServiceListAndNavigateRequest(this._businessId, this._permission);

  String get businessId => _businessId;

  String get permission => _permission;
}

class ServiceListAndNavigateOnConfirmRequest {
  String _businessId;
  String _permission;

  ServiceListAndNavigateOnConfirmRequest(this._businessId, this._permission);

  String get businessId => _businessId;

  String get permission => _permission;
}

class ServiceListReturned {
  List<ServiceState> _serviceListState;

  ServiceListReturned(this._serviceListState);

  List<ServiceState> get serviceListState => _serviceListState;
}

class SetServiceListToEmpty {
  String _something;

  SetServiceListToEmpty();

  String get something => _something;
}

class SetServiceListVisibility {
  String _serviceId;
  String _visibility;

  SetServiceListVisibility(this._serviceId, this._visibility);

  String get serviceId => _serviceId;

  String get visibility => _visibility;
}

class SetServiceListVisibilityOnFirebase {
  String _serviceId;
  String _visibility;

  SetServiceListVisibilityOnFirebase(this._serviceId, this._visibility);

  String get serviceId => _serviceId;

  String get visibility => _visibility;
}

class SetServiceList {
  List<ServiceState> _serviceListState;

  SetServiceList(this._serviceListState);

  List<ServiceState> get serviceListState => _serviceListState;
}

ServiceListState serviceListReducer(ServiceListState state, action) {
  ServiceListState serviceListState = new ServiceListState.fromState(state);
  if (action is SetServiceListToEmpty) {
    serviceListState = ServiceListState().toEmpty();
    return serviceListState;
  }
  if (action is SetServiceListVisibility) {
    serviceListState.serviceListState.forEach((element) {
      if (element.serviceId == action.serviceId) {
        element.visibility = action.visibility;
        element.spinnerVisibility = false;
      }
    });
    return serviceListState;
  }
  if (action is SetServiceListVisibilityOnFirebase) {
    serviceListState.serviceListState.forEach((element) {
      if (element.serviceId == action.serviceId) {
        element.spinnerVisibility = true;
      }
    });
    return serviceListState;
  }
  if (action is SetServiceList) {
    serviceListState = ServiceListState(serviceListState: action.serviceListState).copyWith();
    return serviceListState;
  }
  if (action is ServiceListReturned) {
    serviceListState = ServiceListState(serviceListState: action.serviceListState).copyWith();
    print("service_list_reducer return a list length of " + action.serviceListState.length.toString());
    return serviceListState;
  }
  return state;
}
