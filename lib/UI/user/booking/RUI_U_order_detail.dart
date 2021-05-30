import 'dart:math';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:io';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/foundation.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class RUI_U_OrderDetail extends StatefulWidget {
  static String route = '/orderDetails';
  RUI_U_OrderDetail();
  @override
  createState() => _RUI_U_OrderDetailState();

}

class _RUI_U_OrderDetailState extends State<RUI_U_OrderDetail> with SingleTickerProviderStateMixin {

  OrderState order = OrderState().toEmpty();
  Stream<DocumentSnapshot> _orderStream;
  String date = '';
  String currentDate = '';
  String nextDate = '';
  String card = '';
  List<String> cc = ['v','mc','e'];
  double lat = 0.0;
  double lng = 0.0;
  BusinessState businessState;
  bool tourist;
  OrderDetailState orderDetails;
  ServiceState serviceState;

  @override
  void initState() {
    super.initState();
    //currentDate == date ? AppLocalizations.of(context).today + date : index == 1 && nextDate == date ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE').format(i).toUpperCase()}, $date'
  }


  @override
  void dispose() {
    super.dispose();
  }

  String version1000(String imageUrl) {
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

  String whichDate(DateTime orderDate){
    if(orderDetails.itemList.first.time != null){
      return currentDate == date ?
      AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${orderDetails.itemList.first.time}' :
      nextDate == date ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${orderDetails.itemList.first.time}' :
      '${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)},  ${orderDetails.itemList.first.time}';
    }else{
      return currentDate == date ?
      AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDetails.date)}' :
      nextDate == date ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDetails.date)}' :
      '${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)},  ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDetails.date)}';
    }

  }

  String getShopLocationImage(String coordinates){


    String url;
    if(Platform.isIOS)
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${BuytimeConfig.AndroidApiKey}';
    else
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${BuytimeConfig.AndroidApiKey}';

    return url;
  }

  double currentLat = 0;
  double currentLng = 0;
  Position _currentPosition;
  double distanceFromBusiness;
  double distanceFromCurrentPosition;
  bool gettingLocation = true;
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await Permission.location.isGranted;
    if (!granted) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        debugPrint('UI_U_order_details => FROM GEOLOCATOR: $_currentPosition');
        currentLat = _currentPosition.latitude;
        currentLng = _currentPosition.longitude;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getLocation(BusinessState businessState) async{
    loc.Location location = new loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        debugPrint('UI_U_order_details => LOCATION NOT ENABLED');
        setState(() {
          gettingLocation = false;
          distanceFromBusiness = calculateDistance(businessState.coordinate);
        });
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        debugPrint('UI_U_order_details => PERMISSION NOY GARANTED');
        return;
      }
    }

    _locationData = await location.getLocation();
    debugPrint('UI_U_order_details => FROM LOCATION: $_locationData');
    if(_locationData.latitude != null){
      setState(() {
        gettingLocation = false;
        distanceFromCurrentPosition = calculateDistance('$currentLat, $currentLng');
      });
    }
    _getCurrentLocation();
  }

  double calculateDistance(String coordiantes){
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
    if(coordiantes.isNotEmpty){
      List<String> latLng1 = coordiantes.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      //debugPrint('W_add_external_business_list_item => $businessState.name} | Cordinates 1: $latLng1');
      if(latLng1.length == 2){
        lat1 = double.parse(latLng1[0]);
        lon1 = double.parse(latLng1[1]);
      }
    }
    if(serviceState.serviceCoordinates != null && serviceState.serviceCoordinates.isNotEmpty){
      List<String> latLng2 = serviceState.serviceCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('W_add_external_business_list_item => ${serviceState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }else if(serviceState.serviceBusinessCoordinates != null && serviceState.serviceBusinessCoordinates.isNotEmpty){
      List<String> latLng2 = serviceState.serviceBusinessCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      //debugPrint('W_add_external_business_list_item => ${widget.externalBusinessState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    double tmp = (12742 * asin(sqrt(a)));
    debugPrint('W_add_external_business_list_item => Distance: $tmp');

    return  tmp;
  }

  @override
  Widget build(BuildContext context) {
    businessState  = StoreProvider.of<AppState>(context).state.business;
    serviceState = StoreProvider.of<AppState>(context).state.serviceState;
    order = StoreProvider.of<AppState>(context).state.order;

    if(gettingLocation)
      _getLocation(StoreProvider.of<AppState>(context).state.business);
    //serviceState = ServiceState().toEmpty();
    orderDetails = StoreProvider.of<AppState>(context).state.orderDetail;
    tourist = !(StoreProvider.of<AppState>(context).state.booking != null && StoreProvider.of<AppState>(context).state.booking.booking_id.isNotEmpty);
    //debugPrint('${widget.imageUrl}');
    if(orderDetails.cardType != null && orderDetails.cardType.isNotEmpty)
      card = orderDetails.cardType.toLowerCase().substring(0,1) == 'v' ? 'v' : 'mc';
    else
      card = 'e';
    date = DateFormat('MMM dd').format(orderDetails.date).toUpperCase();
    currentDate = DateFormat('MMM dd').format(DateTime.now()).toUpperCase();
    nextDate = DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase();
    if(businessState.id_firestore != null && businessState.id_firestore.isNotEmpty){
      List<String> latLng = businessState.coordinate.replaceAll(' ', '').split(',');
      lat = double.parse(latLng[0]);
      lng = double.parse(latLng[1]);
    }
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    if(orderDetails.orderId != null && orderDetails.orderId.isNotEmpty) {
      _orderStream = FirebaseFirestore.instance.collection('order').doc(orderDetails.orderId).snapshots();
    }
      return StreamBuilder<DocumentSnapshot>(
        stream: _orderStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> orderSnapshot) {
          if (orderSnapshot!= null && orderSnapshot.data != null && !orderSnapshot.hasError && orderSnapshot.connectionState != ConnectionState.waiting) {
            orderDetails = OrderDetailState.fromJson(orderSnapshot.data.data());

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
                    background: tourist != null && tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
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
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.of(context).popUntil(ModalRoute.withName('/bookingPage'));
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
                              orderDetails.itemList.length > 1 ?
                              Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.business.name)
                                  : Utils.retriveField(Localizations.localeOf(context).languageCode,  orderDetails.itemList.first.name),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: BuytimeTheme.appbarTitle,
                            ),
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
                                    onPressed: (){
                                      if (order.cartCounter > 0) {
                                        // dispatch the order
                                        StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                        // go to the cart page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Cart(tourist: false,)),
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
                        constraints: BoxConstraints(
                          //minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ///Image
                            CachedNetworkImage(
                              imageUrl:  orderDetails.itemList.length > 1 ? version1000(orderDetails.business.thumbnail) : version1000(orderDetails.itemList.first.thumbnail),
                              imageBuilder: (context, imageProvider) => Container(
                                //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                //width: double.infinity,
                                //height: double.infinity,
                                //width: 200, ///SizeConfig.safeBlockVertical * widget.width
                                height: 375, ///SizeConfig.safeBlockVertical * widget.width
                                decoration: BoxDecoration(
                                    color: BuytimeTheme.BackgroundWhite,
                                    //borderRadius: BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )
                                ),
                                child: Container(
                                  //width: 375,
                                  height: 375,
                                  decoration: BoxDecoration(
                                    //borderRadius: BorderRadius.all(Radius.circular(5)),
                                    //color: Colors.black.withOpacity(.2)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Service name
                                      Container(
                                        //width: 200,
                                        height: 100/3,
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              BuytimeTheme.BackgroundBlack.withOpacity(0.5),
                                            ],
                                            begin : Alignment.topCenter,
                                            end : Alignment.bottomCenter,
                                            stops: [0.0, 5.0],
                                            //tileMode: TileMode.
                                          ),
                                        ),
                                        //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  orderDetails.itemList.length > 1 ? AppLocalizations.of(context).multipleOrders :
                                                  Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.itemList[0].name),
                                                  style: TextStyle(
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextWhite,
                                                      fontWeight: FontWeight.bold,
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
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                // width: 200, ///SizeConfig.safeBlockVertical * widget.width
                                height: 100, ///SizeConfig.safeBlockVertical * widget.width
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator()
                                  ],
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            ///Address & Map
                            orderDetails.itemList.first.time != null ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Container(
                                    height: 125,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///Address
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ///Address text
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  AppLocalizations.of(context).address.toUpperCase(),
                                                  style: TextStyle(
                                                      letterSpacing: 1.5,
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextMedium,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ///Address value
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                              child: FittedBox(
                                                fit: BoxFit.scaleDown,
                                                child: Text(
                                                  serviceState.serviceAddress.isNotEmpty ? serviceState.serviceAddress : businessState.businessAddress,
                                                  style: TextStyle(
                                                      letterSpacing: 0.15,
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextBlack,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ///Hour text
                                        /*Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context).hours.toUpperCase(),
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),*/
                                        ///Open until value
                                        Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            ///Orario fine giornata
                                            '${AppLocalizations.of(context).openUntil} ${orderDetails.openUntil}',
                                            style: TextStyle(
                                                letterSpacing: 0.15,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),
                                        ///Directions
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                size: 14,
                                                color: BuytimeTheme.SymbolGrey,
                                              ),
                                              ///Min
                                              gettingLocation ? Container(
                                                margin: EdgeInsets.only(left: 5, right: 2.5),
                                                height: 12,
                                                width: 12,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  //valueColor: new AlwaysStoppedAnimation<Color>(widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary),
                                                ),
                                              ) :
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                        (){
                                                      if(distanceFromCurrentPosition != null){
                                                        return distanceFromCurrentPosition.toString().split('.').first.startsWith('0') && distanceFromCurrentPosition.toString().split('.').first.length != 1?
                                                        distanceFromCurrentPosition.toString().split('.').last.substring(0,3) + ' m' :
                                                        distanceFromCurrentPosition.toStringAsFixed(1) + ' Km';
                                                      }else{
                                                        return distanceFromBusiness.toString().split('.').first.startsWith('0') && distanceFromBusiness.toString().split('.').first.length != 1?
                                                        distanceFromBusiness.toString().split('.').last.substring(0,3) + ' m' :
                                                        distanceFromBusiness.toStringAsFixed(1) + ' Km';
                                                      }
                                                    }(),
                                                    style: TextStyle(
                                                        letterSpacing: 0.25,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextMedium,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              ///Directions
                                              Container(
                                                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                  alignment: Alignment.center,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => BuytimeMap(user: true,
                                                                title: orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name,
                                                                businessState: businessState,
                                                                serviceState: serviceState) ///TODO service address
                                                            ),
                                                          );
                                                        },
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        child: Container(
                                                          padding: EdgeInsets.all(5.0),
                                                          child: Text(
                                                            AppLocalizations.of(context).directions,
                                                            style: TextStyle(
                                                                letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: BuytimeTheme.UserPrimary,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 14

                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                            ),
                                                          ),
                                                        )),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                ///Map
                                Flexible(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: (){
                                      String address = orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name;
                                      //Utils.openMap(lat, lng);
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name, businessState: businessState,)),);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: address,
                                          businessState: businessState,
                                          serviceState: ServiceState().toEmpty() ///TODO service address
                                      )));
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                    },
                                    child: Container(
                                      width: 174,
                                      height: 125,
                                      //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:  getShopLocationImage(businessState.coordinate),
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                              color: BuytimeTheme.BackgroundWhite,
                                              //borderRadius: BorderRadius.all(Radius.circular(5)),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  BuytimeTheme.BackgroundWhite,
                                                  BuytimeTheme.BackgroundWhite.withOpacity(0.1),
                                                ],
                                                begin : Alignment.centerLeft,
                                                end : Alignment.centerRight,
                                                //tileMode: TileMode.
                                              ),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Container(
                                          // width: 200, ///SizeConfig.safeBlockVertical * widget.width
                                          height: 100, ///SizeConfig.safeBlockVertical * widget.width
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ) : Container(),
                            ///Divider
                            orderDetails.itemList.first.time != null ?
                            Container(
                              //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                              height: 15,
                              color: BuytimeTheme.DividerGrey,
                            ) : Container(),
                            ///Order status
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  Utils.translateOrderStatus(context, orderDetails.progress).toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Utils.colorOrderStatus(context, orderDetails.progress),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            ///Date
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  orderDetails.itemList.first.time != null ? whichDate(orderDetails.itemList.first.date) : "test",
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            ///Location
                            orderDetails.itemList.first.time == null && orderDetails.location.isNotEmpty ?
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).location.toUpperCase().replaceAll(' ', ''),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ) : Container(),
                            ///Location value
                            orderDetails.itemList.first.time == null && orderDetails.location.isNotEmpty ?
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  orderDetails.location,
                                  style: TextStyle(
                                      letterSpacing: 0.15,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ) : Container(),
                            /*///Conditions
                            orderDetails.itemList.first.time != null  ?
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).conditions.toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ) : Container(),
                            ///Conditions value
                            orderDetails.itemList.first.time != null  ?
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '...',
                                  style: TextStyle(
                                      letterSpacing: 0.15,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ) : Container(),*/
                            ///Payment method
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).choosePaymentMethod.substring(7,AppLocalizations.of(context).choosePaymentMethod.length ).toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            ///Payment value
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 50,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 2.5),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/img/cc/$card.png'
                                            )
                                        )
                                    ),
                                  ),
                                  ///Card Name
                                  Text(
                                    orderDetails.cardType != null && orderDetails.cardType.isNotEmpty?
                                    orderDetails.cardType.substring(0,1).toUpperCase() + orderDetails.cardType.substring(1, orderDetails.cardType.length) + '  ' :
                                    'Sample  ',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextBlack
                                    ),
                                  ),
                                  ///Ending **** ....
                                  Text(
                                    orderDetails.cardType != null && orderDetails.cardLast4Digit != null  ?
                                    '**** ' + orderDetails.cardLast4Digit :
                                    '**** 0000',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextBlack
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ///Price
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).price.toUpperCase(),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextMedium,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            orderDetails.itemList.first.time == null  ?
                            orderDetails.itemList.length > 1 ?
                            ((){
                              List<Widget> tmpOrders = [];
                              orderDetails.itemList.forEach((element) {
                                tmpOrders.add(
                                    Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            element.number > 1 ?
                                            '${element.number} x ${element.name}' :
                                            '${element.number} x ${element.name}',
                                            style: TextStyle(
                                                letterSpacing: 0.15,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                          Text(
                                            '${element.number} x ${element.price.toStringAsFixed(2)} €',
                                            style: TextStyle(
                                                letterSpacing: 0.15,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                );
                              });
                              return Column(
                                children: tmpOrders.map((e) => e).toList(),
                              );
                            }()) :
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderDetails.itemList.first.number > 1 ?
                                    '${orderDetails.itemList.first.number} x ${AppLocalizations.of(context).products}' :
                                    '${orderDetails.itemList.first.number} x ${AppLocalizations.of(context).product}',
                                    style: TextStyle(
                                        letterSpacing: 0.15,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                  Text(
                                    '${orderDetails.itemList.first.number} x ${orderDetails.itemList.first.price.toStringAsFixed(2)} €',
                                    style: TextStyle(
                                        letterSpacing: 0.15,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  )
                                ],
                              ),
                            ) : Container(),
                            ///Price value
                            orderDetails.itemList.first.time == null ? Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).onlyTotal}',
                                    style: TextStyle(
                                        letterSpacing: 0.15,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                  Text(
                                    '${AppLocalizations.of(context).euroSpace} ${orderDetails.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        letterSpacing: 0.15,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  )
                                ],
                              ),
                            ) :
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${AppLocalizations.of(context).euroSpace} ${orderDetails.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      letterSpacing: 0.15,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  /* )*/
                ),
              ),
            );
          } else {
            return spinnerConfirmOrder();
          }

          OrderState orderState = OrderState.fromJson(orderSnapshot.data.data());
          order = orderState.itemList != null ? (orderState.itemList.length > 0 ? orderState : OrderState().toEmpty()) : OrderState().toEmpty();
          debugPrint('UI_U_ServiceDetails => CART COUNT: ${order.cartCounter}');

        },
      );
  }

  Stack spinnerConfirmOrder() {
    return Stack(
      children: [
        Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
              height: SizeConfig.safeBlockVertical * 100,
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
      ],
    );
  }
}
