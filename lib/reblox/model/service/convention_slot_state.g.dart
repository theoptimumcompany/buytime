// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'convention_slot_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConventionSlot _$ConventionSlotFromJson(Map<String, dynamic> json) {
  return ConventionSlot(
    hubName: json['hubName'] as String ?? '',
    hubId: json['hubId'] as String ?? '',
    discount: json['discount'] as int ?? 0,
  );
}

Map<String, dynamic> _$ConventionSlotToJson(ConventionSlot instance) =>
    <String, dynamic>{
      'hubName': instance.hubName,
      'hubId': instance.hubId,
      'discount': instance.discount,
    };
