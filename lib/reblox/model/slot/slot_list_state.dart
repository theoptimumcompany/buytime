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
