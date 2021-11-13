// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaListState _$AreaListStateFromJson(Map<String, dynamic> json) {
  return AreaListState(
    areaList: (json['areaList'] as List)
        ?.map((e) =>
            e == null ? null : AreaState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$AreaListStateToJson(AreaListState instance) =>
    <String, dynamic>{
      'areaList': instance.areaList?.map((e) => e?.toJson())?.toList(),
    };
