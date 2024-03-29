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