import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'booking_state.g.dart';

enum BookingStatus {
  opened,
  closed,
  sent,
  canceld,
  created,
  empty
}

@JsonSerializable(explicitToJson: true)
class BookingState {
  String business_id;
  String booking_id;
  String business_name;
  String business_address;
  int guest_number_booked_for;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime start_date;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime end_date;
  String booking_code;
  List<String> userEmail;
  List<UserSnippet> user;
  String status;
  String wide;

  BookingState({
    @required this.business_id,
    this.booking_id,
    @required this.business_name,
    @required this.business_address,
    @required this.guest_number_booked_for,
    @required this.start_date,
    @required this.end_date,
    @required this.booking_code,
    @required this.userEmail,
    @required this.user,
    @required this.status,
    @required this.wide,
  });

  BookingState toEmpty() {
    return BookingState(
      business_id: "",
      booking_id: "",
      business_name: "",
      business_address: "",
      guest_number_booked_for: 0,
      start_date: DateTime.now(),
      end_date: DateTime.now(),
      booking_code: "",
      userEmail: [],
      user: [],
      status: Utils.enumToString(BookingStatus.empty),
      wide: "",
    );
  }



  BookingState.fromState(BookingState state) {
    this.business_id = state.business_id;
    this.booking_id = state.booking_id;
    this.business_name = state.business_name;
    this.business_address = state.business_address;
    this.guest_number_booked_for = state.guest_number_booked_for;
    this.start_date = state.start_date;
    this.end_date = state.end_date;
    this.booking_code = state.booking_code;
    this.userEmail = state.userEmail;
    this.user = state.user;
    this.status = state.status;
    this.wide = state.wide;
  }

  BookingState copyWith({
    String business_id,
    String booking_id,
    String business_name,
    String business_address,
    int guest_number_booked_for,
    DateTime start_date,
    DateTime end_date,
    String booking_code,
    List<String> userEmail,
    List<GenericState> user,
    String status,
    String wide,
  }) {
    return BookingState(
      business_id: business_id ?? this.business_id,
      booking_id: booking_id ?? this.booking_id,
      business_name: business_name ?? this.business_name,
      business_address: business_address ?? this.business_address,
      guest_number_booked_for: guest_number_booked_for ?? this.guest_number_booked_for,
      start_date: start_date ?? this.start_date,
      end_date: end_date ?? this.end_date,
      booking_code: booking_code ?? this.booking_code,
      userEmail: userEmail ?? this.userEmail,
      user: user ?? this.user,
      status: status ?? this.status,
      wide: wide ?? this.wide,
    );
  }

  factory BookingState.fromJson(Map<String, dynamic> json) => _$BookingStateFromJson(json);
  Map<String, dynamic> toJson() => _$BookingStateToJson(this);

}
