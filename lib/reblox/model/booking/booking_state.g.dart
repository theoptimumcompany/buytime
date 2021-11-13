// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingState _$BookingStateFromJson(Map<String, dynamic> json) {
  return BookingState(
    business_id: json['business_id'] as String,
    booking_id: json['booking_id'] as String,
    business_name: json['business_name'] as String,
    business_address: json['business_address'] as String,
    guest_number_booked_for: json['guest_number_booked_for'] as int,
    start_date: Utils.getDate(json['start_date'] as Timestamp),
    end_date: Utils.getDate(json['end_date'] as Timestamp),
    booking_code: json['booking_code'] as String,
    userEmail: (json['userEmail'] as List)?.map((e) => e as String)?.toList(),
    user: (json['user'] as List)
        ?.map((e) =>
            e == null ? null : UserSnippet.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    status: json['status'] as String,
    wide: json['wide'] as String,
  );
}

Map<String, dynamic> _$BookingStateToJson(BookingState instance) =>
    <String, dynamic>{
      'business_id': instance.business_id,
      'booking_id': instance.booking_id,
      'business_name': instance.business_name,
      'business_address': instance.business_address,
      'guest_number_booked_for': instance.guest_number_booked_for,
      'start_date': Utils.setDate(instance.start_date),
      'end_date': Utils.setDate(instance.end_date),
      'booking_code': instance.booking_code,
      'userEmail': instance.userEmail,
      'user': instance.user?.map((e) => e?.toJson())?.toList(),
      'status': instance.status,
      'wide': instance.wide,
    };
