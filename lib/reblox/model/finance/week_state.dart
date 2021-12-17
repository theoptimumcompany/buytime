import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'week_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Week {
  Week({
    @required this.data,
    @required this.mediumRevenue,
    @required this.orderNumber,
    @required this.totalRevenue,
    @required this.realRevenue,
  });

  dynamic data;
  int mediumRevenue;
  int orderNumber;
  int totalRevenue;
  int realRevenue;
  factory Week.fromJson(Map<String, dynamic> json) => _$WeekFromJson(json);
  Map<String, dynamic> toJson() => _$WeekToJson(this);
}