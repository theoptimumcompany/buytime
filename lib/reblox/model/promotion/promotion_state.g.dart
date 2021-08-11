// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionState _$PromotionStateFromJson(Map<String, dynamic> json) {
  return PromotionState(
    area: json['area'] as String ?? '',
    businessIdList:
        (json['businessIdList'] as List)?.map((e) => e as String)?.toList() ??
            [],
    categoryIdList:
        (json['categoryIdList'] as List)?.map((e) => e as String)?.toList() ??
            [],
    dateStart: Utils.getDate(json['dateStart'] as Timestamp),
    dateStop: Utils.getDate(json['dateStop'] as Timestamp),
    discount: json['discount'] as int ?? 0,
    discountType: json['discountType'] as String ?? 'fixedAmount',
    limit: json['limit'] as int ?? 0,
  );
}

Map<String, dynamic> _$PromotionStateToJson(PromotionState instance) =>
    <String, dynamic>{
      'area': instance.area,
      'businessIdList': instance.businessIdList,
      'categoryIdList': instance.categoryIdList,
      'dateStart': Utils.setDate(instance.dateStart),
      'dateStop': Utils.setDate(instance.dateStop),
      'discount': instance.discount,
      'discountType': instance.discountType,
      'limit': instance.limit,
    };
