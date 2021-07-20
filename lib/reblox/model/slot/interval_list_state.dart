import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'interval_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class IntervalListState {
  String id;
  List<SquareSlotState> slot;

  IntervalListState({
    @required this.slot,
    this.id
  });

  IntervalListState.fromState(IntervalListState state) {
    this.slot = state.slot;
    this.id = state.id;
  }

  IntervalListState copyWith({intervalListState}) {
    return IntervalListState(
        slot: intervalListState ?? this.slot,
    );
  }

  IntervalListState toEmpty() {
    return IntervalListState(slot: [], id: '');
  }

  factory IntervalListState.fromJson(Map<String, dynamic> json) => _$IntervalListStateFromJson(json);
  Map<String, dynamic> toJson() => _$IntervalListStateToJson(this);
}
