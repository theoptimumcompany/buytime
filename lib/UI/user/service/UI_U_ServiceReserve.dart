import 'dart:async';
import 'dart:math';
import 'package:Buytime/UI/user/cart/UI_U_Cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/cart_icon.dart';
import 'package:Buytime/reusable/time_slot_widget.dart';
import 'package:Buytime/utils/globals.dart';
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


class ServiceReserve extends StatefulWidget {
  final ServiceState serviceState;

  ServiceReserve({@required this.serviceState});

  @override
  createState() => _ServiceReserveState();

}

class _ServiceReserveState extends State<ServiceReserve> with SingleTickerProviderStateMixin {

  ServiceState serviceState;
  OrderState order = OrderState().toEmpty();

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
  List<List<List<dynamic>>> tmpSlots = [];
  List<List<List<dynamic>>> slots = [];
  List<List<List<int>>> indexes = [];
  List<DateTime> getDaysInBeteween(DateTime startDate, DateTime endDate, DateTime userStartDate, DateTime userEndDate, ServiceSlot slot) {
    tmpSlots.clear();
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if(startDate.add(Duration(days: i)).isAfter(userStartDate) && startDate.add(Duration(days: i)).isBefore(userEndDate)){
        if(startDate.add(Duration(days: i)).isAfter(startDate)){
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          if(startDate.add(Duration(days: i)).isAfter(currentTime) || startDate.add(Duration(days: i)).isAtSameMomentAs(currentTime)) {
              days.add(startDate.add(Duration(days: i)));
              tmpSlots.add(List.generate(slot.startTime.length, (index) => [index, slot]));
            }
          //picked.add(List.generate(endDate.difference(startDate).inDays, (index) => false));
          //indexes.add(List.generate(endDate.difference(startDate).inDays, (index) => List.generate(2, (index) => 0)));
        }
      }
    }
    return days;
  }

  void deleteItem(OrderState snapshot, OrderEntry entry) {
    setState(() {
      //cartCounter = cartCounter - entry.number;
      order.cartCounter = order.cartCounter - entry.number;
      order.removeReserveItem(entry);
      order.itemList.remove(entry);
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(order));
    });
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        order = store.state.order.itemList != null ? (store.state.order.itemList.length > 0 ? store.state.order : order) : order;
        //order = store.state.order.itemList != null ? (store.state.order.itemList.length > 0 ? store.state.order : order) : order;

        DateTime startDate = DateFormat('dd/MM/yyyy').parse(widget.serviceState.serviceSlot.first.checkIn);
        DateTime endDate = DateFormat('dd/MM/yyyy').parse(widget.serviceState.serviceSlot.first.checkOut);

        debugPrint('UI_U_ServiceReserve => SLOTS: ${widget.serviceState.serviceSlot.length}');
        dates.clear();
        widget.serviceState.serviceSlot.forEach((element) {
          DateTime tmpStartDate = DateFormat('dd/MM/yyyy').parse(element.checkIn);
          DateTime tmpEndDate = DateFormat('dd/MM/yyyy').parse(element.checkOut);
          if(dates.isEmpty){
            dates = getDaysInBeteween(tmpStartDate, tmpEndDate, store.state.booking.start_date,  store.state.booking.end_date, element);
            slots.addAll(tmpSlots);
          }else{
            List<DateTime> tmpDates = getDaysInBeteween(tmpStartDate, tmpEndDate, store.state.booking.start_date,  store.state.booking.end_date, element);
            for(int i = 0; i < dates.length; i++){
              for(int j = 0; j < tmpDates.length; j++){
                if(dates[i] == tmpDates[j])
                  slots[i].addAll(tmpSlots[j]);
              }
            }
            for(int i = 0; i < tmpDates.length; i++){
              if(!dates.contains(tmpDates[i])){
                dates.add(tmpDates[i]);
                slots.add(tmpSlots[i]);
              }
            }
            /*tmpDates.forEach((element) {
              if(!dates.contains(element))
                dates.add(element);
              if(dates.contains(element)){

              }
            });*/
          }

         /* if(tmpStartDate.isBefore(startDate))
            startDate = tmpStartDate;

          if(tmpEndDate.isAfter(endDate))
            endDate = tmpEndDate;*/
        });

        slots.forEach((element) {
          element.sort((a,b) => (a.last.startTime[a.first]).compareTo(b.last.startTime[b.first]));
        });

        slots.forEach((element) {
          picked.add(List.generate(element.length, (index) => false));
          indexes.add(List.generate(element.length, (index) => List.generate(2, (index) => 0)));
        });

        debugPrint("UI_U_ServiceReserve => SLOTS: ${slots}");

        //dates = getDaysInBeteween(startDate, endDate, store.state.booking.start_date,  store.state.booking.end_date);
      },
      builder: (context, snapshot) {
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        int start = int.parse(widget.serviceState.serviceSlot.first.checkIn.substring(0,2));
        int end = int.parse(widget.serviceState.serviceSlot.first.checkOut.substring(0,2));

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
        for(int i = 0; i < picked.length; i++){
          for(int j = 0; j < picked[i].length; j++){
            bool found = false;
            order.selected.forEach((element) {
              if(i == element[0] && j == element[1]){
                found = true;
              }
            });
            if(found)
              picked[i][j] = true;
            else
              picked[i][j] = false;
          }
        }
        /*dates.forEach((element) {
          debugPrint('UI_U_ServiceReserve => DATE: ${element}');
        });*/
        /*for(int i = start; i < end; i++){
          dates.add(i);
        }*/
        debugPrint("UI_U_ServiceReserve => CART COUNT: ${order.cartCounter}");
        debugPrint('UI_U_ServiceReserve => PICKED: ${picked.length}');
        debugPrint('UI_U_ServiceReserve => INTERVAL SLOTS LENGTH: ${widget.serviceState.serviceSlot.first.startTime.length}');
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
                background: BuytimeTheme.UserPrimary,
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
                            StoreProvider.of<AppState>(context).dispatch(SetOrder(OrderState().toEmpty()));
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        AppLocalizations.of(context).reserveSpace + widget.serviceState.name,
                        textAlign: TextAlign.start,
                        style: BuytimeTheme.appbarTitle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                              serviceState.name ?? AppLocalizations.of(context).serviceName,
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
                              ' ${serviceState.price.toStringAsFixed(2)}',
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
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 2.5),
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3, right: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockVertical * 2),
                              child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    border: Border.all(
                                      color: picked.first[0] ? BuytimeTheme.UserPrimary.withOpacity(0.5) : BuytimeTheme.BackgroundWhite
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: picked[0][0] ? BuytimeTheme.BackgroundWhite : BuytimeTheme.BackgroundBlack.withOpacity(0.3),
                                        spreadRadius: .5,
                                        blurRadius: 1,
                                        offset: Offset(0, picked.first[0] ? 0 : 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.all(Radius.circular(5)),
                                        onTap: () async {
                                          setState(() {
                                            picked[0][0] = !picked[0][0];
                                          });

                                          indexes[0][0][0] = 0;
                                          indexes[0][0][1] = 0;

                                          if(picked.first[0]){
                                            order.business.name = snapshot.business.name;
                                            order.business.id = snapshot.business.id_firestore;
                                            order.user.name = snapshot.user.name;
                                            order.user.id = snapshot.user.uid;
                                            order.addReserveItem(widget.serviceState, snapshot.business.ownerId, slots[0][0][1].startTime[slots[0][0][0]], slots[0][0][1].duration.toString(), dates[0], slots[0][0][1].price);
                                            order.selected.add(indexes[0][0]);
                                            order.cartCounter++;
                                            //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                            StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                            /*setState(() {
                                              cartCounter++;
                                            });*/
                                          }else{
                                            OrderEntry tmp;
                                            order.itemList.forEach((element) {
                                              if(element.time ==  slots[0][0][1].startTime[slots[0][0][0]] && element.date.isAtSameMomentAs(dates[0])){
                                                tmp = element;
                                              }
                                            });
                                            order.selected.remove(indexes[0][0]);
                                            deleteItem(snapshot.order, tmp);
                                          }

                                          debugPrint('UI_U_ServiceReserve => SELECTED INDEXES: ${order.selected}');
                                        },
                                        child: TimeSlotWidget(slots[0][0][1], slots[0][0][0], picked.first[0]),
                                      )
                                  )
                              ),
                            )

                            ,
                          )
                        ],
                      ),
                      ///Blue part & Time Slots
                      Expanded(
                        flex: 5,
                        child: CustomScrollView(shrinkWrap: true, slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              //MenuItemModel menuItem = menuItems.elementAt(index);
                              //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                              DateTime i = dates.elementAt(index);
                              String date = DateFormat('MMM dd').format(i).toUpperCase();
                              List<bool> select = picked.elementAt(index);
                              return Column(
                                children: [
                                  ///Blue part
                                  Container(
                                    color: BuytimeTheme.UserPrimary,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                          child: Text(
                                            index == 0 ? AppLocalizations.of(context).today + date : index == 1 ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE').format(i).toUpperCase()}, $date',
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
                                  Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3),
                                    height: 104,
                                    width: SizeConfig.safeBlockHorizontal * 100,
                                    child: CustomScrollView(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true, slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate((context, i) {
                                          //MenuItemModel menuItem = menuItems.elementAt(index);
                                          //final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                          List<dynamic> serviceSlot = slots[index].elementAt(i);
                                          indexes[index][i][0] = index;
                                          indexes[index][i][1] = i;
                                          return index == 0 && i == 0 ? Container() :
                                          Container(
                                            margin: EdgeInsets.only(top: 2, bottom: 2, right: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockVertical * 2),
                                            child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color:  BuytimeTheme.BackgroundWhite,
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  border: Border.all(
                                                      color: select[i] ? BuytimeTheme.UserPrimary.withOpacity(0.5) : BuytimeTheme.BackgroundWhite
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
                                                      onTap: () async {
                                                        setState(() {
                                                          select[i] = !select[i];
                                                        });
                                                        if(select[i]){
                                                          order.business.name = snapshot.business.name;
                                                          order.business.id = snapshot.business.id_firestore;
                                                          order.user.name = snapshot.user.name;
                                                          order.user.id = snapshot.user.uid;
                                                          order.addReserveItem(widget.serviceState, snapshot.business.ownerId, serviceSlot[1].startTime[serviceSlot[0]], serviceSlot[1].duration.toString(), dates[index], serviceSlot[1].price);
                                                          order.selected.add(indexes[index][i]);
                                                          order.cartCounter++;
                                                          //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                          StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                        }else{
                                                          OrderEntry tmp;
                                                          order.itemList.forEach((element) {
                                                            if(element.time ==  serviceSlot[1].startTime[serviceSlot[0]] && element.date.isAtSameMomentAs(dates[index])){
                                                              tmp = element;
                                                            }
                                                          });
                                                          order.selected.remove(indexes[index][i]);
                                                          deleteItem(snapshot.order, tmp);
                                                        }

                                                        debugPrint('UI_U_ServiceReserve => SELECTED INDEXES: ${order.selected}');
                                                      },
                                                      child: TimeSlotWidget(serviceSlot[1], serviceSlot[0], select[i]),
                                                    )
                                                )
                                            ),
                                          );
                                        },
                                          childCount: slots[index].length,
                                        ),
                                      ),
                                    ]),
                                  ),
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
                                        StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                        // go to the cart page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Cart(serviceState: widget.serviceState,)),
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
                                            ));
                                      }
                                    },
                                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                                    color: BuytimeTheme.UserPrimary,
                                    padding: EdgeInsets.all(media.width * 0.03),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context).confirmUpper,
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
