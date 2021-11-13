// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_invite_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryInviteState _$CategoryInviteStateFromJson(Map<String, dynamic> json) {
  return CategoryInviteState(
    id: json['id'] as String,
    id_business: json['id_business'] as String,
    id_category: json['id_category'] as String,
    mail: json['mail'] as String,
    link: json['link'] as String,
    role: json['role'] as String,
    timestamp: Utils.getDate(json['timestamp'] as Timestamp),
  );
}

Map<String, dynamic> _$CategoryInviteStateToJson(
        CategoryInviteState instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_business': instance.id_business,
      'id_category': instance.id_category,
      'mail': instance.mail,
      'link': instance.link,
      'role': instance.role,
      'timestamp': Utils.setDate(instance.timestamp),
    };
