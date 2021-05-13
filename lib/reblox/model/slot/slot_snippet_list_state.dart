import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_list_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'slot_snippet_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class SlotSnippetListState {
  List<SlotListState> slotSnippetListState;

  SlotSnippetListState({
    @required this.slotSnippetListState,
  });

  SlotSnippetListState.fromState(SlotSnippetListState state) {
    this.slotSnippetListState = state.slotSnippetListState;
  }

  SlotSnippetListState copyWith({slotSnippetListState}) {
    return SlotSnippetListState(
        slotSnippetListState: slotSnippetListState ?? this.slotSnippetListState);
  }

  SlotSnippetListState toEmpty() {
    return SlotSnippetListState(slotSnippetListState: []);
  }

  factory SlotSnippetListState.fromJson(Map<String, dynamic> json) => _$SlotSnippetListStateFromJson(json);
  Map<String, dynamic> toJson() => _$SlotSnippetListStateToJson(this);
}
