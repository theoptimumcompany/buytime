// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListState _$NotificationListStateFromJson(
    Map<String, dynamic> json) {
  return NotificationListState(
    notificationListState: (json['notificationListState'] as List)
        ?.map((e) => e == null
            ? null
            : NotificationState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotificationListStateToJson(
        NotificationListState instance) =>
    <String, dynamic>{
      'notificationListState':
          instance.notificationListState?.map((e) => e?.toJson())?.toList(),
    };
