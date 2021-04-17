import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";

// final Stripe stripe = Stripe(
//   stripeTestKey,
//   stripeAccount: "acct_1HS20eHr13hxRBpC",
//   returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
// );

class StripePaymentAddPaymentMethod implements EpicClass<AppState> {
  String userId = '';
  StatisticsState statisticsState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
      Map<String,dynamic> stripePaymentMethod = event.stripePaymentMethod;
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID: ${event.userId}");
      userId = event.userId + '_test';

      if (userId.isNotEmpty) {
        // requesting secretKey
        DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId).get(); /// 1 READ - 1 DOC
        debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => SetupIntentSecret got from firestore");
        String customerSecret = stripeCustomerReference.get("stripeCustomerSecret");

        // saving payment method on firebase
        await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/token/").doc().set(stripePaymentMethod); /// 1 WRITE
        debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Added to firestore"); // this will trigger the creation of a new stripeIntent to be used in the next request
        String paymentMethodId = stripePaymentMethod["id"];

        // confirm the setupIntent (and in doing so add the card to stripe)
        // Future<Map<String,dynamic>> confirmationResult = stripe.api.confirmSetupIntent(customerSecret,data: {'payment_method': paymentMethodId});
        // var confirmationResultResolved = await confirmationResult;
        // if (event.stripePaymentMethod['card'] != null && event.stripePaymentMethod['card']['three_d_secure_usage'] != null){
        //   debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Requires 3D secure auth");
        //   if ( confirmationResultResolved['next_action'] != null &&  confirmationResultResolved['next_action']['use_stripe_sdk'] != null && confirmationResultResolved['next_action']['use_stripe_sdk']['stripe_js'] != null ) {
        //     var card3Dsecurelink = confirmationResultResolved['next_action']['use_stripe_sdk']['stripe_js'];
        //     if (await canLaunch(card3Dsecurelink)) {
        //       await launch(card3Dsecurelink);
        //     } else {
        //       throw 'Could not launch $card3Dsecurelink';
        //       // return "problems with 3D auth";
        //     }
        //   }
        // }

        // save the card also on firestore
        // await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/card/").doc().set(confirmationResultResolved); /// 1 WRITE

        // ask for the card list

        statisticsState = store.state.statistics;
        int reads = statisticsState.stripePaymentAddPaymentMethodRead;
        int writes = statisticsState.stripePaymentAddPaymentMethodWrite;
        int documents = statisticsState.stripePaymentAddPaymentMethodDocuments;
        debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        ++reads;
        writes = writes + 2;
        ++documents;
        debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        statisticsState.stripePaymentAddPaymentMethodRead = reads;
        statisticsState.stripePaymentAddPaymentMethodWrite = writes;
        statisticsState.stripePaymentAddPaymentMethodDocuments = documents;

        ///Return
        //return new StripeCardListRequest(userId);
      } else {
        debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID is empty, cannot create payment method");
      }
    }).expand((element) => [
      userId.isNotEmpty ? StripeCardListRequest(userId) : null,
      UpdateStatistics(statisticsState),
    ]);
  }
}

/// Checks if the stripe_customer document for the current logged in user has been created,
/// always checks the production document.
/// If the production document has been created, the test document should also be there.
class CheckStripeCustomerService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String userId = '';
  bool stripeCustomerCreated = false;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CheckStripeCustomer>().asyncMap((event) async {
      userId = store.state.user.uid;
      debugPrint("stripe_payment_service_epic: CheckStripeCustomerService - searching for a stripe customer");
      if (userId.isNotEmpty) {
        DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId).get(); /// 1 READ
        statisticsState = store.state.statistics;
        statisticsState.stripeCheckCustomerRead = statisticsState.stripeCheckCustomerRead + 1;
        if (stripeCustomerReference.exists) {
          stripeCustomerCreated = true;
          debugPrint("stripe_payment_service_epic: CheckStripeCustomerService - a stripe customer has been found");
        }
      }
    }).expand((element) => [
      CheckedStripeCustomer(stripeCustomerCreated),
      UpdateStatistics(statisticsState),
      stripeCustomerCreated ? StripeListCardListRequest('${userId}_test') : null,
      ///TODO change the null value with the error popup action
      ///TODO Remember _test when switching to production
    ]);
  }
}


