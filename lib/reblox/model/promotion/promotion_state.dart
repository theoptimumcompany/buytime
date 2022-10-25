/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promotion_state.g.dart';

enum DiscountType {
  fixedAmount,
  percentageAmount
}

@JsonSerializable(explicitToJson: true)
class PromotionState {
  @JsonKey(defaultValue: '')
  String area;
  @JsonKey(defaultValue: '')
  String promotionId;
  @JsonKey(defaultValue: [])
  List<String> businessIdList;
  @JsonKey(defaultValue: [])
  List<String> categoryIdList;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime dateStart;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime dateStop;
  @JsonKey(defaultValue: 0)
  int discount;
  @JsonKey(defaultValue: 'fixedAmount')
  String discountType;
  @JsonKey(defaultValue: 0)
  int limit;

  PromotionState({
    this.area,
    this.promotionId,
    this.businessIdList,
    this.categoryIdList,
    this.dateStart,
    this.dateStop,
    this.discount,
    this.discountType,
    this.limit
  });

  PromotionState toEmpty() {
    return PromotionState(
      area: '',
      promotionId: '',
      businessIdList: [],
      categoryIdList: [],
      dateStart: DateTime.now(),
      dateStop: DateTime.now(),
      discount: 0,
      discountType: Utils.enumToString(DiscountType.fixedAmount),
      limit: 0
    );
  }

  PromotionState.fromState(PromotionState promotionState) {
    this.area = promotionState.area;
    this.promotionId = promotionState.promotionId;
    this.businessIdList = promotionState.businessIdList;
    this.categoryIdList = promotionState.categoryIdList;
    this.dateStart = promotionState.dateStart;
    this.dateStop = promotionState.dateStop;
    this.discount = promotionState.discount;
    this.discountType = promotionState.discountType;
    this.limit = promotionState.limit;
  }

  PromotionState copyWith({
  String area,
  String promotionId,
  List<String> businessIdList,
  List<String> categoryIdList,
  DateTime dateStart,
  DateTime dateStop,
  int discount,
  String discountType,
  int limit,
  }) {
    return PromotionState(
      area: area ?? this.area,
      promotionId: promotionId ?? this.promotionId,
      businessIdList: businessIdList ?? this.businessIdList,
      categoryIdList: categoryIdList ?? this.categoryIdList,
      dateStart: dateStart ?? this.dateStart,
      dateStop: dateStop ?? this.dateStop,
      discount: discount ?? this.discount,
      discountType: discountType ?? this.discountType,
      limit: limit ?? this.limit,
    );
  }

  factory PromotionState.fromJson(Map<String, dynamic> json) => _$PromotionStateFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionStateToJson(this);
}
