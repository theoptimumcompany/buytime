// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) {
  return UserState(
    name: json['name'] as String,
    surname: json['surname'] as String,
    email: json['email'] as String,
    uid: json['uid'] as String,
    birth: json['birth'] as String,
    gender: json['gender'] as String,
    city: json['city'] as String,
    street: json['street'] as String,
    nation: json['nation'] as String,
    cellularPhone: json['cellularPhone'] as int,
    zip: json['zip'] as int,
    owner: json['owner'] as bool,
    salesman: json['salesman'] as bool,
    manager: json['manager'] as bool,
    admin: json['admin'] as bool,
    worker: json['worker'] as bool,
    photo: json['photo'] as String,
    device: (json['device'] as List)?.map((e) => e as String)?.toList(),
    token: (json['token'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'email': instance.email,
      'uid': instance.uid,
      'birth': instance.birth,
      'gender': instance.gender,
      'city': instance.city,
      'zip': instance.zip,
      'street': instance.street,
      'nation': instance.nation,
      'cellularPhone': instance.cellularPhone,
      'owner': instance.owner,
      'salesman': instance.salesman,
      'manager': instance.manager,
      'admin': instance.admin,
      'worker': instance.worker,
      'photo': instance.photo,
      'device': instance.device,
      'token': instance.token,
    };
