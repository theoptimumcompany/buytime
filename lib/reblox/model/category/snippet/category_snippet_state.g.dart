// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySnippet _$CategorySnippetFromJson(Map<String, dynamic> json) {
  return CategorySnippet(
    numberOfServices: json['numberOfServices'] as int,
    mostSoldService: json['mostSoldService'] == null
        ? null
        : ServiceState.fromJson(
            json['mostSoldService'] as Map<String, dynamic>),
    numberOfManagers: json['numberOfManagers'] as int,
    numberOfWorkers: json['numberOfWorkers'] as int,
  );
}

Map<String, dynamic> _$CategorySnippetToJson(CategorySnippet instance) =>
    <String, dynamic>{
      'numberOfServices': instance.numberOfServices,
      'mostSoldService': instance.mostSoldService?.toJson(),
      'numberOfManagers': instance.numberOfManagers,
      'numberOfWorkers': instance.numberOfWorkers,
    };
