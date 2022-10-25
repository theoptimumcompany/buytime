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
part 'area_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AreaState {
  String areaId;
  @JsonKey(defaultValue: '')
  String address;
  @JsonKey(defaultValue: '')
  String coordinates;

  AreaState({
    @required this.areaId,
    @required this.address,
    @required this.coordinates,
  });

  AreaState toEmpty() {
    return AreaState(
      areaId: "",
      address: "",
      coordinates: "",
    );
  }



  AreaState.fromState(AreaState state) {
    this.areaId = state.areaId;
    this.address = state.address;
    this.coordinates = state.coordinates;
  }

  AreaState copyWith({
    String areaId,
    String address,
    String business_name,
  }) {
    return AreaState(
      areaId: areaId ?? this.areaId,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  factory AreaState.fromJson(Map<String, dynamic> json) => _$AreaStateFromJson(json);
  Map<String, dynamic> toJson() => _$AreaStateToJson(this);

}
