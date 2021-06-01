import 'package:Buytime/reblox/model/role/role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_notification_state.g.dart';


@JsonSerializable(explicitToJson: true)
class UserNotificationState {
  String device;
  String token;
  bool hasNotification;

  UserNotificationState({
    this.device,
    this.token,
    this.hasNotification,
  });

  UserNotificationState.fromState(UserNotificationState user) {
    this.device = user.device;
    this.token = user.token;
    this.hasNotification = user.hasNotification;
  }

  UserNotificationState toEmpty() {
    return UserNotificationState(
      device: "",
      token: "",
      hasNotification: false,
    );
  }

  UserNotificationState copyWith(
      {String device,
      String token,
      bool hasNotification,
      }) {
    return UserNotificationState(
      device: device ?? this.device,
      token: token ?? this.token,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }

  factory UserNotificationState.fromJson(Map<String, dynamic> json) => _$UserNotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$UserNotificationStateToJson(this);
}
