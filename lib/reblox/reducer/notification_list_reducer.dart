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

import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class RequestNotificationList {
  String _userId;
  String _businessId;
  RequestNotificationList(this._userId, this._businessId);
  String get userId => _userId;
  String get businessId => _businessId;
}

class RequestedNotificationList {
  List<NotificationState> _notificationListState;
  RequestedNotificationList(this._notificationListState);
  List<NotificationState> get notificationListState => _notificationListState;
}

NotificationListState notificationListReducer(NotificationListState state, action) {
  NotificationListState notificationListState = new NotificationListState.fromState(state);
  if (action is RequestedNotificationList) {
    notificationListState = NotificationListState(notificationListState: action.notificationListState).copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return notificationListState;
  }
  return state;
}
