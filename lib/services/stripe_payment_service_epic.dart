import 'dart:convert';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/services/payment/util.dart';
import 'package:Buytime/services/statistic/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String error;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
      /// request the creation of the payment method
      Map<String, dynamic> stripePaymentMethod = await StripePaymentService.createPaymentMethodFromCard(event.stripeCard);
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID: ${event.userId}");
      userId = event.userId;
      if (userId.isNotEmpty) {
        try {
          /// create setupIntent on the user
          await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc().set({'status': "create request"}).then((value) async {
            var url = Uri.https('europe-west1-buytime-458a1.cloudfunctions.net', '/createSetupIntent', {'userId': '$userId'});
            final http.Response response = await http.get(url);
            if (response.statusCode == 200 && !response.body.contains('error')) {
              /// requesting back the secretKey (aka the setupIntent)
              DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId + "_test").get();
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => SetupIntentSecret got from firestore");
              String customerSecret = stripeCustomerReference.get("stripeCustomerSecret");
              /// saving payment method on firebase TODO: store only the payment method ID as soon as the libraries allow that
              await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/token/").doc().set(stripePaymentMethod);
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Added to firestore"); // this will trigger the creation of a new stripeIntent to be used in the next request
              String paymentMethodId = stripePaymentMethod["id"];
              /// confirm the setupIntent (and in doing so add the card to stripe)
              var confirmationResultResolved = await stripeSDK.api.confirmSetupIntent(customerSecret, data: {'payment_method': paymentMethodId});
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
              var cardSavingResult = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/card/").doc().set(confirmationResultResolved);
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => card should be added in firestore ");
              statisticsComputation();
            } else {
              debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the setup intent creation: " + response.body);
              error = "error in the setup intent creation";
            }
          }).catchError((onError){
            debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error  creating the setupIntent document on firebase" + onError.toString());
            error = "error in the setup intent creation on firebase";
          });
        } catch (errorCatched) {
          debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the saving of the card");
          error = "error saving the card " + errorCatched.toString();
        }
      } else {
        debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID is empty, cannot create payment method");
        error = "USER ID is empty, cannot create payment method";
      }
      debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => the card has been added');
    }).expand((element) {
      var actionArray = [];
      if (error != null) {
        actionArray.add(ErrorAction(error));
      } else {
        actionArray.add(StripeCardListRequestAndNavigate('${userId}_test'));
      }
      actionArray.add(UpdateStatistics(statisticsState));
      return actionArray;
    });
  }
}



/// Checks if the stripe_customer document for the current logged in user has been created,
/// always checks the production document.
/// If the production document has been created, the test document should also be there.
class CheckStripeCustomerService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String userId = '';
  bool stripeCustomerCreated = false;
  bool updateCardList = false;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CheckStripeCustomer>().asyncMap((event) async {
      updateCardList = event.updateCardList;
      userId = store.state.user.uid;
      debugPrint("stripe_payment_service_epic: CheckStripeCustomerService - searching for a stripe customer");
      if (userId.isNotEmpty) {
        DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId).get();
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
          if (stripeCustomerCreated && updateCardList) StripeCardListRequest('${userId}_test') else null,
        ]);
  }
}

class StripeCardListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<StripeState> stripeStateList;
  StripeCardResponse stripeCardResponse;
  List<CardState> cardList;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<StripeCardListRequest>().asyncMap((event) async {
      stripeStateList = [];
      cardList = [];
      cardList = await stripeCardListMaker(event, stripeStateList, cardList, stripeCardResponse);
    }).expand((element) {
      var actionArray = [];
      actionArray.add(AddCardToList(cardList));
      actionArray.add(UpdateStatistics(statisticsState));
      return actionArray;
    });
  }
}

class StripeCardListRequestAndNavigateService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<StripeState> stripeStateList;
  StripeCardResponse stripeCardResponse;
  List<CardState> cardList;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<StripeCardListRequestAndNavigate>().asyncMap((event) async {
      stripeStateList = [];
      cardList = [];
      cardList = await stripeCardListMaker(event, stripeStateList, cardList, stripeCardResponse);
    }).expand((element) {
      var actionArray = [];
      actionArray.add(AddCardToList(cardList));
      actionArray.add(AddedStripePaymentMethod());
      actionArray.add(UpdateStatistics(statisticsState));
      return actionArray;
    });
  }
}

class StripeDetachPaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  http.Response response;
  String userId = '';
  String firestoreCardId = '';

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<CreateDisposePaymentMethodIntent>().asyncMap((event) async {
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => USER ID: ${event.userId} FIRESTORE CARD ID: ${event.firestoreCardId}");
      userId = event.userId;
      firestoreCardId = event.firestoreCardId;
      await FirebaseFirestore.instance.collection("stripeCustomer/" + event.userId + "_test/detach/").doc().set({'firestore_id': event.firestoreCardId});
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => Detach document created");
      var url = Uri.https('europe-west1-buytime-458a1.cloudfunctions.net', '/detachPaymentMethod', {'userId': '$userId','firestoreCardId': '${event.firestoreCardId.toString()}'});
      response = await http.get(url);
      statisticsComputation();
    }).expand((element) {
      var actionArray = [];
      if (response != null && response.body.contains("error")) {
        actionArray.add(ErrorDisposePaymentMethodIntent(response.body));
      } else {
        actionArray.add(CheckStripeCustomer(true));
        // actionArray.add(DeleteStripePaymentMethodLocally(firestoreCardId));
      }
      actionArray.add(DeletedStripePaymentMethod());
      actionArray.add(UpdateStatistics(statisticsState));
      return actionArray;
    });
  }
}

class StripePaymentService {
  double totalCost = 10.0;
  double tip = 0.0;
  double tax = 0.0;
  double taxPercent = 0.2;
  int amount = 0;
  bool showSpinner = false;
  List<StripeRecommended.ApplePayItem> items = [];
  final String cloudAddress = 'europe-west1-buytime-458a1.cloudfunctions.net';
  final String cloudFunctionPathPay = '/StripePIOnOrder';
  final String cloudFunctionPathHold = '/StripePIOnOrderHold';
  String currency = 'EUR';
  String country = 'IT';

  StripePaymentService({
    this.tip = 0.0,
    this.tax = 0.0,
    this.taxPercent = 0.2,
    this.currency = 'EUR',
    this.country = 'IT'
  });

