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

import 'package:Buytime/reblox/model/email/template_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'email_state.g.dart';


@JsonSerializable(explicitToJson: true)
class EmailState {
  String to;
  String cc;
  TemplateState template;
  bool sent;

  EmailState({
    this.to,
    this.cc,
    this.template,
    this.sent,
  });

  EmailState toEmpty() {
    return EmailState(
        to: '',
        cc: '',
        template: TemplateState().toEmpty(),
        sent: null,
    );
  }

  EmailState.fromState(EmailState state) {
    this.to = state.to;
    this.cc = state.cc;
    this.template = state.template;
    this.sent = state.sent;
  }

  EmailState copyWith({
    String to,
    String cc,
    TemplateState template,
    bool sent,
  }) {
    return EmailState(
      to: to ?? this.to,
      cc: cc ?? this.cc,
      template: template ?? this.template,
      sent: sent ?? this.sent,
    );
  }

  factory EmailState.fromJson(Map<String, dynamic> json) => _$EmailStateFromJson(json);
  Map<String, dynamic> toJson() => _$EmailStateToJson(this);

}
