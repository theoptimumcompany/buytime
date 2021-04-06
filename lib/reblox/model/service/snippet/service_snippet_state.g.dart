// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSnippet _$ServiceSnippetFromJson(Map<String, dynamic> json) {
  return ServiceSnippet(
    timesSold: json['timesSold'] as int ?? 0,
    name: json['name'] as String ?? '',
    image: json['image'] as String ?? '',
    visibility: json['visibility'] as String ?? '',
    connectedBusinessVisibility:
        json['connectedBusinessVisibility'] as String ?? '',
    absolutePath: json['absolutePath'] as String ?? '',
    internalPath: json['internalPath'] as String ?? '',
  );
}

Map<String, dynamic> _$ServiceSnippetToJson(ServiceSnippet instance) =>
    <String, dynamic>{
      'timesSold': instance.timesSold,
      'name': instance.name,
      'image': instance.image,
      'visibility': instance.visibility,
      'connectedBusinessVisibility': instance.connectedBusinessVisibility,
      'absolutePath': instance.absolutePath,
      'internalPath': instance.internalPath,
    };
