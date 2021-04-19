import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_state.dart';
part 'external_business_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalBusinessListState {
  List<ExternalBusinessState> externalBusinessListState;

  ExternalBusinessListState({
    @required this.externalBusinessListState,
  });

  ExternalBusinessListState.fromState(ExternalBusinessListState state) {
    this.externalBusinessListState = state.externalBusinessListState ;
  }

  companyStateFieldUpdate(List<ExternalBusinessState> externalBusinessListState) {
    ExternalBusinessListState(
        externalBusinessListState: externalBusinessListState ?? this.externalBusinessListState
    );
  }

  ExternalBusinessListState copyWith({externalBusinessListState}) {
    return ExternalBusinessListState(
        externalBusinessListState: externalBusinessListState ?? this.externalBusinessListState
    );
  }

  ExternalBusinessListState toEmpty() {
    return ExternalBusinessListState(externalBusinessListState: []);
  }

  factory ExternalBusinessListState.fromJson(Map<String, dynamic> json) => _$ExternalBusinessListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalBusinessListStateToJson(this);
}