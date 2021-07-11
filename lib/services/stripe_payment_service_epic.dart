import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
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
import 'package:flutter/services.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/utils/utils.dart';

// final StripeUnofficial.Stripe stripeSDK = StripeUnofficial.Stripe(
//   Environment().config.stripePublicKey,
//   // stripeAccount: "",
//   returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
// );

const StripeRecommended = null;

// /// SAVE A CREDIT CARD
// class StripePaymentAddPaymentMethod implements EpicClass<AppState> {
//   String userId = '';
//   StatisticsState statisticsState;
//   String error;
//
//   @override
//   Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
//     return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
//       /// request the creation of the payment method
//       Map<String, dynamic> stripePaymentMethod = await StripePaymentService.createPaymentMethodFromCard(event.stripeCard);
//       debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID: ${event.userId}");
//       userId = event.userId;
//       if (userId.isNotEmpty) {
//         try {
//           /// create setupIntent on the user
//           await FirebaseFirestore.instance
//               .collection("stripeCustomer/" + userId + Environment().config.stripeSuffix + "/setupIntent")
//               .doc()
//               .set({'status': "create request"}).then((value) async {
//             var url = Uri.https(Environment().config.cloudFunctionLink, '/createSetupIntent', {'userId': '$userId'});
//             final http.Response response = await http.get(url);
//             if (response.statusCode == 200 && !response.body.contains('error')) {
//               /// requesting back the secretKey (aka the setupIntent)
//               DocumentSnapshot stripeCustomerReference = await FirebaseFirestore.instance.collection("stripeCustomer/").doc(userId + Environment().config.stripeSuffix).get();
//               debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => SetupIntentSecret got from firestore");
//               String customerSecret = stripeCustomerReference.get("stripeCustomerSecret");
//
//               /// saving payment method on firebase TODO: store only the payment method ID as soon as the libraries allow that
//               await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + Environment().config.stripeSuffix + "/token/").doc().set(stripePaymentMethod);
//               debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Added to firestore"); // this will trigger the creation of a new stripeIntent to be used in the next request
//               String paymentMethodId = stripePaymentMethod["id"];
//
//               /// confirm the setupIntent (and in doing so add the card to stripe)
//
//               PaymentMethodParams paymentMethodParams = PaymentMethodParams.cardFromMethodId(paymentMethodId: paymentMethodId);
//
//               var confirmationResultResolved = await Stripe.instance.confirmSetupIntent(customerSecret, paymentMethodParams);
//               // save the card also on firestore
//               var cardSavingResult = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + Environment().config.stripeSuffix + "/card/")
//                   .doc()
//                   .set(confirmationResultResolved.toJson());
//               debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => card should be added in firestore ");
//               statisticsComputation();
//             } else {
//               debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the setup intent creation: " + response.body);
//               error = "error in the setup intent creation";
//             }
//           }).catchError((onError) {
//             debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error  creating the setupIntent document on firebase" +
//                 onError.toString());
//             error = "error in the setup intent creation on firebase";
//           });
//         } catch (errorCatched) {
//           debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => error in the saving of the card");
//           error = "error saving the card " + errorCatched.toString();
//         }
//       } else {
//         debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID is empty, cannot create payment method");
//         error = "USER ID is empty, cannot create payment method";
//       }
//       debugPrint('STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => the card has been added');
//     }).expand((element) {
//       var actionArray = [];
//       if (error != null) {
//         actionArray.add(ErrorAction(error));
//       } else {
//         actionArray.add(StripeCardListRequestAndNavigate('${userId}${Environment().config.stripeSuffix}'));
//       }
//       actionArray.add(UpdateStatistics(statisticsState));
//       return actionArray;
//     });
//   }
// }

