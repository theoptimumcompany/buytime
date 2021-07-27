import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/login/tourist_session/UI_U_tourist_session.dart';
import 'package:Buytime/UI/user/login/tourist_session/UI_U_tourist_session_register.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Cart extends StatefulWidget {
  ServiceState serviceState;
  bool tourist;

  Cart({Key key, this.serviceState, this.tourist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartState();
}

class CartState extends State<Cart> {
  OrderState orderState;
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void undoDeletion(index, OrderEntry item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      orderState.itemList.insert(index, item);
      orderState.total += item.price * item.number;
    });
  }

  void deleteItem(OrderState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_Cart => Remove Normal Item');
    setState(() {
      if (snapshot.itemList.length >= 1) {
        orderState.cartCounter = orderState.cartCounter - entry.number;
        orderState.itemList.remove(entry);
        double serviceTotal = orderState.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        orderState.total = serviceTotal;
        //snapshot.removeItem(snapshot.itemList[index]);
        //snapshot.itemList.removeAt(index);
      } else {
        orderState.cartCounter = orderState.cartCounter - entry.number;
        orderState.itemList.remove(entry);
        double serviceTotal = orderState.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        orderState.total = serviceTotal;
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(orderState));
    });
  }

  void deleteReserveItem(OrderState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_Cart => Remove Normal Item');
    setState(() {
      orderState.cartCounter = orderState.cartCounter - entry.number;
      orderState.removeReserveItem(entry);
      orderState.selected.removeAt(index);
      orderState.itemList.remove(entry);
      if (orderState.itemList.length == 0) Navigator.of(context).pop();

      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(orderState));
    });
  }

  ServiceState tmp;

  bool isExternal = false;
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
              if (!widget.tourist) {
                _locationController.text = store.state.business.area?.first;
                store.state.order.location = store.state.business.area?.first;
              }
            },
            builder: (context, snapshot) {
              orderState = snapshot.order;
              if(orderState != null && orderState.itemList.isNotEmpty && orderState.itemList.first.id_business != snapshot.business.id_firestore){
                debugPrint('UI_U_cart => ORDER BUSINESS ID: ${orderState.itemList.first.id_business} | BUSIENSS ID: ${snapshot.business.id_firestore}');
                isExternal = true;
              }
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: BuytimeAppbar(
                    background: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                    width: media.width,
                    children: [
                      ///Back Button
                      IconButton(
                        key: Key('back_from_cart_key'),
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
                            AppLocalizations.of(context).cart,
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
                                                  delegate: SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      debugPrint('UI_U_Cart => LIST| ${orderState.itemList[index].name} ITEM COUNT: ${orderState.itemList[index].number}');
                                                      var item = (index != orderState.itemList.length ? orderState.itemList[index] : null);
                                                      //int itemCount = orderState.itemList[index].number;
                                                      return Dismissible(
                                                        // Each Dismissible must contain a Key. Keys allow Flutter to
                                                        // uniquely identify widgets.
                                                        key: UniqueKey(),
                                                        // Provide a function that tells the app
                                                        // what to do after an item has been swiped away.
                                                        direction: DismissDirection.endToStart,
                                                        onDismissed: (direction) {
                                                          // Remove the item from the data source.
                                                          setState(() {
                                                            orderState.itemList.removeAt(index);
                                                          });
                                                          if (direction == DismissDirection.endToStart) {
                                                            orderState.selected == null || orderState.selected.isEmpty ? deleteItem(orderState, item, index) : deleteReserveItem(orderState, item, index);
                                                            debugPrint('UI_U_SearchPage => DX to DELETE');
                                                            // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text(Utils.retriveField(Localizations.localeOf(context).languageCode, item.name) + ' ${AppLocalizations.of(context).spaceRemoved}'),
                                                                action: SnackBarAction(
                                                                    label: AppLocalizations.of(context).undo,
                                                                    onPressed: () {
                                                                      //To undo deletion
                                                                      undoDeletion(index, item);
                                                                    })));
                                                          } else {
                                                            orderState.itemList.insert(index, item);
                                                          }
                                                        },
                                                        child: OptimumOrderItemCardMedium(
                                                          key: ObjectKey(item),
                                                          orderEntry: orderState.itemList[index],
                                                          mediaSize: media,
                                                          orderState: orderState,
                                                          index: index,
                                                          show: true,
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
                                                    childCount: orderState.itemList.length,
                                                  ),
                                                ),
                                              ]),
                                            ),

                                            ///Total Order
                                            OrderTotal(media: media, orderState: orderState),

                                            ///Divider
                                            Container(
                                              color: BuytimeTheme.DividerGrey,
                                              height: SizeConfig.safeBlockVertical * 2,
                                            ),

                                            ///Location TExt
                                            !widget.tourist && !isExternal
                                                ? Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                    child: Text(
                                                      AppLocalizations.of(context).whereDoYouWantToRecive,
                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, fontSize: 14),
                                                    ),
                                                  )
                                                : Container(),

                                            ///Location
                                            !widget.tourist && !isExternal
                                                ? Container(
                                                    width: 335.0,
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                    decoration: BoxDecoration(border: Border.all(color: BuytimeTheme.SymbolLightGrey), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                    child: DropdownButtonHideUnderline(
                                                      child: ButtonTheme(
                                                        alignedDropdown: true,
                                                        child: DropdownButton(
                                                          hint: Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 10.0),
                                                              child: Text(
                                                                _locationController.text,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: BuytimeTheme.TextMedium,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          //value: _locationController.text,
                                                          items: StoreProvider.of<AppState>(context).state.business.area?.map(
                                                            (val) {
                                                              return DropdownMenuItem<String>(
                                                                value: val,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 10.0),
                                                                        child: Text(
                                                                          val,
                                                                          textAlign: TextAlign.start,
                                                                          style: TextStyle(
                                                                            fontSize: 16,
                                                                            color: BuytimeTheme.TextMedium,
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    _locationController.text == val ? Icon(Icons.radio_button_checked, color: BuytimeTheme.SymbolGrey,) : Icon(Icons.radio_button_off, color: BuytimeTheme.SymbolGrey,),
                                                                    // Radio(
                                                                    //   toggleable: true,
                                                                    //   value: val,
                                                                    //   activeColor: BuytimeTheme.Secondary,
                                                                    //   groupValue: _locationController.text,
                                                                    //   onChanged: null,
                                                                    // )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          )?.toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _locationController.text = value;
                                                              orderState.location = value;
                                                              StoreProvider.of<AppState>(context).dispatch(UpdateOrder(orderState));
                                                            });
                                                          },
                                                          style: Theme.of(context).textTheme.title,
                                                        ),
                                                      ),
                                                    ))
                                                : Container(),
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
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ///Continue Shopping
                                      Container(
                                          width: 158,

                                          ///SizeConfig.safeBlockHorizontal * 40
                                          height: 44,
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2, right: SizeConfig.safeBlockHorizontal * 2.5),
                                          decoration: BoxDecoration(borderRadius: new BorderRadius.circular(5), border: Border.all(color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user ? (widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary) : BuytimeTheme.SymbolGrey)),
                                          child: MaterialButton(
                                            elevation: 0,
                                            hoverElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            textColor: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                            disabledTextColor: BuytimeTheme.SymbolGrey,
                                            color: BuytimeTheme.BackgroundWhite,
                                            //padding: EdgeInsets.all(15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '${AppLocalizations.of(context).continueShopping.split(' ').first}\n${AppLocalizations.of(context).continueShopping.split(' ').last}',
                                              style: TextStyle(
                                                  letterSpacing: 1.25,

                                                  ///SizeConfig.safeBlockHorizontal * .2
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                            ),
                                          )),

                                      ///Buy button
                                      Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                                          width: 158,

                                          /// media.width * .4
                                          height: 46,
                                          child: MaterialButton(
                                            key: Key('cart_buy_key'),
                                            elevation: 0,
                                            hoverElevation: 0,
                                            focusElevation: 0,
                                            highlightElevation: 0,
                                            onPressed: () {
                                              auth.User user = auth.FirebaseAuth.instance.currentUser;
                                              if (user == null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => TouristSessionRegister()),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ConfirmOrder(reserve: false, tourist: widget.tourist)),
                                                );
                                              }
                                            },
                                            textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                            color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                            //padding: EdgeInsets.all(media.width * 0.03),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context).buyUpper,
                                              style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextWhite, letterSpacing: 1.25),
                                            ),
                                          )),
                                    ],
                                  )
                                  /*Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 5),
                                        alignment: Alignment.center,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                              onTap: () {
                                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                Navigator.of(context).pop();
                                              },
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                              child: Container(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  AppLocalizations.of(context).continueShopping,
                                                  style: TextStyle(
                                                      letterSpacing: 1.25,

                                                      ///SizeConfig.safeBlockHorizontal * .2
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                ),
                                              )),
                                        )),*/
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ));
            }));
  }
}
