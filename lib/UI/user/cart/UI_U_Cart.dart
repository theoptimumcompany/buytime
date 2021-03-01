import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
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

class Cart extends StatefulWidget {
  final String title = 'Cart';

  @override
  State<StatefulWidget> createState() => CartState();
}

class CartState extends State<Cart> {

  OrderState orderState;
  @override
  void initState() {
    super.initState();
  }

  void deleteItem(OrderState snapshot, int index) {
    setState(() {
      if (snapshot.itemList.length > 1) {
        cartCounter = cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
      } else {
        cartCounter = cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(OrderState(
          itemList: snapshot.itemList, date: snapshot.date, position: snapshot.position, total: snapshot.total, business: snapshot.business, user: snapshot.user, businessId: snapshot.businessId, userId: snapshot.userId)));
    });
  }

  void deleteOneItem(OrderState snapshot, int index) {
    setState(() {
      if(snapshot.itemList.length >= 1){
        if (snapshot.itemList[index].number > 1) {
          --cartCounter;
          int itemCount =  snapshot.itemList[index].number;
          debugPrint('UI_U_Cart => BEFORE| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => BEFORE| TOTAL: ${snapshot.total}');
          --itemCount;
          snapshot.itemList[index].number = itemCount;
          double serviceTotal =  snapshot.total;
          serviceTotal = serviceTotal - snapshot.itemList[index].price;
          snapshot.total = serviceTotal;
          debugPrint('UI_U_Cart => AFTER| ${snapshot.itemList[index].name} ITEM COUNT: ${snapshot.itemList[index].number}');
          debugPrint('UI_U_Cart => AFTER| TOTAL: ${snapshot.total}');


          /*snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);*/
        }
      }else{
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(OrderState(
          itemList: snapshot.itemList, date: snapshot.date, position: snapshot.position, total: snapshot.total, business: snapshot.business, user: snapshot.user, businessId: snapshot.businessId, userId: snapshot.userId)));
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
            converter: (store) => store.state,
            builder: (context, snapshot) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
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
                            'Cart', ///TODO Make it Global
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
                          children: [
                            /*Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Text(
                          AppLocalizations.of(context).orderIn + StoreProvider.of<AppState>(context).state.business.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.025,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),*/
                            ///Service List
                            Expanded(
                              flex: 2,
                              child: Container(
                                //color: Colors.black87,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: StoreConnector<AppState, OrderState>(
                                      converter: (store) => store.state.order,
                                      rebuildOnChange: true,
                                      builder: (context, snapshot) {
                                        orderState = snapshot;
                                        print("UI_U_cart => CART COUNT: ${orderState.itemList.length}");
                                        return Column(
                                          children: [
                                            ///Service List
                                            Flexible(
                                              flex: 1,
                                              child: CustomScrollView(shrinkWrap: true, slivers: [
                                                SliverList(
                                                  delegate: SliverChildBuilderDelegate((context, index) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                    debugPrint('UI_U_Cart => LIST| ${orderState.itemList[index].name} ITEM COUNT: ${orderState.itemList[index].number}');
                                                    var item = (index != orderState.itemList.length ? orderState.itemList[index] : null);
                                                    int itemCount = orderState.itemList[index].number;
                                                    return OptimumOrderItemCardMedium(
                                                      key: ObjectKey(item),
                                                      orderEntry: orderState.itemList[index],
                                                      mediaSize: media,
                                                      orderState: orderState,
                                                      index: index,
                                                      show: true,
                                                      /*rightWidget1: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              itemCount >= 2 ? IconButton(
                                                                icon: Icon(
                                                                  Icons.remove_circle_outline,
                                                                  color: BuytimeTheme.AccentRed,
                                                                  //size: SizeConfig.safeBlockHorizontal * 15,
                                                                ),
                                                                onPressed: () {
                                                                  deleteOneItem(orderState, index);
                                                                },
                                                              ) : Container(),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.remove_shopping_cart,
                                                                  color: BuytimeTheme.SymbolGrey,
                                                                  //size: SizeConfig.safeBlockHorizontal * 15,
                                                                ),
                                                                onPressed: () {
                                                                  deleteItem(orderState, index);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),*/
                                                    );
                                                  },
                                                    childCount: orderState.itemList.length,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                            ///Total Order
                                            OrderTotal(media: media, orderState: snapshot),
                                            ///Divider
                                            Container(
                                              color: BuytimeTheme.DividerGrey,
                                              height: SizeConfig.safeBlockVertical * 2,
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
                            ///Buy Button & Continue Shooping
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                //height: double.infinity,
                                //color: Colors.black87,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Buy button
                                    Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                        width: media.width * .4,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmOrder()),);
                                          },
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: BuytimeTheme.UserPrimary,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            'BUY',//AppLocalizations.of(context).logBack, ///TODO Make it Global
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                fontWeight: FontWeight.w500,
                                                color: BuytimeTheme.TextWhite
                                            ),
                                          ),
                                        )
                                    ),
                                    ///Continue Shopping
                                    Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2.5),
                                        alignment: Alignment.center,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: (){
                                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                Navigator.of(context).pop();
                                              },
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              child: Container(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  'CONTINUE\nSHOPPING',//AppLocalizations.of(context).somethingIsNotRight,
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
