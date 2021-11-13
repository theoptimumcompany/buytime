// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_data_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateDataState _$TemplateDataStateFromJson(Map<String, dynamic> json) {
  return TemplateDataState(
    name: json['name'] as String,
    link: json['link'] as String,
    userEmail: json['userEmail'] as String,
    businessName: json['businessName'] as String,
    businessId: json['businessId'] as String,
    searched: json['searched'] as String,
  );
}

Map<String, dynamic> _$TemplateDataStateToJson(TemplateDataState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'link': instance.link,
      'userEmail': instance.userEmail,
      'businessName': instance.businessName,
      'businessId': instance.businessId,
      'searched': instance.searched,
    };
