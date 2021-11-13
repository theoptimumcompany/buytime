// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateState _$TemplateStateFromJson(Map<String, dynamic> json) {
  return TemplateState(
    name: json['name'] as String,
    data: json['data'] == null
        ? null
        : TemplateDataState.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TemplateStateToJson(TemplateState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'data': instance.data?.toJson(),
    };