/// SAVE A CREDIT CARD
class StripePaymentAddPaymentMethod implements EpicClass<AppState> {
  String userId = '';
  StatisticsState statisticsState;
  String error;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddStripePaymentMethod>().asyncMap((event) async {
      /// request the creation of the payment method
      // Map<String, dynamic> stripePaymentMethod = ;
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => USER ID: ${event.userId}");
      userId = event.userId;
      if (userId.isNotEmpty) {
        try {
          /// create setupIntent on the user
          debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => Added to firestore"); // this will trigger the creation of a new stripeIntent to be used in the next request
          // save the card also on firestore
          var cardToUpload = event.stripeCard.toJson();
          cardToUpload.addAll({
            'paymentMethodId': event.paymentMethodId
          });
          await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + Environment().config.stripeSuffix + "/card/")
              .doc()
              .set(cardToUpload);
          debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentAddPaymentMethod => card should be added in firestore ");
          statisticsComputation();
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
        actionArray.add(StripeCardListRequestAndNavigate('${userId}${Environment().config.stripeSuffix}'));
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
      if (stripeCustomerCreated && updateCardList) StripeCardListRequest('${userId}${Environment().config.stripeSuffix}') else null,
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
      actionArray.add(NavigateReplaceAction(AppRoutes.confirmOrder));
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
      await FirebaseFirestore.instance
          .collection("stripeCustomer/" + event.userId + Environment().config.stripeSuffix + "/detach/")
          .doc()
          .set({'firestore_id': event.firestoreCardId});
      debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripeDetachPaymentMethodRequest => Detach document created");
      var url = Uri.https(Environment().config.cloudFunctionLink, '/detachPaymentMethod',
          {'userId': '$userId', 'firestoreCardId': '${event.firestoreCardId.toString()}'});
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
  List<ApplePayCartSummaryItem> items = [];
  final String cloudAddress = Environment().config.cloudFunctionLink;
  final String cloudFunctionPathPay = '/StripePIOnOrder';
  final String cloudFunctionPathHold = '/StripePIOnOrderHold';
  String currency = 'EUR';
  String country = 'IT';

  StripePaymentService({this.tip = 0.0, this.tax = 0.0, this.taxPercent = 0.2, this.currency = 'EUR', this.country = 'IT'});

  void initializePaymentValues(OrderState orderState, String businessName) {
    print('initializing instance payment values...');
    totalCost = orderState.total;

    /// why setting the account to null?
    /// StripeRecommended.StripePayment.setStripeAccount(null);

    /// Apple items initialization
    for (int i = 0; i < orderState.itemList.length; i++) {
      items.add(ApplePayCartSummaryItem(
        label: Utils.retriveField("en", orderState.itemList[i].name),
        amount: orderState.itemList[i].toString(),
      ));
    }
    if (tip != 0.0) {
      items.add(ApplePayCartSummaryItem(
        label: 'Tip',
        amount: tip.toString(),
      ));
    }
    if (taxPercent != 0.0) {
      tax = ((totalCost * taxPercent) * 100).ceil() / 100;
      items.add(ApplePayCartSummaryItem(
        label: 'Tax',
        amount: tax.toString(),
      ));
    }
    items.add(ApplePayCartSummaryItem(
      label: businessName,
      amount: (totalCost + tip).toString(),
    ));
    amount = ((totalCost + tip) * 100).toInt();
    debugPrint('amount in cent which will be charged = $amount');
  }

  Future<PaymentMethod> createPaymentMethodNative(OrderState orderState, String businessName) async {
    Stripe.publishableKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
    Stripe.merchantIdentifier = "merchant.theoptimumcompany.buytime";
    // StripePayment.setOptions(
    //     StripeOptions(
    //         publishableKey: stripeKey,
    //         merchantId: "merchant.theoptimumcompany.buytime",
    //         androidPayMode: 'production'
    //     ));


    PaymentMethod paymentMethod;
    initializePaymentValues(orderState, businessName);
    print('started NATIVE payment method creation...');

    /// why setting the account to null????? TODO: discover why
    /// StripeRecommended.StripePayment.setStripeAccount(null);

    List<ApplePayCartSummaryItem> items = [];
    for (int i = 0; i < orderState.itemList.length; i++) {
      OrderEntry orderEntry = orderState.itemList[i];
      String totalItemPrice = (orderEntry.price * orderEntry.number).toString();
      ApplePayCartSummaryItem item = ApplePayCartSummaryItem(label: Utils.retriveField("en", orderEntry.name), amount: totalItemPrice);
      items.add(item);
    }
    OrderEntry orderEntry = OrderEntry(
        number: 1, name: '', description: '', price: orderState.total, thumbnail: '', id: '', id_business: '', id_owner: '', id_category: '');
    String totalItemPrice = (orderEntry.price * orderEntry.number).toString();
    ApplePayCartSummaryItem item = ApplePayCartSummaryItem(label: Utils.retriveField("en", orderEntry.name), amount: totalItemPrice);
    items.add(item);

    /// add total item???
    // try {
    //step 1: add card
    // var token = await Stripe.instance.paymentRequestWithNativePay(
    //   androidPayOptions: StripeRecommended.AndroidPayPaymentRequest(
    //     totalPrice: (totalCost + tip).toStringAsFixed(2),
    //     currencyCode: currency,
    //   ),
    //   applePayOptions: StripeRecommended.ApplePayPaymentOptions(
    //     countryCode: country,
    //     currencyCode: currency,
    //     items: items,
    //   ),
    // );
    await Stripe.instance.presentApplePay(
      ApplePayPresentParams(
        cartItems: items,
        country: 'IT',
        currency: 'EUR',
      ),
    );
    debugPrint("stripe_payment_service_epic createPaymentServiceNative");
    //
    //   const MethodChannel channel = const MethodChannel('stripe_payment');
    //
    //   debugPrint('UI_U_ConfirmOrder => token received:' + token.toString());
    //   paymentMethod = await StripeRecommended.StripePayment.createPaymentMethod(
    //     StripeRecommended.PaymentMethodRequest(
    //       card: StripeRecommended.CreditCard(
    //         token: token.tokenId,
    //       ),
    //     ),
    //   ).whenComplete((){
    //     debugPrint('UI_U_ConfirmOrder => whenComplete:');
    //     if (Platform.isIOS) {
    //       return channel.invokeMethod("completeApplePayRequest");
    //     } else {
    //       return null;
    //     }
    //   });
    //   // await StripeRecommended.StripePayment.cancelNativePayRequest();
    //   if (paymentMethod != null) {
    //     return paymentMethod;
    //   } else {
    //     debugPrint('UI_U_ConfirmOrder => error in creating Native Method, the response from stripe is null');
    //     return null;
    //   }
    // } catch (e) {
    //   debugPrint('stripe_payment_service_epic payment exception: ' + e.toString());
    // }
    // return null;
  }

  Future<PaymentMethod> createPaymentMethodNativeReservable(OrderState orderState, String businessName) async {
    PaymentMethod paymentMethod;
    initializePaymentValues(orderState, businessName);
    print('started NATIVE payment method creation...');

    /// why setting the account to null????? TODO: discover why
    /// StripeRecommended.StripePayment.setStripeAccount(null);

    List<ApplePayCartSummaryItem> items = [];
    for (int i = 0; i < orderState.itemList.length; i++) {
      OrderEntry orderEntry = orderState.itemList[i];
      String totalItemPrice = (orderEntry.price * orderEntry.number).toString();
      ApplePayCartSummaryItem item = ApplePayCartSummaryItem(label: orderEntry.name, amount: totalItemPrice);
      items.add(item);
    }
    //step 1: add card
    try {
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
      const MethodChannel channel = const MethodChannel('stripe_payment');
      paymentMethod = await StripeRecommended.StripePayment.createPaymentMethod(
        StripeRecommended.PaymentMethodRequest(
          card: StripeRecommended.CreditCard(
            token: token.tokenId,
          ),
        ),
      ).whenComplete((){
        debugPrint('UI_U_ConfirmOrder => whenComplete:');
        if (Platform.isIOS) {
          return channel.invokeMethod("completeApplePayRequest");
        }
      });
      await StripeRecommended.StripePayment.cancelNativePayRequest();
      if (paymentMethod != null) {
        return paymentMethod;
      } else {
        debugPrint('UI_U_ConfirmOrder => error in creating Native Method, the response from stripe is null');
        return null;
      }
    } catch (e) {
      debugPrint('stripe_payment_service_epic payment exception: ' + e.toString());
    }
    return null;
  }

  Future<String> processPaymentAsDirectCharge(String orderId, String StripeConnectedBusinessId) async {
    var url = Uri.https(cloudAddress, cloudFunctionPathPay, {'orderId': '$orderId', 'currency': currency});
    final http.Response response = await http.get(url);
    debugPrint('processPaymentAsDirectCharge: Now i decode');
    if (response.body != null && response.body != 'error') {
        final paymentIntentX = jsonDecode(response.body);
        String clientSecret = paymentIntentX['client_secret'];
        debugPrint('processPaymentAsDirectCharge clientSecret: ' + clientSecret);
      // final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);
    } else {
      //case A
      StripeRecommended.StripePayment.cancelNativePayRequest();
      debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
      return "error";
    }
  }

  Future<String> processHoldCharge(String orderId, String StripeConnectedBusinessId, BuildContext context) async {
    var url = Uri.https(cloudAddress, cloudFunctionPathHold, {'orderId': '$orderId', 'currency': currency});
    final http.Response response = await http.get(url);
    if (response.body != null && response.body != 'error') {
      final paymentIntentX = jsonDecode(response.body);
      String clientSecret = paymentIntentX['client_secret'];
      debugPrint('processPaymentAsDirectCharge clientSecret: ' + clientSecret);
      // final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);
    } else {
      //case A
      StripeRecommended.StripePayment.cancelNativePayRequest();

      /// stop spinner
      debugPrint('processPaymentAsDirectCharge:  Payment error. canceling.');
      return "error";
    }
  }

  Future<String> confirmPaymentIntent(BuildContext context, String paymentIntentClientSecret, String paymentMethodId) async {
    String result = 'processing';
    await StripeRecommended.StripePayment.confirmPaymentIntent(
      StripeRecommended.PaymentIntent(
        clientSecret: paymentIntentClientSecret,
        paymentMethodId: paymentMethodId,
      ),
    ).then((paymentIntent) {
      /// TODO: check if the payment intent has a next action, if so, redirect the user to the link
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).holdingConfirmed)));
      result = "success";
      debugPrint('confirmPaymentIntent: success');
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).holdingError)));
      result = "error";
      debugPrint('confirmPaymentIntent: error ' + error);
    });
    return result;
  }

// static Future<Map<String, dynamic>> createPaymentMethodFromCard(StripeUnofficialUI.StripeCard stripeCard) async {
//   Map<String, dynamic> paymentMethod = await stripeSDK.api.createPaymentMethodFromCard(stripeCard);
//   return paymentMethod;
// }
}
