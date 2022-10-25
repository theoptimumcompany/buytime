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

import 'package:Buytime/reblox/model/notification/notification_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_state.g.dart';


@JsonSerializable(explicitToJson: true)
class NotificationState {
  String body;
  String title;
  String userId;
  NotificationData data;
  int timestamp;
  bool opened;
  String notificationId;
  String serviceName;


  NotificationState({
    this.body,
    this.title,
    this.userId,
    this.data,
    this.timestamp,
    this.opened,
    this.notificationId,
    this.serviceName,
  });

  NotificationState toEmpty() {
    return NotificationState(
        body: '',
      title: '',
      userId: '',
      data: NotificationData().toEmpty(),
      timestamp: 0,
      opened: false,
      notificationId: '',
      serviceName: '',
    );
  }

  NotificationState.fromState(NotificationState state) {
    this.body = state.body;
    this.title = state.title;
    this.userId = state.userId;
    this.data = state.data;
    this.timestamp = state.timestamp;
    this.opened = state.opened;
    this.notificationId = state.notificationId;
    this.serviceName = state.serviceName;
  }

  NotificationState copyWith({
    String body,
    String title,
    String userId,
    NotificationData data,
    int timestamp,
    bool opened,
    String notificationId,
    String serviceName
  }) {
    return NotificationState(
      body: body ?? this.body,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      opened: opened ?? this.opened,
      notificationId: notificationId ?? this.notificationId,
      serviceName: serviceName ?? this.serviceName,
    );
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) => _$NotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationStateToJson(this);

}
