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

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'business_state.dart';
part 'business_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessListState {
  List<BusinessState> businessListState;

  BusinessListState({
    @required this.businessListState,
  });

  BusinessListState.fromState(BusinessListState state) {
    this.businessListState = state.businessListState ;
  }

  companyStateFieldUpdate(List<BusinessState> businessListState) {
    BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState copyWith({businessListState}) {
    return BusinessListState(
      businessListState: businessListState ?? this.businessListState
    );
  }

  BusinessListState toEmpty() {
    return BusinessListState(businessListState: List<BusinessState>());
  }

  factory BusinessListState.fromJson(Map<String, dynamic> json) => _$BusinessListStateFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessListStateToJson(this);
}