import 'dart:convert';
import 'dart:io';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/UI/user/cart/tab/T_room_disabled.dart';
import 'package:Buytime/UI/user/cart/widget/W_credit_card_simple.dart';
import 'package:Buytime/UI/user/cart/widget/W_loading_button.dart';
import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pay/pay.dart' as pay;
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as StripeOfficial;

import 'package:http/http.dart' as http;

import '../../../environment_abstract.dart';
import 'UI_U_CardChoice.dart';

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
  CardFieldInputDetails _card;
  String _email = '';
  SetupIntent _setupIntentResult;
  String _userId = '';
  bool _saveCard = false;
  OrderState orderState;
  OrderReservableState orderReservableState;
  bool disableRoomPayment = false;
  List<Widget> cardWidgetList = [];
  bool deleting = false;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 2, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      // print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  void dispose() {
    StoreProvider.of<AppState>(context).dispatch(ResetOrderIfPaidOrCanceled());
    super.dispose();
  }

  bool waitingForUser = true;
  bool isExternal = false;
  bool cardOrder = false;
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
            store?.dispatch(AddingStripePaymentMethodReset());
            initializeCardList(store.state.cardListState);
            debugPrint('UI_U_ConfirmOrder => ON INIT');
          },
          distinct: true,
          converter: (store) => store.state,
          builder: (context, snapshot) {
            /// check if the stripe customer have been created for this user:

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
            } else {
              orderState = snapshot.order;
              if ( (widget != null && widget.tourist != null && widget.tourist) ||
                  ((snapshot.booking != null && snapshot.booking.business_id != null && snapshot.booking.business_id.isNotEmpty) &&
                   (snapshot.order != null && snapshot.order.itemList.isNotEmpty && snapshot.order.itemList[0].id_business != snapshot.booking.business_id))
              ) {
                disableRoomPayment = true;
              } else {
                disableRoomPayment = false;
              }
            }

            if(orderState != null && orderState.itemList.isNotEmpty && orderState.itemList.first.id_business != snapshot.business.id_firestore){
              debugPrint('UI_U_cart => ORDER BUSINESS ID: ${orderState.itemList.first.id_business} | BUSIENSS ID: ${snapshot.business.id_firestore}');
              isExternal = true;
            }

            _email = snapshot.user.email;
            _userId = snapshot.user.uid;

            debugPrint('T_credit_cards => ON INIT');
            return
              Scaffold(
                  appBar: buildBuytimeAppbar(media, context),
                  body: SafeArea(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Recap
                                buildOrderRecap(context, snapshot, media),

                                // ///Divider
                                // Container(
                                //   color: BuytimeTheme.BackgroundLightGrey,
                                //   height: SizeConfig.safeBlockVertical * 1,
                                // ),

                                // ///Tab bar
                                // PreferredSize(
                                //   preferredSize: Size.fromHeight(kToolbarHeight),
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       color: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                //       boxShadow: [
                                //         BoxShadow(
                                //           color: Colors.black87.withOpacity(.3),
                                //           spreadRadius: 1,
                                //           blurRadius: 1,
                                //           offset: Offset(0, 2), // changes position of shadow
                                //         ),
                                //       ],
                                //     ),
                                //     child: buildTabBar(context),
                                //   ),
                                // ),
                                // ///Tab value
                                // (() {
                                //   return buildTabsBeforeConfirmation(snapshot.booking.booking_code, snapshot.cardListState);
                                // }())
                              ],
                            ),
                            /// bottom block, confirm button and payment method
                            Column(
                              children: [
                                Container(
                                  width: SizeConfig.blockSizeHorizontal * 100,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3),
                                  child: Text(
                                    AppLocalizations.of(context).paymentMethod,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 18
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0, bottom: 20.0),
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
                                          _modalChoosePaymentMethod(context, snapshot);
                                        },
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                                Center(
                                  child:MaterialButton(
                                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                    color: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                    disabledColor: BuytimeTheme.SymbolLightGrey,
                                    //padding: EdgeInsets.all(media.width * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: SizeConfig.blockSizeHorizontal * 57 ,
                                      height: 44,
                                      child: Text(
                                        !(widget.reserve != null && widget.reserve)
                                            ? AppLocalizations.of(context).confirmPayment
                                            : '${AppLocalizations.of(context).completeBooking.toUpperCase()}',
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
                                    onPressed: () {
                                      /// TODO START PAYMENT FLOW
                                    },
                                  ),
                                )
                              ],
                            )

                          ],
                        ),
                      ),
                    ),
                  ));

          }),
    );
  }

  Text getCurrentPaymentMethod(BuildContext context, AppState snapshot) {
    if(snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
      if (
          snapshot.cardListState != null &&
          snapshot.cardListState.cardList != null &&
          snapshot.cardListState.cardList.first.stripeState != null &&
          snapshot.cardListState.cardList.first.stripeState.stripeCard != null
      ) {
        return Text(snapshot.cardListState.cardList.first.stripeState.stripeCard.brand + " " + snapshot.cardListState.cardList.first.stripeState.stripeCard.last4);
      }
      return Text( AppLocalizations.of(context).creditCard.replaceAll(":", ""));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room)) {
      return Text( AppLocalizations.of(context).room.replaceAll(":", ""));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite)) {
      return Text( AppLocalizations.of(context).onSite);
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay)) {
      return Text( AppLocalizations.of(context).googlePay);
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay)) {
      return Text( AppLocalizations.of(context).applePay);
    }
    return Text( AppLocalizations.of(context).choosePaymentMethod);
  }

  Widget buildTabsBeforeConfirmation(String bookingCode, CardListState cardListState) {
    if (_controller.index == 0) {
      debugPrint('buildTabsBeforeConfirmation ' + cardListState.cardList?.length.toString() + ' ' + cardWidgetList?.length.toString());
      if (cardWidgetList != null && cardWidgetList.length > 0) {
        return cardWidgetList[0];
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CardField(
              onCardChanged: (card) {
                setState(() {
                  _card = card;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Text(AppLocalizations.of(context).virtualAndPrepaidNotSupported,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: TextStyle(
                // letterSpacing: 1.25,
                  fontStyle: FontStyle.italic,
                  fontFamily: BuytimeTheme.FontFamily,
                  color:  BuytimeTheme.TextGrey,
                  fontWeight: FontWeight.w400,
                  fontSize: 14
              ),
            ),
          ),
          (cardListState.cardList != null && cardListState.cardList.length > 0) ? Container() : LoadingButton(onPressed: _requestSaveCard, text: AppLocalizations.of(context).saveYourCard),
        ],
      );
    // } else if (_controller.index == 1) {
    //   return Container(
    //     child: buildMobilePay(),
    //   );
    } else if (_controller.index == 1) {
      if (disableRoomPayment) {
        return RoomDisabled();
      }
      return Room(tourist: widget.tourist, bookingCode: bookingCode);
    }
    return Container();
  }

  Column buildMobilePay() {
    return Column(
        children: [
          if (Stripe.instance.isApplePaySupported.value)
            Padding(
              padding: EdgeInsets.all(16),
              child: ApplePayButton(
                onPressed: _handlePayPress,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Apple Pay is not available in this device'),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: pay.GooglePayButton(
              paymentConfigurationAsset: 'google_pay_payment_profile.json',
              paymentItems: buildGoogleItems(),
              margin: const EdgeInsets.only(top: 15),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
              onPressed: () async {
                // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
                // await debugChangedStripePublishableKey();
              },
              onError: (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'There was an error while trying to perform the payment'),
                  ),
                );
              },
            ),
          )

        ],
      );
  }

  List<pay.PaymentItem> buildGoogleItems() {
    List<pay.PaymentItem> paymentItemArray = [];
    for (int i = 0; i < orderState.itemList.length; i++) {
      paymentItemArray.add(pay.PaymentItem(
        label: orderState.itemList[i].name,
        amount: orderState.itemList[i].price.toString(),
        status: pay.PaymentItemStatus.final_price,
      ));
    }
    return paymentItemArray;
  }

  Padding buildCreating(AppState snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 100.0, right: 8.0, bottom: 8.0),
      child: Text(
        AppLocalizations.of(context).orderConfirming,
        maxLines: 4,
        style: TextStyle(
          letterSpacing: 1.25,
          fontFamily: BuytimeTheme.FontFamily,
          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
          fontSize: 16,

          ///SizeConfig.safeBlockHorizontal * 3.5
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding buildCanceled(AppState snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 100.0, right: 8.0, bottom: 8.0),
      child: Text(
        AppLocalizations.of(context).anErrorOccurredTryLater,
        maxLines: 4,
        style: TextStyle(
          letterSpacing: 1.25,
          fontFamily: BuytimeTheme.FontFamily,
          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
          fontSize: 16,

          ///SizeConfig.safeBlockHorizontal * 3.5
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding buildPending(AppState snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 100.0, right: 8.0, bottom: 8.0),
      child: Text(
        AppLocalizations.of(context).orderPending,
        maxLines: 4,
        style: TextStyle(
          letterSpacing: 1.25,
          fontFamily: BuytimeTheme.FontFamily,
          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
          fontSize: 16,

          ///SizeConfig.safeBlockHorizontal * 3.5
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Padding buildConfirmation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 100.0, right: 8.0, bottom: 8.0),
      child: Text(
        AppLocalizations.of(context).orderConfirmed,
        maxLines: 4,
        style: TextStyle(
          letterSpacing: 1.25,
          fontFamily: BuytimeTheme.FontFamily,
          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
          fontSize: 16,

          ///SizeConfig.safeBlockHorizontal * 3.5
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  ///Bavck to home
  MaterialButton buildBackButton(BuildContext context, Size media) {
    return !widget.tourist
        ? MaterialButton(
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      onPressed: () {
        /// empty order state and go back
        StoreProvider.of<AppState>(context).dispatch(SetOrder(OrderState().toEmpty()));
        Navigator.of(context).popUntil(ModalRoute.withName('/bookingPage'));
      },
      textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
      color: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
      disabledColor: BuytimeTheme.SymbolLightGrey,
      padding: EdgeInsets.all(media.width * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          AppLocalizations.of(context).backToHome,
          style: TextStyle(
            letterSpacing: 1.25,
            fontSize: 14,
            fontFamily: BuytimeTheme.FontFamily,
            fontWeight: FontWeight.w500,
            color: BuytimeTheme.TextWhite,
          ),
        ),
      ),
    )
        : Container();
  }

  Align buildConfirmButton(BuildContext context, AppState snapshot, Size media) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        //height: double.infinity,
        //color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Confirm button
            Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 4),
                width: 158 ,
                ///media.width * .4
                height: 44,
                child: MaterialButton(
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  onPressed:
                      _selectedIndex == 0 &&
                      snapshot.cardListState.cardList != null &&
                      snapshot.cardListState.cardList.length > 0
                    ? () {
                    ///L'avevo messo apposto, non so come ma era ritornata comera prima,
                    ///se non va bene messo cosi ditemelo, comera messo prima il bottono non rimaneva bloccavta
                    ///finche non selezionavi la carta
                    debugPrint("UI_U_ConfirmOrder  confirmation CREDIT CARD");
                    confirmationCard(context, snapshot,
                        snapshot.cardListState.cardList[0].stripeState.stripeCard.last4,
                        snapshot.cardListState.cardList[0].stripeState.stripeCard.brand,
                        snapshot.cardListState.cardList[0].stripeState.stripeCard.country,
                        snapshot.cardListState.cardList[0].stripeState.stripeCard.paymentMethodId);
                  // } : _selectedIndex == 1 ? () async {
                  //   // confirmationNative();
                  //   debugPrint("UI_U_ConfirmOrder confirmation NATIVE");
                    // confirmationNative(context, snapshot);
                  } :  _selectedIndex == 1 && !disableRoomPayment ? (){
                    debugPrint("UI_U_ConfirmOrder confirmation ROOM");
                    confirmationRoom(context, snapshot);
                  } : null,
                  textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                  color: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                  disabledColor: BuytimeTheme.SymbolLightGrey,
                  //padding: EdgeInsets.all(media.width * 0.03),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    child: Text(
                      !(widget.reserve != null && widget.reserve)
                          ? AppLocalizations.of(context).confirmUpper
                          : '${AppLocalizations.of(context).completeBooking.toUpperCase()}',
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
                )),
          ],
        ),
      ),
    );
  }

  ///Tab bar
  TabBar buildTabBar(BuildContext context) {
    return TabBar(
      indicatorWeight: SizeConfig.safeBlockHorizontal * 1,
      indicatorColor: BuytimeTheme.BackgroundWhite,
      labelStyle: TextStyle(
          letterSpacing: 1.25,

          ///SizeConfig.safeBlockHorizontal * .2
          fontFamily: BuytimeTheme.FontFamily,
          color: BuytimeTheme.TextWhite,
          fontWeight: FontWeight.w600,
          fontSize: 14

        ///SizeConfig.safeBlockHorizontal * 4
      ),
      indicatorPadding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
      controller: _controller,
      tabs: [
        Tab(
          text: AppLocalizations.of(context).creditCardSimple,
        ),
        // Tab(
        //     icon: Platform.isAndroid
        //         ? Text(AppLocalizations.of(context).googlePay)
        //         : Icon(
        //       FontAwesome5Brands.apple_pay,
        //       size: 40.0,
        //     )),
        // Tab(text: AppLocalizations.of(context).mobilePay),
        Tab(text: AppLocalizations.of(context).roomSimple,),
      ],
    );
  }

  void _modalChoosePaymentMethod(context, AppState snapshot) {
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: EdgeInsets.only(left: 30, top: 30),
            height: 550,
            child: new Wrap(
              children: <Widget>[
                /// TODO wrap with realtime query for card list
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('stripeCustomer').doc(_userId).collection('card').snapshots(includeMetadataChanges: true),
                  builder: (context, cardListSnapshot) {
                    if (cardListSnapshot.hasError || cardListSnapshot.connectionState == ConnectionState.waiting) {
                      return Text(AppLocalizations.of(context).loading + "...");
                    }
                    StripeCardResponse cardFromFirestore;
                    if (cardListSnapshot.data.docs.isEmpty) {

                    } else {
                      cardFromFirestore = StripeCardResponse.fromJson(cardListSnapshot.data.docs.first.data());
                    }
                    return ListTile(
                      leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/mastercard_icon.png')),
                      title: creditCardText(context, cardFromFirestore),
                      trailing: creditCardTrailing(context, cardFromFirestore) ,
                      onTap: () {
                        if (cardFromFirestore != null) {
                          StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.card)));
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>CardChoice()),);
                        }
                      },
                    );
                  }
                ),
                Divider(),
                Platform.isIOS ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/applePay.png')),
                  title: new Text( AppLocalizations.of(context).applePay),
                  onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.applePay)));
                  Navigator.of(context).pop();
                  },
                ) : Container(),

                // ListTile(
                //   leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/googlePay.png')),
                //   title: new Text( AppLocalizations.of(context).googlePay),
                //   onTap: () {
                //     StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.googlePay)));
                //     Navigator.of(context).pop();
                //   },
                // ),
                !widget.tourist ? Divider() : Container(),
                !widget.tourist ? ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/room.png')),
                  title: new Text( AppLocalizations.of(context).room.replaceAll(":", "")),
                  onTap: () {
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.room)));
                    Navigator.of(context).pop();
                  },
                ) : Container(),
                Divider(),
                ListTile(
                  leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/cash.png')),
                  title: new Text( AppLocalizations.of(context).onSite),
                  onTap: () {
                    StoreProvider.of<AppState>(context).dispatch(ChoosePaymentMethod(Utils.enumToString(PaymentType.onSite)));
                    Navigator.of(context).pop();
                  },
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  Text creditCardText(context, StripeCardResponse cardFromFirestore) {
    if (
    cardFromFirestore != null
    ) {
      return Text(cardFromFirestore.brand + " " + cardFromFirestore.last4);
    }
    return Text( AppLocalizations.of(context).creditCard.replaceAll(":", ""));
  }

  ///Recap
  Container buildOrderRecap(BuildContext context, AppState snapshot, Size media) {
    return Container(
      child: Column(
        children: [
          ///Top Text
          Container(
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                        () {
                      if (widget.reserve != null && widget.reserve) {
                        // print("UI_U_ConfirmOrder => " + snapshot.orderReservable.itemList.length.toString());
                        return snapshot.orderReservable.itemList.length > 1 ? AppLocalizations.of(context).multipleOrders :  snapshot.orderReservable != null && snapshot.orderReservable.itemList.isNotEmpty ? Utils.retriveField(Localizations.localeOf(context).languageCode, snapshot.orderReservable.itemList.first.name) : 'test';
                      } else {
                        // print("UI_U_ConfirmOrder => " + snapshot.order.itemList.length.toString());
                        return snapshot.order.itemList.length > 1 ? AppLocalizations.of(context).multipleOrders :  snapshot.order != null && snapshot.order.itemList.isNotEmpty ? Utils.retriveField(Localizations.localeOf(context).languageCode, snapshot.order.itemList.first.name) : 'test';
                      }
                    }(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextBlack,
                      fontSize: 16,

                      /// SizeConfig.safeBlockHorizontal * 4
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),

          ///Total Price
          Container(
            //color: Colors.black87,
              child: () {
                if (widget.reserve != null && widget.reserve) {
                  // print("UI_U_ConfirmOrder => " + snapshot.orderReservable.itemList.length.toString());
                  return OrderTotal(media: media, orderState: OrderState.fromReservableState(snapshot.orderReservable));
                } else {
                  // print("UI_U_ConfirmOrder => " + snapshot.order.itemList.length.toString());
                  return OrderTotal(media: media, orderState: snapshot.order);
                }
              }()),

          ///Divider
          Container(
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
            color: BuytimeTheme.BackgroundLightGrey,
            height: SizeConfig.safeBlockVertical * .2,
          ),

          ///Location
          widget.reserve != null && !widget.reserve && !widget.tourist && !isExternal
              ? Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockVertical * 2, top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 3),
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



  ///Loading spinner
  Positioned spinnerConfirmOrder() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
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
                    width: SizeConfig.safeBlockVertical * 20,
                    height: SizeConfig.safeBlockVertical * 20,
                    child: Center(
                      child: SpinKitRipple(
                        color: Colors.white,
                        size: SizeConfig.safeBlockVertical * 18,
                      ),
                    ),
                  ),
                ],
              ),
            )),
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
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableCardAndPay(snapshot.orderReservable, last4, brand, country,
              selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.holdAndReminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableCardAndHold(snapshot.orderReservable, last4, brand, country,
              selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.reminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableCardAndReminder(snapshot.orderReservable, last4, brand, country,
              selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
        }
      } else {
        debugPrint('UI_U_ConfirmOrder => dispatching pending order creation');
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableCardPending(snapshot.orderReservable, last4, brand, country,
            selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
      }
    } else {
      /// Direct Card Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Credit Card');
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderCardAndPay(
            snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card, context, snapshot.business.stripeCustomerId));
      } else {
        StoreProvider.of<AppState>(context)
            .dispatch(CreateOrderCardPending(snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card));
      }
    }
  }

  Future<void> confirmationNative(BuildContext context, AppState snapshot) async {
    StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
    // StripeRecommended.PaymentMethod paymentMethod;
    PaymentMethod paymentMethod;
    /// 1: create the payment method
    StripePaymentService stripePaymentService = StripePaymentService();
    if (widget.reserve != null && widget.reserve) {
      paymentMethod = await stripePaymentService.createPaymentMethodNative(OrderState.fromReservableState(snapshot.orderReservable), snapshot.business.name);

      /// Reservable payment process starts with Native Method
      StoreProvider.of<AppState>(context).dispatch(SetOrderReservablePaymentMethod(paymentMethod));
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.directPayment) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndPay(
              snapshot.orderReservable, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.holdAndReminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndHold(
              snapshot.orderReservable, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.reminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndReminder(
              snapshot.orderReservable, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
        }
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativePending(
            snapshot.orderReservable, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
      }
    } else {
      // paymentMethod = await stripePaymentService.createPaymentMethodNative(snapshot.order, snapshot.business.name);

      /// Direct Native Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
      if (paymentMethod != null) {
        /// 2: add the payment method to the order state
        StoreProvider.of<AppState>(context).dispatch(SetOrderPaymentMethod(paymentMethod));

        /// 3: now we can create the order on the database and its sub collection
        if (snapshot.order.isOrderAutoConfirmable()) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderNativeAndPay(snapshot.order, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
        } else {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderNativePending(snapshot.order, paymentMethod, PaymentType.native));
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

  Future<void> _requestSaveCard() async {
    if (_card == null) {
      return;
    }
    try {
      // 1. Create setup intent on backend
      final clientSecret = await _createSetupIntentOnBackend(_email, _userId);

      // 2. Gather customer billing information (ex. email)
      final billingDetails = BillingDetails(
        email: _email,
        phone: '+48888000888',
        name : 'John Doe',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mo/ mocked data for tests

      debugPrint('Setup Intent created $clientSecret, $billingDetails');

      // 3. Confirm setup intent
      final setupIntentResult = await Stripe.instance.confirmSetupIntent(
        clientSecret,
        PaymentMethodParams.card(
          billingDetails: billingDetails,
        ), {}
      ).catchError((error) {
        debugPrint('Setup Intent confirmed $error');
      });
      debugPrint('Setup Intent confirmed $setupIntentResult');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saveYourCardSuccess)));
      setState(() {
        _setupIntentResult = setupIntentResult;
      });
      StripeOfficial.Card card = StripeOfficial.Card(
          brand: _card.brand,
        country: "IT",
        expYear: _card.expiryYear,
        expMonth: _card.expiryMonth,
        funding: "",
        last4: _card.last4
      );
      StoreProvider.of<AppState>(context).dispatch(AddStripePaymentMethod(card, _userId, setupIntentResult.paymentMethodId));
    } catch (error, s) {
      debugPrint('Error while saving payment' + error.toString() + s.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).saveYourCardError)));
    }
  }

  Future<String> _createSetupIntentOnBackend(String email, String userId) async {
    final url = Uri.https("${Environment().config.cloudFunctionLink}", "/createSetupIntent", {'userId': '$userId'});
    final response = await http.get(url);
    final Map<String, dynamic> bodyResponse = json.decode(response.body);
    final clientSecret = bodyResponse['clientSecret'] as String;
    debugPrint('Client token  $clientSecret');
    return clientSecret;
  }

  void initializeCardList(CardListState newStore) {
    if (newStore != null && newStore.cardList != null) {
      for(int i = 0; i < newStore.cardList.length; i++) {
        cardWidgetList.add(CreditCardSimpleListElement(newStore.cardList[i]));
        print("UI_U_ConfirmOrder initializeCardList => N:${newStore.cardList?.length} - ADD CARD FirebaseId: ${newStore.cardList[i].stripeState.stripeCard.firestore_id}");
        print("UI_U_ConfirmOrder initializeCardList => Attributes[0]:${newStore.cardList[0].stripeState.stripeCard.paymentMethodId} - ${newStore.cardList[0].stripeState.stripeCard.last4} - ${newStore.cardList[0].stripeState.stripeCard.brand} - ${newStore.cardList[0].stripeState.stripeCard.expMonth}- ${newStore.cardList[0].stripeState.stripeCard.expYear}- ${newStore.cardList[0].stripeState.stripeCard.expYear}");
      }
    }
  }

  /// APPLE PAY FUNCTIONS
  Future<void> _handlePayPress() async {
    try {
      // 1. Present Apple Pay sheet
      await Stripe.instance.presentApplePay(
        ApplePayPresentParams(
          cartItems: [
            ApplePayCartSummaryItem(
              label: 'Product Test',
              amount: '20',
            ),
          ],
          country: 'Es',
          currency: 'EUR',
        ),
      );

      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecret();
      final clientSecret = response['clientSecret'];
      // 2. Confirm apple pay payment
      await Stripe.instance.confirmApplePayPayment(clientSecret);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Apple Pay payment succesfully completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse('${Environment().config.cloudFunctionLink}/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': _email,
        'currency': 'EUR',
        'items': [
          {'id': 'id'}
        ],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }

  /// google pay functions

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json

      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend
      final response = await fetchPaymentIntentClientSecretGoogle();
      final clientSecret = response['clientSecret'];
      final token =
      paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      print(tokenJson);

      final params = PaymentMethodParams.cardFromToken(
        token: tokenJson['id'], // TODO extract the actual token
      );

      // 3. Confirm Google pay payment method
      await Stripe.instance.confirmPaymentMethod(
        clientSecret,
        params,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google Pay payment succesfully completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchPaymentIntentClientSecretGoogle() async {
    final url = Uri.parse('${Environment().config.cloudFunctionLink}/create-payment-intent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': 'example@gmail.com',
        'currency': 'usd',
        'items': [
          {'id': 'id'}
        ],
        'request_three_d_secure': 'any',
      }),
    );
    return json.decode(response.body);
  }

  Future<void> debugChangedStripePublishableKey() async {
    // if (kDebugMode) {
    //   final profile = await rootBundle.loadString('assets/google_pay_payment_profile.json');
    //   final isValidKey = !profile.contains('<ADD_YOUR_KEY_HERE>');
    //   assert(
    //   isValidKey,
    //   'No stripe publishable key added to assets/google_pay_payment_profile.json',
    //   );
    // }
    assert(
    true,
    'No stripe publishable key added to assets/google_pay_payment_profile.json',
    );
  }
  ///App bar
  BuytimeAppbar buildBuytimeAppbar(Size media, BuildContext context) {
    return BuytimeAppbar(
      background: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
      width: media.width,
      children: [
        ///Back Button
        IconButton(
          icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
          onPressed: () => Future.delayed(Duration.zero, () {
            /// if the order is paid we empty the order status before leaving
            String orderProgress = StoreProvider.of<AppState>(context).state.order.progress;
            if (orderProgress == Utils.enumToString(OrderStatus.paid) || orderProgress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)) {
              StoreProvider.of<AppState>(context).dispatch(SetOrder(OrderState().toEmpty()));
              Navigator.of(context).popUntil(ModalRoute.withName('/bookingPage'));
            } else {
              Navigator.of(context).pop();
            }
          }),
        ),
        ///Order Title
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Text(
              AppLocalizations.of(context).confirmOrder,
              textAlign: TextAlign.start,
              style: BuytimeTheme.appbarTitle,
            ),
          ),
        ),
        SizedBox(
          width: 40.0,
        ),
      ],
    );
  }

  getCurrentLeadingImage(BuildContext context, AppState snapshot) {
    if(snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.card)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/mastercard_icon.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.room)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/room.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.onSite)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/cash.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.googlePay)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/googlePay.png'));
    } else if (snapshot.stripe.chosenPaymentMethod == Utils.enumToString(PaymentType.applePay)) {
      return Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/applePay.png'));
    }
    return null;
  }

  creditCardTrailing(context, StripeCardResponse cardState) {
    if(cardState != null) {
      return TextButton(
          onPressed: () {
            if (!deleting) {
              deleting = true;
              if(cardState != null) {
                StoreProvider.of<AppState>(context).dispatch(DeletingStripePaymentMethod());
                String firestoreCardId = cardState.firestore_id;
                StoreProvider.of<AppState>(context).dispatch(CreateDisposePaymentMethodIntent(firestoreCardId, StoreProvider.of<AppState>(context).state.user.uid));
              }

            }
          },
          child: Text(AppLocalizations.of(context).delete,
              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.AccentRed)
          )
      );
    } else {
      return null;
    }

  }
}
