// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Worker _$WorkerFromJson(Map<String, dynamic> json) {
  return Worker(
    id: json['id'] as String,
    mail: json['mail'] as String,
    name: json['name'] as String,
    surname: json['surname'] as String,
  );
}

Map<String, dynamic> _$WorkerToJson(Worker instance) => <String, dynamic>{
      'id': instance.id,
      'mail': instance.mail,
      'name': instance.name,
      'surname': instance.surname,
    };
