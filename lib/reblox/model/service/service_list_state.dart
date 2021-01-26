import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/foundation.dart';

class ServiceListState {
  List<ServiceState> serviceListState;

  ServiceListState({
    @required this.serviceListState,
  });

  ServiceListState.fromState(ServiceListState state) {
    this.serviceListState = state.serviceListState;
  }

  ServiceListState copyWith({serviceListState}) {
    return ServiceListState(
        serviceListState: serviceListState ?? this.serviceListState);
  }

  ServiceListState toEmpty() {
    return ServiceListState(serviceListState: List<ServiceState>());
  }

  ServiceListState.fromJson(Map json)
      : serviceListState = json['serviceListState'];

  Map<String, dynamic> toJson() => {'serviceListState': serviceListState};
}
