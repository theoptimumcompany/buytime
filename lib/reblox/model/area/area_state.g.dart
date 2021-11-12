// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaState _$AreaStateFromJson(Map<String, dynamic> json) {
  return AreaState(
    areaId: json['areaId'] as String,
    address: json['address'] as String ?? '',
    coordinates: json['coordinates'] as String ?? '',
  );
}

Map<String, dynamic> _$AreaStateToJson(AreaState instance) => <String, dynamic>{
      'areaId': instance.areaId,
      'address': instance.address,
      'coordinates': instance.coordinates,
    };
