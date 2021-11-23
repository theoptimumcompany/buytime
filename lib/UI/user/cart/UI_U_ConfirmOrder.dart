import 'dart:io';
import 'package:Buytime/UI/user/payment/paypal_payment.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/helper/payment/util.dart';
import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/promotion/promo_code_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/w_green_choice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/order/w_order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../environment_abstract.dart';
import 'UI_U_card_choice.dart';

class ConfirmOrder extends StatefulWidget {
  final String title = 'confirmOrder';
  bool tourist = false;
  bool reserve = false;

  ConfirmOrder({Key key, this.reserve, this.tourist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;
  String _email = '';
  SetupIntent _setupIntentResult;
  String _userId = '';
  AppState state;
  OrderState orderState;
  OrderReservableState orderReservableState;
  bool disableRoomPayment = false;
  List<Widget> cardWidgetList = [];
  bool deleting = false;
  bool carbonCompensation = false;
  double totalECO = 0;
  double partialECO = 0;
  PromoCodeState promoCodeState;

  @override
  void initState() {
    super.initState();
    if(Provider.of<Explorer>(context, listen: false).promotionCode.isNotEmpty){
      promotionController.text = Provider.of<Explorer>(context, listen: false).promotionCode;
      addPromotion = true;
    }

  }

  @override
  void dispose() {
    StoreProvider.of<AppState>(context).dispatch(ResetOrderIfPaidOrCanceled()); //TODO: NON SI SA
    super.dispose();
  }

  bool waitingForUser = true;
  bool isExternal = false;
  bool cardOrder = false;

  bool paymentSheetIdLoading = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return false;
      },
      child: StoreConnector<AppState, AppState>(
          onInit: (store) {
            store?.dispatch(CheckStripeCustomer(true));
            resetPaymentTypeIfNotAccepted(store.state);
            debugPrint('UI_U_ConfirmOrder => ON INIT');
          },
          distinct: true,
          converter: (store) => store.state,
          builder: (context, snapshot) {
            debugPrint('UI_U_ConfirmOrder builder | ORDER TOTAL: ${snapshot.order.total}');
            ///Check if order is reservable or not
            if (widget.reserve != null && widget.reserve) {
              orderReservableState = snapshot.orderReservable;
              if (widget.tourist ||
                  snapshot.booking != null &&
                      snapshot.booking.booking_id != null &&
                      snapshot.booking.booking_id.isNotEmpty &&
                      (snapshot.orderReservable != null && snapshot.orderReservable.itemList.isNotEmpty && snapshot.orderReservable.itemList[0].id_business != snapshot.booking.business_id)) {
                disableRoomPayment = true;
              } else {
                disableRoomPayment = false;
              }
              partialECO = (orderReservableState.total * 2.5) / 100;
              carbonCompensation = snapshot.orderReservable.carbonCompensation;
            } else {
              orderState = snapshot.order;
              if ((widget != null && widget.tourist != null && widget.tourist) ||
                  ((snapshot.booking != null && snapshot.booking.business_id != null && snapshot.booking.business_id.isNotEmpty) &&
                      (snapshot.order != null && snapshot.order.itemList.isNotEmpty && snapshot.order.itemList[0].id_business != snapshot.booking.business_id))) {
                disableRoomPayment = true;
              } else {
                disableRoomPayment = false;
              }
              partialECO = (orderState.total * 2.5) / 100;
              carbonCompensation = snapshot.order.carbonCompensation;
            }

            ///Check If External Service
            ///Doesn't work if there isn't a booking
            if (orderState != null && orderState.itemList.isNotEmpty && orderState.itemList.first.id_business != snapshot.business.id_firestore) {
              debugPrint('UI_U_cart => ORDER BUSINESS ID: ${orderState.itemList.first.id_business} | BUSINESS ID: ${snapshot.business.id_firestore}');
              isExternal = true;
            }

            _email = snapshot.user.email;
            _userId = snapshot.user.uid;
            state = snapshot;



            return Scaffold(
                appBar: buildBuytimeAppbar(media, context),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                ///Reserve
                floatingActionButton: showPaymentButton ?
                Container(
                  width: double.infinity,
                  //height: 100,
                  color: Colors.white,
                  child: Container(
                    width: 198,
                    height: 60 + SizeConfig.safeBlockVertical * 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: SizeConfig.safeBlockVertical * 2),
                          child: MaterialButton(
                            color: snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal)
                                ? BuytimeTheme.Secondary
                                : BuytimeTheme.ActionBlackPurple,
                            disabledColor: BuytimeTheme.SymbolLightGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20),
                            ),
                            child: paymentSheetIdLoading ? Container(
                                alignment: Alignment.center,
                                width: SizeConfig.blockSizeHorizontal * 57,
                                height: 44,
                                //padding: EdgeInsets.all(2.5),
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                            ) :
                            Container(
                              alignment: Alignment.center,
                              width: SizeConfig.blockSizeHorizontal * 57,
                              height: 44,
                              child: Text(
                                AppLocalizations.of(context).confirmPayment,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 16,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal) ? Colors.black : BuytimeTheme.TextWhite,
                                ),
                              ),
                            ),
                            onPressed: snapshot.stripe.chosenPaymentMethod != Utils.enumToString(PaymentType.noPaymentMethod) ? () async {
                              FirebaseAnalytics().logEvent(
                                  name: 'ok_confirm_order',
                                  parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': snapshot.stripe.chosenPaymentMethod});

                              double totalToSend = 0.0;
                              if (widget.reserve != null && widget.reserve){
                                totalToSend = snapshot.orderReservable.total;
                                snapshot.orderReservable.total = double.parse(snapshot.orderReservable.total.toStringAsFixed(2));
                                snapshot.orderReservable.totalPromoDiscount = double.parse(snapshot.orderReservable.totalPromoDiscount.toStringAsFixed(2));
                              }else{
                                totalToSend = snapshot.order.total;
                                snapshot.order.total = double.parse(snapshot.order.total.toStringAsFixed(2));
                                snapshot.order.totalPromoDiscount = double.parse(snapshot.order.totalPromoDiscount.toStringAsFixed(2));
                              }

                              if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay) ||
                                  snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay) ||
                                  snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
                                setState(() {
                                  paymentSheetIdLoading = true;
                                });
                                debugPrint("ui_u_confirmOrder stripe paymentSheet");

                                // Stripe.publishableKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
                                Stripe.publishableKey = StripeConfig().keyToUse;
                                final paymentSheetData = await requestPaymentSheet(snapshot.user.uid, totalToSend);
                                Stripe.merchantIdentifier = 'merchant.theoptimumcompany.buytime';
                                // Stripe.merchantIdentifier = 'com.theoptimumcompany.buytime';
                                await Stripe.instance.applySettings();

                                debugPrint(
                                    "ui_u_confirmOrder stripe paymentSheet parameters + ${paymentSheetData['customer']} + ${paymentSheetData['paymentIntent']} + ${paymentSheetData['ephemeralKey']}");
                                debugPrint("ui_u_confirmOrder stripe paymentSheet parameters json + $paymentSheetData");

                                await Stripe.instance.initPaymentSheet(
                                    paymentSheetParameters: SetupPaymentSheetParameters(
                                      applePay: Stripe.instance.isApplePaySupported.value,
                                      googlePay: true,
                                      style: ThemeMode.light,
                                      testEnv: true,
                                      merchantCountryCode: 'DE',
                                      merchantDisplayName: 'Buytime | The Optimum Company S.R.L.i.',
                                      customerId: paymentSheetData['customer'],
                                      paymentIntentClientSecret: paymentSheetData['paymentIntent'],
                                      customerEphemeralKeySecret: paymentSheetData['ephemeralKey'],
                                    ));

                                try {
                                  await Stripe.instance.presentPaymentSheet();
                                  print("OK");
                                  setState(() {
                                    paymentSheetIdLoading = false;
                                  });
                                  confirmationCard(context, snapshot, '', '', '', paymentSheetData['paymentIntent'].split('_secret')[0]);
                                  // if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
                                  //
                                  // } else {
                                  //   print("Native Confirm Order");
                                  //   confirmationNative(context, snapshot);
                                  // }
                                } on Exception catch (e) {
                                  if (e is StripeException) {
                                    print("No Stripe Exception");
                                  } else {
                                    print("No general error Exception");
                                  }
                                  setState(() {
                                    paymentSheetIdLoading = false;
                                  });
                                }
                                debugPrint("ui_u_confirmOrder stripe paymentSheet end");
                              } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room)) {
                                confirmationRoom(context, snapshot);
                              } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite)) {
                                confirmationOnSite(context, snapshot);
                              } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal)) {
                                confirmationPayPal(context, snapshot);
                              }


                            } : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minHeight: SizeConfig.screenHeight - (66 + SizeConfig.safeBlockVertical * 2)
                      ),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Recap list
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildOrderRecap(context, snapshot, media),
                              ],
                            ),
                            /// bottom block, confirm button and payment method
                            Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 100,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3),
                                  child: Text(
                                    AppLocalizations.of(context).paymentMethod,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 0.0, right: 20),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        trailing: const Icon(
                                          Icons.keyboard_arrow_right,
                                          color: Colors.black54,
                                          size: 25.0,
                                        ),
                                        leading: getCurrentLeadingImage(context, snapshot),
                                        title: getCurrentPaymentMethod(context, snapshot),
                                        onTap: () {
                                          String serviceNameFromOrder = "";
                                          if (widget.reserve != null && widget.reserve && snapshot.orderReservable != null && snapshot.orderReservable.itemList.isNotEmpty) {
                                            serviceNameFromOrder = snapshot.orderReservable.itemList.first.name;
                                          } else {
                                            serviceNameFromOrder = snapshot.order.itemList.first.name;
                                          }
                                          FirebaseAnalytics().logEvent(
                                              name: 'open_payment_method_confirm_order',
                                              parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'service_name': serviceNameFromOrder});
                                          _modalChoosePaymentMethod(context, snapshot);
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay) ||
                                    snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay) ||
                                    snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card) ?
                                Container(
                                  height: 26,
                                  width: double.infinity,
                                  margin: EdgeInsets.only(right: 15, bottom: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 26,
                                        width: 119,
                                        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/img/brand/p_stripe.png'))),
                                      )
                                    ],
                                  ),
                                )
                                    : Container(),
                                // snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay) || snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay) || snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)
                                //     ?
                                //
                                //     /// TODO: CASO STRIPE
                                //     Container()

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }),
    );
  }

  Text getCurrentPaymentMethod(BuildContext context, AppState snapshot) {
    if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
      /*if (snapshot.cardListState != null &&
          snapshot.cardListState.cardList != null &&
          snapshot.cardListState.cardList.first.stripeState != null &&
          snapshot.cardListState.cardList.first.stripeState.stripeCard != null) {
        return Text(snapshot.cardListState.cardList.first.stripeState.stripeCard.brand + " " + snapshot.cardListState.cardList.first.stripeState.stripeCard.last4);
      }*/
      return Text(AppLocalizations.of(context).creditCard.replaceAll(":", ""));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room)) {
      return Text(AppLocalizations.of(context).room.replaceAll(":", ""));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite)) {
      return Text(AppLocalizations.of(context).onSite);
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay)) {
      return Text(AppLocalizations.of(context).googlePay);
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay)) {
      return Text(AppLocalizations.of(context).applePay);
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal)) {
      return Text(AppLocalizations.of(context).paypal);
    }
    return Text(AppLocalizations.of(context).choosePaymentMethod);
  }

  bool resetPaymentTypeIfNotAccepted(AppState snapshot) {
    if (((snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card) ||
        snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay) ||
        snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal) ||
        snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay)) &&
        !snapshot.serviceState.paymentMethodCard) ||
        (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room) && (!snapshot.serviceState.paymentMethodRoom || isExternal)) ||
        (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite) && !snapshot.serviceState.paymentMethodOnSite)) {
      StoreProvider.of<AppState>(context).dispatch(ResetPaymentMethod());
    }
  }

  Pay _payClient = Pay.withAssets(['google_pay_payment_profile.json']);

  Future<void> _modalChoosePaymentMethod(context, AppState snapshot) {
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(left: 30, top: 30, bottom: 30, right: 30),
            //height: 550,
            child: new Wrap(
              children: <Widget>[
                /// TODO wrap with realtime query for card list
                ///
                ///Paypal
                snapshot.serviceState.paymentMethodCard
                    ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/brand/paypal.png')),
                  title: new Text(AppLocalizations.of(context).paypal),
                  onTap: () {
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.paypal)));
                    Navigator.of(context).pop();
                  },
                )
                    : Container(),
                snapshot.serviceState.paymentMethodCard ? Divider() : Container(),
                snapshot.serviceState.paymentMethodCard
                    ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('stripeCustomer').doc(_userId).collection('card').snapshots(includeMetadataChanges: true),
                    builder: (context, cardListSnapshot) {
                      if (cardListSnapshot.hasError || cardListSnapshot.connectionState == ConnectionState.waiting) {
                        return Text(AppLocalizations.of(context).loading + "...");
                      }
                      StripeCardResponse cardFromFirestore;
                      if (cardListSnapshot.data.docs.isEmpty) {
                      } else {
                        cardFromFirestore = StripeCardResponse.fromJson(cardListSnapshot.data.docs.first.data());
                        cardFromFirestore.firestore_id = cardListSnapshot.data.docs.first.id;
                      }
                      return ListTile(
                        leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/mastercard_icon.png')),
                        title: creditCardText(context, cardFromFirestore),
                        trailing: creditCardTrailing(context, cardFromFirestore),
                        onTap: () {
                          FirebaseAnalytics().logEvent(
                              name: 'payment_method_specific_confirm_order',
                              parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': Utils.enumToString(PaymentType.card)});
                          StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.card)));
                          Navigator.of(context).pop();
                        },
                      );
                    })
                    : Container(),
                Platform.isIOS && snapshot.serviceState.paymentMethodCard ? Divider() : Container(),
                Platform.isIOS && snapshot.serviceState.paymentMethodCard
                    ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/applePay.png')),
                  title: new Text(AppLocalizations.of(context).applePay),
                  onTap: () {
                    FirebaseAnalytics().logEvent(
                        name: 'payment_method_specific_confirm_order',
                        parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': Utils.enumToString(PaymentType.applePay)});
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.applePay)));
                    Navigator.of(context).pop();
                  },
                )
                    : Container(),
                Platform.isAndroid
                    ? FutureBuilder<bool>(
                  future: _payClient.userCanPay(PayProvider.google_pay),
                  builder: (context, snapshotPay) {
                    if (snapshotPay.connectionState == ConnectionState.done) {
                      if (snapshotPay.data == true) {
                        return Divider();
                      }
                    }
                    return Container();
                  },
                )
                    : Container(),
                Platform.isAndroid
                    ? FutureBuilder<bool>(
                  future: _payClient.userCanPay(PayProvider.google_pay),
                  builder: (context, snapshotPay) {
                    if (snapshotPay.connectionState == ConnectionState.done) {
                      if (snapshotPay.data == true) {
                        return ListTile(
                          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/googlePay.png')),
                          title: new Text(AppLocalizations.of(context).googlePay),
                          onTap: () {
                            FirebaseAnalytics().logEvent(
                                name: 'payment_method_specific_confirm_order',
                                parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': Utils.enumToString(PaymentType.googlePay)});
                            StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.googlePay)));
                            Navigator.of(context).pop();
                          },
                        );
                      }
                    }
                    return Container();
                  },
                )
                    : Container(),
                !widget.tourist && snapshot.serviceState.paymentMethodRoom && !isExternal ? Divider() : Container(),
                !widget.tourist && snapshot.serviceState.paymentMethodRoom && !isExternal
                    ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/room.png')),
                  title: new Text(AppLocalizations.of(context).room.replaceAll(":", "")),
                  onTap: () {
                    FirebaseAnalytics().logEvent(
                        name: 'payment_method_specific_confirm_order',
                        parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': Utils.enumToString(PaymentType.room)});
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.room)));
                    Navigator.of(context).pop();
                  },
                )
                    : Container(),
                snapshot.serviceState.paymentMethodOnSite ? Divider() : Container(),
                snapshot.serviceState.paymentMethodOnSite
                    ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/cash.png')),
                  title: new Text(AppLocalizations.of(context).onSite),
                  onTap: () {
                    FirebaseAnalytics().logEvent(
                        name: 'payment_method_specific_confirm_order',
                        parameters: {'user_email': snapshot.user.email, 'date': DateTime.now().toString(), 'payment_method': Utils.enumToString(PaymentType.onSite)});
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.onSite)));
                    Navigator.of(context).pop();
                  },
                )
                    : Container(),
              ],
            ),
          );
        });
  }

  Text creditCardText(context, StripeCardResponse cardFromFirestore) {
    if (cardFromFirestore != null) {
      return Text(cardFromFirestore.brand + " " + cardFromFirestore.last4);
    }
    return Text(AppLocalizations.of(context).creditCard.replaceAll(":", ""));
  }

  bool addPromotion = false;
  bool showPaymentButton = true;
  bool promotion = false;
  bool requestPromo = false;
  bool invalidPromoCode = false;
  TextEditingController promotionController = TextEditingController();

  ///Recap
  Container buildOrderRecap(BuildContext context, AppState snapshot, Size media) {
    List<String> imgUrl = [];
    List<String> quantity = [];
    List<String> names = [];
    if (widget.reserve != null && widget.reserve) {
      snapshot.orderReservable.itemList.forEach((element) {
        imgUrl.add(element.thumbnail);
        quantity.add('${element.number} x ${element.price.toStringAsFixed(2)}${AppLocalizations.of(context).currency}');
        names.add(Utils.retriveField(Localizations.localeOf(context).languageCode, element.name));
      });
    } else {
      snapshot.order.itemList.forEach((element) {
        imgUrl.add(element.thumbnail);
        quantity.add('${element.number} x ${element.price.toStringAsFixed(2)}${AppLocalizations.of(context).currency}');
        names.add(Utils.retriveField(Localizations.localeOf(context).languageCode, element.name));
      });
    }
    int i = -1;
    debugPrint('UI_U_ConfirmOrder buildOrderRecap | ORDER TOTAL: ${snapshot.order.total}');
    return Container(
      child: Column(
        children: [
          ///Order List
          Column(
            children: imgUrl.map((e) {
              i++;
              return Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ///Image
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: CachedNetworkImage(
                          imageUrl: Utils.version200(imgUrl.elementAt(i)),
                          imageBuilder: (context, imageProvider) => Container(
                            //width: double.infinity,
                            //height: double.infinity,
                            width: 100, ///SizeConfig.safeBlockVertical * widget.width
                            height: 100, ///SizeConfig.safeBlockVertical * widget.width
                            decoration: BoxDecoration(
                                color: BuytimeTheme.BackgroundWhite,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                          ),
                          placeholder: (context, url) => Utils.imageShimmer(100, 100),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              names.elementAt(i),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: Text(
                              quantity.elementAt(i),
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          ///Divider
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 17),
            color: BuytimeTheme.BackgroundLightGrey,
            height: SizeConfig.safeBlockVertical * .2,
          ),
          ///Do you have ...
          Container(
            margin: EdgeInsets.only(left: 16, top: 17, bottom: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Do you have ...
                    Container(
                      child: Text(
                        AppLocalizations.of(context).doYouHaveAPromotionalCode,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ///Icon
                    Container(
                      child: IconButton(
                        onPressed: (){
                          setState(() {
                            addPromotion = !addPromotion;
                          });
                        },
                        icon: Icon(
                          !addPromotion ? Icons.add : Icons.remove,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                ///Promotion insert
                addPromotion ?
                Container(
                  margin: EdgeInsets.only(left: 0, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          height: 38.0,
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, right: 18),
                          child: TextFormField(
                            controller: promotionController,
                            key: Key('table_number_field_key'),
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            //textCapitalization: TextCapitalization.words,
                            //keyboardType: TextInputType.,
                            onChanged: (value) {

                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 10, left: 10),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: invalidPromoCode ? BuytimeTheme.AccentRed : Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              //errorText: invalidPromoCode ? AppLocalizations.of(context).table : null,
                              //labelText: AppLocalizations.of(context).table,
                              labelStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Color(0xff666666), fontWeight: FontWeight.w400, fontSize: 16),
                              //errorStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Color(0xff666666), fontWeight: FontWeight.w400, fontSize: 0),
                            ),
                            style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Color(0xff666666),
                              fontWeight: FontWeight.w800,
                            ),
                            onTap: (){
                              setState(() {
                                showPaymentButton = false;
                              });
                            },
                            onFieldSubmitted: (v){
                              setState(() {
                                showPaymentButton = true;
                                if(promotionController.text.isNotEmpty){
                                  promotion = true;
                                  requestPromo = false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      ///apply
                      Container(
                        height: 38.0,
                        width: 83,
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                        child: MaterialButton(
                          //key: Key('close_table_number_field_key'),
                          elevation: 0,
                          hoverElevation: 0,
                          focusElevation: 0,
                          highlightElevation: 0,
                          onPressed: Provider.of<Explorer>(context, listen: false).promotionCode.isNotEmpty ? (){
                            setState(() {
                              promotionController.clear();
                            });
                            Provider.of<Explorer>(context, listen: false).promotionCode = '';
                            StoreProvider.of<AppState>(context).dispatch(SetOrderTotalPromotionDiscount(0.0));
                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservableTotalPromotionDiscount(0.0));
                            /*if (widget.reserve != null && widget.reserve) {
                              if(promoCodeState.amount != 0){
                                snapshot.orderReservable.totalPromoDiscount -= promoCodeState.amount.toDouble();
                              }else{
                                snapshot.orderReservable.totalPromoDiscount -= double.parse((snapshot.orderReservable.total * promoCodeState.percentage).toStringAsFixed(2));
                              }
                            } else {
                              if(promoCodeState.amount != 0){
                                snapshot.order.totalPromoDiscount -= promoCodeState.amount.toDouble();
                              }else{
                                snapshot.order.totalPromoDiscount -= double.parse((snapshot.order.total * promoCodeState.percentage).toStringAsFixed(2));
                              }
                            }*/
                          } : (widget.reserve != null && widget.reserve ? orderReservableState.totalPromoDiscount > 0 : orderState.totalPromoDiscount > 0) ? null : () async {
                            FocusScope.of(context).unfocus();
                            if(promotionController.text.isNotEmpty){
                              setState(() {
                                requestPromo = true;
                              });
                              DocumentSnapshot promoCode = await FirebaseFirestore.instance.collection('promoCode').doc(promotionController.text.toUpperCase()).get();
                              if(promoCode != null && promoCode.data() != null){
                                promoCodeState = PromoCodeState.fromJson(promoCode.data());
                                Provider.of<Explorer>(context, listen: false).promotionCode = promotionController.text;
                                if (widget.reserve != null && widget.reserve) {
                                  if(promoCodeState.amount != 0){
                                    snapshot.orderReservable.totalPromoDiscount = promoCodeState.amount.toDouble();
                                  }else{
                                    snapshot.orderReservable.totalPromoDiscount = double.parse((snapshot.orderReservable.total * promoCodeState.percentage).toStringAsFixed(2));
                                  }
                                } else {
                                  if(promoCodeState.amount != 0){
                                    snapshot.order.totalPromoDiscount = promoCodeState.amount.toDouble();
                                  }else{
                                    snapshot.order.totalPromoDiscount = double.parse((snapshot.order.total * promoCodeState.percentage).toStringAsFixed(2));
                                  }
                                }
                                setState(() {
                                  invalidPromoCode = false;
                                });
                              }else{
                                setState(() {
                                  requestPromo = false;
                                  invalidPromoCode = true;
                                });
                              }
                            }
                            setState(() {
                              showPaymentButton = true;
                              if(promotionController.text.isNotEmpty){
                                promotion = true;
                                requestPromo = false;
                              }
                            });
                          },
                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                          color: BuytimeTheme.ActionBlackPurple,
                          disabledColor: BuytimeTheme.SymbolLightGrey,
                          //padding: EdgeInsets.all(media.width * 0.03),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5),
                          ),
                          child: requestPromo ? Container(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ): Text(
                            Provider.of<Explorer>(context, listen: false).promotionCode.isNotEmpty ? AppLocalizations.of(context).remove : AppLocalizations.of(context).apply,
                            style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextWhite, letterSpacing: 0),
                          ),
                        ),
                      )
                    ],
                  ),
                ) : Container(),
                // invalidPromoCode ?
                // Container(
                //   margin: EdgeInsets.only(top: 5),
                //   child: Text(
                //     AppLocalizations.of(context).invalidPromocode,
                //     textAlign: TextAlign.start,
                //     style: TextStyle(
                //       fontFamily: BuytimeTheme.FontFamily,
                //       color: BuytimeTheme.AccentRed,
                //       fontSize: 16,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ) : Container(),
              ],
            ),
          ),
          ///Divider
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            color: BuytimeTheme.BackgroundLightGrey,
            height: SizeConfig.safeBlockVertical * .2,
          ),

          ///ECO Section
          snapshot.business.business_type == 'ECO'
              ? Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      W_GreenChoice(false),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 2.5),
                            child: Text(
                              AppLocalizations.of(context).carbonFootprintExplanation,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, height: 1.5, fontWeight: FontWeight.w500, color: BuytimeTheme.TextGrey, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Container(),

          ///ECO Switch
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  ///Switch Add On Environment
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Switch(
                          activeColor: BuytimeTheme.ManagerPrimary,
                          value: carbonCompensation,
                          onChanged: (value) {
                            FirebaseAnalytics().logEvent(name: 'green_confirm_order', parameters: {
                              'user_email': snapshot.user.email,
                              'date': DateTime.now().toString(),
                              'service_name': snapshot.serviceState.name.isNotEmpty ? snapshot.serviceState.name : 'no name found',
                            });
                            setState(() {
                              carbonCompensation = value;
                              if (widget.reserve != null && widget.reserve) {
                                debugPrint('reservable order eco switch - ${orderReservableState.carbonCompensation}');
                                StoreProvider.of<AppState>(context).dispatch((SetOrderReservableCarbonCompensation(carbonCompensation)));
                              } else {
                                debugPrint('order eco switch - ${orderState.carbonCompensation}');
                                StoreProvider.of<AppState>(context).dispatch((SetOrderCarbonCompensation(carbonCompensation)));
                              }
                              //calculateEcoTax();
                              debugPrint('UI_U_ConfirmOrder => SWITCH FOOTPRINT : $value');
                            });
                          }),
                      snapshot.business.business_type != 'ECO' ? W_GreenChoice(false) : Container(),
                      Text('+ € ${Utils.calculateEcoTax(widget.reserve != null && widget.reserve ? OrderState.fromReservableState(orderReservableState) : orderState).toStringAsFixed(2)}'),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 2.5),
                            child: Text(
                              '${AppLocalizations.of(context).addA} 2,5% ${AppLocalizations.of(context).reduceEnvironmentalImpact}',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, height: 1.5, fontWeight: FontWeight.w500, color: BuytimeTheme.TextGrey, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            color: BuytimeTheme.BackgroundLightGrey,
            height: SizeConfig.safeBlockVertical * .2,
          ),
          ///Total Price
          Container(child: () {
            if (widget.reserve != null && widget.reserve) {
              return OrderTotal(media: media, orderState: OrderState.fromReservableState(snapshot.orderReservable), promotion: promotion,);
            } else {
              return OrderTotal(media: media, orderState: snapshot.order, promotion: promotion);
            }
          }()),

          ///Divider
          // Container(
          //   margin: EdgeInsets.only(left: 16, right: 16),
          //   color: BuytimeTheme.BackgroundLightGrey,
          //   height: SizeConfig.safeBlockVertical * .2,
          // ),


          ///Location
          widget.reserve != null && !widget.reserve && !widget.tourist && !isExternal
              ? Container(
              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 3),
              width: media.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Location text
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).location,
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,

                          ///SizeConfig.safeBlockHorizontal * 4
                          color: BuytimeTheme.TextMedium,
                          letterSpacing: 0.25),
                    ),
                  ),

                  ///Total Value
                  Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
                        child: Text(
                          snapshot.order.location ?? '',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,

                              ///SizeConfig.safeBlockHorizontal * 7,
                              color: BuytimeTheme.TextBlack),
                        ),
                      )),

                  ///Tax
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ))
              : Container(),

          ///Divider
          widget.reserve != null && !widget.reserve && !widget.tourist && !isExternal
              ? Container(
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
            color: BuytimeTheme.BackgroundLightGrey,
            height: SizeConfig.safeBlockVertical * .2,
          )
              : Container(),
        ],
      ),
    );
  }

  void confirmationCard(BuildContext context, AppState snapshot, String last4, String brand, String country, String selectedCardPaymentMethodId) {
    setState(() {
      cardOrder = true;
    });
    if (widget.reserve != null && widget.reserve) {
      StoreProvider.of<AppState>(context).dispatch(CreatingOrder());

      /// Reservable payment process starts
      debugPrint('UI_U_ConfirmOrder => order is isOrderAutoConfirmable ' + snapshot.orderReservable.isOrderAutoConfirmable().toString());
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.directPayment) {
          StoreProvider.of<AppState>(context)
              .dispatch(CreateOrderReservableCardAndPay(snapshot.orderReservable, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
        }
      } else {
        debugPrint('UI_U_ConfirmOrder => dispatching pending order creation');
        StoreProvider.of<AppState>(context)
            .dispatch(CreateOrderReservableCardPending(snapshot.orderReservable, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
      }
    } else {
      /// Direct Card Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Credit Card');
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context)
            .dispatch(CreateOrderCardAndPay(snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderCardPending(snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card));
      }
    }
  }

  Future<void> confirmationNative(BuildContext context, AppState snapshot) async {
    StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
    PaymentMethod paymentMethod;

    /// 1: create the payment method
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      StoreProvider.of<AppState>(context).dispatch(SetOrderReservablePaymentMethod(paymentMethod));
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.directPayment) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndPay(snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
        }
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativePending(snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
      }
    } else {
      /// Direct Native Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
      if (paymentMethod != null) {
        /// 2: add the payment method to the order state
        StoreProvider.of<AppState>(context).dispatch(SetOrderPaymentMethod(paymentMethod));

        /// 3: now we can create the order on the database and its sub collection
        if (snapshot.order.isOrderAutoConfirmable()) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderNativeAndPay(snapshot.order, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
        } else {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderNativePending(snapshot.order, paymentMethod, PaymentType.card));
        }
      }
    }
  }

  Future<void> confirmationRoom(BuildContext context, AppState snapshot) async {
    StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
    String roomNumber = '1';
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        if (roomNumber.isNotEmpty) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableRoomAndPay(snapshot.orderReservable, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      } else {
        if (roomNumber.isNotEmpty) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableRoomPending(snapshot.orderReservable, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      }
    } else {
      /// Direct Payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Room Method');
      if (snapshot.order.isOrderAutoConfirmable()) {
        if (roomNumber.isNotEmpty) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderRoomAndPay(snapshot.order, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      } else {
        String roomNumber = '1';
        if (roomNumber.isNotEmpty) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderRoomPending(snapshot.order, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      }
    }
  }

  Future<void> confirmationOnSite(BuildContext context, AppState snapshot) async {
    StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Onsite Method');
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableOnSiteAndPay(snapshot.orderReservable, PaymentType.onSite));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableOnSitePending(snapshot.orderReservable, PaymentType.onSite));
      }
    } else {
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Onsite Method');
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderOnSiteAndPay(snapshot.order, PaymentType.onSite));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderOnSitePending(snapshot.order, PaymentType.onSite));
      }
    }
  }

  Future<void> confirmationPayPal(BuildContext context, AppState snapshot) async {
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Paypal Method');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalPayment(
            onFinish: (number) async {
              print('order id: ${snapshot.order.orderId}');
            },
            tourist: true,
            reserve: widget.reserve,
            orderState: OrderState.fromReservableState(snapshot.orderReservable),
          ),
        ),
      );
    } else {
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Paypal Method');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalPayment(
            onFinish: (number) async {
              print('order id: ${snapshot.order.orderId}');
            },
            tourist: true,
            reserve: widget.reserve,
            orderState: snapshot.order,
          ),
        ),
      );
    }
  }

  ///App bar
  AppBar buildBuytimeAppbar(Size media, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      brightness: Brightness.dark,
      elevation: 1,
      title: Text(
        AppLocalizations.of(context).confirmOrder,
        style: TextStyle(
            fontFamily: BuytimeTheme.FontFamily,
            color: BuytimeTheme.TextBlack,
            fontWeight: FontWeight.w500,
            fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        key: Key('back_cart_from_confirm_order_key'),
        icon: Icon(
          Icons.keyboard_arrow_left,
          color: Colors.black,
        ),
        onPressed: () async{

          Navigator.of(context).pop();
        },
      ),
    );
  }

  getCurrentLeadingImage(BuildContext context, AppState snapshot) {
    if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/mastercard_icon.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/room.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/cash.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/googlePay.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/applePay.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.paypal)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/brand/paypal.png'));
    }
    return null;
  }

  creditCardTrailing(context, StripeCardResponse cardState) {
    if (cardState != null) {
      return TextButton(
          onPressed: () {
            if (!deleting) {
              deleting = true;
              if (cardState != null) {
                StoreProvider.of<AppState>(context).state.stripe.chosenPaymentMethod = Utils.enumToString(PaymentType.noPaymentMethod);
                StoreProvider.of<AppState>(context).dispatch(SetStripeState(StoreProvider.of<AppState>(context).state.stripe));
                StoreProvider.of<AppState>(context).dispatch(DeletingStripePaymentMethod());
                String firestoreCardId = cardState.firestore_id;
                StoreProvider.of<AppState>(context).dispatch(CreateDisposePaymentMethodIntent(firestoreCardId, StoreProvider.of<AppState>(context).state.user.uid));
              }
            }
          },
          child: Text(AppLocalizations.of(context).delete, style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.AccentRed)));
    } else {
      return null;
    }
  }
}
