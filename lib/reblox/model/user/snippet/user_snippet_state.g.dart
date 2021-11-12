// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_snippet_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSnippet _$UserSnippetFromJson(Map<String, dynamic> json) {
  return UserSnippet(
    id: json['id'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$UserSnippetToJson(UserSnippet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
    };
