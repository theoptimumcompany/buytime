// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_list_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingListState _$BookingListStateFromJson(Map<String, dynamic> json) {
  return BookingListState(
    bookingListState: (json['bookingListState'] as List)
        ?.map((e) =>
            e == null ? null : BookingState.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BookingListStateToJson(BookingListState instance) =>
    <String, dynamic>{
      'bookingListState':
          instance.bookingListState?.map((e) => e?.toJson())?.toList(),
    };
