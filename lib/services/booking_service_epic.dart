import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingCreateRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBookingRequest>().asyncMap((event) async {
      print("BookingServiceEpic document id:" + event.bookingState.business_id);

      var addingReturn = await FirebaseFirestore.instance.collection("booking").add(event.bookingState.toJson());
      print('BookingServiceEpic: $addingReturn');

      return new AddBooking(event.bookingState);
    });
  }
}
