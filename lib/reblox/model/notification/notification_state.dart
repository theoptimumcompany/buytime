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
