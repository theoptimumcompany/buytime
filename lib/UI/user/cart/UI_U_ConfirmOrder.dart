
import 'package:Buytime/UI/user/cart/UI_U_ConfirmedOrder.dart';
import 'package:Buytime/UI/user/cart/tab/T_credit_cards.dart';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ConfirmOrder extends StatefulWidget{
  final String title = 'confirmOrder';

  bool reserve;
  ConfirmOrder({Key key, this.reserve}) : super(key: key);

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
    _controller = TabController(length: 2, vsync: this);

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
              store?.dispatch(StripeListCardListRequest('${store?.state?.user?.uid}_test'));
              debugPrint('UI_U_ConfirmOrder => ON INIT');
            }, ///TODO Rememebr _test
            converter: (store) => store.state,
            builder: (context, snapshot) {
              if(widget.reserve)
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
                    background: BuytimeTheme.UserPrimary,
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
                                            if(widget.reserve){
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
                                        color: BuytimeTheme.UserPrimary,
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
                                          ///Credit Card
                                          Tab(
                                            text: AppLocalizations.of(context).creditCardUpper,
                                          ),
                                          ///Room
                                          Tab(
                                            text: AppLocalizations.of(context).roomUpper,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ///Tab
                                  _controller.index == 0 ? CreditCards() : Room(),
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
                                          onPressed: selected && _selectedIndex == 0 ? () {
                                            if(widget.reserve){
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
                                            }else{
                                              StoreProvider.of<AppState>(context).dispatch(SetOrderProgress("in_progress"));
                                              StoreProvider.of<AppState>(context).dispatch(CreateOrder(snapshot.order));
                                            }
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder(_controller.index, widget.reserve)),);
                                          } : _selectedIndex == 1 ? (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder(_controller.index, widget.reserve)),);
                                          } : null,
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: BuytimeTheme.UserPrimary,
                                          disabledColor: BuytimeTheme.SymbolLightGrey,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              !widget.reserve
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
                                    /*Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // trigger payment information page
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => UI_U_StripePayment()),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: (media.height * 0.05)),
                                          child: Container(
                                            width: media.width * 0.55,
                                            decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text(AppLocalizations.of(context).orderAndPay, style: TextStyle(color: Colors.white))],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         // trigger payment information page
                                  //         print("Dispatch Order create!");
                                  //         StoreProvider.of<AppState>(context).dispatch(CreateOrder(OrderState(
                                  //             itemList: snapshot.order.itemList,
                                  //             date: snapshot.order.date,
                                  //             progress: "paid",
                                  //             position: snapshot.order.position,
                                  //             total: snapshot.order.total,
                                  //             business: snapshot.order.business,
                                  //             user: snapshot.order.user,
                                  //             businessId: snapshot.business.id_firestore)));
                                  //         StoreProvider.of<AppState>(context).dispatch(OrderListRequest());
                                  //       },
                                  //       child: Padding(
                                  //         padding: EdgeInsets.only(top: (media.height * 0.05)),
                                  //         child: Container(
                                  //           width: media.width * 0.55,
                                  //           decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8.0),
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text("Test Order Create", style: TextStyle(color: Colors.white))],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: media.height * 0.05,
                                  )*/
                                  ],
                                ),
                              ),
                            )
                            /*Flexible(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.black87,
                                child:  DefaultTabController(
                                  length: 2,
                                  child: Scaffold(
                                    appBar: PreferredSize(
                                      preferredSize: Size.fromHeight(kToolbarHeight),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: BuytimeTheme.UserPrimary,
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
                                          indicatorPadding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                          controller: _controller,
                                          tabs: [
                                            ///Credit Card
                                            Tab(
                                              child: Text(
                                                'CREDIT CARD',//AppLocalizations.of(context).somethingIsNotRight,
                                                style: TextStyle(
                                                    letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextWhite,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                            ///Room
                                            Tab(
                                                child: Text(
                                                  'ROOM',//AppLocalizations.of(context).somethingIsNotRight,
                                                  style: TextStyle(
                                                      letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextWhite,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    body: ConstrainedBox(
                                      constraints: BoxConstraints(),
                                      child: TabBarView(
                                        controller: _controller,
                                        children: [
                                          CreditCardTab(),
                                          Icon(Icons.directions_transit),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )*/
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
}
