import 'dart:convert';
import 'dart:io';
import 'package:Buytime/utils/utils.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
// import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// TODO separate service and UI
class UI_U_AddCard extends StatefulWidget {
  UI_U_AddCard({Key key}) : super(key: key);



  @override
  _UI_U_AddCardState createState() => _UI_U_AddCardState();
}

class _UI_U_AddCardState extends State<UI_U_AddCard> {

  @override
  initState() {
    super.initState();


  }

  Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {}

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final StripeCard card = StripeCard();

  bool remeberMe = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: StoreConnector<AppState, AppState>(
          //onInit: (store) {store?.dispatch(StripeCardListRequest(store?.state?.user?.uid));}, // no
          converter: (store) => store.state,
          builder: (context, snapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) { // no
              if (snapshot?.order?.navigate) {
                debugPrint('UI_U_AddCard => ADD CARD');
                Navigator.of(context).pop();
              }
            });
            return Stack(
              children: [
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Scaffold(
                        appBar: BuytimeAppbar(
                          background: BuytimeTheme.UserPrimary,
                          width: media.width,
                          children: [
                            ///Back Button
                            IconButton(
                                icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                                onPressed: () {
                                  /*Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ServiceList()),
                          );*/
                                  Navigator.of(context).pop();
                                }
                            ),
                            ///Cart Title
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  AppLocalizations.of(context).addCard,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: Colors.white,
                                    fontSize: media.height * 0.025,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 56.0,
                            )
                          ],
                        ),
                        body: new SingleChildScrollView(
                          child: SafeArea(
                            child: Container(
                              height: (SizeConfig.safeBlockVertical * 100) - 80,
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ///Card Information Text
                                            Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 1),
                                                alignment: Alignment.center,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                      onTap: null,
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      child: Container(
                                                        padding: EdgeInsets.all(5.0),
                                                        child: Text(
                                                          AppLocalizations.of(context).cardInformation,
                                                          style: TextStyle(
                                                              letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.UserPrimary,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      )
                                                  ),
                                                )
                                            ),
                                            ///Card Form
                                            CreditCardInputForm(
                                              cardHeight: 225,
                                              showResetButton : true,
                                              onStateChange: (currentState, cardInfo) {
                                                print(currentState);
                                                print(cardInfo);
                                              },
                                              customCaptions: {
                                                'PREV': AppLocalizations.of(context).prev,
                                                'NEXT': AppLocalizations.of(context).next,
                                                'DONE': AppLocalizations.of(context).done,
                                                'CARD_NUMBER': AppLocalizations.of(context).cardNumber,
                                                'CARDHOLDER_NAME': AppLocalizations.of(context).cardHolderName,
                                                'VALID_THRU': AppLocalizations.of(context).validThru,
                                                'SECURITY_CODE_CVC': AppLocalizations.of(context).securityCode,
                                                'NAME_SURNAME': AppLocalizations.of(context).nameSurname,
                                                'MM_YY': 'MM/YY',
                                                'RESET': AppLocalizations.of(context).reset,
                                              },
                                              frontCardDecoration: cardDecoration,
                                              backCardDecoration: cardDecoration,
                                              prevButtonDecoration: buttonStyle,
                                              nextButtonDecoration: buttonStyle,
                                              resetButtonDecoration : buttonStyle,
                                              prevButtonTextStyle: buttonTextStyle,
                                              nextButtonTextStyle: buttonTextStyle,
                                              resetButtonTextStyle: buttonTextStyle,
                                              initialAutoFocus: true, // optional
                                            ),
                                            // CardForm(
                                            //   formKey: formKey,
                                            //   card: card,
                                            //   cardDecoration: BoxDecoration(
                                            //       color: Color.fromRGBO(200, 200, 200, 1.0)
                                            //   ),
                                            //   cardCvcTextStyle: TextStyle(color: Colors.black),
                                            //   cardExpiryTextStyle: TextStyle(color: Colors.black),
                                            //   cardNumberTextStyle: TextStyle(color: Colors.black),
                                            // ),

                                            SizedBox(
                                              height: SizeConfig.safeBlockVertical * 2,
                                            ),
                                          ],
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ///Add Card
                                              Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                  width: 198,
                                                  height: 44,
                                                  child: MaterialButton(
                                                    elevation: 0,
                                                    hoverElevation: 0,
                                                    focusElevation: 0,
                                                    highlightElevation: 0,
                                                    onPressed: () {
                                                      if(formKey.currentState.validate()) {
                                                        formKey.currentState.save();
                                                        // debugPrint('UI_AddCArd => BRAND: ${Utils.enumToString(detectCCType(card.number))}');
                                                        StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethodWithNavigation(snapshot.user.uid));
                                                        // addPaymentMethodWithSetupIntent(context, snapshot.user.uid);

                                                        StripeCardResponse tmpCard = StripeCardResponse();
                                                        // tmpCard.brand = Utils.enumToString(detectCCType(card.number));
                                                        // tmpCard.expMonth = card.expMonth;
                                                        // tmpCard.expYear = card.expYear;
                                                        // tmpCard.last4 = card.last4;
                                                        // tmpCard.secretToken = card.cvc;

                                                        StripeState stripeState = StripeState().toEmpty();
                                                        stripeState.stripeCard = tmpCard;
                                                        CardState cardState = CardState().toEmpty();
                                                        cardState.stripeState = stripeState;
                                                        List<CardState> tmpList = snapshot.cardListState.cardListState;
                                                        bool canAdd = false;
                                                        tmpList.forEach((element) {
                                                          if(element.stripeState.stripeCard.secretToken != cardState.stripeState.stripeCard.secretToken)
                                                            canAdd = true;
                                                        });
                                                        if(canAdd)
                                                          tmpList.add(cardState);

                                                        StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));
                                                      }


                                                    },
                                                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                                    color: BuytimeTheme.UserPrimary,
                                                    padding: EdgeInsets.all(media.width * 0.03),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: new BorderRadius.circular(5),
                                                    ),
                                                    child: Text(
                                                      AppLocalizations.of(context).addCardUpper,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          fontWeight: FontWeight.w600,
                                                          color: BuytimeTheme.TextWhite
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              /*Container(
                                                child: MaterialButton(
                                                  child: Text(
                                                    AppLocalizations.of(context).friday,
                                                  ),
                                                  onPressed: () {
                                                    // TODO: add a card process start
                                                  },
                                                ),
                                              )*/
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                ),
                  ///Ripple Effect
                  (snapshot?.stripe?.stripeCard?.last4 != null && snapshot?.order?.addCardProgress) ?
                  Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                        height: SizeConfig.safeBlockVertical * 100,
                        decoration: BoxDecoration(
                          color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 50,
                                height: 50,
                                child: Center(
                                  child: SpinKitRipple(
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ) : Container()

              ],
            );
          })
    );
  }
  //
  // void buy(context) async {
  //   final StripeCard stripeCard = card;
  //   final String customerEmail = getCustomerEmail();
  //
  //   if (!stripeCard.validateCVC()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateDate()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateNumber()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
  //     return;
  //   }
  //
  //   Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
  //   String clientSecret = paymentIntentRes['client_secret'];
  //   String paymentMethodId = paymentIntentRes['payment_method'];
  //   String status = paymentIntentRes['status'];
  //
  //   if (status == 'requires_action') //3D secure is enable in this card
  //     paymentIntentRes = await confirmPayment3DSecure(clientSecret, paymentMethodId);
  //
  //   if (paymentIntentRes['status'] != 'succeeded') {
  //     showAlertDialog(context, AppLocalizations.of(context).warning, AppLocalizations.of(context).canceledTransaction);
  //     return;
  //   }
  //
  //   if (paymentIntentRes['status'] == 'succeeded') {
  //     showAlertDialog(context, AppLocalizations.of(context).success, AppLocalizations.of(context).thanksForBuying);
  //     return;
  //   }
  //   showAlertDialog(context, AppLocalizations.of(context).warning, AppLocalizations.of(context).transactionRejected);
  // }
  //
  // void addPaymentMethod(context) async {
  //   final StripeCard stripeCard = card;
  //   final String customerEmail = getCustomerEmail();
  //
  //   if (!stripeCard.validateCVC()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateDate()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateNumber()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
  //     return;
  //   }
  //
  //   Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
  //   print("StripePayment payment method test");
  //
  //
  //
  //   // TODO confirm the payment method has been added or notify a failure to the user
  // }
  //
  // void addPaymentMethodWithSetupIntent(context, userId) async {
  //   final StripeCard stripeCard = card;
  //   final String customerEmail = getCustomerEmail();
  //
  //   if (!stripeCard.validateCVC()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).cvcNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateDate()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).dateNotValid);
  //     return;
  //   }
  //   if (!stripeCard.validateNumber()) {
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).numberNotValid);
  //     return;
  //   }
  //   // TODO take remotes requests away from this file.
  //   // TODO show spinner on tap.
  //   /*var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc()
  //       .set({
  //     'status': "create request"
  //   });
  //   // now http request to create the actual setupIntent
  //   final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);
  //
  //   debugPrint('UI_U_AddCard: RESPONSE: ${response.statusCode}');
  //
  //   if(response.statusCode == 200)
  //     StoreProvider.of<AppState>(context).dispatch(AddedStripePaymentMethod());*/
  //   Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
  //
  //   // TODO confirm the payment method has been added or notify a failure to the user
  // }

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
            MaterialButton(
              elevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              highlightElevation: 0,
              child: Text(AppLocalizations.of(context).ok),
              onPressed: () => Navigator.of(context).pop(), // dismiss dialog
            ),
          ],
        );
      },
    );
  }
  //
  // Future<Map<String, dynamic>> createPaymentIntent(StripeCard stripeCard, String customerEmail) async {
  //   String clientSecret;
  //   Map<String, dynamic> paymentIntentRes, paymentMethod;
  //   try {
  //     // paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
  //     Map<String, dynamic> cardData;
  //     cardData = {
  //       "type": "card",
  //       "card": {"number": stripeCard.number, "exp_month": stripeCard.expMonth, "exp_year": stripeCard.expYear, "cvc": stripeCard.cvc}
  //     };
  //     paymentMethod = await stripe.api.createPaymentMethod(cardData);
  //     var userId = StoreProvider.of<AppState>(context).state.user.uid;
  //     // save this on firebase to trigger the cloud function
  //     StoreProvider.of<AppState>(context).dispatch(AddStripePaymentMethod(paymentMethod, userId));
  //     //clientSecret = await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
  //     //paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
  //   } catch (e) {
  //     print("ERROR_CreatePaymentIntentAndSubmit: $e");
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).somethingWentWrong);
  //   }
  //   return paymentIntentRes;
  // }
  //

  final String postCreateIntentURL = "https:/yourserver/postPaymentIntent";
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

  // Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId) async {
  //   Map<String, dynamic> paymentIntentRes_3dSecure;
  //   try {
  //     await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
  //     paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
  //   } catch (e) {
  //     print("ERROR_ConfirmPayment3DSecure: $e");
  //     showAlertDialog(context, AppLocalizations.of(context).error, AppLocalizations.of(context).somethingWentWrong);
  //   }
  //   return paymentIntentRes_3dSecure;
  // }

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

  final cardDecoration = BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(color: Colors.black54, blurRadius: 5.0, offset: Offset(0, 2))
      ],
      gradient: LinearGradient(
          colors: [
            BuytimeTheme.Indigo,
            BuytimeTheme.UserPrimary,
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  final buttonStyle = BoxDecoration(
    borderRadius: BorderRadius.circular(4.0),
    gradient: LinearGradient(
        colors: [
          BuytimeTheme.UserPrimary,
          BuytimeTheme.UserPrimary,
        ],
        begin: const FractionalOffset(0.0, 0.0),
        end: const FractionalOffset(1.0, 0.0),
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );

  final buttonTextStyle = TextStyle(color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w600, fontSize: 16);

}
class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;
  ShowDialogToDismiss({this.title, this.buttonText, this.content});
  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text(
              buttonText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: new Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                buttonText[0].toUpperCase() +
                    buttonText.substring(1).toLowerCase(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
    }
  }
}