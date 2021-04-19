import 'dart:io';

import 'package:Buytime/UI/user/cart/UI_U_ConfirmedOrder.dart';
import 'package:Buytime/UI/user/cart/tab/T_native_google.dart';
import 'package:Buytime/UI/user/cart/tab/T_credit_cards.dart';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
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
import 'package:stripe_payment/stripe_payment.dart';

class ConfirmOrder extends StatefulWidget{
  final String title = 'confirmOrder';
  bool tourist;
  bool reserve = false;
  ConfirmOrder({Key key, this.reserve, this.tourist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrder> with SingleTickerProviderStateMixin{

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
              store?.dispatch(CheckStripeCustomer());
              debugPrint('UI_U_ConfirmOrder => ON INIT');
            },
            converter: (store) => store.state,
            builder: (context, snapshot) {
              if(widget.reserve != null && widget.reserve)
                orderReservableState = snapshot.orderReservable;
              else
                orderState = snapshot.order;
              bool selected = false;
              List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardListState;
              tmpList.forEach((element) {
                if(element.selected){
                  selected = true;
                }
              });

              return Scaffold(
                  appBar: BuytimeAppbar(
                    background: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                    width: media.width,
                    children: [
                      ///Back Button
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                        onPressed: () => Future.delayed(Duration.zero, () {
                          Navigator.of(context).pop();
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
                      )
                    ],
                  ),
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
                                              fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
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
                                      child: StoreConnector<AppState, AppState>(
                                          converter: (store) => store.state,
                                          rebuildOnChange: true,
                                          builder: (context, snapshot) {
                                            if(widget.reserve != null && widget.reserve){
                                              print("UI_U_ConfirmOrder => " + snapshot.orderReservable.itemList.length.toString());
                                              return OrderTotal(media: media, orderState: OrderState.fromReservableState(snapshot.orderReservable));
                                            }else{
                                              print("UI_U_ConfirmOrder => " + snapshot.order.itemList.length.toString());
                                              return OrderTotal(media: media, orderState: snapshot.order);
                                            }
                                          }
                                      )
                                  ),
                                  ///Divider
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                                    color: BuytimeTheme.BackgroundLightGrey,
                                    height: SizeConfig.safeBlockVertical * .2,
                                  ),
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
                                              fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
                                        color:  widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black87.withOpacity(.3),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: TabBar(
                                        indicatorWeight: SizeConfig.safeBlockHorizontal * 1,
                                        indicatorColor: BuytimeTheme.BackgroundWhite,
                                        labelStyle: TextStyle(
                                            letterSpacing: 1.25, ///SizeConfig.safeBlockHorizontal * .2
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextWhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                        indicatorPadding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                        controller: _controller,
                                        tabs: [
                                          ///Room
                                          Tab(
                                            text: AppLocalizations.of(context).roomSimple,
                                          ),
                                          ///Credit Card
                                          Tab(
                                            icon: Platform.isAndroid ?
                                            Text(AppLocalizations.of(context).googlePay) :
                                            Icon(FontAwesome5Brands.apple_pay,size: 40.0,)
                                          ),
                                          ///Credit Card
                                          Tab(
                                            text: AppLocalizations.of(context).creditCardSimple,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  ///Tab
                                  (() {
                                    if (_controller.index == 0) {
                                      return Room(tourist: widget.tourist);
                                    } else if (_controller.index == 1) {
                                      return NativeGoogle();
                                    } else if (_controller.index == 2) {
                                      return CreditCards(tourist: widget.tourist);
                                    }
                                  }())
                                ],
                              ),
                            ),
                            ///Confirm button
                            Align(
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
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                                        width: 158, ///media.width * .4
                                        height: 44,
                                        child: MaterialButton(
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: _selectedIndex == 0 ? () {
                                            debugPrint("UI_U_ConfirmOrder confirmation 0");
                                            /// TODO room payment logic starts
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder(_controller.index, widget.reserve, widget.tourist)),);
                                          } : _selectedIndex == 1 ?
                                          (){
                                            debugPrint("UI_U_ConfirmOrder confirmation 1");
                                            confirmationNative(context, snapshot);
                                          } : selected && _selectedIndex == 2 ? (){
                                            debugPrint("UI_U_ConfirmOrder  confirmation 2");
                                            confirmationCard(context, snapshot);
                                          } : null,
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                          disabledColor: BuytimeTheme.SymbolLightGrey,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              !(widget.reserve!= null && widget.reserve)
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
                            ),
                            !snapshot.stripe.stripeCustomerCreated ? /// TODO: insert the ripple effect @nipuna
                            Text('load') : Container()
                          ],
                        ),
                      ),
                    ),
                  )
              );
            }
        )
    );
  }

  void confirmationCard(BuildContext context, AppState snapshot) {
    if(widget.reserve != null && widget.reserve){
      /// Reservable payment process starts
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Credit Card');
      StoreProvider.of<AppState>(context).dispatch(SetOrderReservableProgress("in_progress"));
      for(int i = 0; i < snapshot.orderReservable.itemList.length; i++){
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
            serviceId: snapshot.orderReservable.serviceId
        );
    
        debugPrint('UI_U_ConfirmOrder => Date: ${reservable.date}');
        StoreProvider.of<AppState>(context).dispatch(CreateOrderReservable(reservable));
      }
      //StoreProvider.of<AppState>(context).dispatch(CreateOrderReservable(snapshot.orderReservable));
    } else {
      /// Direct Card Payment
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Credit Card');
      StoreProvider.of<AppState>(context).dispatch(SetOrderProgress("in_progress"));
      StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
      //.catchError(err); // TODO: reactivate
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder(_controller.index, widget.reserve, widget.tourist)),);
  }
  void confirmationNative(BuildContext context, AppState snapshot) {

    if(widget.reserve != null && widget.reserve){
      /// Reservable payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start reservable payment process with Native Method');
      StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          totalPrice: "1.20",
          currencyCode: "EUR",
        ),
        applePayOptions: ApplePayPaymentOptions(
          countryCode: 'DE',
          currencyCode: 'EUR',
          items: [
            ApplePayItem(
              label: 'Test',
              amount: '13',
            )
          ],
        ),
      ).then((token) {
        StoreProvider.of<AppState>(context).dispatch(SetOrderProgress("in_progress"));
        StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
      }).catchError((error){
        /// TODO: Show error to the user
        debugPrint('UI_U_ConfirmOrder => error in direct payment process with Native Method:' + error);
      });
    } else {
      /// Direct Payment process starts with Native Method
      debugPrint('UI_U_ConfirmOrder => start direct payment process with Native Method');
      StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
          totalPrice: "1.20",
          currencyCode: "EUR",
        ),
        applePayOptions: ApplePayPaymentOptions(
          countryCode: 'DE',
          currencyCode: 'EUR',
          items: [
            ApplePayItem(
              label: 'Test',
              amount: '13',
            )
          ],
        ),
      ).then((token) {
        StoreProvider.of<AppState>(context).dispatch(SetOrderProgress("in_progress"));
        StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
      }).catchError((error){
        /// TODO: Show error to the user
        debugPrint('UI_U_ConfirmOrder => error in direct payment process with Native Method:' + error);
      });
    }


    // Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder(_controller.index, widget.reserve, widget.tourist)),);
  }
}
