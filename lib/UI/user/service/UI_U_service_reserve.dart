import 'dart:async';
import 'dart:math';
import 'package:Buytime/UI/management/service_internal/class/service_slot_classes.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart_reservable.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/selected_entry.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/interval_list_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/sliverAppBarDelegate.dart';
import 'package:Buytime/reusable/time_slot_widget.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class ServiceReserve extends StatefulWidget {
  static String route = '/serviceReserve';
  final ServiceState serviceState;
  bool tourist;
  ServiceReserve({@required this.serviceState, this.tourist});

  @override
  createState() => _ServiceReserveState();

}

class _ServiceReserveState extends State<ServiceReserve> with SingleTickerProviderStateMixin {

  ServiceState serviceState;
  OrderReservableState order = OrderReservableState().toEmpty();

  bool startRequest = false;
  bool noActivity = false;

  String price = '';
  String firstSlot = '';

  @override
  void initState() {
    super.initState();
    serviceState = widget.serviceState;
    debugPrint('image: ${serviceState.image1}');
  }


  @override
  void dispose() {
    super.dispose();
  }

  String version200(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  //List<int> dates = [];
  List<DateTime> dates = [];
  List<List<bool>> picked = [];
  List<List<bool>> selectedSlot = [];
  List<List<List<dynamic>>> tmpSlots = [];
  List<List<List<dynamic>>> slots = [];
  List<List<SelectedEntry>> indexes = [];
  List<SelectedEntry> alreadySelected = [];

  bool isValid(DateTime dateTime, EveryDay everyDay){
    //String weekdayDate = DateFormat('E d M y').format(dateTime);
    String weekday = DateFormat('E',Localizations.localeOf(context).languageCode).format(dateTime);

    if('Mon' == weekday) {
      return everyDay.everyDay[0];
    }else if('Tue' == weekday){
      return everyDay.everyDay[1];
    }else if('Wed' == weekday){
      return everyDay.everyDay[2];
    }else if('Thu' == weekday){
      return everyDay.everyDay[3];
    }else if('Fri' == weekday){
      return everyDay.everyDay[4];
    }else if('Sat' == weekday){
      return everyDay.everyDay[5];
    }else{
      return everyDay.everyDay[6];
    }
  }

  ///TODO Tourist method
  /*List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate, DateTime userStartDate, DateTime userEndDate, ServiceSlot slot, List<OrderReservableState> reserved) {
    tmpSlots.clear();
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      debugPrint('UI_U_ServiceReserve => LOOKING DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $userStartDate - IS BEFORE: $userEndDate');
      if(startDate.add(Duration(days: i)).isAfter(userStartDate) && startDate.add(Duration(days: i)).isBefore(userEndDate)){
        debugPrint('UI_U_ServiceReserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $startDate');
        if(startDate.add(Duration(days: i)).isAfter(startDate) || startDate.add(Duration(days: i)).isAtSameMomentAs(startDate)){
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          debugPrint('UI_U_ServiceReserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - CURRENT DATE: ${currentTime}');
          if(startDate.add(Duration(days: i)).isAfter(currentTime) || startDate.add(Duration(days: i)).isAtSameMomentAs(currentTime)) {
              //tmpSlots.add(List.generate(slot.startTime.length, (index) => [index, slot]));
               bool isIn = false;
              bool isReserved = false;
              tmpSlots.add([]);
              Map<DateTime, List<int>> limted = Map();
              reserved.forEach((element) {
                debugPrint('UI_U_ServiceReserve => RESERVED: ${element.date} | ${element.itemList.first.time}');
              });
              reserved.forEach((r) {
                r.itemList.forEach((item) {
                  //debugPrint('UI_U_ServiceReserve => LOOKING DATE: ${item.date}');
                  if(startDate.add(Duration(days: i)).isAtSameMomentAs(item.date) && !isReserved && slot.startTime.contains(item.time)){
                    debugPrint('UI_U_ServiceReserve => LOOKED DATE: ${item.date} - RESERVED: ${startDate.add(Duration(days: i))}');
                    for(int j = 0; j < slot.startTime.length; j++) {
                      debugPrint('UI_U_ServiceReserve => LOOKING TIME: ${slot.startTime[j]} - TIME: ${item.time}');
                      if(isValid(startDate.add(Duration(days: i)), slot.daysInterval[j])){
                        if(slot.startTime[j] == item.time){
                          isReserved = true;
                          debugPrint('UI_U_ServiceReserve => LOOKED TIME: ${item.time} - RESERVED: ${slot.startTime[j]}');
                        }else{
                          isIn = true;
                          debugPrint('UI_U_ServiceReserve => VALID FROM RESERVED: ${DateFormat('dd MMMM yyyy').format(startDate.add(Duration(days: i)))} - ${slot.startTime[j]}');
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
                  //debugPrint('UI_U_ServiceReserve => LOOKING TIME: ${slot.startTime[j]} - TIME: ${item.time}');
                  if(isValid(startDate.add(Duration(days: i)), slot.daysInterval[j])){
                    debugPrint('UI_U_ServiceReserve => VALID : ${DateFormat('dd MMMM yyyy').format(startDate.add(Duration(days: i)))} - ${slot.startTime[j]}');
                    isIn = true;
                    tmpSlots.last.add([j, slot]);
                  }
                }
              }
               debugPrint('UI_U_ServiceReserve => BEFORE | tmpSlots LENGTH: ${tmpSlots.length}');
              if(isIn){
                debugPrint('UI_U_ServiceReserve => IS IN');
                days.add(startDate.add(Duration(days: i)));
                if(tmpSlots.last.isEmpty)
                  tmpSlots.removeLast();
              }else{
                debugPrint('UI_U_ServiceReserve => NOT IN');
                tmpSlots.removeLast();
              }
               debugPrint('UI_U_ServiceReserve => AFTER | tmpSlots LENGTH: ${tmpSlots.length}');

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
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      //debugPrint('UI_U_ServiceReserve => LOOKING DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $userStartDate - IS BEFORE: $userEndDate');
      if (startDate.add(Duration(days: i)).isAfter(userStartDate) && startDate.add(Duration(days: i)).isBefore(userEndDate)) {
        //debugPrint('UI_U_ServiceReserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - IS AFTER: $startDate');
        if (startDate.add(Duration(days: i)).isAfter(startDate) || startDate.add(Duration(days: i)).isAtSameMomentAs(startDate)) {
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          //debugPrint('UI_U_ServiceReserve => LOOKED DATE: ${startDate.add(Duration(days: i))} - CURRENT DATE: ${currentTime}');
          if (startDate.add(Duration(days: i)).isAfter(currentTime) || startDate.add(Duration(days: i)).isAtSameMomentAs(currentTime)) {
            days.add(startDate.add(Duration(days: i)));
            tmpSlots.add([]);
            for (int j = 0; j < mySlots.length; j++) {
              //debugPrint('SQUARE TIME: $mySlots');
              if (mySlots[j].free != 0 /*&& mySlots[i].visibility*/) {
                DateTime squareDateFormat = DateFormat("dd/MM/yyyy",Localizations.localeOf(context).languageCode).parse(mySlots[j].date).toUtc();
                //debugPrint('DATE: $squareDateFormat');
                DateTime squareDate = squareDateFormat;
                squareDate = new DateTime(squareDate.year, squareDate.month, squareDate.day, 0, 0, 0, 0, 0);
                DateTime squareTime = DateFormat("dd/MM/yyyy",Localizations.localeOf(context).languageCode).parse(mySlots[j].date).toUtc();
                squareTime = new DateTime(squareTime.year, squareTime.month, squareTime.day, int.parse(mySlots[j].on.split(':').first), int.parse(mySlots[j].on.split(':').last), 0, 0, 0);
                //debugPrint('UI_U_ServiceReserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                if(squareDate.isAtSameMomentAs(startDate.add(Duration(days: i))) && squareTime.isAfter(DateTime.now())){
                  //debugPrint('UI_U_ServiceReserve => SQUARE SLOT DATE: $squareDate - CURRENT DATE: ${startDate.add(Duration(days: i))} - SQUARE SLOT TIME: ${mySlots[j].on} - SQUARE TIME: $squareTime');
                  tmpSlots.last.add([j, slot, mySlots[j]]);
                }
              }
            }
            if(tmpSlots.last.isEmpty){
              tmpSlots.removeLast();
              days.removeLast();
            }
          }
        }
      }
    }
    List<int> addIndexes = [];
    //debugPrint('UI_U_service_reserve => SLOTS LENGTH: ${tmpSlots.length}');
    for(int i = 0; i < tmpSlots.length; i++){
      //debugPrint('UI_U_service_reserve => SLOT LENGTH: ${tmpSlots[i].length} - INDEX: $i');
      if(tmpSlots[i].isNotEmpty){
        //debugPrint('UI_U_service_reserve => SLOT: ${element}');
        tmpSlots[i].forEach((sT) {
          //debugPrint('UI_U_service_reserve => START TIME: ${sT[2].startTime} |  STOP TIME: ${sT[2].stopTime}');
        });
      }
      if(tmpSlots[i].length != 0){
        //debugPrint('UI_U_service_reserve => SLOT LENGTH: ${tmpSlots[i].length} - INDEX TO REMOVE: $i');
        addIndexes.add(i);
      }
    }
    /*List<List<List<dynamic>>> tmp = [];
    addIndexes.forEach((element) {
      tmp.add(tmpSlots[element]);
    });
    tmpSlots = tmp;*/
    if(tmpSlots.isEmpty){
      debugPrint('UI_U_service_reserve => SLOTS IS EMPTY');
      //days.removeLast();
    }
    return days;
  }


  void deleteItem(OrderState snapshot, OrderEntry entry) {
    setState(() {
      //cartCounter = cartCounter - entry.number;
      order.cartCounter = order.cartCounter - entry.number;
      order.removeReserveItem(entry);
      order.itemList.remove(entry);
      StoreProvider.of<AppState>(context).dispatch(UpdateOrderReservable(order));
    });
  }

  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  SquareSlotState selectedSquareSlot = SquareSlotState().toEmpty();
  List<bool> selectQuantity = [];
  List<int> slotIndex = [];
  int selectedQuantityNumber = 0;
  List<List<List<dynamic>>> selectedSquareSlotList = [];
  List<List<List<dynamic>>> tmpSelectedSquareSlotList = [];

  ScrollController _controller = ScrollController();
  List<List<dynamic>> _controllerList = [];
  List<List<dynamic>> _slotControllerList = [];

  double scrollPosition = 0.0;
  List<List<bool>> scrollPositionList = [];

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        store.state.slotSnippetListState.slotListSnippet.clear();
        //store.dispatch(OrderReservableListRequest(widget.serviceState.serviceId));
        store.dispatch(SlotListSnippetRequest(widget.serviceState.serviceId));
        order = store.state.orderReservable.itemList != null ? (store.state.orderReservable.itemList.length > 0 ? store.state.orderReservable : order) : order;

        debugPrint('UI_U_ServiceReserve => SLOTS: ${widget.serviceState.serviceSlot.length}');

        startRequest = true;

        double tmpPrice;
        debugPrint('UI_U_ServiceReserve => SLOTS LENGTH: ${widget.serviceState.serviceSlot.length}');
        DateTime currentTime = DateTime.now();
        currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
        widget.serviceState.serviceSlot.forEach((element) {
          DateTime checkOut = DateFormat('dd/MM/yyyy',Localizations.localeOf(context).languageCode).parse(element.checkOut);
          if(checkOut.isAtSameMomentAs(currentTime) || checkOut.isAfter(currentTime)){
            debugPrint('UI_U_ServiceReserve => VALID: ${element.checkIn}');
            tmpPrice = element.price;
            if(element.price <= tmpPrice){
              if(element.day != 0){
                debugPrint('UI_U_ServiceReserve => SLOT WITH DAYS');
                if(element.day > 1)
                  price = ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).days}';
                else
                  price = ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).day}';
              }else{
                debugPrint('UI_U_ServiceReserve => SLOT WITHOUT DAYS');
                int tmpMin = element.hour * 60 + element.minute;
                if(tmpMin > 90)
                  price = ' ${element.price.toStringAsFixed(0)} / ${element.hour} h ${element.minute} ${AppLocalizations.of(context).spaceMinSpace}';
                else
                  price = ' ${element.price.toStringAsFixed(0)} / $tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
              }
            }
          }
        });

        store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
          if(eBL.id_firestore == widget.serviceState.businessId){
            isExternal = true;
            externalBusinessState = eBL;
          }
        });
      },
      builder: (context, snapshot) {

        if(snapshot.slotSnippetListState.slotListSnippet.isEmpty && startRequest){
          noActivity = true;
          startRequest = false;
        }
        else{
          noActivity = false;
          dates.clear();
          slots.clear();
          List<IntervalListState> tmpState = snapshot.slotSnippetListState.slotListSnippet;
          for(int i = 0; i < tmpState.length; i++){
            //DateTime tmpStartDate = tmpState[i].slot.first.date;
            //DateTime tmpEndDate = tmpState[i].slot.last.date;
            DateTime tmpStartDate = DateFormat('dd/MM/yyyy',Localizations.localeOf(context).languageCode).parse(widget.serviceState.serviceSlot[i].checkIn);
            DateTime tmpEndDate = DateFormat('dd/MM/yyyy',Localizations.localeOf(context).languageCode).parse(widget.serviceState.serviceSlot[i].checkOut);
            debugPrint('UI_U_service_reserve => START DATE: $tmpStartDate | END DATE: $tmpEndDate');
            if(dates.isEmpty){
              dates = getDaysInBeteween(tmpStartDate, tmpEndDate, snapshot.booking.start_date,  snapshot.booking.end_date, tmpState[i].slot, widget.serviceState.serviceSlot[i]);
              if(tmpSlots.isNotEmpty){
                slots.addAll(tmpSlots);
                slots.forEach((element) {
                  picked.add(List.generate(element.length, (index) => false));
                  selectedSlot.add(List.generate(element.length, (index) => false));
                  indexes.add(List.generate(element.length, (index) => SelectedEntry(first: 0, last: 0)));
                });
              }
            }else{
              List<DateTime> tmpDates = getDaysInBeteween(tmpStartDate, tmpEndDate, snapshot.booking.start_date,  snapshot.booking.end_date, tmpState[i].slot, widget.serviceState.serviceSlot[i]);
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
          }

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

          slots.forEach((element) {
            element.sort((a,b) => (a[2].on).compareTo(b[2].on));
          });


          debugPrint("UI_U_ServiceReserve => SLOTS LENGTH: ${slots.length}");

          /*slots.forEach((element) {
            picked.add(List.generate(element.length, (index) => false));
            selectedSlot.add(List.generate(element.length, (index) => false));
            indexes.add(List.generate(element.length, (index) => SelectedEntry(first: 0, last: 0)));
          });*/

          if(slots.isNotEmpty && slots[0] != null && slots[0].isNotEmpty){
            if(slots[0][0][1].day != 0){
              if(slots[0][0][1].day > 1){
                firstSlot = '${slots[0][0][1].day} ${AppLocalizations.of(context).days}';
              }else{
                firstSlot = '${slots[0][0][1].day} ${AppLocalizations.of(context).day}';
              }
            }else{
              int tmpMin = slots[0][0][1].hour * 60 + slots[0][0][1].minute;
              if(tmpMin > 90)
                firstSlot = '${slots[0][0][1].hour} h ${slots[0][0][1].minute} ${AppLocalizations.of(context).spaceMinSpace}';
              else
                firstSlot = '$tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
            }

          }

          if(selectQuantity.isEmpty){
            selectQuantity = List.generate(dates.length, (index) => false);
            slotIndex = List.generate(dates.length, (index) => -1);
            scrollPositionList = List.generate(dates.length, (index) => List.generate(slots[index].length, (index) => false));
            selectedSquareSlotList = List.generate(dates.length, (index) => []);
            tmpSelectedSquareSlotList = List.generate(dates.length, (index) => []);
            _controllerList = List.generate(dates.length, (index) => [0, ItemScrollController()]);
            _slotControllerList = List.generate(dates.length, (index) => [0, ItemScrollController()]);
            debugPrint('UI_U_ServiceReserve => DATES LENGTH: ${dates.length} | BOOL LENGTH: ${selectQuantity.length}');
          }
        }



        order = snapshot.orderReservable.itemList != null ? (snapshot.orderReservable.itemList.length > 0 ? snapshot.orderReservable : OrderReservableState().toEmpty()) : OrderReservableState().toEmpty();
        //int start = int.parse(widget.serviceState.serviceSlot.first.checkIn.substring(0,2));
        //int end = int.parse(widget.serviceState.serviceSlot.first.checkOut.substring(0,2));

        ///First try
        /*if(order.itemList.isNotEmpty){
          debugPrint('UI_U_ServiceReserve => ORDER NOT EMPTY');
          for(int i = 0; i < order.itemList.length; i++){
            for(int j = 0; j < dates.length; j++){
                if(order.itemList[i].date == dates[j]){
                  for(int k = 0; k < picked[j].length; k++){
                    if(order.itemList[i].time == widget.serviceState.serviceSlot.first.startTime[k]){
                      debugPrint("UI_U_ServiceReserve => $i TIME: ${order.itemList[i].time}");
                      debugPrint("UI_U_ServiceReserve => $i DATE: ${order.itemList[i].date}");
                      picked[j][k] = true;
                    }
                  }
                }
            }
          }
        }*/
        ///Second try
        /*order.selected.forEach((element) {
          debugPrint('UI_U_ServiceReserve => SELECTED INDEXES: $element');
          //picked[element[0]][element[1]] = true;
        });*/
        ///Third try
        List<dynamic> idk = [];
        tmpSelectedSquareSlotList = List.generate(dates.length, (index) => []);
        for(int i = 0; i < picked.length; i++){
          for(int j = 0; j < picked[i].length; j++){
            bool found = false;
            order.selected.forEach((element) {
              if(i == element.first && j == element.last){
                found = true;
              }
            });
            if(found){
              picked[i][j] = true;
              for(int k = 0; k < selectedSquareSlotList[i].length; k++){
                if(selectedSquareSlotList[i][k][1].uid == slots[i][j][2].uid){
                  if(!idk.contains([i,k])){
                    debugPrint('FOUND TRUE: $i $k');
                    idk.add([i,k]);
                  }
                }
              }
              //selectedSquareSlotList[i].removeAt(mSQQIndex);
            }else
              picked[i][j] = false;
          }
        }
        //_controllerList = List.generate(dates.length, (index) => [ItemScrollController(initialScrollOffset: scrollPositionList[index])]);
        idk.forEach((element) {
          tmpSelectedSquareSlotList[element[0]].add(selectedSquareSlotList[element[0]][element[1]]);
          if(tmpSelectedSquareSlotList[element[0]].length > 1){
            debugPrint("UI_U_ServiceReserve =>JUMP TO: QUANTITY: ${_controllerList[element[0]][0]}");
            //debugPrint("UI_U_ServiceReserve =>JUMP TO: SLOT: ${_slotControllerList[element[0]][0]}");
            //_controllerList[element[0]][1].scrollTo(index: selectedSquareSlotList[element[0]].length-1, duration: Duration(milliseconds: 500));
            //_slotControllerList[element[0]][1].scrollTo(index: _slotControllerList[element[0]][0], duration: Duration(milliseconds: 500));
            //slotIndex[element[0]] = _slotControllerList[element[0]][0];
            //_controller.initialScrollOffset;
          }
          if(order.itemList.length == 1){
            slotIndex[element[0]] = selectedSquareSlotList[element[0]][0][2];
            _slotControllerList[element[0]][0] = selectedSquareSlotList[element[0]][0][2];
            _controllerList[element[0]][0] = selectedSquareSlotList[element[0]][0][2];
          }
        });
        //selectedSquareSlotList.clear();
        selectedSquareSlotList = tmpSelectedSquareSlotList;

        if(order.itemList.isEmpty)
          slotIndex = List.generate(dates.length, (index) => -1);


        /*_controllerList.forEach((element) {
          //ScrollController().initialScrollOffset
          element[1].jumpTo(element[0]);
        });*/

        debugPrint("UI_U_ServiceReserve => CART COUNT: ${order.cartCounter}");
        debugPrint('UI_U_ServiceReserve => PICKED: ${picked.length}');
        //debugPrint('UI_U_ServiceReserve => INTERVAL SLOTS LENGTH: ${widget.serviceState.serviceSlot.first.startTime.length}');
        return  GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
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
                            //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(0));
                            StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(OrderReservableState().toEmpty()));
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                  ///Title
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          AppLocalizations.of(context).reserveSpace + ' ' +  Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
                          textAlign: TextAlign.start,
                          style: BuytimeTheme.appbarTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 56.0,
                  )
                ],
              ),
              body: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///Service subtitle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 4),
                            child: Text(
                              Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name)  ?? AppLocalizations.of(context).serviceName,
                              style: TextStyle(
                                  letterSpacing: 0.25,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
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
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            child: Text(
                              price,
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          )
                        ],
                      ),
                      ///Availability text
                      Row(
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
                      ),
                      ///Next available time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5),
                            child: Text(
                              AppLocalizations.of(context).nextAvailableTime,
                              style: TextStyle(
                                //letterSpacing: 1.25,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          ///First slot
                          noActivity ?
                          Flexible(
                              child: Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockVertical * 2),
                                width: 179,
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator()
                                  ],
                                ),
                              ),
                          ) :
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockVertical * 2),
                            width: 150,
                            height: 120,
                            decoration: BoxDecoration(
                              color: BuytimeTheme.BackgroundLightBlue.withOpacity(.2),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: dates.isNotEmpty ?
                            Column(
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
                                      DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(DateTime.now()).toUpperCase() == DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(dates[0]).toUpperCase() ? AppLocalizations.of(context).today.replaceFirst(',', '').toUpperCase() : '${DateFormat('EEEE',Localizations.localeOf(context).languageCode).format(dates[0])}',
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
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
                                          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
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
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
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
                                      '${AppLocalizations.of(context).currency} ' + slots[0][0][1].price.toStringAsFixed(2) ,
                                      style: TextStyle(
                                        //letterSpacing: 1.25,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color:  BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) :
                            Column(
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
                                          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ///Blue part & Time Slots
                      noActivity ?
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        ),
                      ) :
                      Expanded(
                          flex: 5,
                          child: CustomScrollView(
                              shrinkWrap: true,
                              slivers: [
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
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
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
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                    //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                    DateTime i = dates.elementAt(index);
                                    String date = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(i).toUpperCase();
                                    String currentDate = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(DateTime.now()).toUpperCase();
                                    String nextDate = DateFormat('MMM dd',Localizations.localeOf(context).languageCode).format(DateTime.now().add(Duration(days: 1))).toUpperCase();
                                    List<bool> select = picked.elementAt(index);
                                    return Column(
                                      children: [
                                        ///Blue part
                                        Container(
                                          color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                          height: 20,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                                child: Text(
                                                  index == 0 && currentDate == date ? AppLocalizations.of(context).today + ' '+ date : index == 1 && nextDate == date ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE',Localizations.localeOf(context).languageCode).format(i).toUpperCase()}, $date',
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
                                                                color: select[i] ? ( widget.tourist ? BuytimeTheme.BackgroundCerulean.withOpacity(0.5) : BuytimeTheme.UserPrimary.withOpacity(0.5)) : BuytimeTheme.BackgroundWhite
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
                                                                      debugPrint('SELECTED SLOT: ${selectQuantity[index]}');
                                                                      selectedSquareSlotList[index].add([selectedQuantityNumber, selectedSquareSlot]);
                                                                      debugPrint('SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
                                                                    }else{
                                                                      serviceSlot[2].availablePlaces = serviceSlot[2].maxAvailablePlace;
                                                                      selectedQuantityNumber = serviceSlot[2].maxAvailablePlace - serviceSlot[2].availablePlaces;
                                                                      int mSQQIndex = 0;
                                                                      debugPrint('SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
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
                                                                    //debugPrint('TIMESTAMP: ${Timestamp.fromDate(serviceSlot[2].date)}');
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
                                                                    order.user.name = snapshot.user.name;
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

                                                                  debugPrint('UI_U_ServiceReserve => SELECTED INDEXES: ${order.selected}');
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
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5, bottom: SizeConfig.safeBlockVertical * 1.5),
                                          height: 110,
                                          width: SizeConfig.safeBlockHorizontal * 100,
                                          child: ScrollablePositionedList.builder(
                                              itemCount: slots[index].length,
                                              itemScrollController: _slotControllerList[index][1],
                                              //physics: NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, i){
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
                                                                color: select[i] ? ( widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary) : BuytimeTheme.BackgroundWhite,
                                                              width: 1.5
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
                                                                      slotIndex[index] = i;
                                                                      //_slotControllerList[index][0] = i;
                                                                      selectedSquareSlot = serviceSlot[2];
                                                                      selectedQuantityNumber = selectedSquareSlot.max - selectedSquareSlot.free;
                                                                      if(selectedQuantityNumber == 0)
                                                                        selectedQuantityNumber = 1;

                                                                      selectedSquareSlot.free -= selectedQuantityNumber;

                                                                      debugPrint('SELECTED SLOT: ${selectQuantity[index]}');
                                                                      selectedSquareSlotList[index].add([selectedQuantityNumber, selectedSquareSlot, i, serviceSlot[1]]);
                                                                      _controllerList[index][0] = selectedSquareSlotList[index].length - 1;
                                                                      debugPrint('QUANTITY SLOT: ${_controllerList[index][0]}');
                                                                      if(selectedSquareSlotList[index].length > 1){
                                                                        debugPrint('MOVE TO');
                                                                        //_controllerList[index][1].scrollTo(index: _controllerList[index][0], duration: Duration(milliseconds: 500));
                                                                        //_slotControllerList[index][1].scrollTo(index: i, duration: Duration(milliseconds: 500));
                                                                      }
                                                                      debugPrint('SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
                                                                    }else{
                                                                      serviceSlot[2].free = serviceSlot[2].max;
                                                                      selectedQuantityNumber = serviceSlot[2].max - serviceSlot[2].free;
                                                                      int mSQQIndex = 0;
                                                                      debugPrint('SELECTED SLOT LIST: ${selectedSquareSlotList[index].length}');
                                                                      for(int j = 0; j < selectedSquareSlotList[index].length; j++){
                                                                        if(selectedSquareSlotList[index][j][1].uid == serviceSlot[2].uid){
                                                                          mSQQIndex = j;
                                                                        }
                                                                      }
                                                                      selectedSquareSlotList[index].removeAt(mSQQIndex);
                                                                     if(selectedSquareSlotList[index].isNotEmpty){
                                                                       slotIndex[index] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                       //slotIndex[index] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                       //_slotControllerList[index][0] = selectedSquareSlotList[index][mSQQIndex - 1][2];
                                                                       //_controllerList[index][0] = selectedSquareSlotList[index][selectedSquareSlotList[index].length - 1][2];
                                                                       /*slotIndex[index] = selectedSquareSlotList[index][0][2];
                                                                       _slotControllerList[index][0] = selectedSquareSlotList[index][0][2];
                                                                       _controllerList[index][0] = selectedSquareSlotList[index][0][2];*/
                                                                     }else{
                                                                       slotIndex[index] = -1;
                                                                       _slotControllerList[index][0] = -1;
                                                                     }
                                                                    }
                                                                  });
                                                                  if(select[i]){
                                                                    String duration = '';
                                                                    //debugPrint('TIMESTAMP: ${Timestamp.fromDate(serviceSlot[2].date)}');
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
                                                                    order.user.name = snapshot.user.name;
                                                                    order.user.id = snapshot.user.uid;
                                                                    order.addReserveItem(widget.serviceState, snapshot.business.ownerId, serviceSlot[2].on, duration, dates[index], serviceSlot[1].price, serviceSlot[2].uid);
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
                                                                      if(element.time ==  serviceSlot[2].on && element.date.isAtSameMomentAs(tmpDate)){
                                                                        tmp = element;
                                                                        debugPrint('UI_U_service_reserve => ENTRY: ${element.id_business}');
                                                                      }
                                                                    });
                                                                    //debugPrint('UI_U_service_reserve => ENTRY: ${tmp.id_business}');
                                                                    order.selected.remove(indexes[index][i]);
                                                                    //order.selected.remove(selected);
                                                                    deleteItem(snapshot.order, tmp);
                                                                  }

                                                                  debugPrint('UI_U_ServiceReserve => SELECTED INDEXES: ${order.selected}');
                                                                } : null,
                                                                child: TimeSlotWidget(serviceSlot[1], serviceSlot[2], serviceSlot[0], select[i]),
                                                              )
                                                          )
                                                      ),
                                                    ),

                                                    Container(
                                                      margin: EdgeInsets.only(top: 5),
                                                      height: 1,
                                                      width: 80,
                                                      color: slotIndex[index] == i ? BuytimeTheme.UserPrimary : BuytimeTheme.BackgroundWhite,
                                                    )
                                                  ],
                                                );
                                              }),
                                        ),
                                        ///Max Quantity
                                        //selectQuantity[index]
                                            Container(
                                              margin: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                                              height: selectedSquareSlotList[index].isNotEmpty ? 100 : 0,
                                              width: SizeConfig.safeBlockHorizontal * 100,
                                              child: ScrollablePositionedList.builder(
                                                //reverse: true,
                                                  itemCount: selectedSquareSlotList[index].length,
                                                  itemScrollController: _controllerList[index][1],
                                                  physics: NeverScrollableScrollPhysics(),
                                                  scrollDirection: Axis.horizontal,
                                                  //initialScrollIndex: selectedSquareSlotList[index].length - 1,
                                                  itemBuilder: (context, i){
                                                    SquareSlotState mySSS = selectedSquareSlotList[index].elementAt(i)[1];
                                                    ServiceSlot tmpService = selectedSquareSlotList[index].elementAt(i)[3];
                                                    debugPrint('UI_U_ServiceReserve => QUANTITY INDEXES: ${selectedSquareSlotList[index].length}');
                                                    return Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        ///Left
                                                        i != 0 ?
                                                        Container(
                                                          height: 100,
                                                          width: 24,
                                                          decoration: BoxDecoration(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              color:  widget.tourist ? BuytimeTheme.BackgroundCerulean.withOpacity(.2) : BuytimeTheme.UserPrimary.shade50,
                                                          ),
                                                          child: Material(
                                                            color: Colors.transparent,
                                                            child: InkWell(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              onTap: (){
                                                                int jump = i;
                                                                --jump;
                                                                debugPrint('JUMP: $jump');
                                                                setState(() {
                                                                  _controllerList[index][0] = jump;
                                                                  _controllerList[index][1].scrollTo(index: jump, duration: Duration(milliseconds: 500));
                                                                  _slotControllerList[index][0] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  _slotControllerList[index][1].scrollTo(index: selectedSquareSlotList[index].elementAt(jump)[2], duration: Duration(milliseconds: 500));
                                                                  slotIndex[index] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 24,
                                                                width: 24,
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_left,
                                                                  color:  widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ) : Container(),
                                                        ///Text
                                                        Flexible(
                                                          child: Container(
                                                            //color: Colors.black,
                                                            alignment: Alignment.center,
                                                            margin: EdgeInsets.only(left: 20, top: 25, right: 20),
                                                            height: 100,
                                                            width: i != 0 && i != selectedSquareSlotList[index].length - 1 ? SizeConfig.screenWidth - 40 - 24 - 24 -10 :
                                                            i != 0 ? SizeConfig.screenWidth - 40 - 24 -10 :
                                                            i != selectedSquareSlotList[index].length - 1 ? SizeConfig.screenWidth - 40 - 24 -10: SizeConfig.screenWidth - 40 -10,
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
                                                                        style: TextStyle(
                                                                            fontFamily: BuytimeTheme.FontFamily,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w400
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ///Icons
                                                                    Row(
                                                                      children: [
                                                                        ///Remove
                                                                        Container(
                                                                          height: 24,
                                                                          width: 24,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                              color:  widget.tourist ? BuytimeTheme.BackgroundCerulean.withOpacity(.2) : BuytimeTheme.UserPrimary.shade50
                                                                          ),
                                                                          child: Material(
                                                                            color: Colors.transparent,
                                                                            child: InkWell(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                              onTap: selectedSquareSlotList[index].elementAt(i)[0] > 1 && mySSS.free < mySSS.max ? (){
                                                                                setState(() {
                                                                                  slots[index].forEach((el2) {
                                                                                    if(el2[2].uid == mySSS.uid){
                                                                                      el2[2].free += 1;
                                                                                      selectedSquareSlotList[index].elementAt(i)[0] -=1;
                                                                                    }
                                                                                  });
                                                                                  order.total = 0;
                                                                                  order.itemList.forEach((element) {
                                                                                    if(element.idSquareSlot == mySSS.uid){
                                                                                      element.orderCapacity = selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.price = tmpService.price * selectedSquareSlotList[index].elementAt(i)[0];
                                                                                    }
                                                                                    order.total += element.price;
                                                                                  });
                                                                                });
                                                                              } : null,
                                                                              child: Container(
                                                                                height: 24,
                                                                                width: 24,
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ///Quantity
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                                                                          child: Text(
                                                                            '${selectedSquareSlotList[index].elementAt(i)[0]}',
                                                                            style: TextStyle(
                                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w500
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ///Add
                                                                        Container(
                                                                          height: 24,
                                                                          width: 24,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                              color: widget.tourist ? BuytimeTheme.BackgroundCerulean.withOpacity(.2) : BuytimeTheme.UserPrimary.shade50
                                                                          ),
                                                                          child: Material(
                                                                            color: Colors.transparent,
                                                                            child: InkWell(
                                                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                                                              onTap: mySSS.free > 0 ? (){
                                                                                setState(() {
                                                                                  slots[index].forEach((el2) {
                                                                                    if(el2[2].uid == mySSS.uid){
                                                                                      el2[2].free -= 1;
                                                                                      selectedSquareSlotList[index].elementAt(i)[0] +=1;
                                                                                    }
                                                                                  });
                                                                                  order.total = 0;
                                                                                  order.itemList.forEach((element) {
                                                                                    if(element.idSquareSlot == mySSS.uid){
                                                                                      element.orderCapacity = selectedSquareSlotList[index].elementAt(i)[0];
                                                                                      element.price = tmpService.price * selectedSquareSlotList[index].elementAt(i)[0];
                                                                                    }
                                                                                    order.total += element.price;
                                                                                  });
                                                                                });
                                                                              } : null,
                                                                              child: Container(
                                                                                height: 24,
                                                                                width: 24,
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
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
                                                                    '${mySSS.free} ${AppLocalizations.of(context).spot}',
                                                                    style: TextStyle(
                                                                        fontFamily: BuytimeTheme.FontFamily,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w600
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        ///Right
                                                        selectedSquareSlotList[index].length != 1 && i != selectedSquareSlotList[index].length - 1 ?
                                                        Container(
                                                          height: 100,
                                                          width: 24,
                                                          decoration: BoxDecoration(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              color: widget.tourist ? BuytimeTheme.BackgroundCerulean.withOpacity(.2) : BuytimeTheme.UserPrimary.shade50,

                                                          ),
                                                          child: Material(
                                                            color: Colors.transparent,
                                                            child: InkWell(
                                                              //borderRadius: BorderRadius.all(Radius.circular(12)),
                                                              onTap: (){
                                                                int jump = i;
                                                                ++jump;
                                                                debugPrint('JUMP: $jump');
                                                                setState(() {
                                                                  _controllerList[index][0] = jump;
                                                                  _controllerList[index][1].scrollTo(index: jump, duration: Duration(milliseconds: 500));
                                                                  _slotControllerList[index][0] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                  _slotControllerList[index][1].scrollTo(index: selectedSquareSlotList[index].elementAt(jump)[2], duration: Duration(milliseconds: 500));
                                                                  slotIndex[index] = selectedSquareSlotList[index].elementAt(jump)[2];
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 24,
                                                                width: 24,
                                                                child: Icon(
                                                                  Icons.keyboard_arrow_right,
                                                                  color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ) : Container(),
                                                      ],
                                                    );
                                                  }),
                                            )
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
                              ])
                      ),
                      ///Confirm button
                      noActivity ?
                      Container() :
                      Align(
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
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                                  width: 158, ///media.width * .4
                                  height: 44,
                                  child: MaterialButton(
                                    elevation: 0,
                                    hoverElevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    onPressed: () {
                                      if (order.cartCounter > 0) {
                                        // dispatch the order
                                        StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(order));
                                        // go to the cart page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => CartReservable(serviceState: widget.serviceState, tourist: widget.tourist)),
                                        );
                                      }
                                      else {
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
                                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                    color:  widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                    padding: EdgeInsets.all(media.width * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).reserveUpper,
                                      style: TextStyle(
                                        letterSpacing: 1.25,
                                        fontSize: 14,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: BuytimeTheme.TextWhite,

                                      ),
                                    ),
                                  )
                              ),
                              /*Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // trigger payment information page
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => UI_U_StripePayment()),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: (media.height * 0.05)),
                                          child: Container(
                                            width: media.width * 0.55,
                                            decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text(AppLocalizations.of(context).orderAndPay, style: TextStyle(color: Colors.white))],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         // trigger payment information page
                                  //         print("Dispatch Order create!");
                                  //         StoreProvider.of<AppState>(context).dispatch(CreateOrder(OrderState(
                                  //             itemList: snapshot.order.itemList,
                                  //             date: snapshot.order.date,
                                  //             progress: "paid",
                                  //             position: snapshot.order.position,
                                  //             total: snapshot.order.total,
                                  //             business: snapshot.order.business,
                                  //             user: snapshot.order.user,
                                  //             businessId: snapshot.business.id_firestore)));
                                  //         StoreProvider.of<AppState>(context).dispatch(OrderListRequest());
                                  //       },
                                  //       child: Padding(
                                  //         padding: EdgeInsets.only(top: (media.height * 0.05)),
                                  //         child: Container(
                                  //           width: media.width * 0.55,
                                  //           decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.all(8.0),
                                  //             child: Row(
                                  //               mainAxisAlignment: MainAxisAlignment.center,
                                  //               children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text("Test Order Create", style: TextStyle(color: Colors.white))],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: media.height * 0.05,
                                  )*/
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              /* )*/
            ),
          ),
        );
      },
    );
  }
}
