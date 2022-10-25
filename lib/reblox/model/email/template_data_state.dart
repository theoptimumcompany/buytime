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
part 'template_data_state.g.dart';


@JsonSerializable(explicitToJson: true)
class TemplateDataState {
  String name;
  String link;
  String userEmail;
  String businessName;
  String businessId;
  String searched;

  TemplateDataState({
    this.name,
    this.link,
    this.userEmail,
    this.businessName,
    this.businessId,
    this.searched,
  });

  TemplateDataState toEmpty() {
    return TemplateDataState(
      name: '',
      link: '',
      userEmail: '',
      businessName: '',
      businessId: '',
      searched: '',
    );
  }

  TemplateDataState.fromState(TemplateDataState state) {
    this.name = state.name;
    this.link = state.link;
    this.userEmail = state.userEmail;
    this.businessName = state.businessName;
    this.businessId = state.businessId;
    this.searched = state.searched;
  }

  TemplateDataState copyWith({
    String name,
    String link,
    String userEmail,
    String businessName,
    String businessId,
    String searched,
  }) {
    return TemplateDataState(
      name: name ?? this.name,
      link: link ?? this.link,
      userEmail: userEmail ?? this.userEmail,
      businessName: businessName ?? this.businessName,
      businessId: businessId ?? this.businessId,
      searched: searched ?? this.searched,
    );
  }

  factory TemplateDataState.fromJson(Map<String, dynamic> json) => _$TemplateDataStateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateDataStateToJson(this);

}
