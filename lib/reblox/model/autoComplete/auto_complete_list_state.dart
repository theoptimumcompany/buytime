import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:flutter/foundation.dart';


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

  AutoCompleteListState.fromJson(Map json)
      : autoCompleteListState = json['autoCompleteListState'];

  Map<String, dynamic> toJson() => {
    'autoCompleteState': autoCompleteListState
  };

  AutoCompleteListState toEmpty() {
    return AutoCompleteListState(autoCompleteListState: []);
  }

}