import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/area_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:Buytime/UI/user/map/animated_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../environment_abstract.dart';


class OrderDetails extends StatefulWidget {
  final OrderState orderState;
  static String route = '/orderDetails';
  bool tourist;
  ServiceState serviceState;
  OrderDetails({@required this.orderState, this.tourist, this.serviceState});

  @override
  createState() => _OrderDetailsState();

}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {

  OrderState order = OrderState().toEmpty();

  String date = '';
  String currentDate = '';
  String nextDate = '';
  String card = '';
  List<String> cc = ['v','mc','e'];
  double lat = 0.0;
  double lng = 0.0;
  bool refundAsked = false;

  @override
  void initState() {
    super.initState();

    //debugPrint('${widget.imageUrl}');
    if(widget.orderState.cardType != null && widget.orderState.cardType.isNotEmpty)
      card = widget.orderState.cardType.toLowerCase().substring(0,1) == 'v' ? 'v' : 'mc';
    else
      card = 'e';
    date = DateFormat('MMM dd').format(widget.orderState.date).toUpperCase();
    currentDate = DateFormat('MMM dd').format(DateTime.now()).toUpperCase();
    nextDate = DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase();
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
    DateTime orderDateUTC2 = new DateTime(orderDate.year, orderDate.month, orderDate.day, orderDate.hour + 2, orderDate.minute, 0, 0, 0);
    if(widget.orderState.itemList.first.time != null){
      return currentDate == date ?
      AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${widget.orderState.itemList.first.time}' :
      nextDate == date ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${widget.orderState.itemList.first.time}' :
      '${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)},  ${widget.orderState.itemList.first.time}';
    }else{
      return currentDate == date ?
      AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDateUTC2)}' :
      nextDate == date ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDateUTC2)}' :
      '${DateFormat('dd EEE',Localizations.localeOf(context).languageCode).format(orderDate)},  ${DateFormat('HH:mm',Localizations.localeOf(context).languageCode).format(orderDateUTC2)}';
    }

  }

  String getShopLocationImage(String coordinates){


    String url;
    if(Platform.isIOS)
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${Environment().config.googleApiKey}';
    else
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${Environment().config.googleApiKey}';

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
      AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
      StoreProvider.of<AppState>(context).dispatch(SetArea(Utils.getCurrentArea('$currentLat, $currentLng', areaListState)));
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
    if(widget.serviceState.serviceCoordinates != null && widget.serviceState.serviceCoordinates.isNotEmpty){
      List<String> latLng2 = widget.serviceState.serviceCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('W_add_external_business_list_item => ${widget.serviceState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }else if(widget.serviceState.serviceBusinessCoordinates != null && widget.serviceState.serviceBusinessCoordinates.isNotEmpty){
      List<String> latLng2 = widget.serviceState.serviceBusinessCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
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
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    refundAsked = false;
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        if(store.state.business.id_firestore != null && store.state.business.id_firestore.isNotEmpty){
          List<String> latLng = store.state.business.coordinate.replaceAll(' ', '').split(',');
          lat = double.parse(latLng[0]);
          lng = double.parse(latLng[1]);
        }
        //requestLocationPermission();
        //_gpsService();
       // _getCurrentLocation();
        _getLocation(store.state.business);
      },
      builder: (context, snapshot) {
        debugPrint('UI_U_ServiceDetails => SNAPSHOT CART COUNT: ${snapshot.order}');
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_ServiceDetails => CART COUNT: ${order.cartCounter}');

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
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration(seconds: 1), () {
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
                          widget.orderState.itemList.length > 1 ?
                          Utils.retriveField(Localizations.localeOf(context).languageCode, widget.orderState.business.name)
                           : Utils.retriveField(Localizations.localeOf(context).languageCode,  widget.orderState.itemList.first.name),
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
                          imageUrl:  widget.orderState.itemList.length > 1 ? version1000(widget.orderState.business.thumbnail) : version1000(widget.orderState.itemList.first.thumbnail),
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
                                              widget.orderState.itemList.length > 1 ? AppLocalizations.of(context).multipleOrders :
                                              Utils.retriveField(Localizations.localeOf(context).languageCode, widget.orderState.itemList[0].name),
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
                        widget.orderState.itemList.first.time != null ?
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
                                              snapshot.serviceState.serviceAddress != null && snapshot.serviceState.serviceAddress.isNotEmpty ? snapshot.serviceState.serviceAddress : snapshot.business.businessAddress,
                                              //snapshot.business.street + ', ' + snapshot.business.street_number + ', ' + snapshot.business.ZIP + ', ' + snapshot.business.state_province,
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
                                    /*Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        //AppLocalizations.of(context).openUntil + ' ...',
                                        '',
                                        style: TextStyle(
                                            letterSpacing: 0.15,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ),*/
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
                                                        MaterialPageRoute(builder: (context) => BuytimeMap(user: false, title: snapshot.business.name,
                                                          businessState: snapshot.business,
                                                          serviceState: widget.serviceState,
                                                        )
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
                                  String address = widget.orderState.itemList.length > 1 ? widget.orderState.business.name : widget.orderState.itemList.first.name;
                                  //Utils.openMap(lat, lng);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: widget.orderState.itemList.length > 1 ? widget.orderState.business.name : widget.orderState.itemList.first.name, businessState: snapshot.business,)),);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: address,
                                    businessState: snapshot.business,
                                      serviceState: ServiceState().toEmpty() ///TODO service address
                                  )));
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                },
                                child: Container(
                                  width: 174,
                                  height: 125,
                                  //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                  child: CachedNetworkImage(
                                    imageUrl:  getShopLocationImage(snapshot.business.coordinate),
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
                        widget.orderState.itemList.first.time != null ?
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
                              Utils.translateOrderStatusUser(context, widget.orderState.progress).toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Utils.colorOrderStatusUser(context, widget.orderState.progress),
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
                              whichDate(widget.orderState.itemList.first.date),
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
                        widget.orderState.itemList.first.time == null && widget.orderState.location.isNotEmpty ?
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
                        widget.orderState.itemList.first.time == null && widget.orderState.location.isNotEmpty ?
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.orderState.location,
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
                        widget.orderState.itemList.first.time != null  ?
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
                        widget.orderState.itemList.first.time != null  ?
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
                              widget.orderState.cardLast4Digit != null ?
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
                              ) : Container(),
                              ///Card Name
                              widget.orderState.cardLast4Digit != null ?
                              Text(
                                widget.orderState.cardType != null && widget.orderState.cardType.isNotEmpty?
                                  widget.orderState.cardType.substring(0,1).toUpperCase() + widget.orderState.cardType.substring(1, widget.orderState.cardType.length) + '  ' :
                                  'Sample  ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    fontWeight: FontWeight.w600,
                                    color: BuytimeTheme.TextBlack
                                ),
                              ) : Container(),
                              ///Ending **** ....
                              Text(
                                widget.orderState.cardType != null && widget.orderState.cardLast4Digit != null  ?
                                  '**** ' + widget.orderState.cardLast4Digit :
                                AppLocalizations.of(context).native,
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
                        widget.orderState.itemList.first.time == null  ?
                        widget.orderState.itemList.length > 1 ?
                            ((){
                        List<Widget> tmpOrders = [];
                          widget.orderState.itemList.forEach((element) {
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
                                widget.orderState.itemList.first.number > 1 ?
                                '${widget.orderState.itemList.first.number} x ${AppLocalizations.of(context).products}' :
                                '${widget.orderState.itemList.first.number} x ${AppLocalizations.of(context).product}',
                                style: TextStyle(
                                    letterSpacing: 0.15,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextBlack,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                              Text(
                                '${widget.orderState.itemList.first.number} x ${widget.orderState.itemList.first.price.toStringAsFixed(2)} €',
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
                        widget.orderState.itemList.first.time == null ? Container(
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
                                '${AppLocalizations.of(context).euroSpace} ${widget.orderState.total.toStringAsFixed(2)}',
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
                              '${AppLocalizations.of(context).euroSpace} ${widget.orderState.total.toStringAsFixed(2)}',
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
                        widget.orderState.progress == Utils.enumToString(OrderStatus.paid) ? Container(
                            margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                            alignment: Alignment.center,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: refundAsked ? null: () {
                                    refundAsked = true;
                                    StoreProvider.of<AppState>(context).dispatch(RefundOrderByUser(widget.orderState.orderId));
                                  },
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      AppLocalizations.of(context).askForRefund,
                                      style: TextStyle(
                                          letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: refundAsked ? BuytimeTheme.TextGrey : BuytimeTheme.UserPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16
                                      ),
                                    ),
                                  )),
                            )) : Container(),
                      ],
                    ),
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
