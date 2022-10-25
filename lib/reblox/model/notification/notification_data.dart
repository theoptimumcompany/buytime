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

import 'package:Buytime/reblox/model/notification/id_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_data.g.dart';


@JsonSerializable(explicitToJson: true)
class NotificationData {
  String click_action;
  @JsonKey(fromJson: Utils.stringToMap, toJson: Utils.mapToString )
  IdState state;

  NotificationData({
    this.click_action,
    this.state,
  });

  NotificationData toEmpty() {
    return NotificationData(
      click_action: '',
      state: IdState().toEmpty()
    );
  }

  NotificationData.fromState(NotificationData state) {
    this.click_action = state.click_action;
    this.state = state.state;
  }

  NotificationData copyWith({
    String click_action,
    IdState state,
  }) {
    return NotificationData(
      click_action: click_action ?? this.click_action,
      state: state ?? this.state,
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}
