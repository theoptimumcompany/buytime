import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_list_snippet_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceListSnippetListState {
  List<ServiceListSnippetState> serviceListSnippetListState;

  ServiceListSnippetListState({
    @required this.serviceListSnippetListState,
  });

  ServiceListSnippetListState.fromState(ServiceListSnippetListState state) {
    this.serviceListSnippetListState = state.serviceListSnippetListState ;
  }

  companyStateFieldUpdate(List<ServiceListSnippetState> serviceListSnippetListState) {
    ServiceListSnippetListState(
        serviceListSnippetListState: serviceListSnippetListState ?? this.serviceListSnippetListState
    );
  }

  ServiceListSnippetListState copyWith({serviceListSnippetListState}) {
    return ServiceListSnippetListState(
        serviceListSnippetListState: serviceListSnippetListState ?? this.serviceListSnippetListState
    );
  }

  ServiceListSnippetListState toEmpty() {
    return ServiceListSnippetListState(serviceListSnippetListState: []);
  }

  factory ServiceListSnippetListState.fromJson(Map<String, dynamic> json) => _$ServiceListSnippetListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceListSnippetListStateToJson(this);
}