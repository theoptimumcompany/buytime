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

import 'package:Buytime/UI/management/notification/widget/manager_notification_list_item.dart';
import 'package:Buytime/UI/user/booking/widget/user_notification_list_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RNotificationCenter extends StatefulWidget {
  static String route = '/notifications';
  RNotificationCenter({Key key, }) : super(key: key);

  @override
  _RNotificationCenterState createState() => _RNotificationCenterState();
}

class _RNotificationCenterState extends State<RNotificationCenter> {

  bool sameMonth = false;
  String searched = '';
  OrderState order = OrderState().toEmpty();
  Stream<QuerySnapshot> _orderNotificationStream;
  String userId;
  bool showAll = false;
  List<NotificationState> notifications = [];
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
  }

  String _selected = '';
  bool isManagerOrAbove = false;
  //bool startRequest = false;
  bool noActivity = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    //notifications = [];
    SizeConfig().init(context);
    userId = StoreProvider.of<AppState>(context).state.user.uid;
    order = StoreProvider.of<AppState>(context).state.order;
    if(userId != null && userId.isNotEmpty) {
      if (notifications.isEmpty) {
        debugPrint('RUI_M_notification_center => ASKING FOR NOTIFICATIONS');
        /// first list
        _orderNotificationStream = FirebaseFirestore.instance.collection('notification')
            .where("userId", isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(20)
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
              key: _drawerKey,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.dark,
                elevation: 1,
                title: Text(
                  AppLocalizations.of(context).notificationCenter,
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  key: Key('business_drawer_key'),
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.black,
                    //size: 30.0,
                  ),
                  tooltip: AppLocalizations.of(context).openMenu,
                  onPressed: () {
                    _drawerKey.currentState.openDrawer();
                  },
                ),
              ),
              drawer: ManagerDrawer(),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                        width: double.infinity,
                        //color: BuytimeTheme.DividerGrey,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: _orderNotificationStream,
                          builder: (context, AsyncSnapshot<QuerySnapshot> notificationSnapshot) {
                            notifications.clear();
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
                              return CircularProgressIndicator();
                            }

                            for (int j = 0; j < notificationSnapshot.data.docs.length; j++) {
                              String idNotification = notificationSnapshot.data.docs[j].id;
                              debugPrint('RUI_M_notification_center => NOTIFICATION ID: $idNotification');
                              NotificationState notificationState = NotificationState.fromJson(notificationSnapshot.data.docs[j].data());
                              notificationState.notificationId = idNotification;
                              debugPrint('RUI_M_notification_center => SERVICE NAME: ${notificationState.serviceName}');
                              notifications.add(notificationState);
                            }

                            notifications.sort((b,a) => a.timestamp.compareTo(b.timestamp));
                            /*if(notifications.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(notifications.isNotEmpty && notifications.first.userId.isEmpty)
            notifications.removeLast();

          if(notifications.isNotEmpty){
            notifications.forEach((element) {
              debugPrint('RUI_M_notification_center => ${element.timestamp}');
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
                                notifications.isNotEmpty ?
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
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
                                                  debugPrint('RUI_M_notification_center => fine scroll 90%');
                                                }
                                              }),
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            slivers: [
                                              SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                      (context, index) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                    NotificationState notification = notifications.elementAt(index);
                                                    //StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                                                    //StoreProvider.of<AppState>(context).dispatch(ServiceRequestByID(notification.data.state.serviceId));
                                                    ServiceState serviceState = ServiceState().toEmpty();
                                                    StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
                                                      if(service.serviceId == notification.data.state.serviceId)
                                                        serviceState = service;
                                                    });
                                                    // widget.orderStateList.forEach((element) {
                                                    //   if(notification.data.state != null && element.orderId == notification.data.state.orderId){
                                                    //     debugPrint('RUI_M_notification_center => ${element.orderId}');
                                                    //     orderState = element;
                                                    //   }
                                                    // });
                                                    // snapshot.serviceList.serviceListState.forEach((element) {
                                                    //   if(notification.data.state != null && element.serviceId == notification.data.state.serviceId){
                                                    //     //debugPrint('RUI_M_notification_center => ${element.orderId}');
                                                    //     serviceState = element;
                                                    //   }
                                                    // });
                                                    // if (orderState != null) {
                                                    return ManagerNotificationListItem(notification, serviceState);
                                                    // }
                                                    return Container();

                                                    //debugPrint('RUI_M_notification_center => booking_month_list: bookings booking status: ${booking.user.first.surname} ${booking.status}');
                                                  },
                                                  childCount: notifications.length,
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