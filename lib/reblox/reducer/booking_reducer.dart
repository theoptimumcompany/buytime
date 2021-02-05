import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:flutter/material.dart';

class AddBooking {
  BookingState _bookingState;

  AddBooking(this._bookingState);

  BookingState get bookingState => _bookingState;
}

class BookingRequest {
  String _bookingId;

  BookingRequest(this._bookingId);

  String get bookingId => _bookingId;
}

class CreateBookingRequest {
  BookingState _bookingState;

  CreateBookingRequest(this._bookingState);

  BookingState get bookingState => _bookingState;
}

class BookingRequestResponse {
  BookingState _bookingState;

  BookingRequestResponse(this._bookingState);

  BookingState get bookingState => _bookingState;
}

class DeleteBooking {
  BookingState _bookingState;

  DeleteBooking();

  BookingState get bookingState => _bookingState;
}

class SendRequestBooking {
  String _sendRequestBooking;

  SendRequestBooking(this._sendRequestBooking);

  String get sendRequestBooking => _sendRequestBooking;
}

class ClosedRequestBooking {
  String _closedRequestBooking;

  ClosedRequestBooking(this._closedRequestBooking);

  String get closedRequestBooking => _closedRequestBooking;
}

class SetBookingStatus {
  BookingStatus _bookingStatus;

  SetBookingStatus(this._bookingStatus);

  BookingStatus get bookingStatus => _bookingStatus;
}


BookingState bookingReducer(BookingState state, action) {
  BookingState bookingState = new BookingState.fromState(state);
  
  if (action is AddBooking) {
    bookingState = action.bookingState.copyWith();
    debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return bookingState;
  }

  if (action is DeleteBooking) {
    bookingState = BookingState().toEmpty();
    return bookingState;
  }

  if (action is SetBookingStatus) {
    debugPrint('booking_reducer: action: ${action.bookingStatus}');
    bookingState.status = bookingState.enumToString(action.bookingStatus);
    debugPrint('booking_reducer: booking status: ${bookingState.status}');
    return bookingState;
  }
  
  return state;
}
