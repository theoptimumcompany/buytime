// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationState _$NotificationStateFromJson(Map<String, dynamic> json) {
  return NotificationState(
    businessId: json['businessId'] as String,
    orderId: json['orderId'] as String,
    serviceId: json['serviceId'] as String,
    serviceName: json['serviceName'] as String,
    serviceState: json['serviceState'] as String,
    manager: json['manager'] == null
        ? null
        : UserSnippet.fromJson(json['manager'] as Map<String, dynamic>),
    user: json['user'] == null
        ? null
        : UserSnippet.fromJson(json['user'] as Map<String, dynamic>),
    notifyDate: json['notifyDate'] == null
        ? null
        : DateTime.parse(json['notifyDate'] as String),
  );
}

Map<String, dynamic> _$NotificationStateToJson(NotificationState instance) =>
    <String, dynamic>{
      'businessId': instance.businessId,
      'orderId': instance.orderId,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'serviceState': instance.serviceState,
      'manager': instance.manager?.toJson(),
      'user': instance.user?.toJson(),
      'notifyDate': instance.notifyDate?.toIso8601String(),
    };
