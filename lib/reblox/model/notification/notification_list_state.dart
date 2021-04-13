import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationListState {
  List<NotificationState> notificationListState;

  NotificationListState({
    @required this.notificationListState,
  });

  NotificationListState.fromState(NotificationListState state) {
    this.notificationListState = state.notificationListState ;
  }

  companyStateFieldUpdate(List<BookingState> bookingListState) {
    NotificationListState(
        notificationListState: notificationListState ?? this.notificationListState
    );
  }

  NotificationListState copyWith({bookingListState}) {
    return NotificationListState(
        notificationListState: notificationListState ?? this.notificationListState
    );
  }

  NotificationListState toEmpty() {
    return NotificationListState(notificationListState: []);
  }

  factory NotificationListState.fromJson(Map<String, dynamic> json) => _$NotificationListStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationListStateToJson(this);


}