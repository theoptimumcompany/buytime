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

import 'dart:math';

import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:flutter/material.dart';

class UpdateStatistics {
  StatisticsState _statisticsState;

  UpdateStatistics(this._statisticsState);

  StatisticsState get statisticsState => _statisticsState;
}


StatisticsState statisticsReducer(StatisticsState state, action) {
  StatisticsState statisticsState = new StatisticsState.fromState(state);
  
  if (action is UpdateStatistics) {
    if (action.statisticsState != null) {
      statisticsState = action.statisticsState.copyWith();
    }
    return statisticsState;
  }
  
  return state;
}
