import 'package:Buytime/reblox/model/finance/today_state.dart';
import 'package:Buytime/reblox/model/finance/week_state.dart';
import 'package:Buytime/reblox/model/finance/year_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'month_state.dart';
part 'finance.g.dart';

@JsonSerializable(explicitToJson: true)
class Finance {
  Finance({
    @required this.year,
    @required this.week,
    @required this.monthlyExternalServiceGiveback,
    @required this.month,
    @required this.monthlyExternalServiceRevenue,
    @required this.activeUserMonthly,
    @required this.today,
    @required this.monthlyGiveback,
  });

  Year year;
  Week week;
  int monthlyExternalServiceGiveback;
  Month month;
  int monthlyExternalServiceRevenue;
  int activeUserMonthly;
  Today today;
  int monthlyGiveback;

  factory Finance.fromJson(Map<String, dynamic> json) => _$FinanceFromJson(json);
  Map<String, dynamic> toJson() => _$FinanceToJson(this);
}







