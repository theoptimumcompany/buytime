// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryListState _$CategoryListStateFromJson(Map<String, dynamic> json) {
  return CategoryListState(
    categoryListState: (json['categoryListState'] as List)
        ?.map((e) => e == null
            ? null
            : CategoryState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CategoryListStateToJson(CategoryListState instance) =>
    <String, dynamic>{
      'categoryListState':
          instance.categoryListState?.map((e) => e?.toJson())?.toList(),
    };
