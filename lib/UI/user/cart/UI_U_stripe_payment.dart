import 'dart:convert';
import 'package:Buytime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/reusable/stripe/optimum_credit_card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO separate service and UI
class UI_U_StripePayment extends StatefulWidget {
  UI_U_StripePayment({Key key}) : super(key: key);

  @override
  _UI_U_StripePaymentState createState() => _UI_U_StripePaymentState();
}

class _UI_U_StripePaymentState extends State<UI_U_StripePayment> {
  String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
  final String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
  bool showSpinner = false;
  
  final String postCreateIntentURL = "https:/yourserver/postPaymentIntent";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();

  bool addCard = false;
  final Stripe stripe = Stripe(
    "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz",
    stripeAccount: "acct_1HS20eHr13hxRBpC",
    returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
  );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).choosePaymentMethod),
      ),
      body: new SingleChildScrollView(
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: StoreConnector<AppState, AppState>(
              onInit: (store) => store?.dispatch(StripeCardListRequest(store?.state?.user?.uid)), // no
              converter: (store) => store.state,
              builder: (context, snapshot) {
                WidgetsBinding.instance.addPostFrameCallback((_) { // no
                  if (snapshot?.order?.progress != null && snapshot?.order?.progress == "paid" && snapshot?.order?.total != 0.0) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
                    );

                  }
                });
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: media.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(snapshot.business.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: media.height * 0.028,
                                  fontWeight: FontWeight.w700,
                                ),),
                            ),
                            OrderTotal(media: media, orderState: snapshot.order)
                          ],
                        ),
                      ),
                      Container(
                        child: snapshot?.order?.progress == "in_progress" ? // no
                        ///Proccessing Payment
                        Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context).processingPayment),
                              SizedBox(height: 8.0,),
                              CircularProgressIndicator(),
                            ],
                          ),
                        ) :
                        Column(
                          children: [
                            Container(
                              child: snapshot?.stripe?.stripeCard?.last4 != null ? // no
                              ///Pay With
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20.0),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          AppLocalizations.of(context).payWith,
                                          style: TextStyle(fontSize: 25.0),
                                        ),
                                      ),
                                    ),
                                    OptimumCreditCardButton(
                                      stripeCardResponse: snapshot?.stripe?.stripeCard, // no
                                      mediaSize: media,
                                      onCreditCardButtonTap: () {
                                        StoreProvider.of<AppState>(context).dispatch(SetOrderProgress("in_progress"));
                                        StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
                                      },
                                      onCreditCardDisposeTap: (stripeCreditCardResponse){
                                        // send the request that triggers the deletion of the payment method
                                        StoreProvider.of<AppState>(context).dispatch(CreateDisposePaymentMethodIntent(stripeCreditCardResponse, snapshot.user.uid));
                                      },
                                    ),
                                    snapshot?.stripe?.error == "error" ? // no
                                        Text(AppLocalizations.of(context).anErrorOccurredTryLater) :
                                        SizedBox()
                                  ],
                                ),
                              ) :
                              ///Add Card
                              Column(
                                children: [
                                  Container(
                                    child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            ///Card Form
                                            CardForm(
                                              formKey: formKey,
                                              card: card,
                                              cardDecoration: BoxDecoration(
                                                  color: Color.fromRGBO(200, 200, 200, 1.0)
                                              ),
                                              cardCvcTextStyle: TextStyle(color: Colors.black),
                                              cardExpiryTextStyle: TextStyle(color: Colors.black),
                                              cardNumberTextStyle: TextStyle(color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: media.height * 0.05,
                                            ),
                                            ///Add Card Button
                                            GestureDetector(
                                              onTap: () {
                                                formKey.currentState.validate();
                                                formKey.currentState.save();
                                                StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethod());
                                                addPaymentMethodWithSetupIntent(context, snapshot.user.uid);

                                              },
                                              child: snapshot?.stripe?.stripeCard?.last4 == null && !snapshot?.order?.addCardProgress ? // no
                                              AddCardButton(media, AppLocalizations.of(context).addCreditCard, Color.fromRGBO(1, 175, 81, 1.0)) :
                                              Text(AppLocalizations.of(context).loading),
                                            ),

                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Container AddCardButton(Size media, String text, Color color) {
    return Container(
      width: media.width * 0.8,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, color: Colors.white),
            SizedBox(width: 10.0),
            Text(text, style: TextStyle(fontSize: (media.width * 0.06), color: Colors.white))
          ],
        ),
      ),
    );
  }

  void buy(context) async {
    final StripeCard stripeCard = card;
    final String customerEmail = getCustomerEmail();

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
      return;
    }

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];

    if (status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes = await confirmPayment3DSecure(clientSecret, paymentMethodId);

    if (paymentIntentRes['status'] != 'succeeded') {
      showAlertDialog(context, AppLocalizations.of(context).warning, AppLocalizations.of(context).canceledTransaction);
      return;
    }

    if (paymentIntentRes['status'] == 'succeeded') {
      showAlertDialog(context, AppLocalizations.of(context).success, AppLocalizations.of(context).thanksForBuying);
      return;
    }
    showAlertDialog(context, AppLocalizations.of(context).warning, AppLocalizations.of(context).transactionRejected);
  }

  void addPaymentMethod(context) async {
    final StripeCard stripeCard = card;
    final String customerEmail = getCustomerEmail();

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
      return;
    }

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
    print("StripePayment payment method test");



    // TODO confirm the payment method has been added or notify a failure to the user
  }

  void addPaymentMethodWithSetupIntent(context, userId) async {
    final StripeCard stripeCard = card;
    final String customerEmail = getCustomerEmail();

    if (!stripeCard.validateCVC()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
      return;
    }
    if (!stripeCard.validateDate()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
      return;
    }
    if (!stripeCard.validateNumber()) {
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
      return;
    }
    // TODO take remotes requests away from this file.
    // TODO show spinner on tap.
    var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc()
        .set({
      'status': "create request"
    });
    // now http request to create the actual setupIntent
    final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);

    // TODO confirm the payment method has been added or notify a failure to the user
  }

