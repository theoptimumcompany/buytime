import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'booking_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingListState {
  List<BookingState> bookingListState;

  BookingListState({
    @required this.bookingListState,
  });

  BookingListState.fromState(BookingListState state) {
    this.bookingListState = state.bookingListState ;
  }

  companyStateFieldUpdate(List<BookingState> bookingListState) {
    BookingListState(
      bookingListState: bookingListState ?? this.bookingListState
    );
  }

  BookingListState copyWith({bookingListState}) {
    return BookingListState(
      bookingListState: bookingListState ?? this.bookingListState
    );
  }

  BookingListState toEmpty() {
    return BookingListState(bookingListState: List<BookingState>());
  }

  factory BookingListState.fromJson(Map<String, dynamic> json) => _$BookingListStateFromJson(json);
  Map<String, dynamic> toJson() => _$BookingListStateToJson(this);


}