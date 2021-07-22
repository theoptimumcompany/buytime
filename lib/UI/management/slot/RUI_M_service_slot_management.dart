import 'dart:ui';

import 'package:Buytime/UI/management/activity/widget/W_cancel_popup.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/reusable/sliverAppBarDelegate.dart';
import 'package:Buytime/reusable/time_slot_management_widget.dart';
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

class RServiceSlotManagement extends StatefulWidget {
  //static String route = '/RActivityManagement';
  ServiceState serviceState;
  RServiceSlotManagement({Key key, this.serviceState}) : super(key: key);

  @override
  _RServiceSlotManagementState createState() => _RServiceSlotManagementState();
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

class _RServiceSlotManagementState extends State<RServiceSlotManagement> {
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
  Map<DateTime, Map<DateTime, List<SquareSlotState>>> allMap = new Map();

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

  List<Widget> _list(DateTime key, Map<DateTime, List<SquareSlotState>> map) {

    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);

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
    map.forEach((key, value) {
      debugPrint('here');
      DateTime orderTime = DateFormat('dd/MM/yyyy').parse(value.first.date);
      DateTime tmp = DateFormat('dd/MM/yyyy').parse(value.first.date);
      tmp = DateTime(orderTime.year, orderTime.month, 1, 0,0,0,0,0);
      //DateTime orderTime = list[i][0][0].date;
      //orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0);
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
                              /*SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///Remove
                                        Container(
                                          margin: EdgeInsets.only(right: 21),
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color:  BuytimeTheme.ManagerPrimary.withOpacity(.1)),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              onTap: (){

                                              },
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                child: Icon(
                                                  Icons.remove,
                                                  color: BuytimeTheme.ManagerPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ///Add
                                        Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color:  BuytimeTheme.ManagerPrimary.withOpacity(.1)),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              onTap: (){

                                              },
                                              child: Container(
                                                height: 24,
                                                width: 24,
                                                child: Icon(
                                                  Icons.add,
                                                  color:  BuytimeTheme.ManagerPrimary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),*/
                              SizedBox(
                                height: 10,
                              ),
                              SliverGrid(
                                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 100,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    mainAxisExtent: 100,
                                    childAspectRatio: 50,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                  //debugPrint('UI_M_activity_management => LIST SIZE: ${list[i].length}');
                                  //OrderState order = list[i].elementAt(index)[0];
                                  //OrderEntry entry = list[i].elementAt(index)[1];
                                  /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
                                  /// or the entry?
                                  bool managerHasChosenAction = false;
                                  SquareSlotState slot = value[index];
                                  return Container(
                                    //margin: EdgeInsets.only(top: 10, bottom: 10),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: BuytimeTheme.BackgroundWhite,
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        border: Border.all(color: BuytimeTheme.TextLightGrey, width: 1.5),
                                        /*boxShadow: [
                                              BoxShadow(
                                                color: BuytimeTheme.BackgroundBlack.withOpacity(0.1),
                                                spreadRadius: .5,
                                                blurRadius: 1,
                                                offset: Offset(0, 1), // changes position of shadow
                                              ),
                                            ],*/
                                      ),
                                      child: TimeSlotManagementWidget(
                                          slot,
                                          (int value){
                                            debugPrint('SLOT SNIPPET ID: ${slotSnippetListState.slotListSnippet.first.id}');
                                            slotSnippetListState.slotListSnippet.first.slot.forEach((element) {
                                              if(element.uid == slot.uid)
                                                element.free = value;
                                              //debugPrint('${element.date} - ${element.on} - ${element.free}');
                                            });
                                            StoreProvider.of<AppState>(context).dispatch(UpdateSlotSnippet(widget.serviceState.serviceId, slotSnippetListState));
                                            /*squareSlotList.forEach((element) {

                                            });*/
                                            }, false));
                                },
                                  childCount: value.length,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
    });

