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
part 'user_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class UserSnippet {
  String id;
  String name;
  String surname;
  String email;

  UserSnippet({
    this.id,
    this.name,
    this.surname,
    this.email,
  });

  UserSnippet.fromState(UserSnippet userSnippet) {
    this.id = userSnippet.id;
    this.name = userSnippet.name;
    this.surname = userSnippet.surname;
    this.email = userSnippet.email;
  }

  UserSnippet copyWith({
    String id,
    String name,
    String surname,
    String email,
  }) {
    return UserSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
    );
  }

  UserSnippet toEmpty() {
    return UserSnippet(
      id: '',
      name: '',
      surname: '',
      email: '',
    );
  }
  factory UserSnippet.fromJson(Map<String, dynamic> json) => _$UserSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$UserSnippetToJson(this);

}
