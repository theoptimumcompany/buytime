import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'year_state.g.dart';

@JsonSerializable(explicitToJson: true)
class Year {
  Year({
    @required this.data,
    @required this.mediumRevenue,
    @required this.orderNumber,
    @required this.totalRevenue,
    @required this.realRevenue,
  });

  dynamic data;
  double mediumRevenue;
  double orderNumber;
  int totalRevenue;
  double realRevenue;

  factory Year.fromJson(Map<String, dynamic> json) => _$YearFromJson(json);
  Map<String, dynamic> toJson() => _$YearToJson(this);
}