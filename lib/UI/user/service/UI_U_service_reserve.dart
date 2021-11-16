import 'dart:async';
import 'dart:math';
import 'package:Buytime/UI/management/service_internal/class/service_slot_classes.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart_reservable.dart';
import 'package:Buytime/UI/user/cart/infopark/UI_U_personal_info_park.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/selected_entry.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/interval_list_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/w_sliver_app_bar_delegate.dart';
import 'package:Buytime/UI/user/service/widget/w_time_slot.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ServiceReserve extends StatefulWidget {
  static String route = '/serviceReserve';
  final ServiceState serviceState;
  bool tourist;
  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<ReserveList>(
      create: (_) => ReserveList([], OrderReservableState().toEmpty(), [], [], [], []),
      child: ServiceReserve(),
    );
  }
  ServiceReserve({@required this.serviceState, this.tourist});

  @override
  createState() => _ServiceReserveState();
}

class _ServiceReserveState extends State<ServiceReserve> with SingleTickerProviderStateMixin {
  ServiceState serviceState;
  //OrderReservableState order = OrderReservableState().toEmpty();

  bool startRequest = false;
  bool noActivity = false;

  String price = '';
  String firstSlot = '';

  @override
  void initState() {
    super.initState();
    serviceState = widget.serviceState;
    debugPrint('UI_U_service_reserve => image: ${serviceState.image1}');
    startRequest = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double tmpPrice;
      debugPrint('UI_U_service_reserve => SLOTS LENGTH: ${widget.serviceState.serviceSlot.length}');
      DateTime currentTime = DateTime.now();
      currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
      widget.serviceState.serviceSlot.forEach((element) {
        DateTime checkOut = DateFormat('dd/MM/yyyy').parse(element.checkOut);
        if (checkOut.isAtSameMomentAs(currentTime) || checkOut.isAfter(currentTime)) {
          //debugPrint('UI_U_service_reserve => VALID: ${element.checkIn}');
          tmpPrice = element.price;
          if (element.price <= tmpPrice) {
            if (element.day != 0) {
              //debugPrint('UI_U_service_reserve => SLOT WITH DAYS');
              if (element.day > 1)
                price = ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).days}';
              else
                price = ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).day}';
            } else {
              //debugPrint('UI_U_service_reserve => SLOT WITHOUT DAYS');
              int tmpMin = element.hour * 60 + element.minute;
              if (tmpMin > 90)
                price = ' ${element.price.toStringAsFixed(0)} / ${element.hour} h ${element.minute} ${AppLocalizations.of(context).spaceMinSpace}';
              else
                price = ' ${element.price.toStringAsFixed(0)} / $tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
            }
          }
        }
      });

      StoreProvider.of<AppState>(context).state.externalBusinessList.externalBusinessListState.forEach((eBL) {
        if (eBL.id_firestore == widget.serviceState.businessId) {
          isExternal = true;
          externalBusinessState = eBL;
        }
      });

    });
  }


  //List<int> dates = [];
  List<DateTime> dates = [];
  List<List<bool>> picked = [];
  List<List<bool>> selectedSlot = [];
  List<List<List<dynamic>>> tmpSlots = [];
  //List<List<List<dynamic>>> slots = [];
  List<List<SelectedEntry>> indexes = [];
  List<SelectedEntry> alreadySelected = [];

  bool isValid(DateTime dateTime, EveryDay everyDay) {
    //String weekdayDate = DateFormat('E d M y').format(dateTime);
    String weekday = DateFormat('E').format(dateTime);

    if ('Mon' == weekday) {
      return everyDay.everyDay[0];
    } else if ('Tue' == weekday) {
      return everyDay.everyDay[1];
    } else if ('Wed' == weekday) {
      return everyDay.everyDay[2];
    } else if ('Thu' == weekday) {
      return everyDay.everyDay[3];
    } else if ('Fri' == weekday) {
      return everyDay.everyDay[4];
    } else if ('Sat' == weekday) {
      return everyDay.everyDay[5];
    } else {
      return everyDay.everyDay[6];
    }
  }

  ///TODO Tourist method
  /*List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate, DateTime userStartDate, DateTime userEndDate, ServiceSlot slot, List<OrderReservableState> reserved) {
    tmpSlots.clear();
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      debugPrint('UI_U_service_reserve => LOOKING DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $userStartDate - IS BEFORE: $userEndDate');
      if(startDate.add(Duration(days: i)).isAfter(userStartDate) && startDate.add(Duration(days: i)).isBefore(userEndDate)){
        debugPrint('UI_U_service_reserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $startDate');
        if(startDate.add(Duration(days: i)).isAfter(startDate) || startDate.add(Duration(days: i)).isAtSameMomentAs(startDate)){
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          debugPrint('UI_U_service_reserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - CURRENT DATE: ${currentTime}');
          if(startDate.add(Duration(days: i)).isAfter(currentTime) || startDate.add(Duration(days: i)).isAtSameMomentAs(currentTime)) {
              //tmpSlots.add(List.generate(slot.startTime.length, (index) => [index, slot]));
               bool isIn = false;
              bool isReserved = false;
              tmpSlots.add([]);
              Map<DateTime, List<int>> limted = Map();
              reserved.forEach((element) {
                debugPrint('UI_U_service_reserve => RESERVED: ${element.date} | ${element.itemList.first.time}');
              });
              reserved.forEach((r) {
                r.itemList.forEach((item) {
                  //debugPrint('UI_U_service_reserve => LOOKING DATE: ${item.date}');
                  if(startDate.add(Duration(days: i)).isAtSameMomentAs(item.date) && !isReserved && slot.startTime.contains(item.time)){
                    debugPrint('UI_U_service_reserve => LOOKED DATE: ${item.date} - RESERVED: ${startDate.add(Duration(days: i))}');
                    for(int j = 0; j < slot.startTime.length; j++) {
                      debugPrint('UI_U_service_reserve => LOOKING TIME: ${slot.startTime[j]} - TIME: ${item.time}');
                      if(isValid(startDate.add(Duration(days: i)), slot.daysInterval[j])){
                        if(slot.startTime[j] == item.time){
                          isReserved = true;
                          debugPrint('UI_U_service_reserve => LOOKED TIME: ${item.time} - RESERVED: ${slot.startTime[j]}');
                        }else{
                          isIn = true;
                          debugPrint('UI_U_service_reserve => VALID FROM RESERVED: ${DateFormat('dd MMMM yyyy').format(startDate.add(Duration(days: i)))} - ${slot.startTime[j]}');
                          tmpSlots.last.add([j, slot]);
                        }
                      }
                    }
                  }
                });
              });

              if(!isReserved){
                //tmpSlots.removeLast();
                //tmpSlots.add(List.generate(slot.startTime.length, (index) => [index, slot]));
                for(int j = 0; j < slot.startTime.length; j++) {
                  //debugPrint('UI_U_service_reserve => LOOKING TIME: ${slot.startTime[j]} - TIME: ${item.time}');
                  if(isValid(startDate.add(Duration(days: i)), slot.daysInterval[j])){
                    debugPrint('UI_U_service_reserve => VALID : ${DateFormat('dd MMMM yyyy').format(startDate.add(Duration(days: i)))} - ${slot.startTime[j]}');
                    isIn = true;
                    tmpSlots.last.add([j, slot]);
                  }
                }
              }
               debugPrint('UI_U_service_reserve => BEFORE | tmpSlots LENGTH: ${tmpSlots.length}');
              if(isIn){
                debugPrint('UI_U_service_reserve => IS IN');
                days.add(startDate.add(Duration(days: i)));
                if(tmpSlots.last.isEmpty)
                  tmpSlots.removeLast();
              }else{
                debugPrint('UI_U_service_reserve => NOT IN');
                tmpSlots.removeLast();
              }
               debugPrint('UI_U_service_reserve => AFTER | tmpSlots LENGTH: ${tmpSlots.length}');

               //days.add(startDate.add(Duration(days: i)));
            }
          //picked.add(List.generate(endDate.difference(startDate).inDays, (index) => false));
          //indexes.add(List.generate(endDate.difference(startDate).inDays, (index) => List.generate(2, (index) => 0)));
        }
      }
    }
    return days;
  }*/

  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate, DateTime userStartDate, DateTime userEndDate, List<SquareSlotState> mySlots, ServiceSlot slot) {
    tmpSlots.clear();
    //debugPrint("UI_U_service_reserve => mySlots - " + mySlots.length.toString());
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      //debugPrint('UI_U_service_reserve => LOOKING DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $userStartDate - IS BEFORE: $userEndDate');
      if ((startDate.add(Duration(days: i)).isAtSameMomentAs(userStartDate) || startDate.add(Duration(days: i)).isAfter(userStartDate)) && startDate.add(Duration(days: i)).isBefore(userEndDate)) {
        //debugPrint('UI_U_service_reserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $startDate');
        if (startDate.add(Duration(days: i)).isAfter(startDate) || startDate.add(Duration(days: i)).isAtSameMomentAs(startDate)) {
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          //debugPrint('UI_U_service_reserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - CURRENT DATE: ${currentTime}');
          if (startDate.add(Duration(days: i)).isAfter(currentTime) || startDate.add(Duration(days: i)).isAtSameMomentAs(currentTime)) {
            days.add(startDate.add(Duration(days: i)));
            tmpSlots.add([]);
            for (int j = 0; j < mySlots.length; j++) {
              if (!first /*&& mySlots[i].visibility*/) {
               // debugPrint('UI_U_service_reserve => FIRST TIME');
                if (mySlots[j].free != 0) {
                  //debugPrint('UI_U_service_reserve => HEREEE => ${mySlots[j].on}');
                  DateTime squareDateFormat = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  //debugPrint('UI_U_service_reserve => DATE: $squareDateFormat');
                  DateTime squareDate = squareDateFormat;
                  squareDate = new DateTime(squareDate.year, squareDate.month, squareDate.day, 0, 0, 0, 0, 0);
                  DateTime squareTime = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  squareTime = new DateTime(squareTime.year, squareTime.month, squareTime.day, int.parse(mySlots[j].on.split(':').first), int.parse(mySlots[j].on.split(':').last), 0, 0, 0);
                  //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                  if (squareDate.isAtSameMomentAs(startDate.add(Duration(days: i))) && squareTime.isAfter(DateTime.now())) {
                    //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                    tmpSlots.last.add([j, slot, mySlots[j]]);
                  }
                }
              } else {
               // debugPrint('UI_U_service_reserve => SECONDS AND OTHERS');
                bool found = false;
                Provider.of<ReserveList>(context, listen: false).order.itemList.forEach((element) {
                  if (element.idSquareSlot == mySlots[j].uid) {
                    found = true;
                 //   debugPrint('UI_U_service_reserve => FOUND SLOT FROM ORDER');
                  }
                });
                if (found) {
                  //debugPrint('UI_U_service_reserve => FROM ORDER');
                  DateTime squareDateFormat = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  //debugPrint('UI_U_service_reserve => DATE: $squareDateFormat');
                  DateTime squareDate = squareDateFormat;
                  squareDate = new DateTime(squareDate.year, squareDate.month, squareDate.day, 0, 0, 0, 0, 0);
                  DateTime squareTime = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  squareTime = new DateTime(squareTime.year, squareTime.month, squareTime.day, int.parse(mySlots[j].on.split(':').first), int.parse(mySlots[j].on.split(':').last), 0, 0, 0);
                  //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                  if (mySlots[j].free != 0){
                    if (squareDate.isAtSameMomentAs(startDate.add(Duration(days: i))) && squareTime.isAfter(DateTime.now())) {
                      //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                      tmpSlots.last.add([j, slot, mySlots[j]]);
                    }
                  }
                } else {
                  DateTime squareDateFormat = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  //debugPrint('UI_U_service_reserve => DATE: $squareDateFormat');
                  DateTime squareDate = squareDateFormat;
                  squareDate = new DateTime(squareDate.year, squareDate.month, squareDate.day, 0, 0, 0, 0, 0);
                  DateTime squareTime = DateFormat("dd/MM/yyyy").parse(mySlots[j].date);
                  squareTime = new DateTime(squareTime.year, squareTime.month, squareTime.day, int.parse(mySlots[j].on.split(':').first), int.parse(mySlots[j].on.split(':').last), 0, 0, 0);
                  if (squareDate.isAtSameMomentAs(startDate.add(Duration(days: i))) && squareTime.isAfter(DateTime.now())) {
                    //debugPrint('UI_U_service_reserve => OUTSIDE SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                    //debugPrint('UI_U_service_reserve => NOT FROM ORDER');
                  }
                  if (mySlots[j].free != 0) {
                    //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                    if (squareDate.isAtSameMomentAs(startDate.add(Duration(days: i))) && squareTime.isAfter(DateTime.now())) {
                      //debugPrint('UI_U_service_reserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                      tmpSlots.last.add([j, slot, mySlots[j]]);
                    }
                  }
                }
              }
            }
            if (tmpSlots.last.isEmpty) {
              tmpSlots.removeLast();
              days.removeLast();
            }
          }
        }
      }
    }
    List<int> addIndexes = [];
    //debugPrint('UI_U_service_reserve => SLOTS LENGTH: ${tmpSlots.length}');
    for (int i = 0; i < tmpSlots.length; i++) {
      //debugPrint('UI_U_service_reserve => SLOT LENGTH: ${tmpSlots[i].length} - INDEX: $i');
      if (tmpSlots[i].isNotEmpty) {
        //debugPrint('UI_U_service_reserve => SLOT: ${element}');
        tmpSlots[i].forEach((sT) {
          //debugPrint('UI_U_service_reserve => START TIME: ${sT[2].startTime} |  STOP TIME: ${sT[2].stopTime}');
        });
      }
      if (tmpSlots[i].length != 0) {
        //debugPrint('UI_U_service_reserve => SLOT LENGTH: ${tmpSlots[i].length} - INDEX TO REMOVE: $i');
        addIndexes.add(i);
      }
    }
    /*List<List<List<dynamic>>> tmp = [];
    addIndexes.forEach((element) {
      tmp.add(tmpSlots[element]);
    });
    tmpSlots = tmp;*/
    if (tmpSlots.isEmpty) {
      //debugPrint('UI_U_service_reserve => SLOTS IS EMPTY');
      //days.removeLast();
    }
    return days;
  }

  void deleteItem(OrderState snapshot, OrderEntry entry) {
    //setState(() {
      //cartCounter = cartCounter - entry.number;
      debugPrint('UI_U_service_reserve => PROVIDE RENTRY NUMBER: ${entry.number}');
      Provider.of<ReserveList>(context, listen: false).order.cartCounter = Provider.of<ReserveList>(context, listen: false).order.cartCounter - 1;
      Provider.of<ReserveList>(context, listen: false).order.itemList.remove(entry);
      Provider.of<ReserveList>(context, listen: false).order.removeReserveItem(entry,context);
      debugPrint('UI_U_service_reserve => PROVIDER ITEM LIST: ${Provider.of<ReserveList>(context, listen: false).order.itemList.length}');
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(Provider.of<ReserveList>(context, listen: false).order));
    //});
  }

  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  SquareSlotState selectedSquareSlot = SquareSlotState().toEmpty();
  List<bool> selectQuantity = [];
  //List<int> slotIndex = [];
  int selectedQuantityNumber = 0;
  //List<List<List<dynamic>>> selectedSquareSlotList = [];
  List<List<List<dynamic>>> tmpSelectedSquareSlotList = [];

  ScrollController _controller = ScrollController();
  //List<List<dynamic>> _controllerList = [];
  //List<List<dynamic>> _slotControllerList = [];

  double scrollPosition = 0.0;
  List<List<bool>> scrollPositionList = [];

  bool first = false;

  BusinessState businessState;
  BookingState bookingState;
  OrderReservableState orderReservableState;
  OrderState orderState;
  UserState userState;

  @override
  void dispose() {
    /*setState(() {
      first = true;
    });*/
    super.dispose();
  }

  Stream<QuerySnapshot> _serviceSnippet;
  List<SquareSlotState> squareSlotList = [];
  SlotListSnippetState slotSnippetListState = SlotListSnippetState(slotListSnippet: []);

  bool reserve = false;
  bool isRestaurant = false;

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    _serviceSnippet = FirebaseFirestore.instance.collection('service')
        .doc(widget.serviceState.serviceId)
        .collection('slotSnippet')
    //.where("date", isLessThanOrEqualTo: sevenDaysFromNow)
        .snapshots();

    SizeConfig().init(context);

    businessState =  StoreProvider.of<AppState>(context).state.business;
    bookingState =  StoreProvider.of<AppState>(context).state.booking;
    orderReservableState =  StoreProvider.of<AppState>(context).state.orderReservable;
    orderState =  StoreProvider.of<AppState>(context).state.order;
    userState =  StoreProvider.of<AppState>(context).state.user;

    debugPrint('UI_U_service_reserve => SERVICE RESERVE HERE');
    slotSnippetListState = SlotListSnippetState(slotListSnippet: []);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.dark,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).reserveSpace + ' ' + Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
              style: TextStyle(
                  fontFamily: BuytimeTheme.FontFamily,
                  color: BuytimeTheme.TextBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
              onPressed: () async{
                FirebaseAnalytics().logEvent(
                    name: 'back_time_slots',
                    parameters: {
                      'user_email': StoreProvider.of<AppState>(context).state.user.email,
                      'date': DateTime.now().toString(),
                    });
                //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(0));
                setState(() {
                  startRequest = true;
                });
                Provider.of<ReserveList>(context, listen: false).clear();
                StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(OrderReservableState().toEmpty()));
                //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: (SizeConfig.safeBlockVertical * 100) - 60),
              child:  StreamBuilder<QuerySnapshot>(
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
                  //slotIndex = List.generate(dates.length, (index) => -1);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<ReserveList>(context, listen: false).initSlotIndex(List.generate(dates.length, (index) => -1));
                  });

                  //slotIndex.clear();
                  //_slotControllerList.clear();
                  //allMap.clear();
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
                  debugPrint("UI_U_service_reserve => slotSnippetListState: ${slotSnippetListState.slotListSnippet.length}");
                  /*squareSlotList.clear();
                  slotSnippetListState.slotListSnippet.forEach((element) {
                    squareSlotList.addAll(element.slot);
                  });*/
                  if (slotSnippetListState.slotListSnippet.isEmpty && startRequest) {
                    noActivity = true;
                    startRequest = false;
                  } else {
                    noActivity = false;
                    dates.clear();
                    Provider.of<ReserveList>(context, listen: false).slots.clear();
                    selectedSlot.clear();
                    picked.clear();
                    //selectQuantity.clear();
                    List<IntervalListState> tmpState = slotSnippetListState.slotListSnippet;
                    //tmpState.addAll();
                    for (int i = 0; i < tmpState.length; i++) {
                      //DateTime tmpStartDate = tmpState[i].slot.first.date;
                      //DateTime tmpEndDate = tmpState[i].slot.last.date;
                      DateTime tmpStartDate = DateFormat('dd/MM/yyyy').parse(widget.serviceState.serviceSlot[i].checkIn);
                      DateTime tmpEndDate = DateFormat('dd/MM/yyyy').parse(widget.serviceState.serviceSlot[i].checkOut);
                      debugPrint('UI_U_service_reserve => START DATE: $tmpStartDate | END DATE: $tmpEndDate');
                      if (dates.isEmpty) {
                        DateTime endDateBoth;
                        DateTime startDateBoth;
                        if (widget.tourist) {
                          startDateBoth = DateTime.now();
                          endDateBoth = DateTime(startDateBoth.year, startDateBoth.month, startDateBoth.day + 14, 0, 0, 0, 0, 0);
                          //endDateBoth = tmpEndDate;
                        } else {
                          startDateBoth = bookingState.start_date;
                          endDateBoth = bookingState.end_date;
                        }

                        dates = getDaysInBeteween(tmpStartDate, tmpEndDate, startDateBoth, endDateBoth, tmpState[i].slot, widget.serviceState.serviceSlot[i]);
                        if (tmpSlots.isNotEmpty) {
                          debugPrint('UI_U_service_reserve => TMP SLOTS FIRST: $tmpSlots');
                          Provider.of<ReserveList>(context, listen: false).slots.addAll(tmpSlots);
                          Provider.of<ReserveList>(context, listen: false).slots.forEach((element) {
                            picked.add(List.generate(element.length, (index) => false));
                            selectedSlot.add(List.generate(element.length, (index) => false));
                            indexes.add(List.generate(element.length, (index) => SelectedEntry(first: 0, last: 0)));
                          });
                        }
                      } else {
                        List<DateTime> tmpDates = getDaysInBeteween(tmpStartDate, tmpEndDate, bookingState.start_date, bookingState.end_date, tmpState[i].slot, widget.serviceState.serviceSlot[i]);
                        debugPrint('UI_U_service_reserve => TMP SLOTS SECOND: $tmpSlots');
                        for (int i = 0; i < dates.length; i++) {
                          for (int j = 0; j < tmpDates.length; j++) {
                            if (dates[i] == tmpDates[j]) {
                              if (tmpSlots[j].isNotEmpty) {
                                Provider.of<ReserveList>(context, listen: false).slots[i].addAll(tmpSlots[j]);
                                picked[i].addAll(List.generate(tmpSlots[j].length, (index) => false));
                                selectedSlot[i].addAll(List.generate(tmpSlots[j].length, (index) => false));
                                indexes[i].addAll(List.generate(tmpSlots[j].length, (index) => SelectedEntry(first: 0, last: 0)));
                              }
                            }
                          }
                        }
                        for (int i = 0; i < tmpDates.length; i++) {
                          if (!dates.contains(tmpDates[i])) {
                            dates.add(tmpDates[i]);
                            if (tmpSlots[i].isNotEmpty) {
                              Provider.of<ReserveList>(context, listen: false).slots.add(tmpSlots[i]);
                              picked.add(List.generate(tmpSlots[i].length, (index) => false));
                              selectedSlot.add(List.generate(tmpSlots[i].length, (index) => false));
                              indexes.add(List.generate(tmpSlots[i].length, (index) => SelectedEntry(first: 0, last: 0)));
                            }
                          }
                        }
                      }
                    }
                    debugPrint('UI_U_service_reserve => AFTER FOR');
                    first = true;

                    /*widget.serviceState.serviceSlot.forEach((element) {
            DateTime tmpStartDate = DateFormat('dd/MM/yyyy').parse(element.checkIn);
            DateTime tmpEndDate = DateFormat('dd/MM/yyyy').parse(element.checkOut);
            if(dates.isEmpty){
              dates = getDaysInBeteween(tmpStartDate, tmpEndDate, snapshot.booking.start_date,  snapshot.booking.end_date, element, snapshot.orderReservableList.orderReservableListState);
              if(tmpSlots.isNotEmpty){
                slots.addAll(tmpSlots);
                slots.forEach((element) {
                  picked.add(List.generate(element.length, (index) => false));
                  selectedSlot.add(List.generate(element.length, (index) => false));
                  indexes.add(List.generate(element.length, (index) => SelectedEntry(first: 0, last: 0)));
                });
              }
            }else{
              List<DateTime> tmpDates = getDaysInBeteween(tmpStartDate, tmpEndDate, snapshot.booking.start_date,  snapshot.booking.end_date, element, snapshot.orderReservableList.orderReservableListState);
              for(int i = 0; i < dates.length; i++){
                for(int j = 0; j < tmpDates.length; j++){
                  if(dates[i] == tmpDates[j]){
                    if(tmpSlots[j].isNotEmpty){
                      slots[i].addAll(tmpSlots[j]);
                      picked[i].addAll(List.generate(tmpSlots[j].length, (index) => false));
                      selectedSlot[i].addAll(List.generate(tmpSlots[j].length, (index) => false));
                      indexes[i].addAll(List.generate(tmpSlots[j].length, (index) => SelectedEntry(first: 0, last: 0)));
                    }
                  }
                }
              }
              for(int i = 0; i < tmpDates.length; i++){
                if(!dates.contains(tmpDates[i])){
                  dates.add(tmpDates[i]);
                  if(tmpSlots[i].isNotEmpty){
                    slots.add(tmpSlots[i]);
                    picked.add(List.generate(tmpSlots[i].length, (index) => false));
                    selectedSlot.add(List.generate(tmpSlots[i].length, (index) => false));
                    indexes.add(List.generate(tmpSlots[i].length, (index) => SelectedEntry(first: 0, last: 0)));
                  }

                }
              }
            }
          });*/

                    Provider.of<ReserveList>(context, listen: false).slots.forEach((element) {
                      element.sort((a, b) => (a[2].on).compareTo(b[2].on));
                    });

                    debugPrint("UI_U_service_reserve => SLOTS LENGTH: ${Provider.of<ReserveList>(context, listen: false).slots.length} ${tmpSlots.length}");

                    /*slots.forEach((element) {
            picked.add(List.generate(element.length, (index) => false));
            selectedSlot.add(List.generate(element.length, (index) => false));
            indexes.add(List.generate(element.length, (index) => SelectedEntry(first: 0, last: 0)));
          });*/

                    if (Provider.of<ReserveList>(context, listen: false).slots.isNotEmpty && Provider.of<ReserveList>(context, listen: false).slots[0] != null && Provider.of<ReserveList>(context, listen: false).slots[0].isNotEmpty) {
                      if (Provider.of<ReserveList>(context, listen: false).slots[0][0][1].day != 0) {
                        if (Provider.of<ReserveList>(context, listen: false).slots[0][0][1].day > 1) {
                          firstSlot = '${Provider.of<ReserveList>(context, listen: false).slots[0][0][1].day} ${AppLocalizations.of(context).days}';
                        } else {
                          firstSlot = '${Provider.of<ReserveList>(context, listen: false).slots[0][0][1].day} ${AppLocalizations.of(context).day}';
                        }
                      } else {
                        int tmpMin = Provider.of<ReserveList>(context, listen: false).slots[0][0][1].hour * 60 + Provider.of<ReserveList>(context, listen: false).slots[0][0][1].minute;
                        if (tmpMin > 90)
                          firstSlot = '${Provider.of<ReserveList>(context, listen: false).slots[0][0][1].hour} h ${Provider.of<ReserveList>(context, listen: false).slots[0][0][1].minute} ${AppLocalizations.of(context).spaceMinSpace}';
                        else
                          firstSlot = '$tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
                      }
                    }

                    if (selectQuantity.isEmpty) {
                      selectQuantity = List.generate(dates.length, (index) => false);
                      //slotIndex = List.generate(dates.length, (index) => -1);
                      scrollPositionList = List.generate(dates.length, (index) => List.generate(Provider.of<ReserveList>(context, listen: false).slots[index].length, (index) => false));
                      //selectedSquareSlotList = List.generate(dates.length, (index) => []);
                      tmpSelectedSquareSlotList = List.generate(dates.length, (index) => []);
                      //_controllerList = List.generate(dates.length, (index) => [0, ItemScrollController()]);
                      //_slotControllerList = List.generate(dates.length, (index) => [0, ItemScrollController()]);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(List.generate(dates.length, (index) => []));
                        Provider.of<ReserveList>(context, listen: false).initSlotIndex(List.generate(dates.length, (index) => -1));
                        Provider.of<ReserveList>(context, listen: false).initControllerList(List.generate(dates.length, (index) => [0, ItemScrollController()]));
                        Provider.of<ReserveList>(context, listen: false).initSlotControllerList(List.generate(dates.length, (index) => [0, ItemScrollController()]));
                      });
                      debugPrint('UI_U_service_reserve => DATES LENGTH: ${dates.length} | BOOL LENGTH: ${selectQuantity.length}');
                    }
                  }

                  //order = orderReservableState.itemList != null ? (orderReservableState.itemList.length > 0 ? orderReservableState : OrderReservableState().toEmpty()) : OrderReservableState().toEmpty();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<ReserveList>(context, listen: false).initOrder(orderReservableState.itemList != null ? (orderReservableState.itemList.length > 0 ? orderReservableState : OrderReservableState().toEmpty()) : OrderReservableState().toEmpty());
                  });
                  //int start = int.parse(widget.serviceState.serviceSlot.first.checkIn.substring(0,2));
                  //int end = int.parse(widget.serviceState.serviceSlot.first.checkOut.substring(0,2));

                  ///First try
                  /*if(order.itemList.isNotEmpty){
          debugPrint('UI_U_service_reserve => ORDER NOT EMPTY');
          for(int i = 0; i < order.itemList.length; i++){
            for(int j = 0; j < dates.length; j++){
                if(order.itemList[i].date == dates[j]){
                  for(int k = 0; k < picked[j].length; k++){
                    if(order.itemList[i].time == widget.serviceState.serviceSlot.first.startTime[k]){
                      debugPrint("UI_U_service_reserve => $i TIME: ${order.itemList[i].time}");
                      debugPrint("UI_U_service_reserve => $i DATE: ${order.itemList[i].date}");
                      picked[j][k] = true;
                    }
                  }
                }
            }
          }
        }*/

                  ///Second try
                  /*order.selected.forEach((element) {
          debugPrint('UI_U_service_reserve => SELECTED INDEXES: $element');
          //picked[element[0]][element[1]] = true;
        });*/

                  ///Third try
                  List<dynamic> idk = [];
                  tmpSelectedSquareSlotList = List.generate(dates.length, (index) => []);
                  for (int i = 0; i < picked.length; i++) {
                    for (int j = 0; j < picked[i].length; j++) {
                      bool found = false;
                      Provider.of<ReserveList>(context, listen: false).order.selected.forEach((element) {
                        if (i == element.first && j == element.last) {
                          found = true;
                        }
                      });
                      if (found) {
                        picked[i][j] = true;
                        for (int k = 0; k < Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[i].length; k++) {
                          if (Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[i][k][1].uid == Provider.of<ReserveList>(context, listen: false).slots[i][j][2].uid) {
                            if (!idk.contains([i, k])) {
                              debugPrint('UI_U_service_reserve => FOUND TRUE: $i $k');
                              idk.add([i, k]);
                            }
                          }
                        }
                        //selectedSquareSlotList[i].removeAt(mSQQIndex);
                      } else
                        picked[i][j] = false;
                    }
                  }
                  //_controllerList = List.generate(dates.length, (index) => [ItemScrollController(initialScrollOffset: scrollPositionList[index])]);
                  idk.forEach((element) {
                    tmpSelectedSquareSlotList[element[0]].add(Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]]);
                    debugPrint('UI_U_service_reserve => FREE: ${Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]]}');
                    debugPrint('UI_U_service_reserve => FREE TMP: ${tmpSelectedSquareSlotList[element[0]]}');
                    if (tmpSelectedSquareSlotList[element[0]].length > 1) {
                      //debugPrint("UI_U_service_reserve => JUMP TO: QUANTITY: ${_controllerList[element[0]][0]}");
                      //debugPrint("UI_U_service_reserve => JUMP TO: SLOT: ${_slotControllerList[element[0]][0]}");
                      //_controllerList[element[0]][1].scrollTo(index: selectedSquareSlotList[element[0]].length-1, duration: Duration(milliseconds: 500));
                      //_slotControllerList[element[0]][1].scrollTo(index: _slotControllerList[element[0]][0], duration: Duration(milliseconds: 500));
                      //slotIndex[element[0]] = _slotControllerList[element[0]][0];
                      //_controller.initialScrollOffset;
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      debugPrint('UI_U_service_reserve => UPDATE');
                      Provider.of<ReserveList>(context, listen: false).updateSlotIndex(element[0], Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]][2]);
                      Provider.of<ReserveList>(context, listen: false).updateControllerList(element[0], 0, Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]][2]);
                      Provider.of<ReserveList>(context, listen: false).updateSlotControllerList(element[0], 0, Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]][2]);
                      Provider.of<ReserveList>(context, listen: false)._controllerList[element[0]][1].jumpTo(index: Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]][2]);
                      Provider.of<ReserveList>(context, listen: false)._slotControllerList[element[0]][1].jumpTo(index: Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[element[0]][element[1]][2]);
                    });

                  });
                  //selectedSquareSlotList.clear();
                  //selectedSquareSlotList = tmpSelectedSquareSlotList;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(tmpSelectedSquareSlotList);
                  });

                  if (Provider.of<ReserveList>(context, listen: false).order.itemList.isEmpty){
                    //slotIndex = List.generate(dates.length, (index) => -1);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Provider.of<ReserveList>(context, listen: false).initSlotIndex(List.generate(dates.length, (index) => -1));
                    });
                  }

                  /*_controllerList.forEach((element) {
          //ScrollController().initialScrollOffset
          element[1].jumpTo(element[0]);
        });*/

                  debugPrint("UI_U_service_reserve => CART COUNT: ${Provider.of<ReserveList>(context, listen: false).order.cartCounter}");
                  debugPrint('UI_U_service_reserve => PICKED: ${picked.length} - $picked');
                  debugPrint('UI_U_service_reserve => SELECTED: ${selectedSlot}');
                  debugPrint('UI_U_service_reserve => SELECT QUANTITY: ${selectQuantity}');
                  //isRestaurant = true;
                  //debugPrint('UI_U_service_reserve => INTERVAL SLOTS LENGTH: ${widget.serviceState.serviceSlot.first.startTime.length}');
                  return Consumer<ReserveList>(
                    builder: (_, reserveState, child) {
                      if(reserveState.selectedSquareSlotList.isNotEmpty && reserveState.selectedSquareSlotList.first.isNotEmpty)
                        debugPrint('UI_U_service_reserve => FREE ON BUILD: ${reserveState.selectedSquareSlotList.first.first.first} - ${reserveState.selectedSquareSlotList.first.first[1].free}');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /*///Service subtitle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                child: Text(
                                  Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) ?? AppLocalizations.of(context).serviceName,
                                  style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              )
                            ],
                          ),

                          ///Price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                child: Text(
                                  AppLocalizations.of(context).startingFromCurrency,
                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                child: Text(
                                  price,
                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w600, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              )
                            ],
                          ),*/

                          ///Availability text
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                child: Text(
                                  AppLocalizations.of(context).availabilityDuringYourStay,
                                  style: TextStyle(letterSpacing: 1.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w600, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              )
                            ],
                          ),*/

                          ///Next available time
                          /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 2.5),
                            child: Text(
                              AppLocalizations.of(context).nextAvailableTime,
                              style: TextStyle(
                                //letterSpacing: 1.25,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14

                                ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),

                          ///First slot
                          noActivity
                              ? Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockVertical * 2),
                              //width: 179,
                              height: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              ),
                            ),
                          )
                              : Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockVertical * 2),
                            width: 150,
                            height: 120,
                            decoration: BoxDecoration(
                              color: BuytimeTheme.BackgroundLightBlue.withOpacity(.2),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: dates.isNotEmpty
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///Date
                                Container(
                                  width: 179,
                                  //margin: EdgeInsets.only(top: 15),
                                  //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      DateFormat('MMM dd').format(DateTime.now()).toUpperCase() == DateFormat('MMM dd').format(dates[0]).toUpperCase() ? AppLocalizations.of(context).today.replaceFirst(',', '').toUpperCase() : Utils.capitalize(DateFormat('EEEE',Localizations.localeOf(context).languageCode).format(dates[0])),
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),

                                ///Time
                                Container(
                                  width: 179,
                                  //margin: EdgeInsets.only(top: 15),
                                  //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${slots[0][0][2].on}',
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: widget.tourist ? BuytimeTheme.SymbolMalibu : BuytimeTheme.UserPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),

                                ///Duration
                                Container(
                                  width: 179,
                                  //margin: EdgeInsets.only(top: 5),
                                  //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      firstSlot,
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),

                                ///Price
                                Container(
                                  width: 179,
                                  //margin: EdgeInsets.only(top: 5),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '${AppLocalizations.of(context).currency} ' + slots[0][0][1].price.toStringAsFixed(2),
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ///Nothing
                                Container(
                                  width: 179,
                                  //margin: EdgeInsets.only(top: 15),
                                  //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).noServiceFound,
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: widget.tourist ? BuytimeTheme.SymbolMalibu : BuytimeTheme.UserPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),*/

                          ///Blue part & Time Slots
                          noActivity
                              ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            ),
                          )
                              : dates.isNotEmpty ?
                          Expanded(
                              flex: 5,
                              child: Padding(
                                padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                                child: CustomScrollView(shrinkWrap: true, slivers: [
                                  /*SliverPersistentHeader(
                                pinned: true,
                                delegate: CustomSliverAppBarDelegate(
                                  minHeight: 20,
                                  maxHeight: 20,
                                  child: ///Blue part
                                  Container(
                                    color: BuytimeTheme.UserPrimary,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                          child: Text(
                                            '0',//index == 0 ? AppLocalizations.of(context).today + date : index == 1 ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE').format(i).toUpperCase()}, $date',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              letterSpacing: 1.25,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextWhite,
                                              fontSize: 14, /// SizeConfig.safeBlockHorizontal * 4
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                        //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                        DateTime i = dates.elementAt(index);
                                        ///TODO: Controllare che localization non dia problemi con controlli
                                        String date = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(i).toUpperCase();
                                        String currentDate = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(DateTime.now()).toUpperCase();
                                        String nextDate = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(DateTime.now().add(Duration(days: 1))).toUpperCase();

                                        debugPrint('UI_U_service_reserve => DATES: $i - $currentDate - $nextDate');
                                        List<bool> select = picked.elementAt(index);
                                        //isRestaurant = true;
                                        return Column(
                                          children: [
                                            ///Blue part
                                            Container(
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: BuytimeTheme.TextWhite,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: BuytimeTheme.SymbolMalibu,
                                                    width: 2
                                                  )
                                                )
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                                    child: Text(
                                                      index == 0 && currentDate == date
                                                          ? AppLocalizations.of(context).today + ' ' + date
                                                          : index == 1 && nextDate == date
                                                          ? AppLocalizations.of(context).tomorrow + date
                                                          : '${DateFormat('EEEE', Localizations.localeOf(context).languageCode).format(i).toUpperCase()}, $date',
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        letterSpacing: 1.25,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.SymbolMalibu,
                                                        fontSize: 14,

                                                        /// SizeConfig.safeBlockHorizontal * 4
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),

                                            ///Time slot
                                            /*Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5, bottom: SizeConfig.safeBlockVertical * 1.5),
                                          height: 110,
                                          width: SizeConfig.safeBlockHorizontal * 100,
                                          child: CustomScrollView(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              slivers: [
                                            SliverList(
                                              delegate: SliverChildBuilderDelegate((context, i) {
                                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                                //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                                List<dynamic> serviceSlot = slots[index].elementAt(i);
                                                //debugPrint('UI_U_service_reserve => INDEX: $index | I: $i | SQUARE TIME: ${serviceSlot[2].startTime}');
                                                indexes[index][i].first = index;
                                                indexes[index][i].last = i;
                                                SelectedEntry selected = SelectedEntry(first: index, last: i);
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ///Slot
                                                    Container(
                                                      margin: EdgeInsets.only(top: 2, bottom: 2, right: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockVertical * 2),
                                                      child: Container(
                                                          width: 100,
                                                          height: 100,
                                                          decoration: BoxDecoration(
                                                            color:  BuytimeTheme.BackgroundWhite,
                                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                                            border: Border.all(
                                                                color: select[i] ? ( widget.tourist ? BuytimeTheme.SymbolMalibu.withOpacity(0.5) : BuytimeTheme.UserPrimary.withOpacity(0.5)) : BuytimeTheme.BackgroundWhite
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: select[i] ? BuytimeTheme.BackgroundWhite : BuytimeTheme.BackgroundBlack.withOpacity(0.3),
                                                                spreadRadius: .5,
                                                                blurRadius: 1,
                                                                offset: Offset(0, select[i] ? 0 : 1), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                onTap: !selectedSlot[index][i] ? () async {
                                                                  setState(() {
                                                                    //selectQuantity = List.generate(dates.length, (index) => false);
                                                                    select[i] = !select[i];
                                                                    selectQuantity[index] = select[i];
                                                                    scrollPositionList[index][i] = select[i];
                                                                    if(select[i]){
                                                                      selectedSquareSlot = serviceSlot[2];
                                                                      selectedQuantityNumber = selectedSquareSlot.maxAvailablePlace - selectedSquareSlot.availablePlaces;
                                                                      debugPrint('UI_U_service_reserve => SELECTED SLOT: ${selectQuantity[index]}');
                                                                      selectedSquareSlotList[index].add([selectedQuantityNumber, selectedSquareSlot]);
                                                                      debugPrint('UI_U_service_reserve => SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
                                                                    }else{
                                                                      serviceSlot[2].availablePlaces = serviceSlot[2].maxAvailablePlace;
                                                                      selectedQuantityNumber = serviceSlot[2].maxAvailablePlace - serviceSlot[2].availablePlaces;
                                                                      int mSQQIndex = 0;
                                                                      debugPrint('UI_U_service_reserve => SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
                                                                      for(int j = 0; j < selectedSquareSlotList[index].length; j++){
                                                                        if(selectedSquareSlotList[index][j][1].slotId == serviceSlot[2].slotId){
                                                                          mSQQIndex = j;
                                                                        }
                                                                      }
                                                                      selectedSquareSlotList[index].removeAt(mSQQIndex);
                                                                    }
                                                                  });
                                                                  if(select[i]){
                                                                    String duration = '';
                                                                    //debugPrint('UI_U_service_reserve => TIMESTAMP: ${Timestamp.fromDate(serviceSlot[2].date)}');
                                                                    if(serviceSlot[1].day != 0){
                                                                      if(serviceSlot[1].day > 1){
                                                                        duration = '${serviceSlot[1].day} ${AppLocalizations.of(context).days}';
                                                                      }else{
                                                                        duration = '${serviceSlot[1].day} ${AppLocalizations.of(context).day}';
                                                                      }
                                                                    }else{
                                                                      int tmpMin = serviceSlot[1].hour * 60 + serviceSlot[1].minute;
                                                                      if(tmpMin > 90)
                                                                        duration = '${serviceSlot[1].hour} h ${serviceSlot[1].minute} ${AppLocalizations.of(context).min}';
                                                                      else
                                                                        duration = '$tmpMin ${AppLocalizations.of(context).min}';
                                                                    }
                                                                    order.serviceId = widget.serviceState.serviceId;
                                                                    if(isExternal){
                                                                      order.business.name = externalBusinessState.name;
                                                                      order.business.id = externalBusinessState.id_firestore;
                                                                    }else{
                                                                      order.business.name = snapshot.business.name;
                                                                      order.business.id = snapshot.business.id_firestore;
                                                                    }
                                                                    order.user.name = snapshot.user.name; order.user.email = snapshot.user.email;
                                                                    order.user.id = snapshot.user.uid;
                                                                    order.addReserveItem(widget.serviceState, snapshot.business.ownerId, serviceSlot[2].startTime, duration, dates[index], serviceSlot[2].price, serviceSlot[2].slotId);
                                                                    order.selected.add(indexes[index][i]);
                                                                    //order.selected.add(selected);
                                                                    order.cartCounter++;
                                                                    //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                                    StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(order));
                                                                  }
                                                                  else{
                                                                    OrderEntry tmp;

                                                                    order.itemList.forEach((element) {
                                                                      DateTime tmpDate = dates[index];
                                                                      tmpDate = DateTime(dates[index].year, dates[index].month, dates[index].day, int.parse(element.time.split(':').first), int.parse(element.time.split(':').last));
                                                                      if(element.time ==  serviceSlot[2].startTime && element.date.isAtSameMomentAs(tmpDate)){
                                                                        tmp = element;
                                                                        debugPrint('UI_U_service_reserve => ENTRY: ${element.id_business}');
                                                                      }
                                                                    });
                                                                    //debugPrint('UI_U_service_reserve => ENTRY: ${tmp.id_business}');
                                                                    order.selected.remove(indexes[index][i]);
                                                                    //order.selected.remove(selected);
                                                                    deleteItem(snapshot.order, tmp);
                                                                  }

                                                                  debugPrint('UI_U_service_reserve => SELECTED INDEXES: ${order.selected}');
                                                                } : null,
                                                                child: TimeSlotWidget(serviceSlot[1], serviceSlot[2], serviceSlot[0], select[i]),
                                                              )
                                                          )
                                                      ),
                                                    ),
                                                    scrollPositionList[index][i] ?
                                                    Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      height: 1,
                                                      width: 80,
                                                      color: BuytimeTheme.UserPrimary,
                                                    ) : Container()
                                                  ],
                                                );
                                              },
                                                childCount: slots[index].length,
                                              ),
                                            ),
                                          ]),
                                        ),*/
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5, bottom: SizeConfig.safeBlockVertical * 0),
                                              height: !isRestaurant ? 110 : 80,
                                              width: SizeConfig.safeBlockHorizontal * 100,
                                              child: ScrollablePositionedList.builder(
                                                  itemCount: reserveState.slots[index].length,
                                                  itemScrollController: reserveState._slotControllerList.isNotEmpty ? reserveState._slotControllerList[index][1] : ItemScrollController(),
                                                  //physics: NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  itemBuilder: (context, i) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                    //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                                    List<dynamic> serviceSlot = reserveState.slots[index].elementAt(i);
                                                    //debugPrint('UI_U_service_reserve => INDEX: $index | I: $i | SQUARE TIME: ${serviceSlot[2].startTime}');
                                                    indexes[index][i].first = index;
                                                    indexes[index][i].last = i;
                                                    SelectedEntry selected = SelectedEntry(first: index, last: i);
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ///Slot
                                                        Container(
                                                          margin: EdgeInsets.only(top: 0, bottom: 0, right: SizeConfig.safeBlockVertical * 0, left: SizeConfig.safeBlockVertical * 2),
                                                          child: Container(
                                                              width: 100,
                                                              height: !isRestaurant ? 100 : 70,
                                                              decoration: BoxDecoration(
                                                                color: BuytimeTheme.BackgroundWhite,
                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                border: Border.all(color: select[i] ? (BuytimeTheme.SymbolMalibu) : BuytimeTheme.BackgroundWhite, width: 1.5),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: select[i] ? BuytimeTheme.BackgroundWhite : BuytimeTheme.BackgroundBlack.withOpacity(0.3),
                                                                    spreadRadius: .5,
                                                                    blurRadius: 1,
                                                                    offset: Offset(0, select[i] ? 0 : 1), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Material(
                                                                  color: Colors.transparent,
                                                                  child: InkWell(
                                                                    key: Key('service_slot_${index}_${i}_key'),
                                                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                    onTap: !selectedSlot[index][i]
                                                                        ? () async {
                                                                      //setState(() {
                                                                        //selectQuantity = List.generate(dates.length, (index) => false);
                                                                        select[i] = !select[i];
                                                                        selectQuantity[index] = select[i];
                                                                        scrollPositionList[index][i] = select[i];
                                                                        if (select[i]) {
                                                                          FirebaseAnalytics().logEvent(
                                                                              name: 'slot_choice_time_slots',
                                                                              parameters: {
                                                                                'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                                                                'date': date,
                                                                                'service_name': widget.serviceState.name,
                                                                                'slot_time': serviceSlot[2].on,
                                                                              });
                                                                          //slotIndex[index] = i;
                                                                          Provider.of<ReserveList>(context, listen: false).updateSlotIndex(index, i);
                                                                          //_slotControllerList[index][0] = i;
                                                                          selectedSquareSlot = serviceSlot[2];
                                                                          //selectedQuantityNumber = selectedSquareSlot.max - selectedSquareSlot.free;
                                                                          if (selectedQuantityNumber == 0) selectedQuantityNumber = 1;

                                                                          selectedSquareSlot.free -= 1;
                                                                          //selectedSquareSlot.free -= selectedQuantityNumber;

                                                                          debugPrint('UI_U_service_reserve => SELECTED SLOT: ${selectQuantity[index]}');
                                                                          reserveState.selectedSquareSlotList[index].add([selectedQuantityNumber, selectedSquareSlot, i, serviceSlot[1]]);
                                                                          //reserveState.selectedSquareSlotList[index].add([selectedQuantityNumber, selectedSquareSlot, i+1, serviceSlot[1]]);
                                                                          Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(reserveState.selectedSquareSlotList);
                                                                          //_controllerList[index][0] = selectedSquareSlotList[index].length - 1;
                                                                          Provider.of<ReserveList>(context, listen: false).updateControllerList(index, 0, reserveState.selectedSquareSlotList[index].length - 1);
                                                                          /*reserveState.selectedSquareSlotList[index].removeLast();
                                                                          Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(reserveState.selectedSquareSlotList);*/
                                                                          //Provider.of<ReserveList>(context, listen: false).updateSlotControllerList(index, 0, reserveState.selectedSquareSlotList[index].length - 1);
                                                                          debugPrint('UI_U_service_reserve => QUANTITY SLOT: ${reserveState._controllerList[index][0]}');
                                                                          if (reserveState.selectedSquareSlotList[index].length > 1) {
                                                                            debugPrint('UI_U_service_reserve => MOVE TO');
                                                                            reserveState._controllerList[index][1].scrollTo(index: reserveState._controllerList[index][0], duration: Duration(milliseconds: 500));

                                                                            //Provider.of<ReserveList>(context, listen: false)._slotControllerList[index][1].scrollTo(index: i, duration: Duration(milliseconds: 500));
                                                                          }
                                                                          debugPrint('UI_U_service_reserve => SELECTED SLOT LIST: ${reserveState.selectedSquareSlotList[index].length}');
                                                                        } else {
                                                                          FirebaseAnalytics().logEvent(
                                                                              name: 'slot_remove_time_slots',
                                                                              parameters: {
                                                                                'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                                                                'date': date,
                                                                                'service_name': widget.serviceState.name,
                                                                                'slot_time': serviceSlot[2].on,
                                                                              });
                                                                          serviceSlot[2].free = serviceSlot[2].max;
                                                                          selectedQuantityNumber = serviceSlot[2].max - serviceSlot[2].free;
                                                                          int mSQQIndex = 0;
                                                                          debugPrint('UI_U_service_reserve => SELECTED SLOT LIST: ${reserveState.selectedSquareSlotList[index].length}');
                                                                          for (int j = 0; j < reserveState.selectedSquareSlotList[index].length; j++) {
                                                                            if (reserveState.selectedSquareSlotList[index][j][1].uid == serviceSlot[2].uid) {
                                                                              mSQQIndex = j;
                                                                            }
                                                                          }
                                                                          reserveState.selectedSquareSlotList[index].removeAt(mSQQIndex);
                                                                          Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(reserveState.selectedSquareSlotList);
                                                                          if (reserveState.selectedSquareSlotList[index].isNotEmpty) {
                                                                            //slotIndex[index] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                            Provider.of<ReserveList>(context, listen: false).updateSlotIndex(index, reserveState.selectedSquareSlotList[index][reserveState.selectedSquareSlotList[index].length - 1][2]);
                                                                            //slotIndex[index] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                            //_slotControllerList[index][0] = selectedSquareSlotList[index][mSQQIndex - 1][2];
                                                                            //_controllerList[index][0] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                            /*slotIndex[index] = selectedSquareSlotList[index][0][2];
                                                                       _slotControllerList[index][0] = selectedSquareSlotList[index][0][2];
                                                                       _controllerList[index][0] = selectedSquareSlotList[index][0][2];*/
                                                                          } else {
                                                                            //slotIndex[index] = -1;
                                                                            Provider.of<ReserveList>(context, listen: false).updateSlotIndex(index, -1);
                                                                            //_slotControllerList[index][0] = -1;
                                                                            Provider.of<ReserveList>(context, listen: false).updateSlotControllerList(index, 0, -1);
                                                                          }
                                                                        }
                                                                      //});
                                                                      if (select[i]) {
                                                                        String duration = '';
                                                                        //debugPrint('UI_U_service_reserve => TIMESTAMP: ${Timestamp.fromDate(serviceSlot[2].date)}');
                                                                        if (serviceSlot[1].day != 0) {
                                                                          if (serviceSlot[1].day > 1) {
                                                                            duration = '${serviceSlot[1].day} ${AppLocalizations.of(context).days}';
                                                                          } else {
                                                                            duration = '${serviceSlot[1].day} ${AppLocalizations.of(context).day}';
                                                                          }
                                                                        } else {
                                                                          int tmpMin = serviceSlot[1].hour * 60 + serviceSlot[1].minute;
                                                                          if (tmpMin > 90)
                                                                            duration = '${serviceSlot[1].hour} h ${serviceSlot[1].minute} ${AppLocalizations.of(context).min}';
                                                                          else
                                                                            duration = '$tmpMin ${AppLocalizations.of(context).min}';
                                                                        }
                                                                        reserveState.order.serviceId = widget.serviceState.serviceId;
                                                                        if (isExternal) {
                                                                          reserveState.order.business.name = externalBusinessState.name;
                                                                          reserveState.order.business.id = externalBusinessState.id_firestore;
                                                                        } else {
                                                                          reserveState.order.business.name = businessState.name;
                                                                          reserveState.order.business.id = businessState.id_firestore;
                                                                        }
                                                                        reserveState.order.user.name = userState.name;
                                                                        reserveState.order.user.id = userState.uid;
                                                                        reserveState.order.user.email = userState.email;
                                                                        reserveState.order.addReserveItem(widget.serviceState, businessState.ownerId, serviceSlot[2].on, duration, dates[index], serviceSlot[1].price, serviceSlot[2].uid, context);
                                                                        reserveState.order.selected.add(indexes[index][i]);
                                                                        //order.selected.add(selected);
                                                                        reserveState.order.cartCounter++;
                                                                        //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                                        Provider.of<ReserveList>(context, listen: false).updateOrder(reserveState.order);
                                                                        StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(reserveState.order));
                                                                      } else {
                                                                        OrderEntry tmp;

                                                                        reserveState.order.itemList.forEach((element) {
                                                                          DateTime tmpDate = dates[index];
                                                                          tmpDate = DateTime(dates[index].year, dates[index].month, dates[index].day, int.parse(element.time.split(':').first), int.parse(element.time.split(':').last));
                                                                          if (element.time == serviceSlot[2].on && element.date.isAtSameMomentAs(tmpDate)) {
                                                                            tmp = element;
                                                                            debugPrint('UI_U_service_reserve => ENTRY: ${element.id_business}');
                                                                          }
                                                                        });
                                                                        //debugPrint('UI_U_service_reserve => ENTRY: ${tmp.id_business}');
                                                                        reserveState.order.selected.remove(indexes[index][i]);
                                                                        //order.selected.remove(selected);
                                                                        deleteItem(orderState, tmp);
                                                                      }

                                                                      debugPrint('UI_U_service_reserve => SELECTED INDEXES: ${reserveState.order.selected}');
                                                                    }
                                                                        : null,
                                                                    child: TimeSlotWidget(serviceSlot[1], serviceSlot[2], serviceSlot[0], select[i], isRestaurant),
                                                                  ))),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top: 5, left: SizeConfig.safeBlockVertical * 2),
                                                          height: 1,
                                                          width: 80,
                                                          color: reserveState.slotIndex.isNotEmpty && reserveState.slotIndex[index] == i ? BuytimeTheme.SymbolMalibu : BuytimeTheme.BackgroundWhite,
                                                        )
                                                      ],
                                                    );
                                                  }),
                                            ),

                                            ///Max Quantity
                                            //selectQuantity[index]
                                            reserveState.selectedSquareSlotList.isNotEmpty ?
                                            Container(
                                              margin: EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 5),
                                              height: reserveState.selectedSquareSlotList[index].isNotEmpty ? 100 : 0,
                                              width: SizeConfig.safeBlockHorizontal * 100,
                                              child: ScrollablePositionedList.builder(
                                                //reverse: true,
                                                  itemCount: reserveState.selectedSquareSlotList[index].length + 1,
                                                  itemScrollController: reserveState._controllerList.isNotEmpty ? reserveState._controllerList[index][1] : ItemScrollController(),
                                                  physics: NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  //initialScrollIndex: selectedSquareSlotList[index].length - 1,
                                                  itemBuilder: (context, i) {
                                                    //debugPrint('UI_U_service_reserve => i OUT: $i - ${reserveState.selectedSquareSlotList[index].length}');
                                                    if(i < reserveState.selectedSquareSlotList[index].length){
                                                      //debugPrint('UI_U_service_reserve => i IN: $i - ${reserveState.selectedSquareSlotList[index].length}');
                                                      SquareSlotState mySSS = reserveState.selectedSquareSlotList[index].elementAt(i)[1];
                                                      ServiceSlot tmpService = reserveState.selectedSquareSlotList[index].elementAt(i)[3];
                                                      debugPrint('UI_U_service_reserve => INDEX: $index - QUANTITY INDEXES: ${reserveState.selectedSquareSlotList[index].length} '
                                                          '- FREE: ${Provider.of<ReserveList>(context, listen: false).selectedSquareSlotList[index][i][1].free} '
                                                          '- FREE RESERVE STATE: ${reserveState.selectedSquareSlotList[index][i][1].free} '
                                                          '- FREE MYSSS: ${mySSS.free}');
                                                      return Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          ///Left
                                                          i != 0
                                                              ? Container(
                                                            height: 100,
                                                            width: 24,
                                                            decoration: BoxDecoration(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              color: BuytimeTheme.SymbolMalibu.withOpacity(.1),
                                                            ),
                                                            child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                onTap: () {
                                                                  int jump = i;
                                                                  --jump;
                                                                  debugPrint('UI_U_service_reserve => JUMP: $jump');

                                                                  //_controllerList[index][0] = jump;
                                                                  Provider.of<ReserveList>(context, listen: false).updateControllerList(index, 0, jump);
                                                                  reserveState._controllerList[index][1].scrollTo(index: jump, duration: Duration(milliseconds: 500));
                                                                  //_slotControllerList[index][0] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  Provider.of<ReserveList>(context, listen: false).updateSlotControllerList(index, 0, reserveState.selectedSquareSlotList[index].elementAt(jump)[2]);
                                                                  reserveState._slotControllerList[index][1].scrollTo(index: reserveState.selectedSquareSlotList[index].elementAt(jump)[2], duration: Duration(milliseconds: 500));
                                                                  //slotIndex[index] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  Provider.of<ReserveList>(context, listen: false).updateSlotIndex(index, reserveState.selectedSquareSlotList[index].elementAt(jump)[2]);

                                                                },
                                                                child: Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  child: Icon(
                                                                    Icons.keyboard_arrow_left,
                                                                    color: BuytimeTheme.SymbolMalibu,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : Container(),

                                                          ///Text
                                                          Flexible(
                                                            child: Container(
                                                              //color: Colors.black,
                                                              alignment: Alignment.center,
                                                              margin: EdgeInsets.only(left: 20, top: 24, right: 20),
                                                              height: 100,
                                                              width: i != 0 && i != reserveState.selectedSquareSlotList[index].length - 1
                                                                  ? SizeConfig.screenWidth - 40 - 24 - 24 - 10
                                                                  : i != 0
                                                                  ? SizeConfig.screenWidth - 40 - 24 - 10
                                                                  : i != reserveState.selectedSquareSlotList[index].length - 1
                                                                  ? SizeConfig.screenWidth - 40 - 24 - 10
                                                                  : SizeConfig.screenWidth - 40 - 10,
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ///Number
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      ///Text
                                                                      Container(
                                                                        child: Text(
                                                                          AppLocalizations.of(context).numberOfPeople,
                                                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 16, fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),

                                                                      ///Icons
                                                                      Row(
                                                                        children: [
                                                                          ///Remove
                                                                          Container(
                                                                            height: 24,
                                                                            width: 24,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color:  BuytimeTheme.SymbolMalibu.withOpacity(.1)),
                                                                            child: Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                                onTap: reserveState.selectedSquareSlotList[index].elementAt(i)[0] > 1 && mySSS.free < mySSS.max
                                                                                    ? () {
                                                                                  //setState(() {
                                                                                  reserveState.slots[index].forEach((el2) {
                                                                                    if (el2[2].uid == mySSS.uid) {
                                                                                      el2[2].free += 1;
                                                                                      if(reserve)
                                                                                        mySSS.free += 1;
                                                                                      reserveState.selectedSquareSlotList[index].elementAt(i)[0] -= 1;
                                                                                    }
                                                                                  });
                                                                                  Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(reserveState.selectedSquareSlotList);
                                                                                  Provider.of<ReserveList>(context, listen: false).initSlot(reserveState.slots);
                                                                                  reserveState.order.total = 0;
                                                                                  reserveState.order.itemList.forEach((element) {
                                                                                    if (element.idSquareSlot == mySSS.uid) {
                                                                                      element.orderCapacity = reserveState.selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.price = tmpService.price * reserveState.selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.number -= 1;
                                                                                    }
                                                                                    reserveState.order.total += element.price;
                                                                                    reserveState.order.total -= (reserveState.order.totalPromoDiscount / reserveState.order.itemList.length);

                                                                                  });
                                                                                  Provider.of<ReserveList>(context, listen: false).updateOrder(reserveState.order);
                                                                                  //});
                                                                                }
                                                                                    : null,
                                                                                child: Container(
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                  child: Icon(
                                                                                    Icons.remove,
                                                                                    color: BuytimeTheme.SymbolMalibu,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),

                                                                          ///Quantity
                                                                          Container(
                                                                            margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                                                                            child: Text(
                                                                              '${reserveState.selectedSquareSlotList[index].elementAt(i)[0]}',
                                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 16, fontWeight: FontWeight.w500, color: BuytimeTheme.SymbolMalibu),
                                                                            ),
                                                                          ),

                                                                          ///Add
                                                                          Container(
                                                                            height: 24,
                                                                            width: 24,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: BuytimeTheme.SymbolMalibu.withOpacity(.1)),
                                                                            child: Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                                onTap: mySSS.free > 0
                                                                                    ? () {
                                                                                  //setState(() {
                                                                                  reserveState.slots[index].forEach((el2) {
                                                                                    if (el2[2].uid == mySSS.uid) {
                                                                                      el2[2].free -= 1;
                                                                                      if(reserve)
                                                                                        mySSS.free -= 1;
                                                                                      reserveState.selectedSquareSlotList[index].elementAt(i)[0] += 1;
                                                                                    }
                                                                                  });
                                                                                  Provider.of<ReserveList>(context, listen: false).initSelectedSquareSlotList(reserveState.selectedSquareSlotList);
                                                                                  //Provider.of<ReserveList>(context, listen: false).initSlot(reserveState.slots);
                                                                                  reserveState.order.total = 0;
                                                                                  reserveState.order.itemList.forEach((element) {
                                                                                    if (element.idSquareSlot == mySSS.uid) {
                                                                                      element.orderCapacity = reserveState.selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.price = tmpService.price * reserveState.selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.number += 1;
                                                                                    }
                                                                                    reserveState.order.total += element.price;
                                                                                    reserveState.order.total -= (reserveState.order.totalPromoDiscount / reserveState.order.itemList.length);
                                                                                  });
                                                                                  Provider.of<ReserveList>(context, listen: false).updateOrder(reserveState.order);
                                                                                  //});
                                                                                }
                                                                                    : null,
                                                                                child: Container(
                                                                                  height: 24,
                                                                                  width: 24,
                                                                                  child: Icon(
                                                                                    Icons.add,
                                                                                    color: BuytimeTheme.SymbolMalibu,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),

                                                                  ///Spot
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: 5),
                                                                    child: Text(
                                                                      '${AppLocalizations.of(context).still} ${mySSS.free} ${AppLocalizations.of(context).spot}',
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 16, fontWeight: FontWeight.w600),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),

                                                          ///Right
                                                          reserveState.selectedSquareSlotList[index].length != 1 && i != reserveState.selectedSquareSlotList[index].length - 1
                                                              ? Container(
                                                            height: 100,
                                                            width: 24,
                                                            decoration: BoxDecoration(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              color: BuytimeTheme.SymbolMalibu.withOpacity(.1),
                                                            ),
                                                            child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                onTap: () {
                                                                  int jump = i;
                                                                  ++jump;
                                                                  debugPrint('UI_U_service_reserve => JUMP: $jump');
                                                                  //_controllerList[index][0] = jump;
                                                                  Provider.of<ReserveList>(context, listen: false).updateControllerList(index, 0, jump);
                                                                  reserveState._controllerList[index][1].scrollTo(index: jump, duration: Duration(milliseconds: 500));
                                                                  //_slotControllerList[index][0] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  Provider.of<ReserveList>(context, listen: false).updateSlotControllerList(index, 0, reserveState.selectedSquareSlotList[index].elementAt(jump)[2]);
                                                                  reserveState._slotControllerList[index][1].scrollTo(index: reserveState.selectedSquareSlotList[index].elementAt(jump)[2], duration: Duration(milliseconds: 500));
                                                                  //slotIndex[index] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  Provider.of<ReserveList>(context, listen: false).updateSlotIndex(index, reserveState.selectedSquareSlotList[index].elementAt(jump)[2]);
                                                                },
                                                                child: Container(
                                                                  height: 24,
                                                                  width: 24,
                                                                  child: Icon(
                                                                    Icons.keyboard_arrow_right,
                                                                    color: BuytimeTheme.SymbolMalibu,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                              : Container(),
                                                        ],
                                                      );
                                                    }
                                                    return Container();
                                                  }),
                                            ) : Container()
                                            /*Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                                        child:  TimeSlotWidget(widget.serviceState.serviceSlot.first),
                                      )*/
                                          ],
                                        );
                                      },
                                      childCount: dates.length,
                                    ),
                                  ),
                                ]),
                              )
                          ) : ///No List
                          Expanded(child: Column(
                            children: [
                              Container(
                                height: SizeConfig.safeBlockVertical * 8,
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        AppLocalizations.of(context).warningNoSlotReservable,
                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                      ),
                                    )),
                              )
                            ],
                          )),

                          ///Confirm button
                          noActivity
                              ? Container()
                              : Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              //height: double.infinity,
                              //color: Colors.black87,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Confirm button
                                  Container(
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                      width: 198,

                                      ///media.width * .4
                                      height: 44,
                                      child: MaterialButton(
                                        key: Key('service_reserve_key'),
                                        elevation: 0,
                                        hoverElevation: 0,
                                        focusElevation: 0,
                                        highlightElevation: 0,
                                        onPressed: () async{
                                          FirebaseAnalytics().logEvent(
                                              name: 'reserve_time_slots',
                                              parameters: {
                                                'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                                'date': DateTime.now().toString(),
                                                'service_name': widget.serviceState.name
                                              });
                                          if (reserveState.order.cartCounter > 0) {
                                            // dispatch the order
                                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(reserveState.order));
                                            // go to the cart page
                                            bool refresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => CartReservable(serviceState: widget.serviceState, tourist: widget.tourist)),
                                            );
                                            setState(() {
                                              bool r = refresh;
                                              reserve = true;
                                            });
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: Text(AppLocalizations.of(context).warning),
                                                  content: Text(AppLocalizations.of(context).warningNoSlotReservable),
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
                                        textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                        color: BuytimeTheme.ActionBlackPurple,
                                        padding: EdgeInsets.all(media.width * 0.03),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context).reserve,
                                          style: TextStyle(
                                            letterSpacing: 1.25,
                                            fontSize: 14,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            color: BuytimeTheme.TextWhite,
                                          ),
                                        ),
                                      )),
                                  // Container(
                                  //     margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 4),
                                  //     width: 158,
                                  //
                                  //     ///media.width * .4
                                  //     height: 44,
                                  //     child: MaterialButton(
                                  //       key: Key('service_reserve_key'),
                                  //       elevation: 0,
                                  //       hoverElevation: 0,
                                  //       focusElevation: 0,
                                  //       highlightElevation: 0,
                                  //       onPressed: () async{
                                  //         await Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(builder: (context) => PersonalInfoPark()),
                                  //         );
                                  //       },
                                  //       textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                  //       color: BuytimeTheme.SymbolMalibu,
                                  //       padding: EdgeInsets.all(media.width * 0.03),
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: new BorderRadius.circular(5),
                                  //       ),
                                  //       child: Text(
                                  //         AppLocalizations.of(context).test,
                                  //         style: TextStyle(
                                  //           letterSpacing: 1.25,
                                  //           fontSize: 14,
                                  //           fontFamily: BuytimeTheme.FontFamily,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: BuytimeTheme.TextWhite,
                                  //         ),
                                  //       ),
                                  //     )),

                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          /* )*/
        ),
      ),
    );
  }
}

