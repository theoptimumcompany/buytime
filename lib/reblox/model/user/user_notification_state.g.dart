// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotificationState _$UserNotificationStateFromJson(
    Map<String, dynamic> json) {
  return UserNotificationState(
    device: json['device'] as String,
    token: json['token'] as String,
    hasNotification: json['hasNotification'] as bool,
  );
}

Map<String, dynamic> _$UserNotificationStateToJson(
        UserNotificationState instance) =>
    <String, dynamic>{
      'device': instance.device,
      'token': instance.token,
      'hasNotification': instance.hasNotification,
    };
