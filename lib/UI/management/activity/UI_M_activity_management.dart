import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
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

  List<OrderState> pendingList = [];
  List<OrderState> acceptedList = [];
  List<OrderState> orderList = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.dispatch(OrderListRequest(store.state.business.id_firestore));
      },
      builder: (context, snapshot) {
        pendingList.clear();
        acceptedList.clear();
        orderList.clear();
        print("UI_U_OrderHistory : Number of orders is " + snapshot.orderList.orderListState.length.toString());

        List<OrderState> tmp = snapshot.orderList.orderListState;
        /*tmp.forEach((element) {
          element.
        });*/
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
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                    '${AppLocalizations.of(context).today.substring(0,1)}${AppLocalizations.of(context).today.substring(1,AppLocalizations.of(context).today.length).toLowerCase()}${DateFormat('dd MMM').format(DateTime.now())}',
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
                                        !seeAll ? AppLocalizations.of(context).seeAllWeek : AppLocalizations.of(context).showLess,
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
                            type: 'Pending',
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
                            type: 'Accepted',
                          )
                        ],
                      ),
                    ),
                    orderList.isNotEmpty ?
                    ///Order List
                    Column(
                      children: orderList
                          .map((OrderState prder) => Column(
                        children: [
                          //BookingListServiceListItem(service),
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                            height: SizeConfig.safeBlockVertical * .2,
                            color: BuytimeTheme.DividerGrey,
                          )
                        ],
                      ))
                          .toList(),
                    ):
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
          ),
        );
      },
    );
  }
}

