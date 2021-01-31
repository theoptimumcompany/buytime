import 'package:Buytime/reblox/model/booking/booking_state.dart';

class AddBooking {
  BookingState _bookingState;

  AddBooking(this._bookingState);

  BookingState get bookingState => _bookingState;
}

class CreateBookingRequest {
  BookingState _bookingState;

  CreateBookingRequest(this._bookingState);

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


BookingState bookingReducer(BookingState state, action) {
  BookingState bookingState = new BookingState.fromState(state);
  
  if (action is AddBooking) {
    bookingState = action.bookingState.copyWith();
    return bookingState;
  }
  if (action is DeleteBooking) {
    bookingState = BookingState().toEmpty();
    return bookingState;
  }
  
  return state;
}