// class StripePaymentCardListRequest implements EpicClass<AppState> {
//   StatisticsState statisticsState;
//   List<StripeState> stripeListState = [];
//   StripeCardResponse stripeCardResponse;
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     return actions.whereType<StripeCardListRequest>().asyncMap((event) async {
//       debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => USER ID: ${event.firebaseUserId}");
//       String userId = event.firebaseUserId;
//       QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/card/").limit(10).get(); /// 1 READ - ? DOC
//       int snapshotCardDocs = snapshotCard.docs.length;
//       bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;
//
//       QuerySnapshot snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/token/").limit(10).get(); /// 1 READ - ? DOC
//       int snapshotTokenDocs = snapshotToken.docs.length;
//       bool snapshotTokenAvailable = snapshotToken != null && snapshotToken.docs != null && snapshotToken.docs.isNotEmpty;
//
//
//
//       if (snapshotTokenAvailable && snapshotCardAvailable) {
//         debugPrint('stripe_payment_service_epic => CARD LENGTH: $snapshotCardDocs');
//         snapshotCard.docs.forEach((element) {
//           debugPrint('stripe_payment_service_epic => ID: ${element.id}');
//         });
//         debugPrint('stripe_payment_service_epic => TOKEN LENGTH: $snapshotTokenDocs');
//         /*snapshotToken.docs.forEach((element) {
//           var tokenData = element.data();
//           stripeListState.add(
//               StripeState(
//                 stripeCard: StripeCardResponse(
//                   firestore_id: snapshotCard?.docs[0]?.id,
//                   last4: tokenData['card']['last4'],
//                   expYear: tokenData['card']['exp_year'],
//                   expMonth: tokenData['card']['exp_month'],
//                   brand: tokenData['card']['brand'],
//                 )
//               )
//           );
//         });*/
//
//
//         var tokenData = snapshotToken?.docs[0]?.data();
//         stripeCardResponse = StripeCardResponse(
//           firestore_id: snapshotCard?.docs[0]?.id,
//           last4: tokenData['card']['last4'],
//           expYear: tokenData['card']['exp_year'],
//           expMonth: tokenData['card']['exp_month'],
//           brand: tokenData['card']['brand'],
//         );
//         ///Return
//         /*return new StripeCardListResult(StripeCardResponse(
//           firestore_id: snapshotCard?.docs[0]?.id,
//           last4: tokenData['card']['last4'],
//           expYear: tokenData['card']['exp_year'],
//           expMonth: tokenData['card']['exp_month'],
//           brand: tokenData['card']['brand'],
//         ));*/
//       }
//
//       statisticsState = store.state.statistics;
//       int reads = statisticsState.stripePaymentCardListRequestRead;
//       int writes = statisticsState.stripePaymentCardListRequestWrite;
//       int documents = statisticsState.stripePaymentCardListRequestDocuments;
//       debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       reads = reads + 2;
//       documents = documents + snapshotCardDocs + snapshotTokenDocs;
//       debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
//       statisticsState.stripePaymentCardListRequestRead = reads;
//       statisticsState.stripePaymentCardListRequestWrite = writes;
//       statisticsState.stripePaymentCardListRequestDocuments = documents;
//
//       /*List<CardState> tmpList = [];
//       CardState cardState = CardState().toEmpty();
//       cardState.stripeState = snapshot?.stripe;
//       tmpList.add(cardState);
//       StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));*/
//       ///Return
//       //return null;
//       // return new StripeCardListResult(StripeCardResponse());
//     }).expand((element) => [
//       stripeListState != null ? StripeCardListResult(stripeCardResponse) : null,
//       UpdateStatistics(statisticsState),
//     ]);
//   }
// }

class StripeListPaymentCardListRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<StripeState> stripeListState;
  StripeCardResponse stripeCardResponse;
  List<CardState> tmp;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<StripeListCardListRequest>().asyncMap((event) async {
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => USER ID: ${event.firebaseUserId}");
      String userId = event.firebaseUserId;
      stripeListState = [];
      tmp = [];
      QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/card/").limit(10).get(); /// 1 READ - ? DOC
      int snapshotCardDocs = snapshotCard.docs.length;
      bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;

      QuerySnapshot snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" +userId + "/token/").limit(10).get(); /// 1 READ - ? DOC
      int snapshotTokenDocs = snapshotToken.docs.length;
      bool snapshotTokenAvailable = snapshotToken != null && snapshotToken.docs != null && snapshotToken.docs.isNotEmpty;



      if (snapshotTokenAvailable && snapshotCardAvailable) {
        debugPrint('stripe_payment_service_epic => CARD LENGTH: $snapshotCardDocs');
        snapshotCard.docs.forEach((element) {
          debugPrint('stripe_payment_service_epic => ID: ${element.id}');
        });
        debugPrint('stripe_payment_service_epic => TOKEN LENGTH: $snapshotTokenDocs');
        int counter = 0;
        snapshotToken.docs.forEach((element) {
          var tokenData = element.data();
          if (snapshotCard?.docs != null && snapshotCard.docs.length > counter) {
            var cardFirestoreId = snapshotCard?.docs[counter]?.id;
            stripeListState.add(
                StripeState(
                    stripeCard: StripeCardResponse(
                      firestore_id: cardFirestoreId,
                      last4: tokenData['card']['last4'],
                      expYear: tokenData['card']['exp_year'],
                      expMonth: tokenData['card']['exp_month'],
                      brand: tokenData['card']['brand'],
                    )
                )
            );
          }
          counter++;
        });


        Map<String, CardState> map = Map();
        if(stripeListState != null){
          stripeListState.forEach((element) {
            CardState cardState = CardState().toEmpty();
            cardState.stripeState = element;
            debugPrint('stripe_payment_service_epic => LAST4: ${element.stripeCard.last4}');
            map.putIfAbsent(element.stripeCard.last4, () => cardState);
          });

          map.forEach((key, value) {
            tmp.add(value);
          });

          /*for(int i = 0; i < indexes.length; i++){
                      tmp2.add(tmp.elementAt(indexes[i]));
                    }
                    creditCards.addAll(tmp2);*/
          /* cardState.stripeState = snapshot.stripe;
                    creditCards.forEach((element) {
                      if(element.stripeState.stripeCard.secretToken != cardState.stripeState.stripeCard.secretToken)
                        creditCards.add(cardState);
                    });
                    if(creditCards.isEmpty)
                      creditCards.add(cardState);*/
          //snapshot.cardListState.cardListState.addAll(creditCards);
        }

        ///Return
        /*return new StripeCardListResult(StripeCardResponse(
          firestore_id: snapshotCard?.docs[0]?.id,
          last4: tokenData['card']['last4'],
          expYear: tokenData['card']['exp_year'],
          expMonth: tokenData['card']['exp_month'],
          brand: tokenData['card']['brand'],
        ));*/
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.stripePaymentCardListRequestRead;
      int writes = statisticsState.stripePaymentCardListRequestWrite;
      int documents = statisticsState.stripePaymentCardListRequestDocuments;
      debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + 2;
      documents = documents + snapshotCardDocs + snapshotTokenDocs;
      debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.stripePaymentCardListRequestRead = reads;
      statisticsState.stripePaymentCardListRequestWrite = writes;
      statisticsState.stripePaymentCardListRequestDocuments = documents;

      /*List<CardState> tmpList = [];
      CardState cardState = CardState().toEmpty();
      cardState.stripeState = snapshot?.stripe;
      tmpList.add(cardState);
      StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));*/
      ///Return
      //return null;
      // return new StripeCardListResult(StripeCardResponse());
    }).expand((element) => [
      AddCardToList(tmp),
      stripeListState.isNotEmpty ? StripeListCardListResult(stripeListState) : null,
      UpdateStatistics(statisticsState),
    ]);
  }
}

class StripeDetachPaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  http.Response response;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateDisposePaymentMethodIntent>().asyncMap((event) async {
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => USER ID: ${event.userId}");
      // create detach document
      await FirebaseFirestore.instance.collection("stripeCustomer/" + event.userId + "_test/detach/").doc().set({ /// 1 WRITE
        'firestore_id': event.stripePaymentMethodResponse.firestore_id
      });
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => Detach document created");
      // call the endpoint to trigger the cloud function for the detach
      //response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/detachPaymentMethod?userId=' + event.userId.toString());
      var url = Uri.parse('https://europe-west1-buytime-458a1.cloudfunctions.net/detachPaymentMethod');
      response = await http.post(url, body: {'userId': '${event.userId.toString()}'});

      statisticsState = store.state.statistics;
      int reads = statisticsState.stripeDetachPaymentMethodRequestRead;
      int writes = statisticsState.stripeDetachPaymentMethodRequestWrite;
      int documents = statisticsState.stripeDetachPaymentMethodRequestDocuments;
      debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.stripeDetachPaymentMethodRequestRead = reads;
      statisticsState.stripeDetachPaymentMethodRequestWrite = writes;
      statisticsState.stripeDetachPaymentMethodRequestDocuments = documents;

      ///Return
      // handle the result to refresh the card list or show an error dialog
      /*if (response != null && response.body.contains("error")) {
        return new ErrorDisposePaymentMethodIntent(response.body);
      } else {
        return new DisposedPaymentMethodIntent();
      }*/
    }).expand((element) => [
      response != null && response.body.contains("error") ? ErrorDisposePaymentMethodIntent(response.body) : DisposedPaymentMethodIntent(),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class StripePaymentService {

  String text = 'Click the button to start the payment';
  double totalCost = 10.0;
  double tip = 1.0;
  double tax = 0.0;
  double taxPercent = 0.2;
  int amount = 0;
  bool showSpinner = false;
  String url = ''; //'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';

  Future<void> createPaymentMethodNative() async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount(null);
    List<ApplePayItem> items = [];
    items.add(ApplePayItem(
      label: 'Demo Order',
      amount: totalCost.toString(),
    ));
    if (tip != 0.0)
      items.add(ApplePayItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(ApplePayItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(ApplePayItem(
      label: 'Vendor A',
      amount: (totalCost + tip + tax).toString(),
    ));
    amount = ((totalCost + tip + tax) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
        currencyCode: 'GBP',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'GB',
        currencyCode: 'GBP',
        items: items,
      ),
    );
    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    // paymentMethod != null
    //     ? processPaymentAsDirectCharge(paymentMethod)
    //     : showDialog(
    //     context: context,
    //     builder: (BuildContext context) => ShowDialogToDismiss(
    //         title: 'Error',
    //         content:
    //         'It is not possible to pay with this card. Please try again with a different card',
    //         buttonText: 'CLOSE'));
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