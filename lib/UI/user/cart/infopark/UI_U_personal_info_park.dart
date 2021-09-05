import 'dart:convert';

import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PersonalInfoPark extends StatefulWidget {
  final String title = 'Personal Info';
  PersonalInfoPark({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => PersonalInfoParkState();
}

class PersonalInfoParkState extends State<PersonalInfoPark> with SingleTickerProviderStateMixin {

  UserState user = UserState().toEmpty();
  final formKey = GlobalKey<FormState>();
  bool requestFlying = false;
  CardFieldInputDetails _card;

  var _responseObject;

  @override
  void initState() {
    super.initState();
    user = UserState().toEmpty();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: Scaffold(
         appBar: BuytimeAppbar(
            width: media.width,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                      onPressed: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: RBusinessList(), exitPage: UI_M_CreateBusiness(), from: false));
                      }),
                ],
              ),
              ///Title
              Utils.barTitle(AppLocalizations.of(context).yourDetails),
              SizedBox(
                width: 56.0,
              )
            ],
          ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0, bottom: 15.0),
            child: ListView(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      StoreConnector<AppState, AppState>(
                      onInit: (store) {
                        user.email = store.state.user.email;
                      },
                      distinct: true,
                      converter: (store) => store.state,
                      builder: (context, snapshot) {
                        return Container();
                      }),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.name = value;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).name + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.surname = value;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).surname + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.cellularPhone = int.parse(value);
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).phoneNumber + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.city = value;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).cityTown + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.zip = int.parse(value);
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).zipPostal + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).stateTerritoryProvince + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.nation = value;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).state + "*"),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context).required;
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              user.street = value;
                            },
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                            decoration: configureInputDecoration(context, AppLocalizations.of(context).address + "*"),
                          )),
                    ],
                  ),
                ),
                requestFlying ?
                Text("Loading...")    :
                MaterialButton(
                  textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                  color: BuytimeTheme.BackgroundCerulean,
                  disabledColor: BuytimeTheme.SymbolLightGrey,
                  //padding: EdgeInsets.all(media.width * 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: SizeConfig.blockSizeHorizontal * 57,
                    height: 44,
                    child: Text(
                      AppLocalizations.of(context).checkAvailability,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.25,
                        fontSize: 14,
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w500,
                        color: BuytimeTheme.TextWhite,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      debugPrint("UI_U_personal_info_park validation ok");
                      setState(() {
                        requestFlying = true;
                      });
                      // TODO inoltrare richiesta post con i campi necessari per verificare la disponibilitá
                      final url = Uri.https('test1.tourismengine.eu', '/api/public/service/availability-and-prices/4565', {});
                      final http.Response response = await http.get(url);
                      var responseObject =  json.decode(response.body);
                      if (responseObject["status"] == false) {
                        debugPrint("UI_U_personal_info_park slot problem: " + responseObject["message"] );
                      } else {
                        setState(() {
                          requestFlying = false;
                          _responseObject = responseObject;
                        });
                      }
                    } else {
                      debugPrint("UI_U_personal_info_park validation failed");
                    }
                  },
                ),
                CardField(
                  onCardChanged: (card) {
                    setState(() {
                      _card = card;
                    });
                  },
                ),
                MaterialButton(
                  textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                  color: BuytimeTheme.BackgroundCerulean,
                  disabledColor: BuytimeTheme.SymbolLightGrey,
                  //padding: EdgeInsets.all(media.width * 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: SizeConfig.blockSizeHorizontal * 57,
                    height: 44,
                    child: Text(
                      AppLocalizations.of(context).confirmPayment,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        letterSpacing: 1.25,
                        fontSize: 14,
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w500,
                        color: BuytimeTheme.TextWhite,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if(formKey.currentState.validate()) {
                      debugPrint("UI_U_personal_info_park validation ok");
                      setState(() {
                        requestFlying = false;
                      });
                      // TODO inoltrare richiesta post con i campi necessari per verificare la disponibilitá

                        String infoparkStripeTestKey = "pk_test_D913jo5bMZtK6kAANKTpsulW00omqUEEHd";
                        // TODO crea metodo di pagamento con la loro chiave pubblica
                        // var paymentMethodParams = PaymentMethodParams.card()
                        // Stripe.publishableKey = infoparkStripeTestKey;
                        // var resultOfConfirmation = await Stripe.instance.createPaymentMethod(_card);
                        // TODO conferma la prenotazione generando un client secret
                        final url = Uri.parse('test1.tourismengine.eu/api/public/service/confirm-booking');
                        final response = await http.post(
                          url,
                          headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                            'Accept': 'application/json',
                          },
                          body: json.encode({
                            "service": 4549,
                            "seats[1]": 1,
                            "name": "test",
                            "surname": "test",
                            "email": "xxx@cr2.pw",
                            "cellular_prefix":"+39",
                            "cellular": "3280077380",
                            "address":"via roma",
                            "city":"portoferraio",
                            "zip": 57037,
                            "province":"LI",
                            "country":"IT",
                            "tax_code": "xxxx"
                          }),
                        );
                        var responseObject =  json.decode(response.body);


                        // TODO conferma il client secret ricevuto
                        // TODO esito negativo: visualizza l'errore
                        // TODO esito positivo: crea l'ordine buytime associato
                        // TODO inserire l'ordine nello store
                        // TODO redirect al dettaglio dell'ordine

                      /// reset the key to our key
                      Stripe.publishableKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";

                    } else {
                      debugPrint("UI_U_personal_info_park validation failed");
                    }
                  },
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }

  InputDecoration configureInputDecoration(BuildContext context, String label) {
    return InputDecoration(
                      labelText: label,
                      errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                      // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      // border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      // focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      // errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    );
  }

}
