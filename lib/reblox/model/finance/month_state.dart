import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'month_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Month {
  Month({
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
  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);
  Map<String, dynamic> toJson() => _$MonthToJson(this);
}