//--------

  String getCustomerEmail() {
    String customerEmail;
    //Define how to get this info.
    // -Ask to the customer through a textfield.
    // -Get it from firebase Account.
    customerEmail = StoreProvider.of<AppState>(context).state.user.email;
    print("StripePayment user email: " + customerEmail);
    return customerEmail;
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text(AppLocalizations.of(context).ok),
              onPressed: () => Navigator.of(context).pop(), // dismiss dialog
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> createPaymentIntent(StripeCard stripeCard, String customerEmail) async {
    String clientSecret;
    Map<String, dynamic> paymentIntentRes, paymentMethod;
    try {
      // paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
      Map<String, dynamic> cardData;
      cardData = {
        "type": "card",
        "card": {"number": stripeCard.number, "exp_month": stripeCard.expMonth, "exp_year": stripeCard.expYear, "cvc": stripeCard.cvc}
      };
      paymentMethod = await stripe.api.createPaymentMethod(cardData);
      var userId = StoreProvider.of<AppState>(context).state.user.uid;
      // save this on firebase to trigger the cloud function
      StoreProvider.of<AppState>(context).dispatch(AddStripePaymentMethod(paymentMethod, userId));
      //clientSecret = await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
      //paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_CreatePaymentIntentAndSubmit: $e");
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).somethingWentWrong);
    }
    return paymentIntentRes;
  }

  Future<String> postCreatePaymentIntent(String email, String paymentMethodId) async {
    String clientSecret;
    http.Response response = await http.post(
      postCreateIntentURL,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'payment_method_id': paymentMethodId,
      }),
    );
    clientSecret = json.decode(response.body);
    return clientSecret;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId) async {
    Map<String, dynamic> paymentIntentRes_3dSecure;
    try {
      await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
    } catch (e) {
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).somethingWentWrong);
    }
    return paymentIntentRes_3dSecure;
  }

///////////////////////////////////////


}
