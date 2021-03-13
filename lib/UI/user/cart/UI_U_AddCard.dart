import 'dart:convert';
import 'package:Buytime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/reusable/stripe/optimum_credit_card_button.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO separate service and UI
class UI_U_AddCard extends StatefulWidget {
  UI_U_AddCard({Key key}) : super(key: key);

  @override
  _UI_U_AddCardState createState() => _UI_U_AddCardState();
}

class _UI_U_AddCardState extends State<UI_U_AddCard> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();

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
                              width: 40.0,
                            )
                          ],
                        ),
                        body: new SingleChildScrollView(
                          child: SafeArea(
                            child: Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      ///User Information Text
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
                                                    'User Information',//AppLocalizations.of(context).somethingIsNotRight,
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
                                      ///User Information
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ///Name
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: SizeConfig.safeBlockHorizontal * 42.5,
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                margin: const EdgeInsets.only(top: 8),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.done,
                                                  //initialValue: _validationModel.postalCode ?? widget.card.postalCode,
                                                  /*onChanged: (text) => setState(() => _validationModel.postalCode = text),
                        onSaved: (text) => widget.card.postalCode = text,
                        autofillHints: [AutofillHints.postalCode],
                        validator: (text) => _validationModel.isPostalCodeValid()
                            ? null
                            : widget.postalCodeErrorText ?? 'Invalid postal code',*/
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Name'
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ///surname
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Container(
                                                width: SizeConfig.safeBlockHorizontal * 42.5,
                                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                margin: const EdgeInsets.only(top: 8),
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  textInputAction: TextInputAction.done,
                                                  //initialValue: _validationModel.postalCode ?? widget.card.postalCode,
                                                  /*onChanged: (text) => setState(() => _validationModel.postalCode = text),
                        onSaved: (text) => widget.card.postalCode = text,
                        autofillHints: [AutofillHints.postalCode],
                        validator: (text) => _validationModel.isPostalCodeValid()
                            ? null
                            : widget.postalCodeErrorText ?? 'Invalid postal code',*/
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      labelText: 'Surname'
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ///Card Information Text
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 0),
                                          alignment: Alignment.center,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: null,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Card Information',//AppLocalizations.of(context).somethingIsNotRight,
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
                                      ///Remeber Me
                                      Row(
                                        children: [
                                          Checkbox(
                                            checkColor: BuytimeTheme.TextWhite,
                                            activeColor: BuytimeTheme.TextGrey,
                                            value: remeberMe,
                                            onChanged: (bool value) {
                                              setState(() {
                                                remeberMe = value;
                                              });
                                            },
                                          ),
                                          Container(
                                            //padding: EdgeInsets.all(5.0),
                                            child: Text(
                                              'Remember My Cards Info ',//AppLocalizations.of(context).somethingIsNotRight,
                                              style: TextStyle(
                                                  letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextGrey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: media.height * 0.05,
                                      ),
                                      ///Add Card Button
                                      /*GestureDetector(
                      onTap: () {
                        formKey.currentState.validate();
                        formKey.currentState.save();
                        //StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethod());
                        //addPaymentMethodWithSetupIntent(context, snapshot.user.uid);

                      },
                      child: AddCardButton(media, AppLocalizations.of(context).addCreditCard, Color.fromRGBO(1, 175, 81, 1.0)),
                    ),*/
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          //height: double.infinity,
                                          //color: Colors.black87,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ///Add Card
                                              Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                  width: media.width * .4,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      formKey.currentState.validate();
                                                      formKey.currentState.save();

                                                     // debugPrint('UI_AddCArd => BRAND: ${card.}');
                                                      StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethodWithNavigation(snapshot.user.uid));
                                                      addPaymentMethodWithSetupIntent(context, snapshot.user.uid);

                                                      StripeCardResponse tmpCard = StripeCardResponse();
                                                      tmpCard.brand = card.number.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                                      tmpCard.expMonth = card.expMonth;
                                                      tmpCard.expYear = card.expYear;
                                                      tmpCard.last4 = card.last4;
                                                      tmpCard.secretToken = card.cvc;

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
                                                      //CardState().writeToStorage(tmpList);
                                                      StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));

                                                        /*tmpCard.brand = '4000 0000 0000 0000'.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                                  tmpCard.expMonth = 12;
                                                  tmpCard.expYear = 22;
                                                  tmpCard.last4 = '0000';
                                                  tmpCard.secretToken = '000';
                                                  cardState.cardId = '';
                                                  cardState.cardOwner = '';
                                                  cardState.cardResponse = tmpCard;
                                                  cardState.selected = false;

                                                  CardState tmpCardState = CardState().toEmpty();
                                                  StripeCardResponse tmpCard2 = StripeCardResponse();
                                                  tmpCard2.brand = '5000 0000 0000 1111'.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                                  tmpCard2.expMonth = 12;
                                                  tmpCard2.expYear = 22;
                                                  tmpCard2.last4 = '1111';
                                                  tmpCard2.secretToken = '111';
                                                  tmpCardState.cardId = '';
                                                  tmpCardState.cardOwner = '';
                                                  tmpCardState.cardResponse = tmpCard2;
                                                  tmpCardState.selected = false;
                                                  List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardListState;
                                                  tmpList.add(cardState);
                                                  tmpList.add(tmpCardState);
                                                  if(remeberMe)*/

                                                      //Navigator.of(context).pop();
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
                                                          fontSize: 18,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          fontWeight: FontWeight.w500,
                                                          color: BuytimeTheme.TextWhite
                                                      ),
                                                    ),
                                                  )
                                              ),
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
    /*var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc()
        .set({
      'status': "create request"
    });
    // now http request to create the actual setupIntent
    final http.Response response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);

    debugPrint('UI_U_AddCard: RESPONSE: ${response.statusCode}');

    if(response.statusCode == 200)
      StoreProvider.of<AppState>(context).dispatch(AddedStripePaymentMethod());*/
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


}
