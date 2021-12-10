import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'year_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Year {
  Year({
    @required this.month,
    @required this.mediumRevenue,
    @required this.realRevenue,
  });

  List<int> month;
  int mediumRevenue;
  int realRevenue;

  factory Year.fromJson(Map<String, dynamic> json) => _$YearFromJson(json);
  Map<String, dynamic> toJson() => _$YearToJson(this);
}