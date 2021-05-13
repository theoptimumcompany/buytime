// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationState _$NotificationStateFromJson(Map<String, dynamic> json) {
  return NotificationState(
    body: json['body'] as String,
    title: json['title'] as String,
    userId: json['userId'] as String,
    data: json['data'] == null
        ? null
        : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    timestamp: json['timestamp'] as int,
    opened: json['opened'] as bool,
    notificationId: json['notificationId'] as String,
  );
}

Map<String, dynamic> _$NotificationStateToJson(NotificationState instance) =>
    <String, dynamic>{
      'body': instance.body,
      'title': instance.title,
      'userId': instance.userId,
      'data': instance.data?.toJson(),
      'timestamp': instance.timestamp,
      'opened': instance.opened,
      'notificationId': instance.notificationId,
    };
