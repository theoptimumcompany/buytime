import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_list_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'slot_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class SlotListState {
  List<IntervalListState> slotlistState;

  SlotListState({
    @required this.slotlistState,
  });

  SlotListState.fromState(SlotListState state) {
    this.slotlistState = state.slotlistState;
  }

  SlotListState copyWith({slotlistState}) {
    return SlotListState(
        slotlistState: slotlistState ?? this.slotlistState);
  }

  SlotListState toEmpty() {
    return SlotListState(slotlistState: []);
  }

  factory SlotListState.fromJson(Map<String, dynamic> json) => _$SlotListStateFromJson(json);
  Map<String, dynamic> toJson() => _$SlotListStateToJson(this);
}
