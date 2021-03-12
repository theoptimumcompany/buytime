import 'package:Buytime/UI/user/UI_U_Tabs.dart';
import 'package:Buytime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:Buytime/UI/user/cart/tab/T_room.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
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

class ConfirmedOrder extends StatefulWidget{
  final String title = 'Cart';

  int from;
  ConfirmedOrder(this.from);

  @override
  State<StatefulWidget> createState() => ConfirmedOrderState();
}

class ConfirmedOrderState extends State<ConfirmedOrder> with SingleTickerProviderStateMixin{

  TabController _controller;
  int _selectedIndex = 0;
  CardState cardState = CardState().toEmpty();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });

  }

  OrderState order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardListState;
    tmpList.forEach((element) {
      if(element.selected)
        cardState = element;
    });
    return WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, snapshot) {
              //order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
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
                      ///Order ConfirmedTitle
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Order Confirmed', ///TODO Make it Global
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
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: (SizeConfig.safeBlockVertical * 80)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Cart Details & Confirm Details
                            Flexible(
                              //fit: FlexFit.tight,
                              child: Container(
                                //color: Colors.black87,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StoreConnector<AppState, OrderState>(
                                      converter: (store) => store.state.order,
                                      rebuildOnChange: true,
                                      builder: (context, snapshot) {
                                        print("UI_U_cart => " + snapshot.itemList.length.toString());
                                        return Column(
                                          children: [
                                            ///Top Text
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Service name second line', ///TODO Make it Global
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
                                            ///Service List
                                            Column(
                                              children: snapshot.itemList.map((item){
                                                return OptimumOrderItemCardMedium(
                                                  key: ObjectKey(item),
                                                  orderEntry: item,
                                                  mediaSize: media,
                                                  show: false,
                                                );
                                              }).toList(),
                                            ),
                                            ///Total order
                                            OrderTotal(media: media, orderState: snapshot),
                                            Container(
                                              color: BuytimeTheme.DividerGrey,
                                              height: SizeConfig.safeBlockVertical * 2,
                                            ),
                                            ///Charge Summary
                                            Container(
                                              color: BuytimeTheme.UserPrimary,
                                              height: SizeConfig.safeBlockVertical * 7,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                                    child: Text(
                                                      'CHARGE SUUMMARY:', ///TODO Make it Global
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextWhite,
                                                        fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            ///Room or Credit Card
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                                              height: SizeConfig.safeBlockVertical * 8,
                                              color: Colors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 0.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ///Room or Credit CardText
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                                      child: Text(
                                                        widget.from == 0 ? 'Credit Card:' : 'Room:', ///TODO Make it Global
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          letterSpacing: 0.25,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextMedium,
                                                          fontSize: 14, ///SizeConfig.safeBlockHorizontal * 3.5
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    ///Room or Credit Card Value
                                                    Container(
                                                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                                                      child: Text(
                                                        widget.from == 0 ? '${cardState.stripeState.stripeCard.brand} **** ${cardState.stripeState.stripeCard.last4}' : 'Room Number', ///TODO Make it Global
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          letterSpacing: 0.5,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontSize: 16, ///SizeConfig.safeBlockHorizontal * 3.5
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                                              color: BuytimeTheme.BackgroundLightGrey,
                                              height: SizeConfig.safeBlockVertical * .2,
                                            ),
                                            ///Order Status
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2.5),
                                                  padding: EdgeInsets.all(5.0),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      snapshot.progress == "in_progress" ? 'WE ARE CONFIRMING YOUR ORDER' : snapshot.progress == "failed" ? 'SOMETHING WENT WRONG' : 'ORDER CONFIRMED',//AppLocalizations.of(context).somethingIsNotRight, ///TODO Make it global
                                                      style: TextStyle(
                                                        letterSpacing: 1.25,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.UserPrimary,
                                                        fontSize: 16, ///SizeConfig.safeBlockHorizontal * 3.5
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            ///Animation
                                            Container(
                                              width: SizeConfig.safeBlockVertical * 20,
                                              height: SizeConfig.safeBlockVertical * 20,
                                              child: Center(
                                                child: BCubeGridSpinner(
                                                  color: Colors.transparent,
                                                  size: SizeConfig.safeBlockVertical * 15,
                                                ),
                                              ),
                                            ),
                                            /*GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot.itemList.length + 1,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 1,
                                                childAspectRatio: 5,
                                              ),
                                              itemBuilder: (BuildContext context, int index) {
                                                final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                                return index != snapshot.itemList.length
                                                    ? OptimumOrderItemCardMedium(
                                                  key: ObjectKey(item),
                                                  orderEntry: snapshot.itemList[index],
                                                  mediaSize: media,
                                                  rightWidget1: Column(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.remove_shopping_cart,
                                                          color: BuytimeTheme.SymbolGrey,
                                                        ),
                                                        onPressed: () {
                                                          deleteItem(snapshot, index);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                )
                                                    : Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    OrderTotal(media: media, orderState: snapshot),
                                                    Container(
                                                      color: BuytimeTheme.DividerGrey,
                                                      height: SizeConfig.safeBlockVertical * 2,
                                                    ),
                                                  ],
                                                );
                                              },
                                            )*/
                                          ],
                                        );
                                      }
                                  ),
                                ),
                              ),
                            ),
                            ///Back to home button
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                //height: double.infinity,
                                //color: Colors.black87,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Back to home button
                                    Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2.5),
                                        width: 158,
                                        height: 44,
                                        child: RaisedButton(
                                          onPressed: () {
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmedOrder()),);
                                            //StoreProvider.of<AppState>(context).state.orderList.orderListState = [];
                                            //Navigator.popUntil(context, MaterialPageRoute(builder: (context) => BookingPage()));
                                            //snapshot.order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");
                                            //StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                            //StoreProvider.of<AppState>(context).dispatch(UpdateOrder(order));
                                            StoreProvider.of<AppState>(context).dispatch(SetOrder(OrderState().toEmpty()));
                                            Navigator.of(context).popUntil(ModalRoute.withName('/bookingPage'));
                                          },
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: BuytimeTheme.UserPrimary,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'BACK TO HOME',//AppLocalizations.of(context).logBack, ///TODO Make it Global
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                fontWeight: FontWeight.w500,
                                                color: BuytimeTheme.TextWhite,
                                              letterSpacing: 1.25
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
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
