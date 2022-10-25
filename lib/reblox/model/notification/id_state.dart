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
import 'package:json_annotation/json_annotation.dart';
part 'id_state.g.dart';


@JsonSerializable(explicitToJson: true)
class IdState {
  String businessId;
  String serviceId;
  String orderId;
  String categoryId;

  IdState({
    this.businessId,
    this.orderId,
    this.serviceId,
    this.categoryId,
  });

  IdState toEmpty() {
    return IdState(
        businessId: '',
        orderId: '',
        serviceId: '',
        categoryId: '',
    );
  }

  IdState.fromState(IdState state) {
    this.businessId = state.businessId;
    this.orderId = state.orderId;
    this.serviceId = state.serviceId;
    this.categoryId = state.categoryId;
  }

  IdState copyWith({
    String businessId,
    String orderId,
    String serviceId,
    String categoryId,
  }) {
    return IdState(
      businessId: businessId ?? this.businessId,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  factory IdState.fromJson(Map<String, dynamic> json) => _$IdStateFromJson(json);
  Map<String, dynamic> toJson() => _$IdStateToJson(this);

}
