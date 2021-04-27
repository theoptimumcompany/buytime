import 'dart:convert';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:credit_card_input_form/constants/constanst.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:credit_card_input_form/credit_card_input_form.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart' as StripeUnofficialUI;


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

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final StripeCard card = StripeCard();
  Map<String, dynamic> cardData;
  bool remeberMe = false;
  int initialCardsNumber;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: StoreConnector<AppState, AppState>(
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
                                              onStateChange: (currentState, cardInfo) async {
                                                /// Set the card data to give to Stripe
                                                print(currentState);
                                                print(cardInfo);
                                                if (currentState == InputState.DONE) {
                                                  /// trigger the ripple wait
                                                  StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethod());
                                                  /// create the StripeCard
                                                  String expMonth = cardInfo.validate.split('/')[0];
                                                  String expYear = cardInfo.validate.split('/')[1];
                                                  String last4 = cardInfo.cardNumber.substring(cardInfo.cardNumber.length - 4);
                                                  StripeUnofficialUI.StripeCard stripeCard = StripeUnofficialUI.StripeCard(
                                                      number: cardInfo.cardNumber,
                                                      cvc: cardInfo.cvv,
                                                      expMonth: int.parse(expMonth),
                                                      expYear: int.parse(expYear),
                                                      last4: last4
                                                  );
                                                  /// call the saving in the stripe account
                                                  StoreProvider.of<AppState>(context).dispatch(AddStripePaymentMethod(stripeCard, snapshot.user.uid));

                                                }
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
                                            SizedBox(
                                              height: SizeConfig.safeBlockVertical * 2,
                                            ),
                                          ],
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
                 () {
                 if (snapshot?.order?.addCardProgress == Utils.enumToString(AddCardStatus.inProgress)) {
                   return RippleAddCard();
                 } else if (snapshot?.order?.addCardProgress == Utils.enumToString(AddCardStatus.done)) {
                   StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethodReset());
                   Navigator.of(context).pop();
                   return Container();
                 }
                 return Container();
                } ()
              ],
            );
          })
    );
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
      Uri.parse(postCreateIntentURL),
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

class RippleAddCard extends StatelessWidget {
  const RippleAddCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
                );
  }
}


