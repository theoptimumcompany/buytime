import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartReservable extends StatefulWidget {
  ServiceState serviceState;

  CartReservable({Key key, this.serviceState}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartReservableState();
}

class CartReservableState extends State<CartReservable> {
  OrderReservableState orderReservableState;

  @override
  void initState() {
    super.initState();
  }

  void undoDeletion(index, OrderEntry item) {
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      orderReservableState.itemList.insert(index, item);
      orderReservableState.total += item.price * item.number;
    });
  }

  void deleteItem(OrderReservableState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_CartReservable => Remove Normal Item');
    setState(() {
      if (snapshot.itemList.length >= 1) {
        orderReservableState.cartCounter = orderReservableState.cartCounter - entry.number;
        orderReservableState.itemList.remove(entry);
        double serviceTotal =  orderReservableState.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        orderReservableState.total = serviceTotal;
        //snapshot.removeItem(snapshot.itemList[index]);
        //snapshot.itemList.removeAt(index);
      } else {
        orderReservableState.cartCounter = orderReservableState.cartCounter - entry.number;
        orderReservableState.itemList.remove(entry);
        double serviceTotal =  orderReservableState.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        orderReservableState.total = serviceTotal;
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(orderReservableState));
    });
  }

  void deleteReserveItem(OrderReservableState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_CartReservable => Remove Normal Item');
    setState(() {
      orderReservableState.cartCounter = orderReservableState.cartCounter - entry.number;
      orderReservableState.removeReserveItem(entry);
      orderReservableState.selected.removeAt(index);
      orderReservableState.itemList.remove(entry);
      if (orderReservableState.itemList.length == 0) Navigator.of(context).pop();

      StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(orderReservableState));
    });
  }

  ServiceState tmp;

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
            onInit: (store) {
              tmp = store.state.serviceState;
            },
            builder: (context, snapshot) {
              orderReservableState = snapshot.orderReservable;
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
                            /*StoreProvider.of<AppState>(context).dispatch(UpdateOrder(OrderState(
                              itemList: orderState.itemList, date: orderState.date, position: orderState.position, total: orderState.total, business: orderState.business, user: orderState.user, businessId: orderState.businessId, userId: orderState.userId)));*/

                            Navigator.of(context).pop();
                          }),

                      ///Cart Title
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Text(
                            AppLocalizations.of(context).confirmBooking,
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
                                  child: StoreConnector<AppState, OrderReservableState>(
                                      converter: (store) => store.state.orderReservable,
                                      rebuildOnChange: true,
                                      builder: (context, snapshot) {
                                        orderReservableState = snapshot;
                                        print("UI_U_cartReservable => CART COUNT: ${orderReservableState.itemList.length}");
                                        return Column(
                                          children: [
                                            ///Service List
                                            Flexible(
                                              flex: 1,
                                              child: CustomScrollView(shrinkWrap: true, slivers: [
                                                SliverList(
                                                  delegate: SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      debugPrint('UI_U_CartReservable => LIST| ${orderReservableState.itemList[index].name} ITEM COUNT: ${orderReservableState.itemList[index].number}');
                                                      var item = (index != orderReservableState.itemList.length ? orderReservableState.itemList[index] : null);
                                                      //int itemCount = orderState.itemList[index].number;
                                                      return  Dismissible(
                                                              // Each Dismissible must contain a Key. Keys allow Flutter to
                                                              // uniquely identify widgets.
                                                              key: UniqueKey(),
                                                              // Provide a function that tells the app
                                                              // what to do after an item has been swiped away.
                                                              direction: DismissDirection.endToStart,
                                                              onDismissed: (direction) {
                                                                // Remove the item from the data source.
                                                                setState(() {
                                                                  orderReservableState.itemList.removeAt(index);
                                                                });
                                                                if (direction == DismissDirection.endToStart) {
                                                                  orderReservableState.selected == null || orderReservableState.selected.isEmpty ?
                                                                    deleteItem(orderReservableState, item, index) :
                                                                  deleteReserveItem(orderReservableState, item, index);
                                                                  debugPrint('UI_U_CartReservable => DX to DELETE');
                                                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                                  Scaffold.of(context).showSnackBar(SnackBar(
                                                                      content: Text(item.name + AppLocalizations.of(context).spaceRemoved),
                                                                      action: SnackBarAction(
                                                                          label: AppLocalizations.of(context).undo,
                                                                          onPressed: () {
                                                                            //To undo deletion
                                                                            undoDeletion(index, item);
                                                                          })));
                                                                } else {
                                                                  orderReservableState.itemList.insert(index, item);
                                                                }
                                                              },
                                                              child: OptimumOrderItemCardMedium(
                                                                key: ObjectKey(item),
                                                                orderEntry: orderReservableState.itemList[index],
                                                                mediaSize: media,
                                                                orderState: OrderState.fromReservableState(orderReservableState),
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
                                                              ),
                                                              background: Container(
                                                                color: BuytimeTheme.BackgroundWhite,
                                                                //margin: EdgeInsets.symmetric(horizontal: 15),
                                                                alignment: Alignment.centerRight,
                                                              ),
                                                              secondaryBackground: Container(
                                                                color: BuytimeTheme.AccentRed,
                                                                //margin: EdgeInsets.symmetric(horizontal: 15),
                                                                alignment: Alignment.centerRight,
                                                                child: Container(
                                                                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                                  child: Icon(
                                                                    BuytimeIcons.remove,
                                                                    size: 24,

                                                                    ///SizeConfig.safeBlockHorizontal * 7
                                                                    color: BuytimeTheme.SymbolWhite,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                    },
                                                    childCount: orderReservableState.itemList.length,
                                                  ),
                                                ),
                                              ]),
                                            ),

                                            ///Total Order
                                            OrderTotal(media: media, orderState: OrderState.fromReservableState(orderReservableState)),

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
                                      }),
                                ),
                              ),
                            ),

                            ///Buy Button & Continue Shooping
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                //height: double.infinity,
                                //color: Colors.black87,
                                child: ///Reserve
                                Column (
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Reserve button
                                    Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 5),
                                        width: 158,

                                        /// media.width * .4
                                        height: 46,
                                        child: MaterialButton(
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: () {
                                            if(widget.serviceState.switchAutoConfirm){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ConfirmOrder(reserve: true,)),
                                              );
                                            }else{
                                              ///TODO send notification and navigate ...
                                            }
                                          },
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: BuytimeTheme.UserPrimary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context).reserveUpper,
                                            style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextWhite, letterSpacing: 1.25),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
