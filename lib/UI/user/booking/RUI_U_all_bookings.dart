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

import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/booking/widget/user_service_list_item.dart';
import 'package:provider/provider.dart';

class RAllBookings extends StatefulWidget {
  static String route = '/bookingPage';
  bool fromConfirm;
  bool tourist;
  RAllBookings({Key key, this.fromConfirm, this.tourist}) : super(key: key);

  @override
  _RAllBookingsState createState() => _RAllBookingsState();
}

class _RAllBookingsState extends State<RAllBookings> {
  TextEditingController _searchController = TextEditingController();

  BookingState bookingState;
  BusinessState businessState;
  ServiceListState serviceListState;
  List<ServiceState> serviceList = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];
  List<OrderState> orderList = [];

  bool sameMonth = false;
  String searched = '';
  OrderState order = OrderState().toEmpty();

  bool showAll = false;

  bool startRequest = false;
  bool rippleLoading = false;

  List<OrderState> orderStateList = [];

  @override
  void initState() {
    super.initState();
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  String _selected = '';
  bool isManagerOrAbove = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    order = StoreProvider.of<AppState>(context).state.order.itemList != null ? (StoreProvider.of<AppState>(context).state.order.itemList.length > 0 ? StoreProvider.of<AppState>(context).state.order : OrderState().toEmpty()) : OrderState().toEmpty();
    //debugPrint('RUI_U_all_bookings => CART COUNT: ${order.cartCounter}');
    DateTime currentTime = DateTime.now();
    Stream<QuerySnapshot> _orderStream;
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    if(!widget.tourist){
      _orderStream =  FirebaseFirestore.instance
          .collection("order")
          .where("businessId", isEqualTo: StoreProvider.of<AppState>(context).state.business.id_firestore)
          .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
          .where("date", isGreaterThanOrEqualTo: currentTime)
          .limit(50)
          .snapshots(includeMetadataChanges: true);
    }else
      _orderStream =  FirebaseFirestore.instance
          .collection("order")
          //.where("businessId", isEqualTo: StoreProvider.of<AppState>(context).state.business.id_firestore)
          .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
          .where("date", isGreaterThanOrEqualTo: currentTime)
          .limit(50)
          .snapshots(includeMetadataChanges: true);
    return Stack(children: [
      Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    key: Key('action_button_discover'),
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    tooltip: AppLocalizations.of(context).comeBack,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                centerTitle: true,
                title: Container(
                  width: SizeConfig.safeBlockHorizontal * 60,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context).allBookings,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              //letterSpacing: 0.15,
                              color: BuytimeTheme.TextBlack
                          ),
                        ),
                      )),
                ),
                actions: [
                  Container(
                    width: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///Cart
                        Flexible(
                            child: Container(
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 0),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        key: Key('cart_key'),
                                        icon: Icon(
                                          BuytimeIcons.shopping_cart,
                                          color: BuytimeTheme.TextBlack,
                                          size: 19.0,
                                        ),
                                        onPressed: () {
                                          debugPrint("RUI_U_service_explorer => + cart_discover");
                                          FirebaseAnalytics().logEvent(
                                              name: 'cart_discover',
                                              parameters: {
                                                'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                                'date': DateTime.now().toString(),
                                              });
                                          if (order.cartCounter > 0) {
                                            // dispatch the order
                                            StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                            // go to the cart page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Cart(
                                                    tourist: true,
                                                  )),
                                            );
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                  title: new Text(AppLocalizations.of(context).warning),
                                                  content: new Text(AppLocalizations.of(context).emptyCart),
                                                  actions: <Widget>[
                                                    MaterialButton(
                                                      elevation: 0,
                                                      hoverElevation: 0,
                                                      focusElevation: 0,
                                                      highlightElevation: 0,
                                                      child: Text(AppLocalizations.of(context).ok),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    )
                                                  ],
                                                ));
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  order.cartCounter > 0
                                      ? Positioned.fill(
                                    bottom: 20,
                                    left: 3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${order.cartCounter}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                ],
                elevation: 1,
              ),
              body: SafeArea(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _orderStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                      orderStateList.clear();
                      if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator()
                              ],
                            )
                          ],
                        );
                      }
                      orderSnapshot.data.docs.forEach((element) {
                        orderStateList.add(OrderState.fromJson(element.data()));
                      });
                      return CustomScrollView(shrinkWrap: true, slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            int ind;
                            OrderState order = orderStateList.elementAt(index);
                            for (int i = 0; i < orderStateList.length; i++) {
                              if (orderStateList[i].orderId == order.orderId) ind = i;
                            }
                            //debugPrint('RUI_U_all_bookings => CART COUNT: ${order.date}');
                            ServiceState service = ServiceState().toEmpty();
                            StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.forEach((element) {
                              if(element.notificationId != null && element.notificationId.isNotEmpty && order.orderId.isNotEmpty && order.orderId == element.data.state.orderId){
                                Provider.of<Explorer>(context, listen: false).serviceList.forEach((s) {
                                  if(element.data.state.serviceId == s.serviceId)
                                    service = s;
                                });
                              }
                            });

                            order.itemList.forEach((element) {
                              Provider.of<Explorer>(context, listen: false).serviceList.forEach((s) {
                                if(element.id == s.serviceId)
                                  service = s;
                              });
                            });
                            return Column(
                              children: [
                                UserServiceListItem(order, widget.tourist, service),
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                  height: SizeConfig.safeBlockVertical * .2,
                                  color: BuytimeTheme.DividerGrey,
                                )
                              ],
                            );
                          },
                            childCount: orderStateList.length,
                          ),
                        )
                      ]);
                    }
                ),
              ),
            ),
          ),
        ),
      ),
      ///Ripple Effect
      rippleLoading
          ? Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
              height: double.infinity,
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
      )
          : Container(),
    ]);
  }
}