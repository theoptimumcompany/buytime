/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
