import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/notification/id_state.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_state.g.dart';


@JsonSerializable(explicitToJson: true)
class NotificationState {
  String recipientId;
  String title;
  String message;
  IdState ids;
  DateTime notifyDate;

  NotificationState({
    this.recipientId,
    this.title,
    this.message,
    this.ids,
    this.notifyDate,
  });

  NotificationState toEmpty() {
    return NotificationState(
        recipientId: '',
        title: '',
        message: '',
        ids: IdState().toEmpty(),
        notifyDate: DateTime.now().toUtc()
    );
  }

  NotificationState.fromState(NotificationState state) {
    this.recipientId = state.recipientId;
    this.title = state.title;
    this.message = state.message;
    this.ids = state.ids;
    this.notifyDate = state.notifyDate;
  }

  NotificationState copyWith({
    String recipientId,
    String title,
    String message,
    IdState ids,
    DateTime notifyDate,
  }) {
    return NotificationState(
      recipientId: recipientId ?? this.recipientId,
      title: title ?? this.title,
      message: message ?? this.message,
      ids: ids ?? this.ids,
      notifyDate: notifyDate ?? this.notifyDate,
    );
  }

  factory NotificationState.fromJson(Map<String, dynamic> json) => _$NotificationStateFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationStateToJson(this);

}
