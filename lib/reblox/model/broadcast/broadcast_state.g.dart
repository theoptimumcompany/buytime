// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'broadcast_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BroadcastState _$BroadcastStateFromJson(Map<String, dynamic> json) {
  return BroadcastState(
    body: json['body'] as String ?? '',
    sendNow: json['sendNow'] as bool ?? false,
    sendTime: Utils.getDate(json['sendTime'] as Timestamp),
    senderId: json['senderId'] as String ?? '',
    timestamp: Utils.getDate(json['timestamp'] as Timestamp),
    title: json['title'] as String ?? '',
    topic: json['topic'] as String ?? '',
  );
}

Map<String, dynamic> _$BroadcastStateToJson(BroadcastState instance) =>
    <String, dynamic>{
      'body': instance.body,
      'sendNow': instance.sendNow,
      'sendTime': Utils.setDate(instance.sendTime),
      'senderId': instance.senderId,
      'timestamp': Utils.setDate(instance.timestamp),
      'title': instance.title,
      'topic': instance.topic,
    };
