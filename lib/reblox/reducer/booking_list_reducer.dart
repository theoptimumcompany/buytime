
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:flutter/material.dart';

class BookingListRequest {
  String _businessId;
  BookingListRequest(this._businessId);
  String get businessId => _businessId;
}
class UserBookingListRequest {
  String _userEmail;
  bool fromConfirm;
  UserBookingListRequest(this._userEmail, this.fromConfirm);
  String get userEmail => _userEmail;
}
class BookingListReturned {
  List<BookingState> _bookingListState;
  BookingListReturned(this._bookingListState);
  List<BookingState> get bookingListState => _bookingListState;
}

class UserBookingListReturned {
  List<BookingState> _bookingListState;
  UserBookingListReturned(this._bookingListState);
  List<BookingState> get bookingListState => _bookingListState;
}

class SetBookingListToEmpty {
  String _something;
  SetBookingListToEmpty();
  String get something => _something;
}

BookingListState bookingListReducer(BookingListState state, action) {
  BookingListState bookingListState = new BookingListState.fromState(state);
  if (action is SetBookingListToEmpty) {
    bookingListState = BookingListState().toEmpty();
    return bookingListState;
  }
  if (action is BookingListReturned) {
    bookingListState = BookingListState(bookingListState: action.bookingListState).copyWith();
    debugPrint('booking_list_reducer => bookingListState : ${bookingListState.bookingListState.length}');
    debugPrint('booking_list_reducer => action: ${action.bookingListState}');
    print("Nel reducer booking List");
    return bookingListState;
  }
  if (action is UserBookingListReturned) {
    bookingListState = BookingListState(bookingListState: action.bookingListState).copyWith();
    debugPrint('booking_list_reducer => bookingListState : ${bookingListState.bookingListState.length}');
    debugPrint('booking_list_reducer => action: ${action.bookingListState}');
    debugPrint("booking_list_reducer => Nel reducer booking List");
    return bookingListState;
  }
  return state;
}