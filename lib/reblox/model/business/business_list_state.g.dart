// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessListState _$BusinessListStateFromJson(Map<String, dynamic> json) {
  return BusinessListState(
    businessListState: (json['businessListState'] as List)
        ?.map((e) => e == null
            ? null
            : BusinessState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BusinessListStateToJson(BusinessListState instance) =>
    <String, dynamic>{
      'businessListState':
          instance.businessListState?.map((e) => e?.toJson())?.toList(),
    };