class ReserveList with ChangeNotifier{
  List<List<List<dynamic>>> slots;
  List<List<List<dynamic>>> selectedSquareSlotList;
  List<List<dynamic>> _controllerList;
  List<List<dynamic>> _slotControllerList;
  List<int> slotIndex;
  OrderReservableState order;
  ReserveList(this.slots, this.order, this._controllerList, this._slotControllerList, this.slotIndex, this.selectedSquareSlotList);

  initSlot(List<List<List<dynamic>>> slots){
    this.slots = slots;
    debugPrint('UI_U_service_reserve => SLOT INIT');
    notifyListeners();
  }
  initOrder(OrderReservableState order){
    this.order = order;
    debugPrint('UI_U_service_reserve => ORDER INIT');
    notifyListeners();
  }
  initControllerList(List<List<dynamic>> _controllerList){
    this._controllerList = _controllerList;
    debugPrint('UI_U_service_reserve => CONTROLLER LIST INIT');
    notifyListeners();
  }
  initSlotControllerList(List<List<dynamic>> _slotControllerList){
    this._slotControllerList = _slotControllerList;
    debugPrint('UI_U_service_reserve => SLOT CONTROLLER LIST INIT');
    notifyListeners();
  }
  initSlotIndex(List<int> slotIndex){
    this.slotIndex = slotIndex;
    debugPrint('UI_U_service_reserve => SLOT INDEX INIT');
    notifyListeners();
  }
  initSelectedSquareSlotList(List<List<List<dynamic>>> selectedSquareSlotList){
    this.selectedSquareSlotList = selectedSquareSlotList;
    debugPrint('UI_U_service_reserve => SELECTED SQUARE SLOT LIST INIT');
    notifyListeners();
  }

  updateOrder(OrderReservableState order){
    this.order = order;
    notifyListeners();
  }
  updateControllerList(int pos1, int pos2, dynamic value){
    this._controllerList[pos1][pos2] = value;
    notifyListeners();
  }

  updateSlotControllerList(int pos1, int pos2, dynamic value){
    this._slotControllerList[pos1][pos2] = value;
    notifyListeners();
  }

  updateSlotIndex(int pos, int value){
    this.slotIndex[pos] = value;
    notifyListeners();
  }

  clear(){
    this.selectedSquareSlotList.clear();
    this.slots.clear();
    this.order = OrderReservableState().toEmpty();
    this._slotControllerList.clear();
    this._controllerList.clear();
    this.slotIndex.clear();
    notifyListeners();
  }


}