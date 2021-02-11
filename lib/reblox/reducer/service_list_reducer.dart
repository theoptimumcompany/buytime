import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';

class ServiceListRequest {
  String _businessId;
  String _permission;

  ServiceListRequest(this._businessId, this._permission);

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
