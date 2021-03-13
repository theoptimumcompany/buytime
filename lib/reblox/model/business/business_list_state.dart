import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_state.dart';
part 'business_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessListState {
  List<BusinessState> businessListState;

  BusinessListState({
    @required this.businessListState,
  });

  BusinessListState.fromState(BusinessListState state) {
    this.businessListState = state.businessListState ;
  }

  companyStateFieldUpdate(List<BusinessState> businessListState) {
    BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState copyWith({businessListState}) {
    return BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState toEmpty() {
    return BusinessListState(businessListState: List<BusinessState>());
  }

  factory BusinessListState.fromJson(Map<String, dynamic> json) => _$BusinessListStateFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessListStateToJson(this);
}