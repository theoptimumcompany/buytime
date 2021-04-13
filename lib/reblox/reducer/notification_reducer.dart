import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class RequestNotification {
  RequestNotification();
}
class RequestedNotification {
  RequestedNotification();
}

NotificationState notificationReducer(NotificationState state, action) {
  NotificationState notificationState = new NotificationState.fromState(state);

  return state;
}
