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
    statisticsState = action.statisticsState.copyWith();
    debugPrint('statistics_reducer => Calls: ${statisticsState.numberOfCalls}, Documents: ${statisticsState.numberOfDocuments}');
    return statisticsState;
  }
  
  return state;
}
