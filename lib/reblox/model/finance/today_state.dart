import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'today_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Today {
  Today({
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

  factory Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);
  Map<String, dynamic> toJson() => _$TodayToJson(this);
}