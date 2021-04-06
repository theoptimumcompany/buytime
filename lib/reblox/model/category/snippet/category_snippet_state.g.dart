// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySnippet _$CategorySnippetFromJson(Map<String, dynamic> json) {
  return CategorySnippet(
    serviceNumberInternal: json['serviceNumberInternal'] as int ?? 0,
    serviceNumberExternal: json['serviceNumberExternal'] as int ?? 0,
    image: json['image'] as String ?? '',
    name: json['name'] as String ?? '',
    absolutePath: json['absolutePath'] as String ?? '',
    internalPath: json['internalPath'] as String ?? '',
    tag: json['tag'] as String ?? '',
    serviceSnippetList: (json['serviceSnippetList'] as List)
            ?.map((e) => e == null
                ? null
                : ServiceSnippet.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$CategorySnippetToJson(CategorySnippet instance) =>
    <String, dynamic>{
      'serviceNumberInternal': instance.serviceNumberInternal,
      'serviceNumberExternal': instance.serviceNumberExternal,
      'image': instance.image,
      'name': instance.name,
      'absolutePath': instance.absolutePath,
      'internalPath': instance.internalPath,
      'tag': instance.tag,
      'serviceSnippetList':
          instance.serviceSnippetList?.map((e) => e?.toJson())?.toList(),
    };
