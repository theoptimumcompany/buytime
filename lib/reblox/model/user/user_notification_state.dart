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

import 'package:Buytime/reblox/model/role/role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_notification_state.g.dart';


@JsonSerializable(explicitToJson: true)
class UserNotificationState {
  String device;
  String token;
  bool hasNotification;

  UserNotificationState({
    this.device,
    this.token,
    this.hasNotification,
  });

  UserNotificationState.fromState(UserNotificationState user) {
    this.device = user.device;
    this.token = user.token;
    this.hasNotification = user.hasNotification;
  }

  UserNotificationState toEmpty() {
    return UserNotificationState(
      device: "",
      token: "",
      hasNotification: false,
    );
  }

  UserNotificationState copyWith(
      {String device,
      String token,
      bool hasNotification,
      }) {
    return UserNotificationState(
      device: device ?? this.device,
      token: token ?? this.token,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  factory UserNotificationState.fromJson(Map<String, dynamic> json) => _$UserNotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$UserNotificationStateToJson(this);
}