    return widgetList;
  }

  List<Widget> orderHistory(Map<DateTime, Map<DateTime, List<SquareSlotState>>> list){
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
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
    List<Widget> widgetList = [];
    for (int i = 0; i < list.length; i++){
      if(list[i] != null && list[i].isNotEmpty){
        DateTime orderTime = list[i][0][0].date;
        orderTime = new DateTime(orderTime.year, orderTime.month, orderTime.day, 0, 0, 0, 0, 0);
        widgetList
          ..add(SliverClip(
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

          /// Decline
          order.progress == Utils.enumToString(OrderStatus.pending) || order.progress == Utils.enumToString(OrderStatus.holding) || order.progress == Utils.enumToString(OrderStatus.accepted)?
          Container(
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
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
              )) : Container(),
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
                        onCancel(order);
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
              )) : Container()
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

  //Stream<QuerySnapshot> _orderListRealtime;
  Stream<QuerySnapshot> _serviceSnippet;

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

  bool filterPending = false;
  bool filterAccepted = false;

  List<SquareSlotState> squareSlotList = [];
  SlotListSnippetState slotSnippetListState = SlotListSnippetState(slotListSnippet: []);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    _serviceSnippet = FirebaseFirestore.instance.collection('service')
        .doc(widget.serviceState.serviceId)
        .collection('slotSnippet')
    //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
        .snapshots();
    /*List<BusinessState> businessStateList =  StoreProvider.of<AppState>(context).state.businessList.businessListState;
    List<String> businessIdList = [];
    for(int i = 0; i < businessStateList.length; i++){
      businessIdList.add(businessStateList[i].id_firestore);
    }
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
    //DateTime sevenDaysFromNow = new DateTime(currentTime.year, currentTime.month, currentTime.day + 7, 0, 0, 0, 0, 0).toUtc();
    DateTime sevenDaysFromNow =  currentTime.add(Duration(days: 7));
    debugPrint('RUI_M_activity_management => CURRENT TIME: $currentTime | SEVEN DAYS IN: $sevenDaysFromNow');

    if(businessIdList.isNotEmpty){
      if(businessIdList.length > 10){
        _orderListRealtime = FirebaseFirestore.instance.collection('order')
            .where("businessId", whereIn: businessIdList.sublist(0, 10))
            .orderBy('date', descending: false)
            .where("date", isGreaterThanOrEqualTo: currentTime)
        //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
            .snapshots();
      }else{
        _orderListRealtime = FirebaseFirestore.instance.collection('order')
            .where("businessId", whereIn: businessIdList)
            .orderBy('date', descending: false)
            // .startAt([currentTime])
            .where("date", isGreaterThan: currentTime)
        //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
            .snapshots();
      }
    }*/
    debugPrint('UPDATE');
    //debugPrint('RUI_M_activity_management => STREAM LENGTH: ${_orderListRealtime.length}');
    Locale myLocale = Localizations.localeOf(context);
    ///Init sizeConfig
    SizeConfig().init(context);
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
                  Utils.retriveField(myLocale.languageCode, widget.serviceState.name),
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
          child: StreamBuilder<QuerySnapshot>(
            stream: _serviceSnippet,
            // )
            // StoreConnector<AppState, AppState>(
            //   converter: (store) => store.state,
            //   onInit: (store) {
            //     store.state.orderList.orderListState.clear();
            //     store.dispatch(OrderListRequest(store.state.business.id_firestore));
            //     startRequest = true;
            //   },
            builder: (context,AsyncSnapshot<QuerySnapshot> serviceSnapshot) {
              squareSlotList.clear();
              allMap.clear();
              if (serviceSnapshot.hasError || serviceSnapshot.connectionState == ConnectionState.waiting) {
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
              slotSnippetListState = SlotListSnippetState.fromJson(serviceSnapshot.data.docs.first.data());
              slotSnippetListState.slotListSnippet.first.id = serviceSnapshot.data.docs.first.id;
              debugPrint("slotSnippetListState: ${slotSnippetListState.slotListSnippet.length}");
              squareSlotList.clear();
              slotSnippetListState.slotListSnippet.forEach((element) {
                squareSlotList.addAll(element.slot);
              });
              //squareSlotList = slotSnippetListState.slotListSnippet.first.slot;
              allMap.clear();
              squareSlotList.forEach((element) {
                DateTime tmp = DateFormat('dd/MM/yyyy').parse(element.date);
                DateTime tmp2 = DateFormat('dd/MM/yyyy').parse(element.date);
                DateTime currentDate = DateTime.now();
                currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day, 0,0,0,0,0);
                Map<DateTime, List<SquareSlotState>> tmpMap = Map();
                tmp = DateTime(tmp.year, tmp.month, 1, 0,0,0,0,0);
                tmp2 = DateTime(tmp2.year, tmp2.month, tmp2.day, 0,0,0,0,0);
                if(tmp2.isAfter(currentDate) || tmp2.isAtSameMomentAs(currentDate)){
                  allMap.putIfAbsent(tmp, () => tmpMap);
                  debugPrint('RUI_M_activity_management: VALUE LENGTH: ${element.free}');
                  if(allMap.containsKey(tmp)){
                    allMap[tmp].putIfAbsent(tmp2, () => []);
                    //debugPrint('RUI_M_activity_management: KEY: $key');
                    if(allMap[tmp].containsKey(tmp2))
                      allMap[tmp][tmp2].add(element);
                    /*if(key.isAtSameMomentAs(currentTime) || (key.isAfter(currentTime) && key.isBefore(sevenDaysFromNow)) ){
              debugPrint('RUI_M_activity_management: KEY TIME: $key | CURRENT TIME: $currentTime | SEVEN DAYS FROM NOW: $sevenDaysFromNow');
              debugPrint('RUI_M_activity_management: VALUE LENGTH: ${allMap[tmp].last.length}');
              weekOrderList.add(value);
            }*/
                  }
                }
              });


              return CustomScrollView(
                  shrinkWrap: true, slivers: [MultiSliver(
                children: orderHistory(allMap),
              )]);
            },
          ),
        ),
      ),
    );
  }
}

