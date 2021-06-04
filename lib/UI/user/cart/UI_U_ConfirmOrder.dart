import 'dart:io';
import 'package:Buytime/UI/user/cart/tab/T_native_apple.dart';
import 'package:Buytime/UI/user/cart/tab/T_native_google.dart';
import 'package:Buytime/UI/user/cart/tab/T_credit_cards.dart';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/UI/user/cart/tab/T_room_disabled.dart';
import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reusable/stripe/show_dialog_to_dismiss.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
import 'package:stripe_payment/stripe_payment.dart' as StripeRecommended;

class ConfirmOrder extends StatefulWidget {
  final String title = 'confirmOrder';
  bool tourist;
  bool reserve = false;

  ConfirmOrder({Key key, this.reserve, this.tourist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  OrderState orderState;
  OrderReservableState orderReservableState;
  bool disableRoomPayment = false;

  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 3, vsync: this);
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
              if (widget.tourist ||
                  snapshot.booking != null &&
                      snapshot.booking.business_id != null &&
                      snapshot.booking.business_id.isNotEmpty &&
                      (snapshot.order != null && snapshot.order.itemList.isNotEmpty && snapshot.order.itemList[0].id_business != snapshot.booking.business_id)) {
                disableRoomPayment = true;
              } else {
                disableRoomPayment = false;
              }
            }

            bool selected = false;
            String last4 = '';
            String brand = '';
            String country = '';
            String selectedCardPaymentMethodId = '';
            List<CardState> cardList = StoreProvider.of<AppState>(context).state.cardListState.cardList;
            if (cardList != null) {
              cardList.forEach((element) {
                if (element.selected) {
                  last4 = element.stripeState.stripeCard.last4;
                  brand = element.stripeState.stripeCard.brand;
                  country = element.stripeState.stripeCard.country;
                  selectedCardPaymentMethodId = element.stripeState.stripeCard.paymentMethodId;
                  selected = true;
                }
              });
            }
            if(orderState != null && orderState.itemList.isNotEmpty && orderState.itemList.first.id_business != snapshot.business.id_firestore){
              debugPrint('UI_U_cart => ORDER BUSINESS ID: ${orderState.itemList.first.id_business} | BUSIENSS ID: ${snapshot.business.id_firestore}');
              isExternal = true;
            }
            return Stack(children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Scaffold(
                      appBar: buildBuytimeAppbar(media, context),
                      body: SafeArea(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Cart Details & Confirm Details
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///Recap
                                      buildOrderRecap(context, snapshot, media),

                                      ///Divider
                                      Container(
                                        color: BuytimeTheme.BackgroundLightGrey,
                                        height: SizeConfig.safeBlockVertical * 2,
                                      ),

                                      ///Tab bar
                                      PreferredSize(
                                        preferredSize: Size.fromHeight(kToolbarHeight),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.tourist != null && widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black87.withOpacity(.3),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: Offset(0, 2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: buildTabBar(context),
                                        ),
                                      ),

                                      ///Tab value
                                      (() {
                                        return buildTabsBeforeConfirmation(snapshot.booking.booking_code);
                                      }())
                                    ],
                                  ),
                                ),
                                Center(
                                  child: (() {
                                    return buildConfirmButton(context, snapshot, selected, last4, brand, country, selectedCardPaymentMethodId, media);
                                  }()),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),
              snapshot.order.addCardProgress == Utils.enumToString(AddCardStatus.inProgress) || cardOrder ? spinnerConfirmOrder() : Container(),
              snapshot.lastError != null && snapshot.lastError.isNotEmpty
                  ? ShowErrorDialogToDismiss(
                buttonText: AppLocalizations.of(context).ok,
                content: snapshot.lastError,
                title: AppLocalizations.of(context).error,
              )
                  : Container()
            ]);
          }),
    );
  }

  Widget buildTabsBeforeConfirmation(String bookingCode) {
    if (_controller.index == 0) {
      return CreditCards(tourist: widget.tourist != null && widget.tourist);
    } else if (_controller.index == 1) {
      return Platform.isAndroid ? NativeGoogle() : NativeApple();
    } else if (_controller.index == 2) {
      if (disableRoomPayment) {
        return RoomDisabled();
      }
      return Room(tourist: widget.tourist, bookingCode: bookingCode);
    }
    return Container();
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

  Align buildConfirmButton(BuildContext context, AppState snapshot, bool selected, String last4, String brand, String country,
      String selectedCardPaymentMethodId, Size media) {
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
                  onPressed: selected && _selectedIndex == 0 ? () { ///L'avevo messo apposto, non so come ma era ritornata comera prima, se non va bene messo cosi ditemelo, comera messo prima il bottono non rimaneva bloccavta
                    ///finche non selezionavi la carta
                    debugPrint("UI_U_ConfirmOrder  confirmation CREDIT CARD");
                    confirmationCard(context, snapshot, last4, brand, country, selectedCardPaymentMethodId);
                  } : _selectedIndex == 1 ? (){
                    debugPrint("UI_U_ConfirmOrder confirmation NATIVE");
                    confirmationNative(context, snapshot);
                  } :  _selectedIndex == 2 ? (){
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
        Tab(
            icon: Platform.isAndroid
                ? Text(AppLocalizations.of(context).googlePay)
                : Icon(
              FontAwesome5Brands.apple_pay,
              size: 40.0,
            )),

        Tab(
          text: AppLocalizations.of(context).roomSimple,
        ),
      ],
    );
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
                  Expanded(
                    flex: 1,
                    child: Container(
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

          ///Please Charge ...
          Container(
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
            height: SizeConfig.safeBlockVertical * 8,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).pleaseChargeThisToMy,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextBlack,
                      fontSize: 14,

                      /// SizeConfig.safeBlockHorizontal * 4
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
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
        /*ColorFiltered(
                            colorFilter: ColorFilter.linearToSrgbGamma(),
                            child: Image.network(
                              StoreProvider.of<AppState>(context).state.business.logo,
                              height: media.height * 0.05,
                            ),
                          ),*/
        SizedBox(
          width: 40.0,
        ),
      ],
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

    /// 1: create the payment method
    StripePaymentService stripePaymentService = StripePaymentService();
    StripeRecommended.PaymentMethod paymentMethod = await stripePaymentService.createPaymentMethodNative(snapshot.order, snapshot.business.name);
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      StoreProvider.of<AppState>(context).dispatch(SetOrderReservablePaymentMethod(paymentMethod));
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      if (snapshot.orderReservable.isOrderAutoConfirmable()) {
        if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.directPayment) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndPay(
              snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.holdAndReminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndHold(
              snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
        } else if (Utils.getTimeInterval(orderReservableState) == OrderTimeInterval.reminder) {
          StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativeAndReminder(
              snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
        }
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservableNativePending(
            snapshot.orderReservable, paymentMethod, PaymentType.card, context, snapshot.business.stripeCustomerId));
      }
    } else {
      /// Direct Native Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');

      /// 2: add the payment method to the order state
      StoreProvider.of<AppState>(context).dispatch(SetOrderPaymentMethod(paymentMethod));

      /// 3: now we can create the order on the database and its sub collection
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context)
            .dispatch(CreateOrderNativeAndPay(snapshot.order, paymentMethod, PaymentType.native, context, snapshot.business.stripeCustomerId));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderNativePending(snapshot.order, paymentMethod, PaymentType.native));
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
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
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
}
