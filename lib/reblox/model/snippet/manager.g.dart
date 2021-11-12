// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manager _$ManagerFromJson(Map<String, dynamic> json) {
  return Manager(
    id: json['id'] as String,
    mail: json['mail'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
  );
}

Map<String, dynamic> _$ManagerToJson(Manager instance) => <String, dynamic>{
      'id': instance.id,
      'mail': instance.mail,
      'name': instance.name,
      'surname': instance.surname,
    };
