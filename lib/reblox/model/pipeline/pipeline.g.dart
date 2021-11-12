// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pipeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pipeline _$PipelineFromJson(Map<String, dynamic> json) {
  return Pipeline(
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$PipelineToJson(Pipeline instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
