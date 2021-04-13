// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenB _$TokenBFromJson(Map<String, dynamic> json) {
  return TokenB(
    id: json['id'] as String,
    name: json['name'] as String,
    user_uid: json['user_uid'] as String,
  );
}

Map<String, dynamic> _$TokenBToJson(TokenB instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_uid': instance.user_uid,
    };
