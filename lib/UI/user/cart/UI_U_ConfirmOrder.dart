import 'dart:io';
import 'package:Buytime/UI/user/cart/tab/T_native_apple.dart';
import 'package:Buytime/UI/user/cart/tab/T_native_google.dart';
import 'package:Buytime/UI/user/cart/tab/T_credit_cards.dart';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/UI/user/cart/tab/T_progress.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
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
import 'package:video_player/video_player.dart';

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


  @override
  void initState() {
    super.initState();

    _controller = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  void dispose() {
      StoreProvider.of<AppState>(context).dispatch(ResetOrderIfPaidOrCanceled());
      super.dispose();
    }

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
              /// check if the stripe customer have been created for this user:
              store?.dispatch(CheckStripeCustomer(false));
              debugPrint('UI_U_ConfirmOrder => ON INIT');
            },
            distinct: true,
            converter: (store) => store.state,
            builder: (context, snapshot) {

              if (widget.reserve != null && widget.reserve)
                orderReservableState = snapshot.orderReservable;
              else
                orderState = snapshot.order;
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
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Cart Details & Confirm Details
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        buildOrderRecap(context, snapshot, media),
                                        ///Divider
                                        Container(
                                          color: BuytimeTheme.BackgroundLightGrey,
                                          height: SizeConfig.safeBlockVertical * 2,
                                        ),
                                        ///Confirm Details
                                        PreferredSize(
                                          preferredSize: Size.fromHeight(kToolbarHeight),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: widget.tourist != null && widget.tourist
                                                  ? BuytimeTheme.BackgroundCerulean
                                                  : BuytimeTheme.UserPrimary,
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

                                        ///Tab
                                        (() {
                                          if (snapshot.order.progress == Utils.enumToString(OrderStatus.paid) ||
                                              snapshot.order.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                          ) {
                                            /// return confirmed
                                            return Progress(
                                              cardState: snapshot.cardState,
                                              orderReservableState: snapshot.orderReservable,
                                              cardOrBooking: orderState.cardType != null && orderState.cardType.isNotEmpty ? orderState.cardType : AppLocalizations.of(context).bookingCode + ':',
                                              fromValue: orderState.cardLast4Digit != null && orderState.cardLast4Digit.isNotEmpty ? orderState.cardLast4Digit : snapshot.booking.booking_code,
                                              textToDisplay: AppLocalizations.of(context).orderConfirmed,
                                              orderState: orderState,
                                              reservable: widget.reserve,
                                              tourist:widget.tourist,
                                              // videoAsset: "assets/video/success.mp4",
                                            );
                                          } else if (snapshot.order.progress == Utils.enumToString(OrderStatus.pending)) {
                                            /// return canceled
                                            return Progress(
                                              cardState: snapshot.cardState,
                                              orderReservableState: snapshot.orderReservable,
                                              cardOrBooking: orderState.cardType != null && orderState.cardType.isNotEmpty ? orderState.cardType : AppLocalizations.of(context).bookingCode + ':',
                                              fromValue: orderState.cardLast4Digit != null && orderState.cardLast4Digit.isNotEmpty ? orderState.cardLast4Digit : snapshot.booking.booking_code,
                                              textToDisplay: AppLocalizations.of(context).orderPending,
                                              orderState: orderState,
                                              reservable: widget.reserve,
                                              tourist:widget.tourist,
                                              // videoAsset: "assets/video/canceled.mp4",

                                            );
                                          } else if (snapshot.order.progress == Utils.enumToString(OrderStatus.canceled)) {
                                            /// return canceled
                                            return Progress(
                                              cardState: snapshot.cardState,
                                              orderReservableState: snapshot.orderReservable,
                                              cardOrBooking: orderState.cardType != null && orderState.cardType.isNotEmpty ? orderState.cardType : AppLocalizations.of(context).bookingCode + ':',
                                              fromValue: orderState.cardLast4Digit != null && orderState.cardLast4Digit.isNotEmpty ? orderState.cardLast4Digit : snapshot.booking.booking_code,
                                              textToDisplay: AppLocalizations.of(context).anErrorOccurredTryLater,
                                              orderState: orderState,
                                              reservable: widget.reserve,
                                              tourist:widget.tourist,
                                              // videoAsset: "assets/video/canceled.mp4",

                                            );
                                          } else if (snapshot.order.progress == Utils.enumToString(OrderStatus.creating)){
                                            /// return creating
                                            return Progress(
                                             cardState: snapshot.cardState,
                                             orderReservableState: snapshot.orderReservable,
                                              cardOrBooking: orderState.cardType != null && orderState.cardType.isNotEmpty ? orderState.cardType : AppLocalizations.of(context).bookingCode + ':',
                                              fromValue: orderState.cardLast4Digit != null && orderState.cardLast4Digit.isNotEmpty ? orderState.cardLast4Digit : snapshot.booking.booking_code,
                                             textToDisplay: AppLocalizations.of(context).orderConfirming,
                                             orderState: orderState,
                                             reservable: widget.reserve,
                                             tourist:widget.tourist,
                                             // videoAsset: "assets/video/moneyCat.mp4",
                                            );
                                          } else {
                                            /// normal case
                                            if (_controller.index == 0) {
                                              return Room(tourist: widget.tourist);
                                            } else if (_controller.index == 1) {
                                              return Platform.isAndroid ? NativeGoogle() : NativeApple();
                                            } else if (_controller.index == 2) {
                                              return CreditCards(tourist: widget.tourist != null && widget.tourist);
                                            }
                                          }
                                        }())
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: (() {
                                      if (snapshot.order.progress == Utils.enumToString(OrderStatus.paid) ||
                                          snapshot.order.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout) ||
                                          snapshot.order.progress == Utils.enumToString(OrderStatus.pending) ||
                                          snapshot.order.progress == Utils.enumToString(OrderStatus.canceled)
                                      ) {
                                        return buildBackButton(context, media);
                                      }  else if (snapshot.order.progress == Utils.enumToString(OrderStatus.creating)){
                                        /// return nothing
                                      } else {
                                        return buildConfirmButton(context, snapshot, selected, last4, brand, country, selectedCardPaymentMethodId, media);
                                      }
                                    }()),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
                !snapshot.stripe.stripeCustomerCreated || snapshot.order.addCardProgress == Utils.enumToString(AddCardStatus.inProgress)
                    ? spinnerConfirmOrder()
                    : Container(),
                snapshot.lastError != null && snapshot.lastError.isNotEmpty
                    ? ShowErrorDialogToDismiss(
                        buttonText: AppLocalizations.of(context).ok,
                        content: snapshot.lastError,
                        title: AppLocalizations.of(context).error,
                      )
                    : Container()
              ]);
            }));
  }

  MaterialButton buildBackButton(BuildContext context, Size media) {
    return MaterialButton(
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
                                      color: widget.tourist != null && widget.tourist
                                          ? BuytimeTheme.BackgroundCerulean
                                          : BuytimeTheme.UserPrimary,
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
                                    );
  }

  Align buildConfirmButton(BuildContext context, AppState snapshot, bool selected, String last4, String brand, String country, String selectedCardPaymentMethodId, Size media) {
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
                                            margin:
                                                EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 4),
                                            width: 158,

                                            ///media.width * .4
                                            height: 44,
                                            child: MaterialButton(
                                              elevation: 0,
                                              hoverElevation: 0,
                                              focusElevation: 0,
                                              highlightElevation: 0,
                                              onPressed: _selectedIndex == 0
                                                  ? () {
                                                      debugPrint("UI_U_ConfirmOrder confirmation ROOM");
                                                      confirmationRoom(context, snapshot);
                                                    }
                                                  : _selectedIndex == 1
                                                      ? () {
                                                          debugPrint("UI_U_ConfirmOrder confirmation NATIVE");
                                                          confirmationNative(context, snapshot);
                                                        }
                                                      : selected && _selectedIndex == 2
                                                          ? () {
                                                              debugPrint("UI_U_ConfirmOrder  confirmation CREDIT CARD");
                                                              confirmationCard(
                                                                  context, snapshot, last4, brand, country, selectedCardPaymentMethodId);
                                                            }
                                                          : null,
                                              textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                              color: widget.tourist != null && widget.tourist
                                                  ? BuytimeTheme.BackgroundCerulean
                                                  : BuytimeTheme.UserPrimary,
                                              disabledColor: BuytimeTheme.SymbolLightGrey,
                                              padding: EdgeInsets.all(media.width * 0.03),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(5),
                                              ),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  !(widget.reserve != null && widget.reserve)
                                                      ? AppLocalizations.of(context).confirmUpper
                                                      : '${AppLocalizations.of(context).completeBooking.toString().toUpperCase()}',
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
                                        ),
                                      ],
                                    ),
                                  ),
                                );
  }

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
                                            indicatorPadding: EdgeInsets.only(
                                                left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                            controller: _controller,
                                            tabs: [
                                              ///Room
                                              Tab(
                                                text: AppLocalizations.of(context).roomSimple,
                                              ),

                                              ///Credit Card
                                              Tab(
                                                  icon: Platform.isAndroid
                                                      ? Text(AppLocalizations.of(context).googlePay)
                                                      : Icon(
                                                          FontAwesome5Brands.apple_pay,
                                                          size: 40.0,
                                                        )),

                                              ///Credit Card
                                              Tab(
                                                text: AppLocalizations.of(context).creditCardSimple,
                                              ),
                                            ],
                                          );
  }

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
                                                      AppLocalizations.of(context).serviceNameSecondLine,
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

                                            ///Total Price
                                            Container(
                                                //color: Colors.black87,
                                                child: () {
                                              if (widget.reserve != null && widget.reserve) {
                                                print("UI_U_ConfirmOrder => " + snapshot.orderReservable.itemList.length.toString());
                                                return OrderTotal(
                                                    media: media, orderState: OrderState.fromReservableState(snapshot.orderReservable));
                                              } else {
                                                print("UI_U_ConfirmOrder => " + snapshot.order.itemList.length.toString());
                                                return OrderTotal(media: media, orderState: snapshot.order);
                                              }
                                            }()),
                                            ///Divider
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                                              color: BuytimeTheme.BackgroundLightGrey,
                                              height: SizeConfig.safeBlockVertical * .2,
                                            ),

                                            ///Location
                                            widget.reserve != null && !widget.reserve  ?
                                              Container(
                                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical *2, top: SizeConfig.safeBlockVertical * 2),
                                                width: media.width,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ///Location text
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          AppLocalizations.of(context).location,
                                                          style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 16, ///SizeConfig.safeBlockHorizontal * 4
                                                              color: BuytimeTheme.TextMedium,
                                                              letterSpacing: 0.25
                                                          ),
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
                                                            snapshot.order.location,
                                                            style: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 18, ///SizeConfig.safeBlockHorizontal * 7,
                                                                color: BuytimeTheme.TextBlack
                                                            ),
                                                          ),
                                                        )
                                                    ),
                                                    ///Tax
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(),
                                                    ),
                                                  ],
                                                )) : Container(),
                                            ///Divider
                                            widget.reserve != null && !widget.reserve  ?
                                              Container(
                                              margin: EdgeInsets.only(
                                                  left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                                              color: BuytimeTheme.BackgroundLightGrey,
                                              height: SizeConfig.safeBlockVertical * .2,
                                            ) : Container(),

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
            if(orderProgress == Utils.enumToString(OrderStatus.paid)  || orderProgress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)) {
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
            )),
      ),
    );
  }

  void confirmationCard(BuildContext context, AppState snapshot, String last4, String brand, String country, String selectedCardPaymentMethodId) {
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Credit Card');
      StoreProvider.of<AppState>(context).dispatch(SetOrderReservableProgress("in_progress"));
      for (int i = 0; i < snapshot.orderReservable.itemList.length; i++) {
        OrderReservableState reservable = OrderReservableState(
          position: snapshot.orderReservable.position,
          date: snapshot.orderReservable.itemList[i].date,
          itemList: [snapshot.orderReservable.itemList[i]],
          total: snapshot.orderReservable.itemList[i].price,
          tip: snapshot.orderReservable.tip,
          tax: snapshot.orderReservable.tax,
          taxPercent: snapshot.orderReservable.taxPercent,
          amount: 1,
          progress: snapshot.orderReservable.progress,
          addCardProgress: snapshot.orderReservable.addCardProgress,
          navigate: snapshot.orderReservable.navigate,
          businessId: snapshot.orderReservable.businessId,
          userId: snapshot.orderReservable.userId,
          business: snapshot.orderReservable.business,
          user: snapshot.orderReservable.user,
          selected: [snapshot.orderReservable.selected[i]],
          cartCounter: snapshot.orderReservable.cartCounter,
          serviceId: snapshot.orderReservable.serviceId,
        );
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservable(reservable));
      }
      //StoreProvider.of<AppState>(context).dispatch(CreateOrderReservable(snapshot.orderReservable));
    } else {
      /// Direct Card Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Credit Card');
      StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderCardAndPay(snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderCardPending(snapshot.order, last4, brand, country, selectedCardPaymentMethodId, PaymentType.card));
      }

    }

  }

  Future<void> confirmationNative(BuildContext context, AppState snapshot) async {
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');

      if (snapshot.order.isOrderAutoConfirmable()) {
        /// POSSIBLE CHANGE IN FLOW IF IN RANGE OF 7 DAYS TO PAYMENT

      } else {
        /// POSSIBLE CHANGE IN FLOW IF IN RANGE OF 7 DAYS TO PAYMENT

      }
    } else {
      /// Direct Native Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
      /// 1: create the payment method
      StripePaymentService stripePaymentService = StripePaymentService();
      StripeRecommended.PaymentMethod paymentMethod = await stripePaymentService.createPaymentMethodNative(snapshot.order, snapshot.business.name);
      /// 2: add the payment method to the order state
      StoreProvider.of<AppState>(context).dispatch(SetOrderPaymentMethod(paymentMethod));
      StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
      /// 3: now we can create the order on the database and its sub collection
      if (snapshot.order.isOrderAutoConfirmable()) {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderNativeAndPay(snapshot.order, paymentMethod, PaymentType.native));
      } else {
        StoreProvider.of<AppState>(context).dispatch(CreateOrderNativePending(snapshot.order, paymentMethod, PaymentType.native));
      }
    }

  }

  Future<void> confirmationRoom(BuildContext context, AppState snapshot) async {
    if (widget.reserve != null && widget.reserve) {
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      if (snapshot.order.isOrderAutoConfirmable()) {
        /// POSSIBLE CHANGE IN FLOW IF IN RANGE OF 7 DAYS TO PAYMENT

      } else {
        /// POSSIBLE CHANGE IN FLOW IF IN RANGE OF 7 DAYS TO PAYMENT

      }
    } else {
      /// Direct Payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
      if (snapshot.order.isOrderAutoConfirmable()) {
        /// if the items are all autoconfirmed we can launch the paymentflow and create the order when the payment is successful
        /// 1: search for the room number in the booking
        String roomNumber = '1';
        /// IMPORTANT for the moment we just approve and add all order ids to the booking state sub collection "room orders"
        /// TODO: get the actual room number when the UX is defined?
        if (roomNumber.isNotEmpty) {
          /// 2A: now we can create the order on the database and its sub collection
          StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
          StoreProvider.of<AppState>(context).dispatch(CreateOrderRoomAndPay(snapshot.order, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      } else {
        /// we create the order on firebase as "pending"
        /// IMPORTANT for the moment we just approve and add all order ids to the booking state sub collection "room orders"
        /// TODO: get the actual room number when the UX is defined?
        String roomNumber = '1';
        if (roomNumber.isNotEmpty) {
          /// 2A: now we can create the order on the database and its sub collection
          StoreProvider.of<AppState>(context).dispatch(CreatingOrder());
          StoreProvider.of<AppState>(context).dispatch(CreateOrderRoomPending(snapshot.order, roomNumber, PaymentType.room));
        } else {
          /// 2B: we display a message to the user: "you have to ask the concierge to add your room number to be able to use this payment method"
        }
      }
    }
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ConfirmingOrder(_controller.index, widget.reserve, widget.tourist)));
  }
}
