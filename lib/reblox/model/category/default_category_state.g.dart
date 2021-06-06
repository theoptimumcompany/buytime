// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_category_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefaultCategoryState _$DefaultCategoryStateFromJson(Map<String, dynamic> json) {
  return DefaultCategoryState(
    businessType:
        (json['businessType'] as List)?.map((e) => e as String)?.toList(),
    category: json['category'] == null
        ? null
        : CategoryState.fromJson(json['category'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DefaultCategoryStateToJson(
        DefaultCategoryState instance) =>
    <String, dynamic>{
      'businessType': instance.businessType,
      'category': instance.category?.toJson(),
    };
