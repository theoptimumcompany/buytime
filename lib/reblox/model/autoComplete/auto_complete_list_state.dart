import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';


part 'auto_complete_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AutoCompleteListState {
  List<AutoCompleteState> autoCompleteListState;

  AutoCompleteListState({
    @required this.autoCompleteListState,
  });

  AutoCompleteListState.fromState(AutoCompleteListState state) {
    this.autoCompleteListState = state.autoCompleteListState ;
  }

  companyStateFieldUpdate(List<AutoCompleteState> autoCompleteListState) {
    AutoCompleteListState(
        autoCompleteListState: autoCompleteListState ?? this.autoCompleteListState
    );
  }

  AutoCompleteListState copyWith({autoCompleteListState}) {
    return AutoCompleteListState(
        autoCompleteListState: autoCompleteListState ?? this.autoCompleteListState
    );
  }

  AutoCompleteListState toEmpty() {
    return AutoCompleteListState(autoCompleteListState: []);
  }

  factory AutoCompleteListState.fromJson(Map<String, dynamic> json) => _$AutoCompleteListStateFromJson(json);
  Map<String, dynamic> toJson() => _$AutoCompleteListStateToJson(this);

}