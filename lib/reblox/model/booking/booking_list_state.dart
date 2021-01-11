import 'package:BuyTime/reblox/model/booking/booking_state.dart';
import 'package:flutter/foundation.dart';


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

  BookingListState.fromJson(Map json)
      : bookingListState = json['bookingListState'];

  Map<String, dynamic> toJson() => {
    'bookingListState': bookingListState
  };

  BookingListState toEmpty() {
    return BookingListState(bookingListState: List<BookingState>());
  }

}