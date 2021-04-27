// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationState _$NotificationStateFromJson(Map<String, dynamic> json) {
  return NotificationState(
    recipientId: json['recipientId'] as String,
    title: json['title'] as String,
    message: json['message'] as String,
    ids: json['ids'] == null
        ? null
        : IdState.fromJson(json['ids'] as Map<String, dynamic>),
    notifyDate: json['notifyDate'] == null
        ? null
        : DateTime.parse(json['notifyDate'] as String),
  );
}

Map<String, dynamic> _$NotificationStateToJson(NotificationState instance) =>
    <String, dynamic>{
      'recipientId': instance.recipientId,
      'title': instance.title,
      'message': instance.message,
      'ids': instance.ids?.toJson(),
      'notifyDate': instance.notifyDate?.toIso8601String(),
    };
