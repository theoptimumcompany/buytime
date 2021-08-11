// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionListState _$PromotionListStateFromJson(Map<String, dynamic> json) {
  return PromotionListState(
    promotionListState: (json['promotionListState'] as List)
        ?.map((e) => e == null
            ? null
            : PromotionState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PromotionListStateToJson(PromotionListState instance) =>
    <String, dynamic>{
      'promotionListState':
          instance.promotionListState?.map((e) => e?.toJson())?.toList(),
    };
