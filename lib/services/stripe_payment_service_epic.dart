import 'dart:convert';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart' as StripeUnofficialUI;
import 'package:stripe_sdk/stripe_sdk.dart' as StripeUnofficial;
import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
// String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";

final StripeUnofficial.Stripe stripeSDK = StripeUnofficial.Stripe(
  stripeTestKey,
  // stripeAccount: "",
  returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
);


/// SAVE A CREDIT CARD
class StripePaymentAddPaymentMethod implements EpicClass<AppState> {
  String userId = '';
  StatisticsState statisticsState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
      /// request the creation of the payment method
      Map<String, dynamic> stripePaymentMethod = await StripePaymentService.createPaymentMethod(event.stripeCard);
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID: ${event.userId}");
      userId = event.userId;

      if (userId.isNotEmpty) {
        try {
          /// create setupIntent on the user
          FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc().set({'status': "create request"}).then((value) async {
            final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);
            if (response.statusCode == 200 && !response.body.contains('error')) {
              /// requesting back the secretKey (aka the setupIntent)
              DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId + "_test").get();

              /// 1 READ - 1 DOC
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => SetupIntentSecret got from firestore");
              String customerSecret = stripeCustomerReference.get("stripeCustomerSecret");

              /// saving payment method on firebase TODO: store only the payment method ID as soon as the libraries allow that
              await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/token/").doc().set(stripePaymentMethod);

              /// 1 WRITE
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Added to firestore"); // this will trigger the creation of a new stripeIntent to be used in the next request
              String paymentMethodId = stripePaymentMethod["id"];

              /// confirm the setupIntent (and in doing so add the card to stripe)
              Future<Map<String, dynamic>> confirmationResult = stripeSDK.api.confirmSetupIntent(customerSecret, data: {'payment_method': paymentMethodId});
              var confirmationResultResolved = await confirmationResult;
              if (stripePaymentMethod['card'] != null && stripePaymentMethod['card']['three_d_secure_usage'] != null) {
                debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Requires 3D secure auth");
                if (confirmationResultResolved['next_action'] != null &&
                    confirmationResultResolved['next_action']['use_stripe_sdk'] != null &&
                    confirmationResultResolved['next_action']['use_stripe_sdk']['stripe_js'] != null) {
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
              await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/card/").doc().set(confirmationResultResolved);
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
            } else {
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the setup intent creation: " + response.body);
            }
          }).catchError((onError){
            debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error  creating the setupIntent document on firebase" + onError.toString());
          });
        } catch (error) {
          debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the saving of the card");
        }
      } else {
        debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID is empty, cannot create payment method");
      }
    }).expand((element) => [
          UpdateStatistics(statisticsState),
          StripeListCardListRequest('${userId}_test'),
          NavigatePushAction(AppRoutes.confirmOrder),
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
        DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId).get();

        /// 1 READ
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
      QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/card/").limit(10).get();

      /// 1 READ - ? DOC
      int snapshotCardDocs = snapshotCard.docs.length;
      bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;

      QuerySnapshot snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/token/").limit(10).get();

      /// 1 READ - ? DOC
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
            stripeListState.add(StripeState(
                stripeCard: StripeCardResponse(
              firestore_id: cardFirestoreId,
              last4: tokenData['card']['last4'],
              expYear: tokenData['card']['exp_year'],
              expMonth: tokenData['card']['exp_month'],
              brand: tokenData['card']['brand'],
            )));
          }
          counter++;
        });

        Map<String, CardState> map = Map();
        if (stripeListState != null) {
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
          DeletedStripePaymentMethod(),
          AddedStripePaymentMethod()
        ]);
  }
}

class StripeDetachPaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  http.Response response;
  String userId = '';

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateDisposePaymentMethodIntent>().asyncMap((event) async {
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => USER ID: ${event.userId}");
      userId = event.userId;
      // create detach document
      await FirebaseFirestore.instance.collection("stripeCustomer/" + event.userId + "_test/detach/").doc().set({
        /// 1 WRITE
        'firestore_id': event.firestoreCardId
      });
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => Detach document created");
      // call the endpoint to trigger the cloud function for the detach
      //response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/detachPaymentMethod?userId=' + event.userId.toString());
      var url = Uri.parse('https://europe-west1-buytime-458a1.cloudfunctions.net/detachPaymentMethod');
      response = await http.post(url, body: {
        'userId': '${event.userId.toString()}',
        'firestoreCardId': '${event.firestoreCardId.toString()}'
      });

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
          (response != null && response.body.contains("error"))
              ? [ErrorDisposePaymentMethodIntent(response.body)]
              : [DisposedPaymentMethodIntent(), StripeListCardListRequest('${userId}_test')],
          ConfirmOrderWait(false),
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

  /// url for our cloud function payment
  String url = '';

  Future<bool> createPaymentMethodNativeAndPay(OrderState orderState, String businessName) async {
    bool paymentResult = false;
    totalCost = orderState.total;
    print('started NATIVE payment...');
    /// why setting the account to null?
    /// StripeRecommended.StripePayment.setStripeAccount(null);
    ///
    List<StripeRecommended.ApplePayItem> items = [];
    for(int i= 0; i < orderState.itemList.length; i++) {
      items.add(StripeRecommended.ApplePayItem(
        label: orderState.itemList[i].name,
        amount: orderState.itemList[i].toString().toString(),
      ));
    }
    if (tip != 0.0)
      items.add(StripeRecommended.ApplePayItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(StripeRecommended.ApplePayItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(StripeRecommended.ApplePayItem(
      label: businessName,
      amount: (totalCost + tip + tax).toString(),
    ));
    amount = ((totalCost + tip + tax) * 100).toInt();
    debugPrint('amount in pence/cent which will be charged = $amount');
    //step 1: add card
    StripeRecommended.PaymentMethod paymentMethod = StripeRecommended.PaymentMethod();
    await StripeRecommended.StripePayment.paymentRequestWithNativePay(
      androidPayOptions: StripeRecommended.AndroidPayPaymentRequest(
        totalPrice: (totalCost + tax + tip).toStringAsFixed(2),
        currencyCode: 'EUR',
      ),
      applePayOptions: StripeRecommended.ApplePayPaymentOptions(
        countryCode: 'IT', // TODO: adapt with business country asap
        currencyCode: 'EUR',
        items: items,
      ),
    ).then((token) async {
      debugPrint('UI_U_ConfirmOrder => token received:' + token.toString());
      paymentMethod = await StripeRecommended.StripePayment.createPaymentMethod(
        StripeRecommended.PaymentMethodRequest(
          card: StripeRecommended.CreditCard(
            token: token.tokenId,
          ),
        ),
      );
      if (paymentMethod != null) {
        /// save the payment method id in the order sub collection
        await FirebaseFirestore.instance.collection("order/" + orderState.orderId + "/orderPaymentMethod/").doc().set({
          /// 1 WRITE
          'paymentMethod': paymentMethod
        });
        /// process payment
        processPaymentAsDirectCharge(paymentMethod);
      } else {
        /// TODO: show error message to the user:
        /// 'It is not possible to pay with this card. Please try again with a different card',
      }

      // StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
    }).catchError((error){
      /// TODO: Show error to the user
      debugPrint('UI_U_ConfirmOrder => error in direct payment process with Native Method:' + error);
    });
    return paymentResult;
  }

  Future<void> processPaymentAsDirectCharge(StripeRecommended.PaymentMethod paymentMethod) async {
    //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
    final http.Response response = await http.post('$url?amount=$amount&currency=GBP&paym=${paymentMethod.id}');
    debugPrint('Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['paymentIntent']['status'];
      final strAccount = paymentIntentX['stripeAccount'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded') {
        //payment was confirmed by the server without need for futher authentification
        StripeRecommended.StripePayment.completeNativePayRequest();
        debugPrint('Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged');
        /// stop spinner
      } else {
        //step 4: there is a need to authenticate
        StripeRecommended.StripePayment.setStripeAccount(strAccount);
        await StripeRecommended.StripePayment.confirmPaymentIntent(StripeRecommended.PaymentIntent(
            paymentMethodId: paymentIntentX['paymentIntent']
            ['payment_method'],
            clientSecret: paymentIntentX['paymentIntent']['client_secret']))
            .then(
              (StripeRecommended.PaymentIntentResult paymentIntentResult) async {
            //This code will be executed if the authentication is successful
            //step 5: request the server to confirm the payment with
            final statusFinal = paymentIntentResult.status;
            if (statusFinal == 'succeeded') {
              StripeRecommended.StripePayment.completeNativePayRequest();
              /// stop spinner
            } else if (statusFinal == 'processing') {
              StripeRecommended.StripePayment.cancelNativePayRequest();
              /// stop spinner
              /// message to the user: 'The payment is still in \'processing\' state. This is unusual. Please contact us'
            } else {
              StripeRecommended.StripePayment.cancelNativePayRequest();
              /// stop spinner
              /// message to the user 'There was an error to confirm the payment. Details: $statusFinal'
            }
          },
          //If Authentication fails, a PlatformException will be raised which can be handled here
        ).catchError((e) {
          //case B1
          StripeRecommended.StripePayment.cancelNativePayRequest();
          /// stop spinner
          /// message to the user 'There was an error to confirm the payment. Please try again with another card'
        });
      }
    } else {
      //case A
      StripeRecommended.StripePayment.cancelNativePayRequest();
      /// stop spinner
      /// message to the user 'There was an error to confirm the payment. Please try again with another card'
    }
  }

  static Future<Map<String, dynamic>> createPaymentMethod(StripeUnofficialUI.StripeCard stripeCard) async {
    Map<String, dynamic> paymentMethod = await stripeSDK.api.createPaymentMethodFromCard(stripeCard);
    return paymentMethod;
  }
}
