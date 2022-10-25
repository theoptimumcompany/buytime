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

import 'package:Buytime/UI/user/booking/widget/user_broadcast_list_item.dart';
import 'package:Buytime/UI/user/booking/widget/user_notification_list_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
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
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class RNotifications extends StatefulWidget {
  static String route = '/notifications';
  bool fromConfirm;
  List<OrderState> orderStateList;
  bool tourist;
  RNotifications({Key key, this.fromConfirm, this.orderStateList, this.tourist}) : super(key: key);

  @override
  _RNotificationsState createState() => _RNotificationsState();
}

class _RNotificationsState extends State<RNotifications> {

  bool sameMonth = false;
  String searched = '';
  OrderState order = OrderState().toEmpty();
  Stream<QuerySnapshot> _orderNotificationStream;
  Stream<QuerySnapshot> _broadcastUserStream;
  Stream<QuerySnapshot> _broadcastBusinessStream;
  Stream<QuerySnapshot> _broadcastAreaStream;
  String userId;
  bool showAll = false;
  List<NotificationState> notifications = [];
  List<BroadcastState> broadcastList = [];
  List<dynamic> combined = [];
  bool startRequest = false;
  bool rippleLoading = false;
  ScrollController _scrollController;


  //NotificationState tmpNotification1 = NotificationState(serviceName: 'Test I', serviceState: 'canceled');
  //NotificationState tmpNotification2 = NotificationState(serviceName: 'Test II', serviceState: 'accepted');

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    //notifications.add(tmpNotification1);
    //notifications.add(tmpNotification2);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });

  }

  String _selected = '';
  bool isManagerOrAbove = false;
  //bool startRequest = false;
  bool noActivity = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    //notifications = [];
    SizeConfig().init(context);
    _broadcastUserStream = FirebaseFirestore.instance
        .collection("broadcast")
        .where("topic", isEqualTo: 'broadcast_user')
        /*.where("topic", isEqualTo: 'broadcast_${Provider.of<Explorer>(context, listen: false).businessState.id_firestore}')
        .where("topic", isEqualTo: 'broadcast_${StoreProvider.of<AppState>(context).state.area.areaId}')*/
    //.limit(limit)
        .snapshots(includeMetadataChanges: true);
        debugPrint("RUI_U_notifications: id del business nello stato" + Provider.of<Explorer>(context, listen: false).businessState.id_firestore);
    _broadcastBusinessStream = FirebaseFirestore.instance
        .collection("broadcast")
        .where("topic", isEqualTo: 'broadcast_${Provider.of<Explorer>(context, listen: false).businessState.id_firestore}')
    //.limit(limit)
        .snapshots(includeMetadataChanges: true);
    _broadcastAreaStream = FirebaseFirestore.instance
        .collection("broadcast")
        .where("topic", isEqualTo: 'broadcast_${StoreProvider.of<AppState>(context).state.area.areaId}')
    //.limit(limit)
        .snapshots(includeMetadataChanges: true);
    userId = StoreProvider.of<AppState>(context).state.user.uid;
    order = StoreProvider.of<AppState>(context).state.order;
    if(userId != null && userId.isNotEmpty) {
      if (notifications.isEmpty) {
        debugPrint('RUI_U_notifications => ASKING FOR NOTIFICATIONS');
        /// first list
        _orderNotificationStream = FirebaseFirestore.instance.collection('notification')
            .where("userId", isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(10)
            .snapshots();
      }
      // else {
      //
      //   _orderNotificationStream = FirebaseFirestore.instance.collection('notification')
      //       .where("userId", isEqualTo: userId)
      //       .orderBy('timestamp', descending: true)
      //       .startAfter()
      //       .limit(10)
      //       .snapshots();
      // }
    }

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
                          AppLocalizations.of(context).notifications,
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
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                        width: double.infinity,
                        //color: BuytimeTheme.DividerGrey,
                        child: StreamBuilder<List<QuerySnapshot>>(
                          stream: CombineLatestStream.list([_broadcastUserStream, _broadcastBusinessStream, _broadcastAreaStream, _orderNotificationStream]),
                          builder: (context, AsyncSnapshot<List<QuerySnapshot>> notificationSnapshot) {
                            notifications.clear();
                            broadcastList.clear();
                            combined.clear();
                            if (notificationSnapshot.hasError) {
                              return  Container(
                                height: SizeConfig.safeBlockVertical * 8,
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of(context).noNotificationFound,
                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                    )
                                ),
                              );
                            }
                            if (notificationSnapshot.connectionState == ConnectionState.waiting) {
                              return Column(
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
                            for (int j = 0; j < notificationSnapshot.data[0].docs.length; j++) {
                              String idNotification = notificationSnapshot.data[0].docs[j].id;
                              //debugPrint('RUI_U_notifications => NOTIFICATION ID: $idNotification');
                              BroadcastState broadcastState = BroadcastState.fromJson(notificationSnapshot.data[0].docs[j].data());
                              broadcastList.add(broadcastState);
                            }
                            for (int j = 0; j < notificationSnapshot.data[1].docs.length; j++) {
                              String idNotification = notificationSnapshot.data[1].docs[j].id;
                              //debugPrint('RUI_U_notifications => NOTIFICATION ID: $idNotification');
                              BroadcastState broadcastState = BroadcastState.fromJson(notificationSnapshot.data[1].docs[j].data());
                              broadcastList.add(broadcastState);
                            }
                            for (int j = 0; j < notificationSnapshot.data[2].docs.length; j++) {
                              String idNotification = notificationSnapshot.data[2].docs[j].id;
                              //debugPrint('RUI_U_notifications => NOTIFICATION ID: $idNotification');
                              BroadcastState broadcastState = BroadcastState.fromJson(notificationSnapshot.data[2].docs[j].data());
                              broadcastList.add(broadcastState);
                            }
                            for (int j = 0; j < notificationSnapshot.data[3].docs.length; j++) {
                              String idNotification = notificationSnapshot.data[3].docs[j].id;
                              debugPrint('RUI_U_notifications => NOTIFICATION ID: $idNotification');
                              NotificationState notificationState = NotificationState.fromJson(notificationSnapshot.data[3].docs[j].data());
                              notificationState.notificationId = idNotification;
                              notifications.add(notificationState);
                            }

                            combined.addAll(broadcastList);
                            combined.addAll(notifications);

                            debugPrint('RUI_U_notifications => BROADCAST LIST LENGTH: ${broadcastList.length}');
                            broadcastList.sort((b,a) => a.timestamp.millisecondsSinceEpoch.compareTo(b.timestamp.millisecondsSinceEpoch));
                            notifications.sort((b,a) => a.timestamp.compareTo(b.timestamp));
                            combined.sort((b,a) => (a is BroadcastState) ?
                              a.timestamp.millisecondsSinceEpoch.compareTo((b is BroadcastState) ? b.timestamp.millisecondsSinceEpoch : b.timestamp) :
                            a.timestamp.compareTo((b is BroadcastState) ? b.timestamp.millisecondsSinceEpoch : b.timestamp));
                            /*if(notifications.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(notifications.isNotEmpty && notifications.first.userId.isEmpty)
            notifications.removeLast();

          if(notifications.isNotEmpty){
            notifications.forEach((element) {
              debugPrint('RUI_U_notifications => ${element.timestamp}');
            });
            //notifications.sort((b,a) => a.timestamp != null ? a.timestamp : 0 .compareTo(b.timestamp != null ? b.timestamp : 0));
            notifications.sort((b,a) => a.timestamp.compareTo(b.timestamp));
          }
          noActivity = false;
          startRequest = false;
        }*/


                            return  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///RNotifications
                                combined.isNotEmpty ?
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomScrollView(
                                            controller: _scrollController
                                              ..addListener(() {
                                                var triggerFetchMoreSize =
                                                    0.9 * _scrollController.position.maxScrollExtent;
                                                if (_scrollController.position.pixels >
                                                    triggerFetchMoreSize) {
                                                  /// qui triggera evento di fine scroll
                                                  debugPrint('RUI_U_notifications => fine scroll 90%');
                                                }
                                              }),
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            slivers: [
                                              SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                      (context, index) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                        if(combined.elementAt(index) is BroadcastState){
                                                          BroadcastState broadcastState = combined.elementAt(index);
                                                          return UserBroadcastListItem(broadcastState);
                                                        }else{
                                                          NotificationState notification = combined.elementAt(index);
                                                          //StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                                                          //StoreProvider.of<AppState>(context).dispatch(ServiceRequestByID(notification.data.state.serviceId));
                                                          ServiceState serviceState = ServiceState().toEmpty();
                                                          OrderState orderState = OrderState().toEmpty();
                                                          StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
                                                            if(service.serviceId == notification.data.state.serviceId)
                                                              serviceState = service;
                                                          });
                                                          debugPrint('RUI_U_notification => OUT: ${notification.data.state.orderId}');
                                                          widget.orderStateList.forEach((element) {
                                                            if(notification.data.state != null && element.orderId == notification.data.state.orderId){
                                                              debugPrint('RUI_U_notification => IN: ${element.orderId}');
                                                              orderState = element;
                                                            }
                                                          });
                                                          // snapshot.serviceList.serviceListState.forEach((element) {
                                                          //   if(notification.data.state != null && element.serviceId == notification.data.state.serviceId){
                                                          //     //debugPrint('RUI_U_notifications => ${element.orderId}');
                                                          //     serviceState = element;
                                                          //   }
                                                          // });
                                                          // if (orderState != null) {
                                                          return UserNotificationListItem(notification, serviceState, widget.tourist, orderState);
                                                          // }
                                                          return Container();

                                                          //debugPrint('RUI_U_notifications => booking_month_list: bookings booking status: ${booking.user.first.surname} ${booking.status}');
                                                        }

                                                  },
                                                  childCount: combined.length,
                                                ),
                                              ),
                                            ])
                                      ],
                                    ),
                                  ),
                                ) :
                                Container(
                                  height: SizeConfig.safeBlockVertical * 8,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                      child: Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          AppLocalizations.of(context).noNotificationFound,
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                  ),
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