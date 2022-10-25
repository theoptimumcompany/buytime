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

import 'dart:convert';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auto_complete_state.g.dart';

@JsonSerializable(explicitToJson: true)
class AutoCompleteState {

  ///Storage
  final storage = new FlutterSecureStorage();

  String email;
  String password;

  List<dynamic> convertToJson(List<UserSnippet> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  AutoCompleteState({
    this.email,
    this.password
  });

  AutoCompleteState toEmpty() {
    return AutoCompleteState(
      email: "",
      password: "",
    );
  }

  AutoCompleteState.fromState(AutoCompleteState state) {
    this.email = state.email;
    this.password = state.password;
  }

  companyStateFieldUpdate(
    String email,
    String password,
  ) {
    AutoCompleteState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  AutoCompleteState copyWith({
    String email,
    String password,
  }) {
    return AutoCompleteState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  factory AutoCompleteState.fromJson(Map<String, dynamic> json) => _$AutoCompleteStateFromJson(json);
  Map<String, dynamic> toJson() => _$AutoCompleteStateToJson(this);

  writeToStorage(List<AutoCompleteState> state) async{

    //List<CardState> list = await readFromStorage();
    String append = '';
    state.forEach((element) {
      String read = jsonEncode(element.toJson());
      debugPrint('auto_complete_state => JSON: $read');
      append = append.isNotEmpty ? append + '|' + read : read;
    });

    debugPrint('auto_complete_state => List: $append');
    await storage.write(
        key: 'autoComplete',
        value: append,
    );

  }


  Future<List<AutoCompleteState>> readFromStorage() async {
    List<AutoCompleteState> list = [];
    String tmpString = await storage.read(
        key: 'autoComplete',
    ) ?? '';
    debugPrint('auto_complete_state => List: $tmpString');

    if (tmpString.isNotEmpty) {
      List<String> cards = tmpString.trim().split('|');
      cards.forEach((element) {
        Map<String, dynamic> map = jsonDecode(element);
        debugPrint('auto_complete_state => EMAIL: ${map['email']}');
        if (element.isNotEmpty) {
          AutoCompleteState state = AutoCompleteState.fromJson(map);
          list.add(state);
        }
      });
    }

    return list;
  }

}
