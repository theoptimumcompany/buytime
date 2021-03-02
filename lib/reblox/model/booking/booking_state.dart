import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:flutter/foundation.dart';

enum BookingStatus {
  opened,
  closed,
  sent,
  canceld,
  created,
  empty
}


class BookingState {
  String business_id;
  String booking_id;
  String business_name;
  String business_address;
  int guest_number_booked_for;
  DateTime start_date;
  DateTime end_date;
  String booking_code;
  List<String> userEmail;
  List<UserSnippet> user;
  String status; //TODO Change to Enum
  String wide;

  List<dynamic> convertToJson(List<UserSnippet> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

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
      start_date: new DateTime.now(),
      end_date: new DateTime.now(),
      booking_code: "",
      userEmail: [],
      user: [],
      status: enumToString(BookingStatus.empty),
      wide: "",
    );
  }

  String enumToString(BookingStatus bookingStatus){
    return bookingStatus.toString().split('.').last;
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

  companyStateFieldUpdate(
    String business_id,
    String booking_id,
    String business_name,
    String business_address,
    int guest_number_booked_for,
    DateTime start_date,
    DateTime end_date,
    String booking_code,
    List<String> userEmail,
    List<UserSnippet> user,
    String status,
    String wide,
  ) {
    BookingState(
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

  BookingState.fromJson(Map<String, dynamic> json)
      : business_id = json['business_id'],
        booking_id = json['booking_id'],
        business_name = json['business_name'],
        business_address = json['business_address'],
        guest_number_booked_for = json['guest_number_booked_for'],
        /*start_date = DateTime(json['start_date'].toDate().year,json['start_date'].toDate().month, json['start_date'].toDate().day).toUtc(),
        end_date = DateTime(json['end_date'].toDate().year,json['end_date'].toDate().month, json['end_date'].toDate().day).toUtc(),*/
        start_date = DateTime.fromMillisecondsSinceEpoch(json['start_date'].seconds * 1000).toUtc(),
        end_date = DateTime.fromMillisecondsSinceEpoch(json['end_date'].seconds * 1000).toUtc(),
        booking_code = json['booking_code'],
        userEmail = json["userEmail"] != null ? List<String>.from(json["userEmail"]) : [],
        user = List<UserSnippet>.from(json["user"].map((item) {
          return new UserSnippet(
            name: item["name"] != null ? item["name"] : "",
            surname: item["surname"] != null ? item["surname"] : "",
            email: item["email"] != null ? item["email"] : "",
            //id: item["id"] != null ? item["id"] : "",
          );
        })),
        status = json['status'],
        wide = json['wide'];

  Map<String, dynamic> toJson() => {
        'business_id': business_id,
        'booking_id': booking_id,
        'business_name': business_name,
        'business_address': business_address,
        'guest_number_booked_for': guest_number_booked_for,
        'start_date': start_date,
        'end_date': end_date,
        'booking_code': booking_code,
        'userEmail': userEmail,
        'user': convertToJson(user),
        'status': status,
        'wide': wide
      };
}
