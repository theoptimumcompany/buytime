import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promo_code_state.g.dart';

enum DiscountType {
  fixedAmount,
  percentageAmount
}

@JsonSerializable(explicitToJson: true)
class PromoCodeState {
  @JsonKey(defaultValue: 0)
  double amount;
  @JsonKey(defaultValue: false)
  bool oneTime;
  @JsonKey(defaultValue: 0)
  double percentage;
  @JsonKey(defaultValue: false)
  bool used;

  PromoCodeState({
    this.amount,
    this.oneTime,
    this.percentage,
    this.used,
  });

  PromoCodeState toEmpty() {
    return PromoCodeState(
      amount: 0,
      oneTime: false,
      percentage: 0,
      used: false,
    );
  }

  PromoCodeState.fromState(PromoCodeState promotionState) {
    this.amount = promotionState.amount;
    this.oneTime = promotionState.oneTime;
    this.percentage = promotionState.percentage;
    this.used = promotionState.used;
  }

  PromoCodeState copyWith({
    double amount,
  bool oneTime,
    double percentage,
  bool used,
  }) {
    return PromoCodeState(
      amount: amount ?? this.amount,
      oneTime: oneTime ?? this.oneTime,
      percentage: percentage ?? this.percentage,
      used: used ?? this.used,
    );
  }


  factory PromoCodeState.fromJson(Map<String, dynamic> json) => _$PromoCodeStateFromJson(json);

  Map<String, dynamic> toJson() => _$PromoCodeStateToJson(this);
}
