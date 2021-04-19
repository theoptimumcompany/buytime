// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySnippet _$CategorySnippetFromJson(Map<String, dynamic> json) {
  return CategorySnippet(
    categoryAbsolutePath: json['categoryAbsolutePath'] as String ?? '',
    categoryName: json['categoryName'] as String ?? '',
    categoryImage: json['categoryImage'] as String ?? '',
    serviceNumberInternal: json['serviceNumberInternal'] as int ?? 0,
    serviceNumberExternal: json['serviceNumberExternal'] as int ?? 0,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList() ?? [],
    serviceList: (json['serviceList'] as List)
            ?.map((e) => e == null
                ? null
                : ServiceSnippet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$CategorySnippetToJson(CategorySnippet instance) =>
    <String, dynamic>{
      'categoryAbsolutePath': instance.categoryAbsolutePath,
      'categoryName': instance.categoryName,
      'categoryImage': instance.categoryImage,
      'serviceNumberInternal': instance.serviceNumberInternal,
      'serviceNumberExternal': instance.serviceNumberExternal,
      'tags': instance.tags,
      'serviceList': instance.serviceList?.map((e) => e?.toJson())?.toList(),
    };
