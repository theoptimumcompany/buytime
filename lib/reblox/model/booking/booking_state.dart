import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:flutter/foundation.dart';

class BookingState {
  String business_id;
  String booking_id;
  String business_name;
  String business_address;
  int guest_number_booked_for;
  DateTime start_date;
  DateTime end_date;
  String booking_code;
  List<ObjectState> user;
  String state; //TODO Change to Enum
  String wide_card_photo;

  List<dynamic> convertToJson(List<ObjectState> objectStateList) {
    List<dynamic> list = List<dynamic>();
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
    @required this.user,
    @required this.state,
    @required this.wide_card_photo,
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
      user: [],
      state: "",
      wide_card_photo: "",
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
    this.user = state.user;
    this.state = state.state;
    this.wide_card_photo = state.wide_card_photo;
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
    List<ObjectState> user,
    String state,
    String wide_card_photo,
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
      user: user ?? this.user,
      state: state ?? this.state,
      wide_card_photo: wide_card_photo ?? this.wide_card_photo,
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
    List<ObjectState> user,
    String state,
    String wide_card_photo,
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
      user: user ?? this.user,
      state: state ?? this.state,
      wide_card_photo: wide_card_photo ?? this.wide_card_photo,
    );
  }

  BookingState.fromJson(Map<String, dynamic> json)
      : business_id = json['business_id'],
        booking_id = json['booking_id'],
        business_name = json['business_name'],
        business_address = json['business_address'],
        guest_number_booked_for = json['guest_number_booked_for'],
        start_date = json['start_date'].toDate(),
        end_date = json['end_date'].toDate(),
        booking_code = json['booking_code'],
        user = List<ObjectState>.from(json["user"].map((item) {
          return new ObjectState(
            name: item["name"] != null ? item["name"] : "",
            id: item["id"] != null ? item["id"] : "",
            // name: item["name"],
            // id: item["id"],
          );
        })),
        state = json['state'],
        wide_card_photo = json['wide_card_photo'];

  Map<String, dynamic> toJson() => {
        'business_id': business_id,
        'booking_id': booking_id,
        'business_name': business_name,
        'business_address': business_address,
        'guest_number_booked_for': guest_number_booked_for,
        'start_date': start_date,
        'end_date': end_date,
        'booking_code': booking_code,
        'user': convertToJson(user),
        'state': state,
        'wide_card_photo': wide_card_photo
      };
}