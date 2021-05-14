import 'package:Buytime/reblox/model/notification/id_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'notification_data.g.dart';


@JsonSerializable(explicitToJson: true)
class NotificationData {
  String click_action;
  @JsonKey(fromJson: Utils.stringToMap, toJson: Utils.mapToString )
  IdState state;

  NotificationData({
    this.click_action,
    this.state,
  });

  NotificationData toEmpty() {
    return NotificationData(
      click_action: '',
      state: IdState().toEmpty()
    );
  }

  NotificationData.fromState(NotificationData state) {
    this.click_action = state.click_action;
    this.state = state.state;
  }

  NotificationData copyWith({
    String click_action,
    IdState state,
  }) {
    return NotificationData(
      click_action: click_action ?? this.click_action,
      state: state ?? this.state,
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}
