import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'month.g.dart';

@JsonSerializable(explicitToJson: true)
class Month {
  Month({
    @required this.mediumRevenue,
    @required this.realRevenue,
    @required this.day,
  });

  int mediumRevenue;
  int realRevenue;
  List<int> day;

  factory Month.fromJson(Map<String, dynamic> json) => _$MonthFromJson(json);
  Map<String, dynamic> toJson() => _$MonthToJson(this);
}