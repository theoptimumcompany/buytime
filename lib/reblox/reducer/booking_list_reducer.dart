/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/


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
    debugPrint('booking_list_reducer: bookingListState : ${bookingListState.bookingListState.length}');
    debugPrint('booking_list_reducer: action: ${action.bookingListState}');
    print("Nel reducer booking List");
    return bookingListState;
  }
  if (action is UserBookingListReturned) {
    bookingListState = BookingListState(bookingListState: action.bookingListState).copyWith();
    debugPrint('booking_list_reducer: bookingListState : ${bookingListState.bookingListState.length}');
    debugPrint('booking_list_reducer: action: ${action.bookingListState}');
    print("Nel reducer booking List");
    return bookingListState;
  }
  return state;
}