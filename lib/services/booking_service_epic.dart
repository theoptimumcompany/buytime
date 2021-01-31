import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingCreateRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateBookingRequest>().asyncMap((event) async {
      print("BookingServiceEpic document id:" + event.bookingState.business_id);

      // create a unique booking code for this booking
      String randomBookingCodeCandidate;
      bool foundRandomCode = false;
      for ( int i = 0; i < 5; i++ ) { // WARNING, every booking we do tops 5 reads to mitigate collisions.
        // This has a really low chance of generating a booking without a code. this is on purpose, to avoid infinite loop risk in a read statement.
        randomBookingCodeCandidate = Utils.getRandomBookingCode(6);
        print('generateBookingCode random booking code candidate: ' + randomBookingCodeCandidate);
        // search if the code already exists
        var bookingCodeCollision = await FirebaseFirestore.instance.collection("booking").where("booking_code", isEqualTo: randomBookingCodeCandidate).get();
        if (bookingCodeCollision.size > 0) {
          print('generateBookingCode code collision happening for code: ' + randomBookingCodeCandidate);
        } else {
            // the candidate is ok, we can break and use it
            foundRandomCode = true;
            break;
        }
      }
      if (foundRandomCode) {
        print('generateBookingCode creating booking for business: ' + event.bookingState.business_id);
        event.bookingState.booking_code = randomBookingCodeCandidate;
        // create a booking
        var addingReturn = await FirebaseFirestore.instance.collection("booking").add(event.bookingState.toJson());
        print('BookingServiceEpic: $addingReturn');
      } else {
        // TODO notify the user something went wrong and he has to try again.
        // example: return new ErrorInBookingCreation(event.bookingState);
      }
      return new AddBooking(event.bookingState);
    }).expand((element) => [ClosedRequestBooking('Request success')]);
  }
}
