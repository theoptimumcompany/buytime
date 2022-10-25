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

import 'package:json_annotation/json_annotation.dart';
part 'order_business_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderBusinessSnippetState {
  String id;
  String name;
  String thumbnail;
  int serviceTakenNumber;

  OrderBusinessSnippetState({
    this.id,
    this.name,
    this.thumbnail,
    this.serviceTakenNumber,
  });

  OrderBusinessSnippetState.fromState(OrderBusinessSnippetState businessSnippet) {
    this.id = businessSnippet.id;
    this.name = businessSnippet.name;
    this.thumbnail = businessSnippet.thumbnail;
    this.serviceTakenNumber = businessSnippet.serviceTakenNumber;
  }

  OrderBusinessSnippetState copyWith({
    String id,
    String name,
    String thumbnail,
    int serviceTakenNumber,
  }) {
    return OrderBusinessSnippetState(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      serviceTakenNumber: serviceTakenNumber ?? this.serviceTakenNumber,
    );
  }

  OrderBusinessSnippetState toEmpty() {
    return OrderBusinessSnippetState(
      id: '',
      name: '',
      thumbnail: '',
      serviceTakenNumber: 0,
    );
  }

  factory OrderBusinessSnippetState.fromJson(Map<String, dynamic> json) => _$OrderBusinessSnippetStateFromJson(json);
  Map<String, dynamic> toJson() => _$OrderBusinessSnippetStateToJson(this);
}
