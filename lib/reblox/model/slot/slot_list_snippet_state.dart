import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_list_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'slot_list_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class SlotListSnippetState {
  List<IntervalListState> slotListSnippet;

  SlotListSnippetState({
    @required this.slotListSnippet,
  });

  SlotListSnippetState.fromState(SlotListSnippetState state) {
    this.slotListSnippet = state.slotListSnippet;
  }

  SlotListSnippetState copyWith({slotListSnippet}) {
    return SlotListSnippetState(
        slotListSnippet: slotListSnippet ?? this.slotListSnippet);
  }

  SlotListSnippetState toEmpty() {
    return SlotListSnippetState(slotListSnippet: []);
  }

  factory SlotListSnippetState.fromJson(Map<String, dynamic> json) => _$SlotListSnippetStateFromJson(json);
  Map<String, dynamic> toJson() => _$SlotListSnippetStateToJson(this);
}
