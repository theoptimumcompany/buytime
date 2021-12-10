import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'week_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Week {
  Week({
    @required this.mediumRevenue,
    @required this.realRevenue,
    @required this.day,
  });

  int mediumRevenue;
  int realRevenue;
  List<int> day;

  factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);
  Map<String, dynamic> toJson() => _$WeekToJson(this);
}