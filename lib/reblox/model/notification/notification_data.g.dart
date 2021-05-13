// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) {
  return NotificationData(
    click_action: json['click_action'] as String,
    state: json['state'] == null
        ? null
        : IdState.fromJson(json['state'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'click_action': instance.click_action,
      'state': instance.state?.toJson(),
    };
