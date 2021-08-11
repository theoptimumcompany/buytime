import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promotion_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PromotionListState {
  @JsonKey(defaultValue: [])
  List<PromotionState> promotionListState;

  PromotionListState({
    @required this.promotionListState,
  });

  PromotionListState.fromState(PromotionListState state) {
    this.promotionListState = state.promotionListState;
  }

  PromotionListState copyWith({promotionListState}) {
    return PromotionListState(
        promotionListState: promotionListState ?? this.promotionListState);
  }

  PromotionListState toEmpty() {
    return PromotionListState(promotionListState: []);
  }

  factory PromotionListState.fromJson(Map<String, dynamic> json) => _$PromotionListStateFromJson(json);
  Map<String, dynamic> toJson() => _$PromotionListStateToJson(this);
}
