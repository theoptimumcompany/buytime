import 'package:Buytime/UI/user/booking/widget/user_notification_list_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Notifications extends StatefulWidget {
  static String route = '/notifications';
  bool fromConfirm;
  List<OrderState> orderStateList;
  bool tourist;
  Notifications({Key key, this.fromConfirm, this.orderStateList, this.tourist}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  bool sameMonth = false;
  String searched = '';
  OrderState order = OrderState().toEmpty();

  bool showAll = false;

  bool startRequest = false;
  bool rippleLoading = false;


  //NotificationState tmpNotification1 = NotificationState(serviceName: 'Test I', serviceState: 'canceled');
  //NotificationState tmpNotification2 = NotificationState(serviceName: 'Test II', serviceState: 'accepted');

  @override
  void initState() {
    super.initState();
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
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
          startRequest = true;
      },
      builder: (context, snapshot) {
        List<NotificationState> notifications = snapshot.notificationListState.notificationListState;
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

        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_BookingPage => CART COUNT: ${order.cartCounter}');

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
                                    key: Key('cart_key'),
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Notifications
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

                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            slivers: [
                                              SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                      (context, index) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      NotificationState notification = notifications.elementAt(index);
                                                      OrderState orderState;
                                                      ServiceState serviceState = ServiceState().toEmpty();
                                                      widget.orderStateList.forEach((element) {
                                                        if(notification.data.state != null && element.orderId == notification.data.state.orderId){
                                                          debugPrint('UI_U_notification => ${element.orderId}');
                                                          orderState = element;
                                                        }
                                                      });
                                                      snapshot.serviceList.serviceListState.forEach((element) {
                                                        if(notification.data.state != null && element.serviceId == notification.data.state.serviceId){
                                                          //debugPrint('UI_U_notification => ${element.orderId}');
                                                          serviceState = element;
                                                        }
                                                      });
                                                      if (orderState != null) {
                                                        return UserNotificationListItem(notification, serviceState, widget.tourist, orderState);
                                                      }
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
                                ) : Container(
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
                                      )),
                                ),
                              ],
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
      },
    );
  }
}