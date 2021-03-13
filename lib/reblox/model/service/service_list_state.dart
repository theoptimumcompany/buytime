import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'service_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory ServiceListState.fromJson(Map<String, dynamic> json) => _$ServiceListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceListStateToJson(this);
}
