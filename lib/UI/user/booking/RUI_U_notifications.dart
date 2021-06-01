import 'package:Buytime/UI/user/booking/widget/user_notification_list_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    //notifications = [];
    SizeConfig().init(context);
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
              appBar: BuytimeAppbar(
                background: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                width: media.width,
                children: [
                  ///Back Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          tooltip: AppLocalizations.of(context).comeBack,
                          onPressed: () {
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration.zero, () {

                              //Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });

                            //StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                          },
                        ),
                      ),
                    ],
                  ),
                  ///Title
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        AppLocalizations.of(context).notifications,
                        textAlign: TextAlign.start,
                        style: BuytimeTheme.appbarTitle,
                      ),
                    ),
                  ),
                  ///Cart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  BuytimeIcons.shopping_cart,
                                  color: BuytimeTheme.TextWhite,
                                  size: 24.0,
                                ),
                                onPressed: () {
                                  if (order.cartCounter > 0) {
                                    // dispatch the order
                                    StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                    // go to the cart page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Cart(tourist: widget.tourist,)),
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
                                        )
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          order.cartCounter > 0
                              ? Positioned.fill(
                            top: 5,
                            left: 2.5,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '${order.cartCounter}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                              debugPrint('RUI_U_notifications => NOTIFICATION ID: $idNotification');
                              NotificationState notificationState = NotificationState.fromJson(notificationSnapshot.data.docs[j].data());
                              notificationState.notificationId = idNotification;
                              notifications.add(notificationState);
                            }
                            /*if(notifications.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(notifications.isNotEmpty && notifications.first.userId.isEmpty)
            notifications.removeLast();

          if(notifications.isNotEmpty){
            notifications.forEach((element) {
              debugPrint('UI_U_notifications => ${element.timestamp}');
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
                                                  debugPrint('UI_U_notifications => fine scroll 90%');
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
                                                    //     debugPrint('UI_U_notification => ${element.orderId}');
                                                    //     orderState = element;
                                                    //   }
                                                    // });
                                                    // snapshot.serviceList.serviceListState.forEach((element) {
                                                    //   if(notification.data.state != null && element.serviceId == notification.data.state.serviceId){
                                                    //     //debugPrint('UI_U_notification => ${element.orderId}');
                                                    //     serviceState = element;
                                                    //   }
                                                    // });
                                                    // if (orderState != null) {
                                                    return UserNotificationListItem(notification, serviceState, widget.tourist);
                                                    // }
                                                    return Container();

                                                    //debugPrint('booking_month_list: bookings booking status: ${booking.user.first.surname} ${booking.status}');
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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