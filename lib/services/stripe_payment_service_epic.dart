import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/stripe/stripe_card_response.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";

final Stripe stripe = Stripe(
  stripeKey,
  stripeAccount: "acct_1HS20eHr13hxRBpC",
  returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
);

class StripePaymentAddPaymentMethod implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
      Map<String,dynamic> stripePaymentMethod = event.stripePaymentMethod;
      String userId = event.userId;

      if (userId.isNotEmpty) {
        // requesting secretKey
        var stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId).get();
        print("stripe_payment_service SetupIntentSecret got from firestore ");
        String customerSecret = stripeCustomerReference.get("stripeCustomerSecret");

        // saving payment method on firebase
        await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/token/").doc().set(stripePaymentMethod);
        print("stripe_payment_service PaymentMethod added to firestore "); // this will trigger the creation of a new stripeIntent to be used in the next request
        String paymentMethodId = stripePaymentMethod["id"];

        // confirm the setupIntent (and in doing so add the card to stripe)
        Future<Map<String,dynamic>> confirmationResult = stripe.api.confirmSetupIntent(customerSecret,data: {'payment_method': paymentMethodId});
        var confirmationResultResolved = await confirmationResult;
        if (event.stripePaymentMethod['card'] != null && event.stripePaymentMethod['card']['three_d_secure_usage'] != null){
          print("stripe_payment_service paymentMethod requires 3D secure auth ");
          if ( confirmationResultResolved['next_action'] != null &&  confirmationResultResolved['next_action']['use_stripe_sdk'] != null && confirmationResultResolved['next_action']['use_stripe_sdk']['stripe_js'] != null ) {
            var card3Dsecurelink = confirmationResultResolved['next_action']['use_stripe_sdk']['stripe_js'];
            if (await canLaunch(card3Dsecurelink)) {
              await launch(card3Dsecurelink);
            } else {
              throw 'Could not launch $card3Dsecurelink';
              // return "problems with 3D auth";
            }
          }
        }

        // save the card also on firestore
        var stripeCardOnFirebase = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/card/").doc().set(confirmationResultResolved);

        // ask for the card list
        return new StripeCardListRequest(userId);
      } else {
        print("userId is empty, cannot create payment method");
      }
    });
  }
}


class StripePaymentCardListRequest implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<StripeCardListRequest>().asyncMap((event) async {
      String userId = event.firebaseUserId;
      var snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/card/").get();
      bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;

      var snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/token/").get();
      bool snapshotTokenAvailable = snapshotToken != null && snapshotToken.docs != null && snapshotToken.docs.isNotEmpty;

      if (snapshotTokenAvailable && snapshotCardAvailable) {
        var tokenData = snapshotToken?.docs[0]?.data();
        return new StripeCardListResult(StripeCardResponse(
          firestore_id: snapshotCard?.docs[0]?.id,
          last4: tokenData['card']['last4'],
          expYear: tokenData['card']['exp_year'],
          expMonth: tokenData['card']['exp_month'],
          brand: tokenData['card']['brand'],
        ));
      }
      return null;
      // return new StripeCardListResult(StripeCardResponse());
    });
  }
}

class StripeDetachPaymentMethodRequest implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateDisposePaymentMethodIntent>().asyncMap((event) async {
      print("stripe_payment_service_epic" + event.userId.toString());
      // create detach document
      await FirebaseFirestore.instance.collection("stripeCustomer/" + event.userId + "/detach/").doc().set({
        'firestore_id': event.stripePaymentMethodResponse.firestore_id
      });
      print("stripe_payment_service_epic, detach document created");
      // call the endpoint to trigger the cloud function for the detach
      final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/detachPaymentMethod?userId=' + event.userId.toString());
      // handle the result to refresh the card list or show an error dialog
      if (response != null && response.body.contains("error")) {
        return new ErrorDisposePaymentMethodIntent(response.body);
      } else {
        return new DisposedPaymentMethodIntent();
      }
    });
  }
}

// Stream<dynamic> stripePaymentCardListRequestEpic(Stream<dynamic> actions, EpicStore<AppState> store) {
//   return actions
//       .where((action) => action is StripeCardListRequest)
//       .asyncMap((action) async {
//         String userId = action.firebaseUserId;
//         var snapshot = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/token/").get();
//         var tokenData = snapshot?.docs[0]?.data();
//         return new StripeCardListResult(StripeCardResponse(
//           last4: tokenData['last4'],
//           expYear: tokenData['exp_year'],
//           expMonth: tokenData['exp_month'],
//         ));
//   });
// }