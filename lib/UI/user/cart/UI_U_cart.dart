/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/login/tourist_session/UI_U_tourist_session_register.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/order/w_optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/w_order_total.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';

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
    debugPrint('UI_U_cart => Remove Normal Item');
    setState(() {
      if (snapshot.itemList.length >= 1) {
        if(Provider.of<Explorer>(context, listen: false).businessState.id_firestore.isNotEmpty){
          ConventionHelper conventionHelper = ConventionHelper();
          Provider.of<Explorer>(context, listen: false).cartServiceList.forEach((s) {
            if(s.serviceId == entry.id)
              snapshot.totalPromoDiscount -= ((s.price * conventionHelper.getConventionDiscount(s, Provider.of<Explorer>(context, listen: false).businessState.id_firestore))/100) * entry.number;
          });
        }
        Provider.of<Explorer>(context, listen: false).cartServiceList.removeWhere((s) => s.serviceId == entry.id);
        orderState.cartCounter = orderState.cartCounter - entry.number;
        orderState.itemList.remove(entry);
        double serviceTotal = orderState.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        orderState.total = serviceTotal;
        //snapshot.removeItem(snapshot.itemList[index]);
        //snapshot.itemList.removeAt(index);
      } else {
        if(Provider.of<Explorer>(context, listen: false).businessState.id_firestore.isNotEmpty){
          ConventionHelper conventionHelper = ConventionHelper();
          Provider.of<Explorer>(context, listen: false).cartServiceList.forEach((s) {
            if(s.serviceId == entry.id)
              snapshot.totalPromoDiscount -= ((s.price * conventionHelper.getConventionDiscount(s, Provider.of<Explorer>(context, listen: false).businessState.id_firestore))/100) * entry.number;
          });
        }
        Provider.of<Explorer>(context, listen: false).cartServiceList.removeWhere((s) => s.serviceId == snapshot.itemList[index].id);
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
    debugPrint('UI_U_cart => Remove Normal Item');
    setState(() {
      orderState.cartCounter = orderState.cartCounter - entry.number;
      orderState.removeReserveItem(entry,context);
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
              debugPrint('UI_U_cart => AREA: ${store.state.business.area} - ${store.state.business.area.length}');
              if (!widget.tourist) {
                if (store.state.business.area?.isEmpty) {
                  debugPrint('UI_U_cart => AREA EMPTY');
                  _locationController.text = 'Reception';
                  store.state.order.location = 'Reception';
                } else {
                  debugPrint('UI_U_cart => AREA NOT EMPTY');
                  _locationController.text = store.state.business.area?.first;
                  store.state.order.location = store.state.business.area?.first;
                }
                debugPrint('UI_U_cart => AREA FRO MCONTROLLER: ${_locationController.text}');
              }
            },
            builder: (context, snapshot) {
              orderState = snapshot.order;
              if (orderState != null && orderState.itemList.isNotEmpty && orderState.itemList.first.id_business != snapshot.business.id_firestore) {
                debugPrint('UI_U_cart => ORDER BUSINESS ID: ${orderState.itemList.first.id_business} | BUSIENSS ID: ${snapshot.business.id_firestore}');
                isExternal = true;
              }



              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      brightness: Brightness.dark,
                      elevation: 1,
                      title: Text(
                        AppLocalizations.of(context).cart,
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextBlack,
                            fontWeight: FontWeight.w500,
                            fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
                        ),
                      ),
                      centerTitle: true,
                      leading: IconButton(
                        key: Key('back_from_cart_key'),
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                        ),
                        onPressed: () async{
                          if(Provider.of<Explorer>(context, listen: false).promotionCode.isNotEmpty){
                            StoreProvider.of<AppState>(context).dispatch(SetOrderTotalPromotionDiscount(0.0));
                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservableTotalPromotionDiscount(0.0));
                            Provider.of<Explorer>(context, listen: false).promotionCode = '';
                          }
                          //snapshot.order.totalPromoDiscount = 0.0;
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
                                    child: StoreConnector<AppState, OrderState>(
                                        converter: (store) => store.state.order,
                                        rebuildOnChange: true,
                                        builder: (context, snapshot) {
                                          orderState = snapshot;
                                          debugPrint("UI_U_cart => CART COUNT: ${orderState.itemList.length}");
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
                                                        debugPrint('UI_U_cart => LIST| ${orderState.itemList[index].name} ITEM COUNT: ${orderState.itemList[index].number}');
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
                                                              debugPrint('UI_U_cart => DX to DELETE');
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
                                              OrderTotal(/*totalECO: 0*/ media: media, orderState: orderState, promotion: false),

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
                                                            items: StoreProvider.of<AppState>(context).state.business.area.isNotEmpty
                                                                ? StoreProvider.of<AppState>(context).state.business.area.map(
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
                                                                            _locationController.text == val
                                                                                ? Icon(
                                                                                    Icons.radio_button_checked,
                                                                                    color: BuytimeTheme.SymbolGrey,
                                                                                  )
                                                                                : Icon(
                                                                                    Icons.radio_button_off,
                                                                                    color: BuytimeTheme.SymbolGrey,
                                                                                  ),
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
                                                                  )?.toList()
                                                                : [
                                                                    DropdownMenuItem<String>(
                                                                      value: 'Reception',
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Container(
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 10.0),
                                                                              child: Text(
                                                                                'Reception',
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  color: BuytimeTheme.TextMedium,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          _locationController.text == 'Reception'
                                                                              ? Icon(
                                                                                  Icons.radio_button_checked,
                                                                                  color: BuytimeTheme.SymbolGrey,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.radio_button_off,
                                                                                  color: BuytimeTheme.SymbolGrey,
                                                                                ),
                                                                          // Radio(
                                                                          //   toggleable: true,
                                                                          //   value: val,
                                                                          //   activeColor: BuytimeTheme.Secondary,
                                                                          //   groupValue: _locationController.text,
                                                                          //   onChanged: null,
                                                                          // )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _locationController.text = value;
                                                                orderState.location = value;
                                                                StoreProvider.of<AppState>(context).dispatch(UpdateOrder(orderState));
                                                              });
                                                            },
                                                            style: Theme.of(context).textTheme.headline1,
                                                          ),
                                                        ),
                                                      )

                                              )
                                                  : Container(),

                                              ///tableNumber TExt
                                              businessIsBar(context)
                                                  ? Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                      child: Text(
                                                        AppLocalizations.of(context).insertTableNumber,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, fontSize: 14),
                                                      ),
                                                    )
                                                  : Container(),
                                              ///Location
                                              businessIsBar(context)
                                                  ? Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Container(
                                                          width: 250.0,
                                                          height: 38,
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                          child: TextFormField(
                                                            key: Key('table_number_field_key'),
                                                            textAlign: TextAlign.start,
                                                            keyboardType: TextInputType.number,
                                                            onChanged: (value) {
                                                              snapshot.tableNumber = value;
                                                            },
                                                            decoration: InputDecoration(
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              labelText: AppLocalizations.of(context).table,
                                                              labelStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Color(0xff666666), fontWeight: FontWeight.w400, fontSize: 16),
                                                            ),
                                                            style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: Color(0xff666666),
                                                              fontWeight: FontWeight.w800,
                                                            ),
                                                          ),
                                              ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                        child: MaterialButton(
                                                          key: Key('close_table_number_field_key'),
                                                          height: 38.0,
                                                          elevation: 0,
                                                          hoverElevation: 0,
                                                          focusElevation: 0,
                                                          highlightElevation: 0,
                                                          onPressed: () {
                                                            FocusScope.of(context).unfocus();
                                                          },
                                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                                          color: BuytimeTheme.ActionBlackPurple,
                                                          //padding: EdgeInsets.all(media.width * 0.03),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: new BorderRadius.circular(20),
                                                          ),
                                                          child: Text(
                                                            AppLocalizations.of(context).ok,
                                                            style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextWhite, letterSpacing: 1.25),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
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
                                    ///Buy button
                                    Container(
                                        margin: EdgeInsets.only(top: 10, bottom: SizeConfig.safeBlockVertical * 0),
                                        width: 198,

                                        /// media.width * .4
                                        height: 46,
                                        child: MaterialButton(
                                          key: Key('cart_buy_key'),
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed:
                                          (orderState.tableNumber != null && orderState.tableNumber != '' && businessIsBar(context)) ||
                                              !businessIsBar(context)
                                              ?  () {
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
                                          } : null,
                                          textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                          disabledTextColor: BuytimeTheme.TextWhite,
                                          disabledColor: BuytimeTheme.SymbolGrey,
                                          color: BuytimeTheme.ActionBlackPurple,
                                          //padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            AppLocalizations.of(context).buy,
                                            style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextWhite, letterSpacing: 1.25),
                                          ),
                                        )),
                                    ///Continue Shopping
                                    Container(
                                        width: 198,

                                        ///SizeConfig.safeBlockHorizontal * 40
                                        height: 44,
                                        margin: EdgeInsets.only(top: 10, bottom: SizeConfig.safeBlockVertical * 2, right: SizeConfig.safeBlockHorizontal * 0),
                                        decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.circular(20),
                                            border: Border.all(color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user ? (BuytimeTheme.ActionBlackPurple) : BuytimeTheme.SymbolGrey)),
                                        child: MaterialButton(
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 0,
                                          highlightElevation: 0,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          textColor: BuytimeTheme.ActionBlackPurple,
                                          disabledTextColor: BuytimeTheme.SymbolGrey,
                                          color: BuytimeTheme.BackgroundWhite,
                                          //padding: EdgeInsets.all(15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            '${AppLocalizations.of(context).continueShopping.split(' ').first}\n${AppLocalizations.of(context).continueShopping.split(' ').last}',
                                            style: TextStyle(
                                                letterSpacing: 1.25,

                                                ///SizeConfig.safeBlockHorizontal * .2
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.ActionBlackPurple,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14

                                              ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

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
                    )),
              );
            }));
  }

  bool businessIsBar(BuildContext context) {
    bool result = false;
    debugPrint("UI_U_cart => businessIsBar ");
    if (StoreProvider.of<AppState>(context).state.business != null && StoreProvider.of<AppState>(context).state.business.business_type == "Bar") {
      result =  true;
    }
    if (StoreProvider.of<AppState>(context).state.businessList != null && StoreProvider.of<AppState>(context).state.order.itemList != null) {
      BusinessListState businessListState = StoreProvider.of<AppState>(context).state.businessList;
      businessListState.businessListState.forEach((business) {
        if (
            StoreProvider.of<AppState>(context).state.order.itemList.isNotEmpty &&
            business.id_firestore == StoreProvider.of<AppState>(context).state.order.itemList.first.id_business &&
            business.business_type == "Bar"
        ) {
          result = true;
        }
      });
    }
    return result;
  }
}
