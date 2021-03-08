import 'package:Buytime/reblox/model/autoComplete/auto_complete_list_state.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';


class AddAutoCompleteToList{
  List<AutoCompleteState> _autoCompleteListState;

  AddAutoCompleteToList(this._autoCompleteListState);

  List<AutoCompleteState> get autoCompleteListState => _autoCompleteListState;
}


AutoCompleteListState autoCompleteListReducer(AutoCompleteListState state, action) {
  AutoCompleteListState autoCompleteListState = new AutoCompleteListState.fromState(state);

  if (action is AddAutoCompleteToList) {
    autoCompleteListState = AutoCompleteListState(autoCompleteListState: action.autoCompleteListState).copyWith();
    debugPrint('auto_complete_list_reducer: LENGTH: ${autoCompleteListState.autoCompleteListState.length}');
    return autoCompleteListState;
  }

  return state;
}
