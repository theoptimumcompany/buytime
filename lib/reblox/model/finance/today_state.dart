import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'today_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Today {
  Today({
    @required this.hour,
    @required this.mediumRevenue,
    @required this.realRevenue,
  });

  List<int> hour;
  int mediumRevenue;
  int realRevenue;

  factory Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);
  Map<String, dynamic> toJson() => _$TodayToJson(this);
}