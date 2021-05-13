import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/notification/notification_list_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/material.dart';

class RequestNotificationList {
  String _userId;
  RequestNotificationList(this._userId);
  String get userId => _userId;
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
