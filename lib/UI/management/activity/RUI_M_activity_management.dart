import 'dart:ui';

import 'package:Buytime/UI/management/activity/widget/W_cancel_popup.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/reusable/sliverAppBarDelegate.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';

class RActivityManagement extends StatefulWidget {
  static String route = '/RActivityManagement';

  ManagerModel manager;
  ServiceModel service;

  RActivityManagement({Key key, this.service, this.manager}) : super(key: key);

  @override
  _RActivityManagementState createState() => _RActivityManagementState();
}

class _CardHeader extends StatelessWidget {
  final String title;

  static const double topInset = 24;

  const _CardHeader({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.only(top: topInset),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RActivityManagementState extends State<RActivityManagement> {
  List<BookingState> bookingList = [];
  bool seeAll = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<List> pendingList = [];
  List<List> acceptedList = [];
  List<List> canceledList = [];
  List<List> orderList = [];
  List<List<List>> weekOrderList = [];
  List<List<List>> allOrderList = [];

  Map<DateTime, List<List>> orderMap = new Map();
  Map<DateTime, List<List<List>>> allMap = new Map();

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
  }

  bool startRequest = false;
  bool noActivity = false;


  void listUp(OrderState element, DateTime currentTime, DateTime sevenDaysFromNow, DateTime orderTime, List<List> list){
    //orderMap.putIfAbsent(DateFormat('dd MM yyyy').format(orderTime), () => []);
    orderMap.putIfAbsent(orderTime, () => []);
    if(element.selected != null && element.selected.isNotEmpty){
      element.itemList.forEach((entry) {
        DateTime orderEntryTime = entry.date;
        orderEntryTime = new DateTime(orderEntryTime.year, orderEntryTime.month, orderEntryTime.day, 0, 0, 0, 0, 0);
        if(seeAll){
          list.add([element, entry]);
        }else{
          if(orderTime.isAtSameMomentAs(currentTime) || (orderTime.isAfter(currentTime) && orderTime.isBefore(sevenDaysFromNow)) )
            list.add([element, entry]);
        }
      });
    }else{
      if(seeAll){
        list.add([element, null]);
      }else{
        if(orderTime.isAtSameMomentAs(currentTime) || (orderTime.isAfter(currentTime) && orderTime.isBefore(sevenDaysFromNow)) )
          list.add([element, null]);
      }
      //list.add([element, null]);
    }
  }

  List<Widget> _list(DateTime key, List<List<List>> list) {

    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();

    List<Widget> widgetList = [];
    widgetList..add(
        SliverPinnedHeader(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
                color: Color(0xff003B5F),
                border: Border(
                    top: BorderSide(
                        color: BuytimeTheme.BackgroundWhite
                    )
                )
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
            child: Text(
                '${DateFormat('MMM yyyy').format(key).toUpperCase()}',
                style: TextStyle(
                  letterSpacing: 1.25,
                  fontFamily: BuytimeTheme.FontFamily,
                  color: BuytimeTheme.TextWhite,
                  fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                  fontWeight: FontWeight.w500,
                )
            ),
          ),
        )
    );
    for(int i = 0; i < list.length; i++){
      if(list[i].isNotEmpty){
        DateTime orderTime = list[i][0][0].date;
        orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0).toUtc();
        widgetList..add(
          SliverClip(
            child: MultiSliver(
              pushPinnedChildren: true,
              children: [
                SliverStack(
                    insetOnOverlap: true,
                    children: [
                      MultiSliver(
                        children: [
                          SliverPinnedHeader(
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                  color: BuytimeTheme.ManagerPrimary,
                                  border: Border(
                                      top: BorderSide(
                                          color: BuytimeTheme.BackgroundWhite
                                      )
                                  )
                              ),
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                              child: Text(
                                  orderTime.isAtSameMomentAs(currentTime) ? '${AppLocalizations.of(context).today} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(orderTime).toUpperCase()}' :
                                  orderTime.isAtSameMomentAs(currentTime.add(Duration(days: 1))) ? '${AppLocalizations.of(context).tomorrow} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(orderTime).toUpperCase()}' :
                                  '${DateFormat('MMM dd').format(orderTime).toUpperCase()}',
                                  style: TextStyle(
                                    letterSpacing: 1.25,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextWhite,
                                    fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                                    fontWeight: FontWeight.w500,
                                  )
                              ),
                            ),
                          ),
                          SliverClip(
                            child: MultiSliver(
                              children: <Widget>[
                                SliverAnimatedPaintExtent(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  child: SliverList(
                                    delegate: SliverChildBuilderDelegate((context, index) {
                                      //debugPrint('UI_M_activity_management => LIST SIZE: ${list[i].length}');
                                      OrderState order = list[i].elementAt(index)[0];
                                      OrderEntry entry = list[i].elementAt(index)[1];
                                      /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
                                      /// or the entry?
                                      bool managerHasChosenAction = false;
                                      return Container(
                                        alignment: Alignment.center,
                                        //color: Colors.lightBlue[100 * (index % 9)],
                                        child: Column(
                                          children: [
                                            ///Order Info
                                            DashboardListItem(order, entry),
                                            ///Actions
                                            buildActivityButtons(order, context, managerHasChosenAction),
                                            ///Divider
                                            Container(
                                              //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                              height: 2,
                                              color: BuytimeTheme.DividerGrey,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                      childCount: list[i].length,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ]
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgetList;
  }

  List<Widget> orderHistory(Map<DateTime, List<List<List>>> list){
    List<Widget> widgetList = [];
    list.forEach((key, value) {
      widgetList.add(
          MultiSliver(
            pushPinnedChildren: true,
            children: [
              SliverStack(
                insetOnOverlap: true,
                children: [
                  SliverPositioned.fill(
                    top: 0,
                    child: Container(),
                  ),
                  MultiSliver(
                    children: _list(key, value),
                  ),
                ],
              ),
            ],
          ));
    });

    return widgetList;
  }

  List<Widget> _sliverList(Map<DateTime, List<List<List>>> list) {
    List<Widget> widgetList = [];
    list.forEach((key, value) {
      widgetList
        ..add(
            SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: CustomSliverAppBarDelegate(minHeight: 24, maxHeight: 24, child:
                Container(
                  decoration: BoxDecoration(
                      color: BuytimeTheme.ManagerPrimary,
                      border: Border(
                          top: BorderSide(
                              color: BuytimeTheme.BackgroundWhite
                          )
                      )
                  ),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                  child: Text(
                      '${DateFormat('MMM yyyy').format(key)}',
                      style: TextStyle(
                        letterSpacing: 1.25,
                        fontFamily: BuytimeTheme.FontFamily,
                        color: BuytimeTheme.TextWhite,
                        fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                        fontWeight: FontWeight.w500,
                      )
                  ),
                )
                )))
        ..add(SliverList(
          //itemExtent: 50.0,
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            debugPrint('UI_M_activity_management => LIST SIZE: ${value[index].length}');
            /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
            /// or the entry?
            bool managerHasChosenAction = false;
            if(value[index].isNotEmpty){
              return CustomScrollView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: CustomSliverAppBarDelegate(minHeight: 24, maxHeight: 24, child:
                      Container(
                        decoration: BoxDecoration(
                            color: BuytimeTheme.ManagerPrimary.withOpacity(0.5),
                            border: Border(
                                top: BorderSide(
                                    color: BuytimeTheme.BackgroundWhite
                                )
                            )
                        ),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                        child: Text(
                            index == 0 ? '${AppLocalizations.of(context).today} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(value[index][0][0].date).toUpperCase()}' :
                            index == 1 ? '${AppLocalizations.of(context).tomorrow} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(value[index][0][0].date).toUpperCase()}' :
                            '${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(value[index][0][0].date).toUpperCase()}',
                            style: TextStyle(
                              letterSpacing: 1.25,
                              fontFamily: BuytimeTheme.FontFamily,
                              color: BuytimeTheme.TextWhite,
                              fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                              fontWeight: FontWeight.w500,
                            )
                        ),
                      )
                      )),
                  SliverList(
                    //itemExtent: 50.0,
                    delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index2) {
                      //debugPrint('UI_M_activity_management => LIST SIZE: ${list[i].length}');
                      OrderState order = value[index].elementAt(index2)[0];
                      OrderEntry entry = value[index].elementAt(index2)[1];
                      /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
                      /// or the entry?
                      bool managerHasChosenAction = false;
                      return Container(
                        alignment: Alignment.center,
                        //color: Colors.lightBlue[100 * (index % 9)],
                        child: Column(
                          children: [
                            ///Order Info
                            DashboardListItem(order, entry),
                            ///Actions
                            buildActivityButtons(order, context, managerHasChosenAction),
                            ///Divider
                            Container(
                              //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                              height: 2,
                              color: BuytimeTheme.DividerGrey,
                            )
                          ],
                        ),
                      );
                    }, childCount: value[index].length),
                  )
                ],
              );
            }else
              return Container();
          }, childCount: value.length),
        ));
    });


    return widgetList;
  }

  List<Widget> _weekSliverList(List<List<List>> list) {
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    List<Widget> widgetList = [];
    for (int i = 0; i < list.length; i++){
      if(list[i] != null && list[i].isNotEmpty){
        DateTime orderTime = list[i][0][0].date;
        orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0).toUtc();
        widgetList
          ..add(
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: CustomSliverAppBarDelegate(minHeight: 24, maxHeight: 24, child:
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                        color: BuytimeTheme.ManagerPrimary,
                        border: Border(
                            top: BorderSide(
                                color: BuytimeTheme.BackgroundWhite
                            )
                        )
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                    child: Text(
                        orderTime.isAtSameMomentAs(currentTime) ? '${AppLocalizations.of(context).today} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(orderTime).toUpperCase()}' :
                        orderTime.isAtSameMomentAs(currentTime.add(Duration(days: 1))) ? '${AppLocalizations.of(context).tomorrow} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(orderTime).toUpperCase()}' :
                        '${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(orderTime).toUpperCase()}',
                        style: TextStyle(
                          letterSpacing: 1.25,
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextWhite,
                          fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                          fontWeight: FontWeight.w500,
                        )
                    ),
                  )
                  )))
          ..add(SliverList(
            //itemExtent: 50.0,
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              debugPrint('UI_M_activity_management => LIST SIZE: ${list[i].length}');
              OrderState order = list[i].elementAt(index)[0];
              OrderEntry entry = list[i].elementAt(index)[1];
              /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
              /// or the entry?
              bool managerHasChosenAction = false;
              return Container(
                alignment: Alignment.center,
                //color: Colors.lightBlue[100 * (index % 9)],
                child: Column(
                  children: [
                    ///Order Info
                    DashboardListItem(order, entry),
                    ///Actions
                    buildActivityButtons(order, context, managerHasChosenAction),
                    ///Divider
                    Container(
                      //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                      height: 2,
                      color: BuytimeTheme.DividerGrey,
                    )
                  ],
                ),
              );
            }, childCount: list[i].length),
          ));
      }
    }


    return widgetList;
  }

  Container buildActivityButtons(OrderState order, BuildContext context, bool managerHasChosenAction) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ///Re-Open: the order was declined in a first moment but now, before it is canceled, the worker/manager wants to evaluate again.
          order.progress == Utils.enumToString(OrderStatus.declined) ?
          Container(
              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (!managerHasChosenAction) {
                        // order.progress = Utils.enumToString(OrderStatus.pending);
                        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(order, OrderStatus.pending));
                        managerHasChosenAction = true;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text(AppLocalizations.of(context).networkRequestStillInProgress)));
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context).reOpen.toUpperCase(),
                        style:  TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextMalibu,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ///SizeConfig.safeBlockHorizontal * 4
                        ),
                      ),
                    )),
              )) : Container(),
          /// Accept: the worker/manager thinks that he can provide the order, so he accepts it.
          /// A notification to the customer is sent, but the rest of the process depends on the payment method and the order type.
          order.progress == Utils.enumToString(OrderStatus.pending)?
          Container(
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (!managerHasChosenAction) {
                        // order.progress = Utils.enumToString(OrderStatus.accepted);
                        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(order, OrderStatus.accepted));
                        managerHasChosenAction = true;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text(AppLocalizations.of(context).networkRequestStillInProgress)));
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context).accept.toUpperCase(),
                        style:  TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextMalibu,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ///SizeConfig.safeBlockHorizontal * 4
                        ),
                      ),
                    )),
              )) :
          Container(),
          /// Decline
          order.progress == Utils.enumToString(OrderStatus.pending)?
          Container(
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      // order.progress = Utils.enumToString(OrderStatus.declined);
                      if (!managerHasChosenAction) {
                        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(order, OrderStatus.declined));
                        managerHasChosenAction = true;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text(AppLocalizations.of(context).networkRequestStillInProgress)));
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context).decline.toUpperCase(),
                        style:  TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextMalibu,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ///SizeConfig.safeBlockHorizontal * 4
                        ),
                      ),
                    )),
              )) :
          Container(),
          ///Cancel the order, in this case it has been paid but for some reason it cannot be provided. The user has to be refunded.
          ///a canceled order cannot be reopened
          order.progress ==  Utils.enumToString(OrderStatus.paid) || order.progress ==  Utils.enumToString(OrderStatus.toBePaidAtCheckout) ?
          Container(
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
              alignment: Alignment.center,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (!managerHasChosenAction) {
                        // order.progress = Utils.enumToString(OrderStatus.canceled);
                        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(order, OrderStatus.canceled));
                        managerHasChosenAction = true;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text(AppLocalizations.of(context).networkRequestStillInProgress)));
                      }
                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        AppLocalizations.of(context).cancel.toUpperCase(),
                        style: TextStyle(
                            letterSpacing: 1.25,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextMalibu,
                            fontWeight: FontWeight.w600,
                            fontSize: 14
                          ///SizeConfig.safeBlockHorizontal * 4
                        ),
                      ),
                    )),
              )) :
          Container()
        ],
      ),
    );
  }

  void onCancel(OrderState order){
    showDialog(
        context: context,
        builder: (context) {
          return CancelPop(order: order);
        }
    );
  }

  Stream<QuerySnapshot> _orderListRealtime;

  /*SliverList(
  delegate: SliverChildBuilderDelegate((context, index) {
  //MenuItemModel menuItem = menuItems.elementAt(index);
  OrderState order = orderList.elementAt(index)[0];
  OrderEntry entry = orderList.elementAt(index)[1];
  bool managerHasChosenAction = false;
  return Column(
  children: [
  ///Order Info
  DashboardListItem(order, entry),
  ///Actions
  buildActivityButtons(order, context, managerHasChosenAction),
  ///Divider
  Container(
  //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
  height: 2,
  color: BuytimeTheme.DividerGrey,
  )
  ],
  );
  },
  childCount: orderList.length,
  ),
  )*/


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    List<BusinessState> businessStateList =  StoreProvider.of<AppState>(context).state.businessList.businessListState;
    List<String> businessIdList = [];
    for(int i = 0; i < businessStateList.length; i++){
      businessIdList.add(businessStateList[i].id_firestore);
    }
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    //DateTime sevenDaysFromNow = new DateTime(currentTime.year, currentTime.month, currentTime.day + 7, 0, 0, 0, 0, 0).toUtc();
    DateTime sevenDaysFromNow =  currentTime.add(Duration(days: 7));
    debugPrint('RUI_M_activity_management => CURRENT TIME: $currentTime | SEVEN DAYS IN: $sevenDaysFromNow');

    if(businessIdList.length > 10){
      _orderListRealtime = FirebaseFirestore.instance.collection('order')
          .where("businessId", whereIn: businessIdList.sublist(0, 10))
          .orderBy('date', descending: false)
      //.where("date", isGreaterThanOrEqualTo: currentTime)
      //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
          .snapshots();
    }else{
      _orderListRealtime = FirebaseFirestore.instance.collection('order')
          .where("businessId", whereIn: businessIdList)
          .orderBy('date', descending: false)
      //.where("date", isGreaterThanOrEqualTo: currentTime)
      //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
          .snapshots();
    }

    debugPrint('RUI_M_activity_management => STREAM LENGTH: ${_orderListRealtime.length}');

    ///Init sizeConfig
    SizeConfig().init(context);
    return StreamBuilder<QuerySnapshot>(
      stream: _orderListRealtime,
      // )
      // StoreConnector<AppState, AppState>(
      //   converter: (store) => store.state,
      //   onInit: (store) {
      //     store.state.orderList.orderListState.clear();
      //     store.dispatch(OrderListRequest(store.state.business.id_firestore));
      //     startRequest = true;
      //   },
      builder: (context,AsyncSnapshot<QuerySnapshot>  snapshot) {
        String today = '${AppLocalizations.of(context).today.substring(0,1)}${AppLocalizations.of(context).today.substring(1,AppLocalizations.of(context).today.length-2).toLowerCase()}';
        // print("UI_M_activity_management : Request: $startRequest - Number of orders is " + snapshot.orderList.orderListState.length.toString());

        // print("UI_M_activity_management : No activity: $noActivity");
        ///Current time
        // DateTime currentTime = DateTime.now();
        // currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);

        /// Firebase realtime checks
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              drawerEnableOpenDragGesture: false,
              key: _drawerKey,
              ///Appbar
              appBar: BuytimeAppbar(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          tooltip: AppLocalizations.of(context).openMenu,
                          onPressed: () {
                            _drawerKey.currentState.openDrawer();
                          },
                        ),
                      ),
                    ],
                  ),
                  ///Title
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        AppLocalizations.of(context).activityManagement,
                        textAlign: TextAlign.start,
                        style: BuytimeTheme.appbarTitle,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56.0,
                  )
                ],
              ),
              drawer: UI_M_BusinessListDrawer(),
              body: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ///Today & show week
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Calendar icon & Date
                          Container(
                            child: Row(
                              children: [
                                ///Calendar Icon
                                Icon(
                                  BuytimeIcons.calendar,
                                  size: 22,
                                ),
                                ///Date
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    seeAll ? AppLocalizations.of(context).showAll : '${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(currentTime)} - ${DateFormat('dd MMM').format(sevenDaysFromNow)}',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontSize: 16,
                                        letterSpacing: 0.18,
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ///See all week
                          Container(
                            //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                              alignment: Alignment.center,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () {
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                      //Navigator.of(context).pop();
                                      setState(() {
                                        seeAll = !seeAll;
                                      });
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        !seeAll ? AppLocalizations.of(context).showAll : '${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(currentTime)} - ${DateFormat('dd MMM').format(sevenDaysFromNow)}',
                                        style: TextStyle(
                                            letterSpacing: .25,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextMalibu,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16

                                          ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    )),
                              ))
                        ],
                      ),
                    ),
                    ///Dashboard
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///Pending card
                          DashboardCard(
                            background: Color(0xff003B5F),
                            icon: Icon(
                              BuytimeIcons.pending_clock,
                              color: BuytimeTheme.SymbolWhite,
                              size: 22,
                            ),
                            count: '${pendingList.length}',
                            type: '${AppLocalizations.of(context).pending}',
                          ),
                          ///Accepted card
                          DashboardCard(
                            background: Color(0xff4C95C2),
                            icon: Icon(
                              BuytimeIcons.accepted_clock,
                              color: BuytimeTheme.SymbolWhite,
                              size: 22,
                            ),
                            count: '${acceptedList.length}',
                            type: '${AppLocalizations.of(context).accepted}',
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          debugPrint('Coonection Stablished');
        }
        pendingList.clear();
        acceptedList.clear();
        canceledList.clear();
        orderList.clear();
        orderMap.clear();
        allMap.clear();
        allOrderList.clear();
        weekOrderList.clear();
        List<OrderState> tmp = [];
        //debugPrint('ORDER MAP LENGTH: ${orderMap.length}');

        for (int j = 0; j < snapshot.data.docs.length; j++) {
          tmp.add(OrderState.fromJson(snapshot.data.docs[j].data()));
        }

        if(tmp.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(tmp.isNotEmpty && tmp.first.businessId == null)
            tmp.removeLast();
          debugPrint('CHECK 1');
          noActivity = false;
          startRequest = false;
        }

        tmp.forEach((element) {
          //debugPrint('CHECK 1');
          DateTime orderTime = element.date;
          orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0);

          if(element.progress == Utils.enumToString(OrderStatus.canceled) || element.progress == Utils.enumToString(OrderStatus.declined)){
            listUp(element, currentTime, sevenDaysFromNow, orderTime, canceledList);
            //pendingList.add(element);
          }else if(element.progress == Utils.enumToString(OrderStatus.pending) || element.progress == Utils.enumToString(OrderStatus.unpaid)){
            listUp(element, currentTime, sevenDaysFromNow, orderTime, pendingList);
            //acceptedList.add(element);
          }else{
            listUp(element, currentTime, sevenDaysFromNow, orderTime, acceptedList);
            //acceptedList.add(element);
          }
        });


        pendingList.forEach((pending) {
          //debugPrint('CHECK PENDING');
          DateTime pendingTime = pending[0].date;
          pendingTime = DateTime(pendingTime.year, pendingTime.month, pendingTime.day, 0, 0, 0, 0, 0);
          //orderMap[DateFormat('dd MM yyyy').format(pendingTime)].add(pending);
          orderMap[pendingTime].add(pending);
        });

        acceptedList.forEach((accepted) {
          //debugPrint('CHECK ACCEPTED');
          DateTime acceptedTime = accepted[0].date;
          acceptedTime = new DateTime(acceptedTime.year, acceptedTime.month, acceptedTime.day, 0, 0, 0, 0, 0);
          //orderMap[DateFormat('dd MM yyyy').format(acceptedTime)].add(accepted);
          orderMap[acceptedTime].add(accepted);
        });

        canceledList.forEach((pending) {
          //debugPrint('CHECK CANCELED');
          DateTime pendingTime = pending[0].date;
          pendingTime = DateTime(pendingTime.year, pendingTime.month, pendingTime.day, 0, 0, 0, 0, 0);
          // orderMap[DateFormat('dd MM yyyy').format(pendingTime)].add(pending);
          orderMap[pendingTime].add(pending);
        });

        orderMap.forEach((key, value) {
          //debugPrint('RUI_M_activity_management: KEY: $key');
          //debugPrint('RUI_M_activity_management: VALUE LENGTH: ${value.length}');
          //DateTime keyTime =  DateFormat("dd/MM/yyyy").parse(key).toUtc();

          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          //value.sort((a,b) => DateFormat('dd').format(a[0].start_date).compareTo(DateFormat('dd').format(b[0].start_date)));
          //value.sort((a,b) => DateFormat('dd').format(a[0].end_date).compareTo(DateFormat('dd').format(b[0].end_date)));

          if(seeAll){
            DateTime tmp = key;
            tmp = DateTime(key.year, key.month, 1, 0,0,0,0,0);
            allMap.putIfAbsent(tmp, () => []);
            //debugPrint('RUI_M_activity_management: VALUE LENGTH: ${value.length}');
            if(allMap.containsKey(tmp)){
              //debugPrint('RUI_M_activity_management: KEY: $key');
              allMap[tmp].add(value);
              /*if(key.isAtSameMomentAs(currentTime) || (key.isAfter(currentTime) && key.isBefore(sevenDaysFromNow)) ){
              debugPrint('RUI_M_activity_management: KEY TIME: $key | CURRENT TIME: $currentTime | SEVEN DAYS FROM NOW: $sevenDaysFromNow');
              debugPrint('RUI_M_activity_management: VALUE LENGTH: ${allMap[tmp].last.length}');
              weekOrderList.add(value);
            }*/
            }
          }else{
            weekOrderList.add(value);
          }

          allOrderList.add(value);
        });

        orderList.addAll(pendingList);
        orderList.addAll(acceptedList);
        orderList.addAll(canceledList);

        //List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,
            ///Appbar
            appBar: BuytimeAppbar(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        tooltip: AppLocalizations.of(context).openMenu,
                        onPressed: () {
                          _drawerKey.currentState.openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
                ///Title
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      AppLocalizations.of(context).activityManagement,
                      textAlign: TextAlign.start,
                      style: BuytimeTheme.appbarTitle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 56.0,
                )
              ],
            ),
            drawer: UI_M_BusinessListDrawer(),
            body: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Week & See all
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///Calendar icon & Date
                        Container(
                          child: Row(
                            children: [
                              ///Calendar Icon
                              Icon(
                                BuytimeIcons.calendar,
                                size: 22,
                              ),
                              ///Date
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  seeAll ? AppLocalizations.of(context).showAll : '${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(currentTime)} - ${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(sevenDaysFromNow)}',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      fontSize: 16,
                                      letterSpacing: 0.18,
                                      fontWeight: FontWeight.w400
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        ///See all week
                        Container(
                          //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                            alignment: Alignment.center,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                    //Navigator.of(context).pop();
                                    setState(() {
                                      seeAll = !seeAll;
                                    });
                                  },
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      !seeAll ? AppLocalizations.of(context).showAll : '${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(currentTime)} - ${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(sevenDaysFromNow)}',
                                      style: TextStyle(
                                          letterSpacing: .25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextMalibu,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  )),
                            ))
                      ],
                    ),
                  ),
                  ///Dashboard
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///Pending card
                        DashboardCard(
                          background: Color(0xff003B5F),
                          icon: Icon(
                            BuytimeIcons.pending_clock,
                            color: BuytimeTheme.SymbolWhite,
                            size: 22,
                          ),
                          count: '${pendingList.length}',
                          type: '${AppLocalizations.of(context).pending}',
                        ),
                        ///Accepted card
                        DashboardCard(
                          background: Color(0xff4C95C2),
                          icon: Icon(
                            BuytimeIcons.accepted_clock,
                            color: BuytimeTheme.SymbolWhite,
                            size: 22,
                          ),
                          count: '${acceptedList.length}',
                          type: '${AppLocalizations.of(context).accepted}',
                        )
                      ],
                    ),
                  ),
                  orderList.isNotEmpty ?
                  ///Order List
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 5),
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: !seeAll ?
                        _weekSliverList(weekOrderList) :
                        [
                          MultiSliver(
                            children: orderHistory(allMap),
                          )
                        ],
                      ),
                    ),
                  )
                  /*Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 5),
                      child: CustomScrollView(
                          shrinkWrap: true,
                          //physics: ScrollPhysics(),
                          slivers: seeAll ?
                          _sliverList(allMap) : _weekSliverList(weekOrderList)),
                    ),
                  )*/ :
                  noActivity ?
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator()
                      ],
                    ),
                  ) :
                  ///No List
                  Container(
                    //height: SizeConfig.safeBlockVertical * 8,
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 5),
                    //decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///Icon
                        Container(
                          //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                          child: Icon(
                            BuytimeIcons.sad,
                            color: BuytimeTheme.SymbolBlack,
                            size: 22,
                          ),
                        ),
                        ///Text
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                          child: Text(
                            AppLocalizations.of(context).noReservationYet,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                letterSpacing: 0.18,
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextBlack
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

