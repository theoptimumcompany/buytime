import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';

class ServiceListRequest {
  String _businessId;
  String _permission;

  ServiceListRequest(this._businessId, this._permission);

  String get businessId => _businessId;

  String get permission => _permission;
}

class ServiceListAndNavigateRequest {
  String _businessId;
  String _permission;

  ServiceListAndNavigateRequest(this._businessId, this._permission);

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
    return serviceListState;
  }
  return state;
}
