import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promotion_state.g.dart';

enum DiscountType {
  fixedAmount
}

@JsonSerializable(explicitToJson: true)
class PromotionState {
  String area;
  List<String> businessIdList;
  List<String> categoryIdList;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime dateStart;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime dateStop;
  int discount;
  String discountType;
  int limit;

  PromotionState({
    this.area,
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
