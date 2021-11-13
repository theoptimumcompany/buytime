// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IdState _$IdStateFromJson(Map<String, dynamic> json) {
  return IdState(
    businessId: json['businessId'] as String,
    orderId: json['orderId'] as String,
    serviceId: json['serviceId'] as String,
    categoryId: json['categoryId'] as String,
  );
}

Map<String, dynamic> _$IdStateToJson(IdState instance) => <String, dynamic>{
      'businessId': instance.businessId,
      'serviceId': instance.serviceId,
      'orderId': instance.orderId,
      'categoryId': instance.categoryId,
    };
