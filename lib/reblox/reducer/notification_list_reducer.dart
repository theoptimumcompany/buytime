import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class RequestNotificationList {
  RequestNotificationList();
}

class RequestedNotificationList {
  RequestedNotificationList();
}

NotificationListState notificationListReducer(NotificationListState state, action) {
  NotificationListState notificationListState = new NotificationListState.fromState(state);

  return state;
}
