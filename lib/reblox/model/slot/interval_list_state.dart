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
