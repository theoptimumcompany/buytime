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

import 'dart:ui';

import 'package:Buytime/UI/management/activity/widget/W_cancel_popup.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/reusable/w_sliver_app_bar_delegate.dart';
import 'package:Buytime/UI/management/slot/widget/time_slot_management_widget.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<DateTime, Map<DateTime, List<ServiceSlot>>> slotMap = new Map();

  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
  }

  bool startRequest = false;
  bool noActivity = false;

  int first = 0;
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

  List<Widget> _list(DateTime date, Map<DateTime, List<SquareSlotState>> map) {

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
            padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
            child: Text(
                '${DateFormat('MMM yyyy').format(date).toUpperCase()}',
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
      debugPrint('RUI_M_service_slot_management => here - $first');
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
                            padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
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
                                    maxCrossAxisExtent: 150,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 0,
                                    mainAxisExtent: 100,
                                    childAspectRatio: 50,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                  //debugPrint('RUI_M_service_slot_management => LIST SIZE: ${list[i].length}');
                                  //OrderState order = list[i].elementAt(index)[0];
                                  //OrderEntry entry = list[i].elementAt(index)[1];
                                  /// when the manager clicks on the button we  block all the buttons (for this order) until the response rebuilds the list
                                  /// or the entry?
                                  bool managerHasChosenAction = false;
                                  SquareSlotState slot = value[index];
                                  return Container(
                                      //padding: EdgeInsets.only(top: 10, bottom: 10),
                                      margin: EdgeInsets.only(left: 10, right: 10),
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
                                            debugPrint('RUI_M_service_slot_management => SLOT SNIPPET ID: ${slotSnippetListState.slotListSnippet.first.id}');
                                            slotSnippetListState.slotListSnippet.first.slot.forEach((element) {
                                              if(element.uid == slot.uid)
                                                element.free = value;
                                              //debugPrint('RUI_M_service_slot_management => ${element.date} - ${element.on} - ${element.free}');
                                            });
                                            StoreProvider.of<AppState>(context).dispatch(UpdateSlotSnippet(widget.serviceState.serviceId, slotSnippetListState));
                                            /*squareSlotList.forEach((element) {

                                            });*/
                                            }, false,
                                          0, index,
                                       slotMap[date][key][index]
                                      ));
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
      first++;
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

  bool filterPending = false;
  bool filterAccepted = false;

  List<SquareSlotState> squareSlotList = [];
  SlotListSnippetState slotSnippetListState = SlotListSnippetState(slotListSnippet: []);

  DateTime start = DateTime.now();
  DateTime end = DateTime.now();


  Future<void> _selectDate(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: cIn,
        firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: new DateTime(2025),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(primaryColor: BuytimeTheme.ManagerPrimary, splashColor: BuytimeTheme.ManagerPrimary, colorScheme: ColorScheme.light(onPrimary: Colors.white, primary: BuytimeTheme.ManagerPrimary)),
            child: child,
          );
        });
    if (picked != null ) {
      print(picked);
      /*_checkInController.text = DateFormat('dd/MM/yyyy').format(picked.start);
      _checkOutController.text = DateFormat('dd/MM/yyyy').format(picked.end);*/
      setState(() {
        /*checkIn = picked.start.toUtc();
        checkOut = picked.end.toUtc();*/
        start = DateTime.utc(picked.year, picked.month, picked.day);
        //end = DateTime.utc(picked.end.year, picked.end.month, picked.end.day);
      });
    }
    return null;
  }

  List<ServiceSlot> serviceSlotList = [];

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
    debugPrint('RUI_M_service_slot_management => CURRENT TIME: $currentTime | SEVEN DAYS IN: $sevenDaysFromNow');

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
    debugPrint('RUI_M_service_slot_management => UPDATE');
    //debugPrint('RUI_M_service_slot_management => STREAM LENGTH: ${_orderListRealtime.length}');
    Locale myLocale = Localizations.localeOf(context);
    ///Init sizeConfig
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: _drawerKey,
        ///Appbar
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.dark,
          elevation: 1,
          title: Text(
            Utils.retriveField(myLocale.languageCode, widget.serviceState.name),
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
              Icons.keyboard_arrow_left_outlined,
              color: Colors.black,
              //size: 24.0,
            ),
            tooltip: AppLocalizations.of(context).openMenu,
            onPressed: () {
              //_drawerKey.currentState.openDrawer();
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              onPressed: (){
                _selectDate(context, start, end);
              },
              icon: Icon(
                Icons.calendar_today_outlined,
                color: BuytimeTheme.TextBlack,
                size: 24,
              ),
            )
          ],
        ),
        drawer: ManagerDrawer(),
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
              slotMap.clear();
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
              if(slotSnippetListState.slotListSnippet.isNotEmpty){
                slotSnippetListState.slotListSnippet.first.id = serviceSnapshot.data.docs.first.id;
                debugPrint("RUI_M_service_slot_management => slotSnippetListState: ${slotSnippetListState.slotListSnippet.length}");
                squareSlotList.clear();
                for(int i = 0; i < slotSnippetListState.slotListSnippet.length; i++){
                  squareSlotList.addAll(slotSnippetListState.slotListSnippet[i].slot);
                  slotSnippetListState.slotListSnippet[i].slot.forEach((element) {
                    serviceSlotList.add(widget.serviceState.serviceSlot[i]);
                  });
                }
                /*slotSnippetListState.slotListSnippet.forEach((element) {
                squareSlotList.addAll(element.slot);
              });*/
                debugPrint("RUI_M_service_slot_management => HOW MANY LIST OD SLOTS: ${slotSnippetListState.slotListSnippet.length}");
                //squareSlotList = slotSnippetListState.slotListSnippet.first.slot;
                allMap.clear();
                slotMap.clear();
                for(int i = 0; i < squareSlotList.length; i++){
                  DateTime tmp = DateFormat('dd/MM/yyyy').parse(squareSlotList[i].date);
                  DateTime tmp2 = DateFormat('dd/MM/yyyy').parse(squareSlotList[i].date);
                  DateTime currentDate = DateTime.now();
                  currentDate = DateTime(start.year, start.month, start.day, 0,0,0,0,0);
                  DateTime slotTime = DateFormat('dd/MM/yyyy').parse(squareSlotList[i].date);
                  int hour = int.parse(squareSlotList[i].on.split(':').first);
                  int minute = int.parse(squareSlotList[i].on.split(':').last);
                  slotTime = DateTime(slotTime.year, slotTime.month, slotTime.day, hour,minute,0,0,0);
                  Map<DateTime, List<SquareSlotState>> tmpMap = Map();
                  Map<DateTime, List<ServiceSlot>> tmpSlotMap = Map();
                  tmp = DateTime(tmp.year, tmp.month, 1, 0,0,0,0,0);
                  tmp2 = DateTime(tmp2.year, tmp2.month, tmp2.day, 0,0,0,0,0);
                  if(tmp2.isAfter(currentDate) || tmp2.isAtSameMomentAs(currentDate)){
                    if(slotTime.isAfter(DateTime.now()) || slotTime.isAtSameMomentAs(DateTime.now())){
                      allMap.putIfAbsent(tmp, () => tmpMap);
                      slotMap.putIfAbsent(tmp, () => tmpSlotMap);
                      debugPrint('RUI_M_service_slot_management => VALUE LENGTH: ${squareSlotList[i].free}');
                      if(allMap.containsKey(tmp)){
                        allMap[tmp].putIfAbsent(tmp2, () => []);
                        slotMap[tmp].putIfAbsent(tmp2, () => []);
                        //debugPrint('RUI_M_service_slot_management => KEY: $key');
                        if(allMap[tmp].containsKey(tmp2))
                          allMap[tmp][tmp2].add(squareSlotList[i]);
                        slotMap[tmp][tmp2].add(serviceSlotList[i]);
                      }
                    }
                  }
                }
              }
              /*squareSlotList.forEach((element) {
                DateTime tmp = DateFormat('dd/MM/yyyy').parse(element.date);
                DateTime tmp2 = DateFormat('dd/MM/yyyy').parse(element.date);
                DateTime currentDate = DateTime.now();
                currentDate = DateTime(start.year, start.month, start.day, 0,0,0,0,0);
                DateTime slotTime = DateFormat('dd/MM/yyyy').parse(element.date);
                int hour = int.parse(element.on.split(':').first);
                int minute = int.parse(element.on.split(':').last);
                slotTime = DateTime(slotTime.year, slotTime.month, slotTime.day, hour,minute,0,0,0);
                Map<DateTime, List<SquareSlotState>> tmpMap = Map();
                Map<DateTime, List<ServiceSlot>> tmpSlotMap = Map();
                tmp = DateTime(tmp.year, tmp.month, 1, 0,0,0,0,0);
                tmp2 = DateTime(tmp2.year, tmp2.month, tmp2.day, 0,0,0,0,0);
                if(tmp2.isAfter(currentDate) || tmp2.isAtSameMomentAs(currentDate)){
                  if(slotTime.isAfter(DateTime.now()) || slotTime.isAtSameMomentAs(DateTime.now())){
                    allMap.putIfAbsent(tmp, () => tmpMap);
                    slotMap.putIfAbsent(tmp, () => tmpSlotMap);
                    debugPrint('RUI_M_service_slot_management => VALUE LENGTH: ${element.free}');
                    if(allMap.containsKey(tmp)){
                      allMap[tmp].putIfAbsent(tmp2, () => []);
                      slotMap[tmp].putIfAbsent(tmp2, () => []);
                      //debugPrint('RUI_M_service_slot_management => KEY: $key');
                      if(allMap[tmp].containsKey(tmp2))
                        allMap[tmp][tmp2].add(element);
                    }
                  }
                }
              });*/

              debugPrint('RUI_M_service_slot_management => ALL MAP SIZE: ${allMap.length}');
              if(allMap.isNotEmpty){
                return CustomScrollView(
                    physics: new ClampingScrollPhysics(),
                    shrinkWrap: true, slivers: [MultiSliver(
                  children: orderHistory(allMap),
                )]);
              }else{
                return Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                  decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).noServiceSlot,
                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      )),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

