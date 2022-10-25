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
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class RequestNotification {
  String _businessId;
  RequestNotification(this._businessId);
  String get businessId => _businessId;
}

class CreateNotification {
  NotificationState _notificationState;

  CreateNotification(this._notificationState);

  NotificationState get notificationState => _notificationState;
}

class RequestedNotification {
  RequestedNotification();
}

class UpdateNotification {
  //BookingStatus _bookingStatus;
  //String _bookingId;
  NotificationState _notificationState;

  UpdateNotification(this._notificationState);

  //BookingStatus get bookingStatus => _bookingStatus;
  //String get bookingId => _bookingId;
  NotificationState get notificationState => _notificationState;
}
class UpdatedNotification {
  //BookingStatus _bookingStatus;
  //String _bookingId;
  NotificationState _notificationState;

  UpdatedNotification(this._notificationState);

  //BookingStatus get bookingStatus => _bookingStatus;
  //String get bookingId => _bookingId;
  NotificationState get notificationState => _notificationState;
}

NotificationState notificationReducer(NotificationState state, action) {
  NotificationState notificationState = new NotificationState.fromState(state);
  if (action is CreateNotification) {
    notificationState = action.notificationState.copyWith();
    //debugPrint('external_service_imported_state_reducer: ${externalServiceImportedState.internalBusinessId}');
    return notificationState;
  }
  if (action is UpdatedNotification) {
    //debugPrint('booking_reducer: action: ${action.bookingStatus}');
    notificationState = action.notificationState.copyWith();
    //debugPrint('booking_reducer: booking status: ${bookingState.status}');
    return notificationState;
  }
  return state;
}
