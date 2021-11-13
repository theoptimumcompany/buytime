// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceListState _$ServiceListStateFromJson(Map<String, dynamic> json) {
  return ServiceListState(
    serviceListState: (json['serviceListState'] as List)
        ?.map((e) =>
            e == null ? null : ServiceState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ServiceListStateToJson(ServiceListState instance) =>
    <String, dynamic>{
      'serviceListState':
          instance.serviceListState?.map((e) => e?.toJson())?.toList(),
    };
