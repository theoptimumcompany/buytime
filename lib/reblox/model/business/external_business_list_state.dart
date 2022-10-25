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

import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_state.dart';
part 'external_business_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalBusinessListState {
  List<ExternalBusinessState> externalBusinessListState;

  ExternalBusinessListState({
    @required this.externalBusinessListState,
  });

  ExternalBusinessListState.fromState(ExternalBusinessListState state) {
    this.externalBusinessListState = state.externalBusinessListState ;
  }

  companyStateFieldUpdate(List<ExternalBusinessState> externalBusinessListState) {
    ExternalBusinessListState(
        externalBusinessListState: externalBusinessListState ?? this.externalBusinessListState
    );
  }

  ExternalBusinessListState copyWith({externalBusinessListState}) {
    return ExternalBusinessListState(
        externalBusinessListState: externalBusinessListState ?? this.externalBusinessListState
    );
  }

  ExternalBusinessListState toEmpty() {
    return ExternalBusinessListState(externalBusinessListState: []);
  }

  factory ExternalBusinessListState.fromJson(Map<String, dynamic> json) => _$ExternalBusinessListStateFromJson(json);
  Map<String, dynamic> toJson() => _$ExternalBusinessListStateToJson(this);
}