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

class CreateSelfBookingRequest {
  BookingState _bookingState;
  String _idBusiness;

  CreateSelfBookingRequest(this._bookingState,this._idBusiness);

  BookingState get bookingState => _bookingState;
  String get idBusiness => _idBusiness;
}

class ConfirmBookingRequest {
  BookingState _bookingState;

  ConfirmBookingRequest(this._bookingState);

  BookingState get bookingState => _bookingState;
}

class ConfirmedBookingRequest {
  BookingState _bookingState;

  ConfirmedBookingRequest(this._bookingState);

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

class UpdateBooking {
  //BookingStatus _bookingStatus;
  //String _bookingId;
  BookingState _bookingState;

  UpdateBooking(this._bookingState);

  //BookingStatus get bookingStatus => _bookingStatus;
  //String get bookingId => _bookingId;
  BookingState get bookingState => _bookingState;
}
class UpdateBookingOnConfirm {
  //BookingStatus _bookingStatus;
  //String _bookingId;
  BookingState _bookingState;

  UpdateBookingOnConfirm(this._bookingState);

  //BookingStatus get bookingStatus => _bookingStatus;
  //String get bookingId => _bookingId;
  BookingState get bookingState => _bookingState;
}

class UpdatedBooking {
  //BookingStatus _bookingStatus;
  //String _bookingId;
  BookingState _bookingState;

  UpdatedBooking(this._bookingState);

  //BookingStatus get bookingStatus => _bookingStatus;
  //String get bookingId => _bookingId;
  BookingState get bookingState => _bookingState;
}

class SetBookingToEmpty {
  String _something;
  SetBookingToEmpty(this._something);
  String get something => _something;
}


BookingState bookingReducer(BookingState state, action) {
  BookingState bookingState = new BookingState.fromState(state);
  
  if (action is AddBooking) {
    bookingState = action.bookingState.copyWith();
    debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return bookingState;
  }

  if (action is BookingRequestResponse) {
    bookingState = action.bookingState.copyWith();
    //debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return bookingState;
  }

  if (action is ConfirmedBookingRequest) {
    bookingState = action.bookingState.copyWith();
    debugPrint('booking_reducer: ${bookingState.user.first.name}');
    return bookingState;
  }

  if (action is DeleteBooking) {
    bookingState = BookingState().toEmpty();
    return bookingState;
  }

  if (action is UpdatedBooking) {
    //debugPrint('booking_reducer: action: ${action.bookingStatus}');
    bookingState = action.bookingState.copyWith();
    debugPrint('booking_reducer: booking status: ${bookingState.status}');
    return bookingState;
  }
  if (action is SetBookingToEmpty) {
    bookingState = BookingState().toEmpty();
    return bookingState;
  }
  return state;
}
