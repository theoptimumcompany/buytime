// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pipeline_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PipelineList _$PipelineListFromJson(Map<String, dynamic> json) {
  return PipelineList(
    pipelineList: (json['pipelineList'] as List)
        ?.map((e) =>
            e == null ? null : Pipeline.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PipelineListToJson(PipelineList instance) =>
    <String, dynamic>{
      'pipelineList': instance.pipelineList?.map((e) => e?.toJson())?.toList(),
    };
