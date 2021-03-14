// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceState _$ServiceStateFromJson(Map<String, dynamic> json) {
  return ServiceState(
    serviceId: json['serviceId'] as String,
    businessId: json['businessId'] as String,
    categoryId: (json['categoryId'] as List)?.map((e) => e as String)?.toList(),
    categoryRootId:
        (json['categoryRootId'] as List)?.map((e) => e as String)?.toList(),
    name: json['name'] as String,
    image1: json['image1'] as String,
    image2: json['image2'] as String,
    image3: json['image3'] as String,
    description: json['description'] as String,
    visibility: json['visibility'] as String,
    price: (json['price'] as num)?.toDouble(),
    timesSold: json['timesSold'] as int,
    tag: (json['tag'] as List)?.map((e) => e as String)?.toList(),
    switchSlots: json['switchSlots'] as bool,
    switchAutoConfirm: json['switchAutoConfirm'] as bool,
    serviceSlot: (json['serviceSlot'] as List)
        ?.map((e) =>
            e == null ? null : ServiceSlot.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    spinnerVisibility: json['spinnerVisibility'] as bool ?? false,
    serviceCreated: json['serviceCreated'] as bool ?? false,
    serviceEdited: json['serviceEdited'] as bool ?? false,
  );
}

Map<String, dynamic> _$ServiceStateToJson(ServiceState instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'businessId': instance.businessId,
      'categoryId': instance.categoryId,
      'categoryRootId': instance.categoryRootId,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'name': instance.name,
      'description': instance.description,
      'visibility': instance.visibility,
      'price': instance.price,
      'timesSold': instance.timesSold,
      'tag': instance.tag,
      'switchSlots': instance.switchSlots,
      'switchAutoConfirm': instance.switchAutoConfirm,
      'serviceSlot': instance.serviceSlot?.map((e) => e?.toJson())?.toList(),
      'spinnerVisibility': instance.spinnerVisibility,
      'serviceCreated': instance.serviceCreated,
      'serviceEdited': instance.serviceEdited,
    };
