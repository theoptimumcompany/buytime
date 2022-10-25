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

import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'area_state.dart';
part 'area_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AreaListState {
  List<AreaState> areaList;

  AreaListState({
    @required this.areaList,
  });

  AreaListState toEmpty() {
    return AreaListState(
      areaList: [],
    );
  }



  AreaListState.fromState(AreaListState state) {
    this.areaList = state.areaList;
  }

  AreaListState copyWith({
    List<AreaState> areaList,
  }) {
    return AreaListState(
      areaList: areaList ?? this.areaList,
    );
  }



  factory AreaListState.fromJson(Map<String, dynamic> json) => _$AreaListStateFromJson(json);
  Map<String, dynamic> toJson() => _$AreaListStateToJson(this);

}
