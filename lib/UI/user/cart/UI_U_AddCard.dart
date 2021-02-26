import 'dart:convert';
import 'package:Buytime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/reusable/stripe/optimum_credit_card_button.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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

  CardState cardState = CardState().toEmpty();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
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
                  'Add Card', ///TODO Make it Global
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
                                      //formKey.currentState.validate();
                                      //formKey.currentState.save();
                                      StripeCardResponse tmpCard = StripeCardResponse();
                                      /*tmpCard.brand = card.number.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                      tmpCard.expMonth = card.expMonth;
                                      tmpCard.expYear = card.expYear;
                                      tmpCard.last4 = card.last4;
                                      tmpCard.secretToken = card.cvc;*/

                                      tmpCard.brand = '4000 0000 0000 0000'.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                      tmpCard.expMonth = 12;
                                      tmpCard.expYear = 22;
                                      tmpCard.last4 = '0000';
                                      tmpCard.secretToken = '000';

                                      cardState.cardResponse = tmpCard;
                                      cardState.selected = false;

                                      CardState tmpCardState = CardState().toEmpty();
                                      StripeCardResponse tmpCard2 = StripeCardResponse();

                                      tmpCard2.brand = '5000 0000 0000 1111'.substring(0,1) == '4' ? 'Visa' : 'Mastercard';
                                      tmpCard2.expMonth = 12;
                                      tmpCard2.expYear = 22;
                                      tmpCard2.last4 = '1111';
                                      tmpCard2.secretToken = '111';

                                      tmpCardState.cardResponse = tmpCard2;
                                      tmpCardState.selected = false;
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder()),);
                                      //StoreProvider.of<AppState>(context).dispatch(AddingStripePaymentMethod());
                                      //addPaymentMethodWithSetupIntent(context, snapshot.user.uid);
                                      List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardListState;
                                      tmpList.add(cardState);
                                      tmpList.add(tmpCardState);
                                      StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));
                                      Navigator.of(context).pop();
                                    },
                                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                    color: BuytimeTheme.UserPrimary,
                                    padding: EdgeInsets.all(media.width * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      'ADD CARD',//AppLocalizations.of(context).logBack, ///TODO Make it Global
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


}
