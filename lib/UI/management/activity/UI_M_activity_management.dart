import 'dart:ui';

import 'package:Buytime/UI/management/activity/widget/W_cancel_popup.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
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
//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ActivityManagement extends StatefulWidget {
  static String route = '/activityManagement';

  ManagerModel manager;
  ServiceModel service;

  ActivityManagement({Key key, this.service, this.manager}) : super(key: key);

  @override
  _ActivityManagementState createState() => _ActivityManagementState();
}

class _ActivityManagementState extends State<ActivityManagement> {
  List<BookingState> bookingList = [];
  bool seeAll = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<List> pendingList = [];
  List<List> acceptedList = [];
  List<List> canceledList = [];
  List<List> orderList = [];
  List<List<List>> allOrderList = [];

  Map<String, List<List>> orderMap = new Map();

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
  }

  bool startRequest = false;
  bool noActivity = false;


  void listUp(OrderState element, DateTime currentTime, DateTime orderTime, List<List> list){
    orderMap.putIfAbsent(DateFormat('dd MM yyyy').format(orderTime), () => []);
    if(element.selected.isNotEmpty){
      element.itemList.forEach((entry) {
        DateTime orderEntryTime = entry.date;
        orderEntryTime = new DateTime(orderEntryTime.year, orderEntryTime.month, orderEntryTime.day, 0, 0, 0, 0, 0);
        if(seeAll){
          list.add([element, entry]);
        }else{
          if(orderEntryTime.isAtSameMomentAs(currentTime))
            list.add([element, entry]);
        }
      });
    }else{
      if(seeAll){
        list.add([element, null]);
      }else{
        if(orderTime.isAtSameMomentAs(currentTime))
          list.add([element, null]);
      }
      //list.add([element, null]);
    }
  }

  List<Widget> _sliverList(List<List<List>> list) {
    List<Widget> widgetList = [];
    for (int i = 0; i < list.length; i++)
      widgetList
        ..add(
            SliverPersistentHeader(
              pinned: true,
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
                i == 0 ? '${AppLocalizations.of(context).today} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(list[i][0][0].date).toUpperCase()}' :
                  i == 1 ? '${AppLocalizations.of(context).tomorrow} ${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(list[i][0][0].date).toUpperCase()}' :
                  '${DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(list[i][0][0].date).toUpperCase()}',
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.state.orderList.orderListState.clear();
        store.dispatch(OrderListRequest(store.state.business.id_firestore));
        startRequest = true;
      },
      builder: (context, snapshot) {
        pendingList.clear();
        acceptedList.clear();
        canceledList.clear();
        orderList.clear();
        orderMap.clear();
        allOrderList.clear();
        print("UI_M_activity_management : Request: $startRequest - Number of orders is " + snapshot.orderList.orderListState.length.toString());
        List<OrderState> tmp = snapshot.orderList.orderListState;
        if(tmp.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(tmp.isNotEmpty && tmp.first.businessId == null)
            tmp.removeLast();
          noActivity = false;
          startRequest = false;
        }
        print("UI_M_activity_management : No activity: $noActivity");



        ///Current time
        DateTime currentTime = DateTime.now();
        currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
        tmp.forEach((element) {
          DateTime orderTime = element.date;
          orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0);

          if(element.progress == Utils.enumToString(OrderStatus.canceled) || element.progress == Utils.enumToString(OrderStatus.declined)){
            listUp(element, currentTime, orderTime, canceledList);
            //pendingList.add(element);
          }else if(element.progress == Utils.enumToString(OrderStatus.pending) || element.progress == Utils.enumToString(OrderStatus.unpaid)){
            listUp(element, currentTime, orderTime, pendingList);
            //acceptedList.add(element);
          }else{
            listUp(element, currentTime, orderTime, acceptedList);
            //acceptedList.add(element);
          }
        });

        pendingList.forEach((pending) {
          DateTime pendingTime = pending[0].date;
          pendingTime = DateTime(pendingTime.year, pendingTime.month, pendingTime.day, 0, 0, 0, 0, 0);
          orderMap[DateFormat('dd MM yyyy').format(pendingTime)].add(pending);
        });

        acceptedList.forEach((accepted) {
          DateTime acceptedTime = accepted[0].date;
          acceptedTime = new DateTime(acceptedTime.year, acceptedTime.month, acceptedTime.day, 0, 0, 0, 0, 0);
          orderMap[DateFormat('dd MM yyyy').format(acceptedTime)].add(accepted);
        });

        canceledList.forEach((pending) {
          DateTime pendingTime = pending[0].date;
          pendingTime = DateTime(pendingTime.year, pendingTime.month, pendingTime.day, 0, 0, 0, 0, 0);
          orderMap[DateFormat('dd MM yyyy').format(pendingTime)].add(pending);
        });

        orderMap.forEach((key, value) {
          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          //value.sort((a,b) => DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));
          //value.sort((a,b) => DateFormat('dd').format(a.end_date).compareTo(DateFormat('dd').format(b.end_date)));
          allOrderList.add(value);
        });

        orderList.addAll(pendingList);
        orderList.addAll(acceptedList);
        orderList.addAll(canceledList);

        String today = '${AppLocalizations.of(context).today.substring(0,1)}${AppLocalizations.of(context).today.substring(1,AppLocalizations.of(context).today.length-2).toLowerCase()}';


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
                                  seeAll ? AppLocalizations.of(context).allWeek : '$today, ${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(DateTime.now())}',
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
                                      !seeAll ? AppLocalizations.of(context).seeAllWeek : '$today, ${DateFormat('dd MMM',Localizations.localeOf(context).languageCode).format(DateTime.now())}',
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
                      child: CustomScrollView(shrinkWrap: true,
                          slivers: seeAll ? _sliverList(allOrderList) : [
                            SliverList(
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
                        ),
                      ]),
                    ),
                  ) :
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

