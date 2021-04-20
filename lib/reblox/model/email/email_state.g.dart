// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailState _$EmailStateFromJson(Map<String, dynamic> json) {
  return EmailState(
    to: json['to'] as String,
    cc: json['cc'] as String,
    template: json['template'] == null
        ? null
        : TemplateState.fromJson(json['template'] as Map<String, dynamic>),
    sent: json['sent'] as bool,
  );
}

Map<String, dynamic> _$EmailStateToJson(EmailState instance) =>
    <String, dynamic>{
      'to': instance.to,
      'cc': instance.cc,
      'template': instance.template?.toJson(),
      'sent': instance.sent,
    };