  void initializePaymentValues(OrderState orderState, String businessName) {
    print('initializing instance payment values...');
    totalCost = orderState.total;
    /// why setting the account to null?
    /// StripeRecommended.StripePayment.setStripeAccount(null);

    /// Apple items initialization
    for(int i= 0; i < orderState.itemList.length; i++) {
      items.add(StripeRecommended.ApplePayItem(
        label: orderState.itemList[i].name,
        amount: orderState.itemList[i].toString(),
      ));
    }
    if (tip != 0.0) {
      items.add(StripeRecommended.ApplePayItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    }
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(StripeRecommended.ApplePayItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(StripeRecommended.ApplePayItem(
      label: businessName,
      amount: (totalCost + tip ).toString(),
    ));
    amount = ((totalCost + tip ) * 100).toInt();
    debugPrint('amount in cent which will be charged = $amount');
  }

  Future<StripeRecommended.PaymentMethod> createPaymentMethodNative(OrderState orderState, String businessName) async {
    StripeRecommended.PaymentMethod paymentMethod;
    initializePaymentValues(orderState, businessName);
    print('started NATIVE payment method creation...');
    /// why setting the account to null????? TODO: discover why
    /// StripeRecommended.StripePayment.setStripeAccount(null);
    ///
    List<StripeRecommended.ApplePayItem> items = [];
    //step 1: add card
    var token = await StripeRecommended.StripePayment.paymentRequestWithNativePay(
      androidPayOptions: StripeRecommended.AndroidPayPaymentRequest(
        totalPrice: (totalCost + tip).toStringAsFixed(2),
        currencyCode: currency,
      ),
      applePayOptions: StripeRecommended.ApplePayPaymentOptions(
        countryCode: country,
        currencyCode: currency,
        items: items,
      ),
    );
    debugPrint('UI_U_ConfirmOrder => token received:' + token.toString());
    paymentMethod = await StripeRecommended.StripePayment.createPaymentMethod(
      StripeRecommended.PaymentMethodRequest(
        card: StripeRecommended.CreditCard(
          token: token.tokenId,
        ),
      ),
    );
    if (paymentMethod != null) {
      return paymentMethod;
    } else {
      debugPrint('UI_U_ConfirmOrder => error in creating Native Method, the response from stripe is null');
      return null;
    }
  }

  Future<String> processPaymentAsDirectCharge(String orderId) async {
    var url = Uri.https(cloudAddress, cloudFunctionPathPay, {'orderId': '$orderId', 'currency': currency});
    final http.Response response = await http.get(url);
    debugPrint('processPaymentAsDirectCharge: Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['status'];
      final nextAction = paymentIntentX['next_action'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded' && nextAction == null) {
        //payment was confirmed by the server without need for futher authentification
        StripeRecommended.StripePayment.completeNativePayRequest();
        debugPrint('processPaymentAsDirectCharge:  Payment completed. ${paymentIntentX['amount'].toString()} successfully charged');
        return "success";
        /// stop spinner
      } else {
        //step 4: there is a need to authenticate
        /// why should I set another stripe account? TODO: discover this.
        /// StripeRecommended.StripePayment.setStripeAccount(strAccount);
        StripeRecommended.PaymentIntentResult paymentIntentResult = await StripeRecommended.StripePayment.confirmPaymentIntent(StripeRecommended.PaymentIntent(
            paymentMethodId: paymentIntentX['payment_method'],
            clientSecret: paymentIntentX['client_secret']
        ));
        //This code will be executed if the authentication is successful
        //step 5: request the server to confirm the payment with
        final statusFinal = paymentIntentResult.status;
        if (statusFinal == 'succeeded') {
          StripeRecommended.StripePayment.completeNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  Payment success');
          return "success";
        } else if (statusFinal == 'processing') {
          StripeRecommended.StripePayment.cancelNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  processing. this is weird');
          return "trouble";
        } else {
          StripeRecommended.StripePayment.cancelNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
          return "error";
        }
      }
    } else {
      //case A
      StripeRecommended.StripePayment.cancelNativePayRequest();
      /// stop spinner
      debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
      return "error";
    }
  }

  Future<String> processHoldCharge(String orderId) async {
    var url = Uri.https(cloudAddress, cloudFunctionPathHold, {'orderId': '$orderId', 'currency': currency});
    final http.Response response = await http.get(url);
    debugPrint('processPaymentAsDirectCharge: Now i decode');
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      final status = paymentIntentX['status'];
      final nextAction = paymentIntentX['next_action'];
      //step 3: check if payment was succesfully confirmed
      if (status == 'succeeded' && nextAction == null) {
        //payment was confirmed by the server without need for futher authentification
        // StripeRecommended.StripePayment.completeNativePayRequest();
        debugPrint('processPaymentAsDirectCharge:  Payment completed. ${paymentIntentX['amount'].toString()} successfully charged');
        return "success";
        /// stop spinner
      } else {
        //step 4: there is a need to authenticate
        /// TODO: discover if this works also for HOLDS
        StripeRecommended.PaymentIntentResult paymentIntentResult = await StripeRecommended.StripePayment.confirmPaymentIntent(StripeRecommended.PaymentIntent(
            paymentMethodId: paymentIntentX['payment_method'],
            clientSecret: paymentIntentX['client_secret']
        ));
        //This code will be executed if the authentication is successful
        //step 5: request the server to confirm the payment with
        final statusFinal = paymentIntentResult.status;
        if (statusFinal == 'succeeded') {
          StripeRecommended.StripePayment.completeNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  Payment success');
          return "success";
        } else if (statusFinal == 'processing') {
          StripeRecommended.StripePayment.cancelNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  processing. this is weird');
          return "trouble";
        } else {
          StripeRecommended.StripePayment.cancelNativePayRequest();
          /// stop spinner
          debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
          return "error";
        }
      }
    } else {
      //case A
      StripeRecommended.StripePayment.cancelNativePayRequest();
      /// stop spinner
      debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
      return "error";
    }
  }

  static Future<Map<String, dynamic>> createPaymentMethodFromCard(StripeUnofficialUI.StripeCard stripeCard) async {
    Map<String, dynamic> paymentMethod = await stripeSDK.api.createPaymentMethodFromCard(stripeCard);
    return paymentMethod;
  }


}
