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

import 'package:Buytime/reblox/model/email/template_data_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'template_state.g.dart';


@JsonSerializable(explicitToJson: true)
class TemplateState {
  String name;
  TemplateDataState data;

  TemplateState({
    this.name,
    this.data,
  });

  TemplateState toEmpty() {
    return TemplateState(
      name: '',
      data: TemplateDataState().toEmpty(),
    );
  }

  TemplateState.fromState(TemplateState state) {
    this.name = state.name;
    this.data = state.data;
  }

  TemplateState copyWith({
    String name,
    TemplateDataState data,
  }) {
    return TemplateState(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }

  factory TemplateState.fromJson(Map<String, dynamic> json) => _$TemplateStateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateStateToJson(this);

}
