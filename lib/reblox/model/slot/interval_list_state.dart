import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'interval_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class IntervalListState {
  List<SquareSlotState> intervalListState;

  IntervalListState({
    @required this.intervalListState,
  });

  IntervalListState.fromState(IntervalListState state) {
    this.intervalListState = state.intervalListState;
  }

  IntervalListState copyWith({intervalListState}) {
    return IntervalListState(
        intervalListState: intervalListState ?? this.intervalListState);
  }

  IntervalListState toEmpty() {
    return IntervalListState(intervalListState: []);
  }

  factory IntervalListState.fromJson(Map<String, dynamic> json) => _$IntervalListStateFromJson(json);
  Map<String, dynamic> toJson() => _$IntervalListStateToJson(this);
}
