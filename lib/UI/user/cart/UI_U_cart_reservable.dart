import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/login/tourist_session/UI_U_tourist_session.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/reblox/enum/order_time_intervals.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reusable/w_promo_discount.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/order/w_optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/w_order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';

class CartReservable extends StatefulWidget {
  ServiceState serviceState;
  bool tourist;
  CartReservable({Key key, this.serviceState, this.tourist}) : super(key: key);

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
    debugPrint('UI_U_cart_reservable => Remove Normal Item 1');
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
        Navigator.of(context).pop(true);
      }
      Provider.of<ReserveList>(context, listen: false).updateOrder(orderReservableState);
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(orderReservableState));
    });
  }

  void deleteReserveItem(OrderReservableState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_cart_reservable => Remove Normal Item 2 - ${entry.number} - ${entry.price}');
    setState(() {
      StoreProvider.of<AppState>(context).state.slotSnippetListState.slotListSnippet.forEach((element) {
        element.slot.forEach((element2) {
          if(element2.uid == entry.idSquareSlot){
            debugPrint('UI_U_cart_reservable => ON: ${element2.on} - FREE: ${element2.free} - MAX: ${element2.max} - ORDER CAPACITY: ${entry.orderCapacity}');
            int tmp = element2.free;
            tmp = tmp+ entry.orderCapacity;
            element2.free = tmp;
          }
        });
      });
      if(Provider.of<Explorer>(context, listen: false).businessState.id_firestore.isNotEmpty){
        ConventionHelper conventionHelper = ConventionHelper();
        orderReservableState.totalPromoDiscount -= (((entry.price/entry.number) * conventionHelper.getConventionDiscount(Provider.of<Explorer>(context, listen: false).cartReservableServiceList.first, Provider.of<Explorer>(context, listen: false).businessState.id_firestore))/100) * entry.number;
      }
      orderReservableState.cartCounter -= 1;
      orderReservableState.removeReserveItem(entry,context);
      orderReservableState.selected.removeAt(index);

      orderReservableState.itemList.remove(entry);
      //StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(orderReservableState));
      if (orderReservableState.itemList.length == 0) Navigator.of(context).pop(true);
      Provider.of<ReserveList>(context, listen: false).updateOrder(orderReservableState);
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
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    brightness: Brightness.dark,
                    elevation: 1,
                    title: Text(
                      AppLocalizations.of(context).confirmBooking,
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextBlack,
                          fontWeight: FontWeight.w500,
                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
                      ),
                    ),
                    centerTitle: true,
                    leading: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.black,
                      ),
                      onPressed: () async{
                        Navigator.of(context).pop();
                      },
                    ),
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
                            ///Promotion Label
                            /*Utils.checkPromoDiscount('general_1', context).promotionId != 'empty'
                                ? Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Center(
                                child: W_PromoDiscount(false),
                              ),
                            )
                                : Container(),*/

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
                                        debugPrint("UI_U_cartReservable => CART COUNT: ${orderReservableState.itemList.length}");
                                        return Column(
                                          children: [
                                            ///Service List
                                            Flexible(
                                              flex: 1,
                                              child: CustomScrollView(
                                                  physics: new ClampingScrollPhysics(),
                                                  shrinkWrap: true, slivers: [
                                                SliverList(
                                                  delegate: SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      debugPrint('UI_U_cart_reservable => LIST| ${orderReservableState.itemList[index].name} ITEM COUNT: ${orderReservableState.itemList[index].number}');
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
                                                                  debugPrint('UI_U_cart_reservable => DX to DELETE');
                                                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                                                  //     content: Text(Utils.retriveField(Localizations.localeOf(context).languageCode, item.name) + ' ${AppLocalizations.of(context).spaceRemoved}'),
                                                                  //     action: SnackBarAction(
                                                                  //         label: AppLocalizations.of(context).undo,
                                                                  //         onPressed: () {
                                                                  //           //To undo deletion
                                                                  //           undoDeletion(index, item);
                                                                  //         })));
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
                                            OrderTotal(/*totalECO: 0*/ media: media, orderState: OrderState.fromReservableState(orderReservableState), promotion: false),

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
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                        width: 198,

                                        /// media.width * .4
                                        height: 46,
                                        child: MaterialButton(
                                          key: Key('cart_reserve_key'),
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: () {
                                            snapshot.slotSnippetListState.slotListSnippet.forEach((sLS) {
                                              sLS.slot.forEach((s) {
                                                orderReservableState.itemList.forEach((iT) {
                                                  if(iT.idSquareSlot == s.uid){
                                                    debugPrint('UI_U_cart_reservable => SLOT TIME: ${s.on}');
                                                    debugPrint('UI_U_cart_reservable => SLOT DATE: ${s.date}');
                                                    debugPrint('UI_U_cart_reservable => SLOT PRICE: ${iT.price}');
                                                    debugPrint('UI_U_cart_reservable => SLOT QUANTITY: ${iT.orderCapacity}');
                                                  }
                                                });
                                              });
                                            });
                                            //orderReservableState.itemList.first.idSquareSlot
                                            /// if we are before the 7 days we just create a reminder
                                            auth.User user = auth.FirebaseAuth.instance.currentUser;
                                            if (user == null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => TouristSession()),
                                              );
                                            }else{
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => ConfirmOrder(reserve: true, tourist: widget.tourist,)),
                                              );
                                            }

                                          },
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          color: BuytimeTheme.ActionBlackPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context).reserve,
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
