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
    name: json['name'] as String,
    image1: json['image1'] as String,
    image2: json['image2'] as String,
    image3: json['image3'] as String,
    description: json['description'] as String,
    visibility: json['visibility'] as String,
    price: (json['price'] as num)?.toDouble(),
    vat: json['vat'] as int,
    conventionSlotList: (json['conventionSlotList'] as List)
            ?.map((e) => e == null
                ? null
                : ConventionSlot.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    timesSold: json['timesSold'] as int,
    tag: (json['tag'] as List)?.map((e) => e as String)?.toList(),
    switchSlots: json['switchSlots'] as bool ?? false,
    hubConvention: json['hubConvention'] as bool ?? false,
    switchAutoConfirm: json['switchAutoConfirm'] as bool ?? false,
    serviceSlot: (json['serviceSlot'] as List)
            ?.map((e) => e == null
                ? null
                : ServiceSlot.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    spinnerVisibility: json['spinnerVisibility'] as bool ?? false,
    serviceCreated: json['serviceCreated'] as bool ?? false,
    serviceEdited: json['serviceEdited'] as bool ?? false,
    serviceCrossSell: json['serviceCrossSell'] as bool ?? true,
    serviceBusinessAddress: json['serviceBusinessAddress'] as String,
    serviceBusinessCoordinates: json['serviceBusinessCoordinates'] as String,
    originalLanguage: json['originalLanguage'] as String ?? '',
    serviceAddress: json['serviceAddress'] as String,
    serviceCoordinates: json['serviceCoordinates'] as String,
    paymentMethodRoom: json['paymentMethodRoom'] as bool ?? true,
    paymentMethodCard: json['paymentMethodCard'] as bool ?? true,
    paymentMethodOnSite: json['paymentMethodOnSite'] as bool ?? false,
    condition: json['condition'] as String ?? '',
  );
}

Map<String, dynamic> _$ServiceStateToJson(ServiceState instance) =>
    <String, dynamic>{
      'serviceId': instance.serviceId,
      'businessId': instance.businessId,
      'categoryId': instance.categoryId,
      'image1': instance.image1,
      'image2': instance.image2,
      'image3': instance.image3,
      'name': instance.name,
      'description': instance.description,
      'visibility': instance.visibility,
      'price': instance.price,
      'vat': instance.vat,
      'timesSold': instance.timesSold,
      'tag': instance.tag,
      'switchSlots': instance.switchSlots,
      'hubConvention': instance.hubConvention,
      'switchAutoConfirm': instance.switchAutoConfirm,
      'serviceSlot': instance.serviceSlot?.map((e) => e?.toJson())?.toList(),
      'spinnerVisibility': instance.spinnerVisibility,
      'serviceCreated': instance.serviceCreated,
      'serviceEdited': instance.serviceEdited,
      'serviceCrossSell': instance.serviceCrossSell,
      'serviceBusinessAddress': instance.serviceBusinessAddress,
      'serviceBusinessCoordinates': instance.serviceBusinessCoordinates,
      'serviceAddress': instance.serviceAddress,
      'serviceCoordinates': instance.serviceCoordinates,
      'originalLanguage': instance.originalLanguage,
      'paymentMethodRoom': instance.paymentMethodRoom,
      'paymentMethodCard': instance.paymentMethodCard,
      'paymentMethodOnSite': instance.paymentMethodOnSite,
      'condition': instance.condition,
      'conventionSlotList':
          instance.conventionSlotList?.map((e) => e?.toJson())?.toList(),
    };
