import 'package:Buytime/reblox/model/booking/booking_state.dart';
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

NotificationState notificationReducer(NotificationState state, action) {
  NotificationState notificationState = new NotificationState.fromState(state);
  if (action is CreateNotification) {
    notificationState = action.notificationState.copyWith();
    //debugPrint('external_service_imported_state_reducer: ${externalServiceImportedState.internalBusinessId}');
    return notificationState;
  }
  return state;
}
