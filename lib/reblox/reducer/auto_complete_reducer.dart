import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';

class AddAutoComplete{
  AutoCompleteState _autoCompleteState;

  AddAutoComplete(this._autoCompleteState);

  AutoCompleteState get autoCompleteState => _autoCompleteState;
}

AutoCompleteState autoCompleteReducer(AutoCompleteState state, action) {
  AutoCompleteState autoCompleteState = new AutoCompleteState.fromState(state);
  
  if (action is AddAutoComplete) {
    autoCompleteState = action.autoCompleteState.copyWith();
    //debugPrint('card_reducer: ${cardState.cardOwner}');
    return autoCompleteState;
  }
  
  return state;
}
