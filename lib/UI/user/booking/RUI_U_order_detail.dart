import 'dart:math';

import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_detail_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:flutter/foundation.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../environment_abstract.dart';

class RUI_U_OrderDetail extends StatefulWidget {
  String route = '/bookingPage';

  RUI_U_OrderDetail(this.route);

  @override
  createState() => _RUI_U_OrderDetailState();
}

class _RUI_U_OrderDetailState extends State<RUI_U_OrderDetail> with SingleTickerProviderStateMixin {
  OrderState order = OrderState().toEmpty();
  Stream<DocumentSnapshot> _orderStream;
  Stream<DocumentSnapshot> _businessStream;
  String date = '';
  String currentDate = '';
  String nextDate = '';
  String card = '';
  List<String> cc = ['v', 'mc', 'e'];
  double lat = 0.0;
  double lng = 0.0;
  BusinessState businessState = BusinessState().toEmpty();
  bool tourist;
  bool refundAsked = false;
  OrderDetailState orderDetails;
  ServiceState serviceState;

  Color _theme;
  Color _bgTheme;
  double height = 30;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    //currentDate == date ? AppLocalizations.of(context).today + date : index == 1 && nextDate == date ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE').format(i).toUpperCase()}, $date'
    _scrollController = ScrollController()
      ..addListener(
            () => _isAppBarExpanded ?
        _theme != Colors.black ?
        setState(() {
          _theme = Colors.black;
          _bgTheme = Colors.white;
          height = 30;
          print(
              'setState is called');
        },
        ):{} : _theme != Colors.white ?
        setState((){
          print('setState is called');
          _theme = Colors.white;
          _bgTheme = Colors.transparent;
          height = 50;
        }):{},
      );
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > ((SizeConfig.safeBlockVertical * 49) - kToolbarHeight);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget chosenPaymentMethod(String paymentType) {
    // card,
    // native,
    // room,
    // applePay,
    // googlePay,
    // onSite,
    // noPaymentMethod

    Widget widget = Container();
    switch (paymentType) {
      case 'card':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/mastercard_icon.png')),
          title: Text(AppLocalizations.of(context).creditCard),
          onTap: () {},
        );
        break;
      case 'native':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/native.png')),
          title: Text(AppLocalizations.of(context).native),
          onTap: () {},
        );
        break;
      case 'room':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/room.png')),
          title: Text(AppLocalizations.of(context).roomPayment),
          onTap: () {},
        );
        break;
      case 'applePay':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/applePay.png')),
          title: Text(AppLocalizations.of(context).applePay),
          onTap: () {},
        );
        break;
      case 'googlePay':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/googlePay.png')),
          title: Text(AppLocalizations.of(context).googlePay),
          onTap: () {},
        );
        break;
      case 'onSite':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/cash.png')),
          title: Text(AppLocalizations.of(context).onSite),
          onTap: () {},
        );
        break;
      case 'paypal':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/brand/paypal.png')),
          title: Text(AppLocalizations.of(context).paypal),
          onTap: () {},
        );
        break;
      case 'noPaymentMethod':
        widget = ListTile(
          leading: Image(width: SizeConfig.blockSizeHorizontal * 10, image: AssetImage('assets/img/noPaymentMethod.png')),
          title: Text(AppLocalizations.of(context).noPaymentMethod),
          onTap: () {},
        );
        break;
    }
    return widget;
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  String whichDate(DateTime orderDate) {
    DateTime orderDateUTC2 = new DateTime(orderDate.year, orderDate.month, orderDate.day, orderDate.toLocal().hour, orderDate.minute, 0, 0, 0);
    if (orderDetails.itemList.first.time != null) {
      return currentDate == date
          ? AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)}, ${orderDetails.itemList.first.time}'
          : nextDate == date
              ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)}, ${orderDetails.itemList.first.time}'
              : '${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)},  ${orderDetails.itemList.first.time}';
    } else {
      return currentDate == date
          ? AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm', Localizations.localeOf(context).languageCode).format(orderDateUTC2)}'
          : nextDate == date
              ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)}, ${DateFormat('HH:mm', Localizations.localeOf(context).languageCode).format(orderDateUTC2)}'
              : '${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(orderDate)},  ${DateFormat('HH:mm', Localizations.localeOf(context).languageCode).format(orderDateUTC2)}';
    }
  }

  String getShopLocationImage(String coordinates) {
    String url;
    if (Platform.isIOS)
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${Environment().config.googleApiKey}';
    else
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${Environment().config.googleApiKey}';

    return url;
  }

  double currentLat = 0;
  double currentLng = 0;
  Position _currentPosition;
  double distanceFromBusiness = 0;
  double distanceFromCurrentPosition = 0;
  bool gettingLocation = true;

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await Permission.location.isGranted;
    if (!granted) {
      requestLocationPermission();
    }
    debugPrint('RUI_U_order_detail => requestContactsPermission $granted');
    return granted;
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true).then((Position position) {
      setState(() {
        _currentPosition = position;
        debugPrint('RUI_U_order_detail => FROM GEOLOCATOR: $_currentPosition');
        currentLat = _currentPosition.latitude;
        currentLng = _currentPosition.longitude;
        gettingLocation = false;
        distanceFromCurrentPosition = calculateDistance('$currentLat, $currentLng');
      });
    }).catchError((e) {
      print(e);
    });
    setState(() {
      gettingLocation = false;
    });
  }

  _getLocation(BusinessState businessState) async {
    loc.Location location = new loc.Location();

    bool _serviceEnabled;
    bool _requestService;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _requestService = await location.requestService();
      if (!_requestService) {
        debugPrint('RUI_U_order_detail => LOCATION NOT ENABLED');
        setState(() {
          gettingLocation = false;
          distanceFromBusiness = calculateDistance(businessState.coordinate);
        });
        return;
      }else{
        debugPrint('RUI_U_order_detail => SERVICE NOT ENABLED');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        debugPrint('RUI_U_order_detail => PERMISSION NOT GARANTED');
        setState(() {
          gettingLocation = false;
          distanceFromBusiness = calculateDistance(businessState.coordinate);
        });
        return;
      }else{
        debugPrint('RUI_U_order_detail => PERMISSION GARANTED');
      }
    }

    // _locationData = await location.getLocation();
    // debugPrint('RUI_U_order_detail => FROM LOCATION: $_locationData');
    // if (_locationData.latitude != null) {
    //   /*setState(() {
    //     gettingLocation = false;
    //     distanceFromCurrentPosition = calculateDistance('$currentLat, $currentLng');
    //   });*/
    // }
    _getCurrentLocation();
  }

  double calculateDistance(String coordiantes) {
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
    if (coordiantes.isNotEmpty) {
      List<String> latLng1 = coordiantes.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      //debugPrint('RUI_U_order_detail => $businessState.name} | Cordinates 1: $latLng1');
      if (latLng1.length == 2) {
        lat1 = double.parse(latLng1[0]);
        lon1 = double.parse(latLng1[1]);
      }
    }
    if (serviceState.serviceCoordinates != null && serviceState.serviceCoordinates.isNotEmpty) {
      List<String> latLng2 = serviceState.serviceCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('RUI_U_order_detail => ${serviceState.name} | Cordinates 2: $latLng2');
      if (latLng2.length == 2) {
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    } else if (serviceState.serviceBusinessCoordinates != null && serviceState.serviceBusinessCoordinates.isNotEmpty) {
      List<String> latLng2 = serviceState.serviceBusinessCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      //debugPrint('RUI_U_order_detail => ${widget.externalBusinessState.name} | Cordinates 2: $latLng2');
      if (latLng2.length == 2) {
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double tmp = (12742 * asin(sqrt(a)));
    debugPrint('RUI_U_order_detail => Distance: $tmp');

    return tmp;
  }

  NotificationState notificationState;

  Future<Uri> createDynamicLink(String userId, String orderId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: Environment().config.dynamicLink,
      link: Uri.parse('${Environment().config.dynamicLink}/onSitePayment/?userId=$userId&orderId=$orderId'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print("Dynamic Link On Site Payment " + dynamicUrl.toString());
    return dynamicUrl;
  }

  String link = '';

  Future readDynamicLink(String userId, String orderId) async {
    if (link.isEmpty) {
      Uri tmp = await createDynamicLink(userId, orderId);
      setState(() {
        link = '$tmp';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    serviceState = StoreProvider.of<AppState>(context).state.serviceState;

    readDynamicLink(StoreProvider.of<AppState>(context).state.user.uid, StoreProvider.of<AppState>(context).state.orderDetail.orderId);

    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    orderDetails = StoreProvider.of<AppState>(context).state.orderDetail;
    tourist = !(StoreProvider.of<AppState>(context).state.booking != null && StoreProvider.of<AppState>(context).state.booking.booking_id.isNotEmpty);
    //debugPrint('RUI_U_order_detail => ${widget.imageUrl}');
    if (orderDetails.cardType != null && orderDetails.cardType.isNotEmpty)
      card = orderDetails.cardType.toLowerCase().substring(0, 1) == 'v' ? 'v' : 'mc';
    else
      card = 'e';
    date = DateFormat('MMM dd').format(orderDetails.date).toUpperCase();
    SizeConfig().init(context);

    if (orderDetails.orderId != null && orderDetails.orderId.isNotEmpty) {
      _orderStream = FirebaseFirestore.instance.collection('order').doc(orderDetails.orderId).snapshots();
    }
    notificationState = StoreProvider.of<AppState>(context).state.notificationState;
    if (notificationState.data.state.businessId.isNotEmpty)
      _businessStream = FirebaseFirestore.instance.collection('business').doc(notificationState.data.state.businessId).snapshots();
    else if (orderDetails.businessId.isNotEmpty)
      _businessStream = FirebaseFirestore.instance.collection('business').doc(orderDetails.itemList.first.id_business).snapshots();
    else
      _businessStream = FirebaseFirestore.instance.collection('business').doc(serviceState.businessId).snapshots();
    refundAsked = false;
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
          body: SafeArea(
            child: Container(
              height: SizeConfig.safeBlockVertical * 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 5,
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: _businessStream,
                      builder: (context, AsyncSnapshot<DocumentSnapshot> businessSnapshot) {
                        if (businessSnapshot != null && businessSnapshot.data != null && !businessSnapshot.hasError && businessSnapshot.connectionState != ConnectionState.waiting) {
                          businessState = BusinessState.fromJson(businessSnapshot.data.data() as Map<String, dynamic>);
                          //debugPrint('UI_U_order_details => PRICE: ${orderDetails.total}');
                          //debugPrint('UI_U_order_details => CARD TYPE: ${orderDetails.cardType}');
                          //businessState  = StoreProvider.of<AppState>(context).state.business;
                          order = StoreProvider.of<AppState>(context).state.order;

                          if (gettingLocation) _getLocation(StoreProvider.of<AppState>(context).state.business);
                          //serviceState = ServiceState().toEmpty();

                          currentDate = DateFormat('MMM dd').format(DateTime.now()).toUpperCase();
                          nextDate = DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase();
                          if (businessState.id_firestore != null && businessState.id_firestore.isNotEmpty) {
                            List<String> latLng = businessState.coordinate.replaceAll(' ', '').split(',');
                            lat = double.parse(latLng[0]);
                            lng = double.parse(latLng[1]);
                          }
                        }

                        return StreamBuilder<DocumentSnapshot>(
                          stream: _orderStream,
                          builder: (context, AsyncSnapshot<DocumentSnapshot> orderSnapshot) {
                            //OrderDetailState orderDetails = OrderDetailState.fromOrderState(orderDetails);
                            if (orderSnapshot != null && orderSnapshot.data != null && !orderSnapshot.hasError && orderSnapshot.connectionState != ConnectionState.waiting) {
                              orderDetails = OrderDetailState.fromJson(orderSnapshot.data.data());
                              order = OrderState.fromJson(orderSnapshot.data.data());
                              debugPrint('UI_U_order_details => PRICE: ${orderDetails.total}');
                              debugPrint('UI_U_order_details => CARD TYPE: ${orderDetails.cardType}');
                              debugPrint('UI_U_order_details => THUMBAIL: ${orderDetails.itemList.first.thumbnail}');
                              debugPrint('UI_U_order_details => _isAppBarExpanded: ${_isAppBarExpanded}');
                            }

                            return  CustomScrollView(
                              physics: new ClampingScrollPhysics(),
                              controller: _scrollController,
                              slivers: <Widget>[
                                SliverAppBar(
                                    centerTitle: true,
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        color: _theme,
                                        size: 25.0,
                                      ),
                                      tooltip: AppLocalizations.of(context).comeBack,
                                      onPressed: () {
                                        StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(''));
                                        Provider.of<ReserveList>(context, listen: false).clear();
                                        StoreProvider.of<AppState>(context).dispatch(SetOrderReservable(OrderReservableState().toEmpty()));
                                        Future.delayed(Duration(seconds: 1), () {
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RServiceExplorer()), (Route<dynamic> route) => false);
                                        });
                                      },
                                    ),
                                    actions: [

                                    ],
                                    title: _theme == Colors.black ? Text(
                                      orderDetails.itemList.length > 1
                                          ? Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.business.name)
                                          : Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.itemList.first.name),
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          //letterSpacing: 0.15,
                                          color: _theme
                                      ),
                                    ) : Container(),
                                    pinned: true,
                                    floating: true,
                                    elevation: 1,
                                    backgroundColor: Colors.white,
                                    expandedHeight: SizeConfig.safeBlockVertical * 50,
                                    flexibleSpace: Stack(
                                      children: [
                                        Positioned(
                                          child: !_isAppBarExpanded ?
                                          ///Image
                                          CachedNetworkImage(
                                            imageUrl: orderDetails.itemList.length > 1 ? version1000(orderDetails.business.thumbnail) : version1000(orderDetails.itemList.first.thumbnail),
                                            imageBuilder: (context, imageProvider) => Container(
                                              //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                              width: double.infinity,
                                              //height: double.infinity,
                                              //width: 200, ///SizeConfig.safeBlockVertical * widget.width
                                              height: SizeConfig.safeBlockVertical * 50,
                                              ///SizeConfig.safeBlockVertical * widget.width
                                              decoration: BoxDecoration(
                                                //color: BuytimeTheme.BackgroundWhite,
                                                //borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  )),
                                              child: Container(
                                                //width: 375,
                                                height: SizeConfig.safeBlockVertical * 50,
                                                decoration: BoxDecoration(
                                                  //borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  //color: Colors.black.withOpacity(.2)
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  ],
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) => Utils.imageShimmer(double.infinity, SizeConfig.safeBlockVertical * 50),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          )  :
                                          Container(
                                            color: Colors.white,
                                          ),
                                        ),
                                        Positioned(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ///Service Name Text
                                                Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                  child: Text(
                                                    orderDetails.itemList.length > 1
                                                        ? Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.business.name)
                                                        : Utils.retriveField(Localizations.localeOf(context).languageCode, orderDetails.itemList.first.name),
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w600, fontSize: 24
                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 20,
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                ),
                                              ],
                                            )),
                                        Positioned(
                                          child: Container(
                                            height: 20,
                                            margin: EdgeInsets.only(top: 50),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 2.5,
                                                  width: 75,
                                                  decoration: BoxDecoration(
                                                    color: BuytimeTheme.TextWhite,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          bottom: -1,
                                          left: 0,
                                          right: 0,
                                        ),
                                      ],
                                    )
                                ),
                                SliverFixedExtentList(
                                  itemExtent: SizeConfig.screenHeight - 75,
                                  delegate: SliverChildListDelegate(
                                    [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [

                                          ///Address & Map
                                          orderDetails.itemList.first.time != null
                                              ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  flex: 3,
                                                  child: Container(
                                                    height: 128,
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
                                                                  style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                                    ///SizeConfig.safeBlockHorizontal * 4
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
                                                                  serviceState.serviceAddress.isNotEmpty ? serviceState.serviceAddress :  businessState.businessAddress.isNotEmpty ?  businessState.businessAddress : "loading...",
                                                                  style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        ///Hour text
                                                        /*Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                                              style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        ///Directions
                                                        Container(
                                                          padding: EdgeInsets.only(bottom: SizeConfig.safeBlockHorizontal * 1),
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.location_pin,
                                                                size: 14,
                                                                color: BuytimeTheme.SymbolGrey,
                                                              ),

                                                              ///Min
                                                              gettingLocation
                                                                  ? Container(
                                                                margin: EdgeInsets.only(left: 5, right: 2.5),
                                                                height: 12,
                                                                width: 12,
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth: 2,
                                                                  //valueColor: new AlwaysStoppedAnimation<Color>(widget.tourist ? BuytimeTheme.SymbolMalibu : BuytimeTheme.SymbolMalibu),
                                                                ),
                                                              )
                                                                  : Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                                                child: FittedBox(
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Text(
                                                                        () {
                                                                      if (distanceFromCurrentPosition != null) {
                                                                        return distanceFromCurrentPosition.toString().split('.').first.startsWith('0') && distanceFromCurrentPosition.toString().split('.').first.length != 1
                                                                            ? distanceFromCurrentPosition.toString().split('.').last.substring(0, 3) + ' m'
                                                                            : distanceFromCurrentPosition.toStringAsFixed(1) + ' Km';
                                                                      } else {
                                                                        return distanceFromBusiness.toString().split('.').first.startsWith('0') && distanceFromBusiness.toString().split('.').first.length != 1
                                                                            ? distanceFromBusiness.toString().split('.').last.substring(0, 3) + ' m'
                                                                            : distanceFromBusiness.toStringAsFixed(1) + ' Km';
                                                                      }
                                                                    }(),
                                                                    style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 14

                                                                      ///SizeConfig.safeBlockHorizontal * 4
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
                                                                            MaterialPageRoute(
                                                                                builder: (context) => BuytimeMap(
                                                                                  user: true,
                                                                                  title: orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name,
                                                                                  businessState: businessState,
                                                                                  serviceState: serviceState,
                                                                                  tourist: false,
                                                                                )

                                                                              ///TODO service address
                                                                            ),
                                                                          );
                                                                        },
                                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(5.0),
                                                                          child: Text(
                                                                            AppLocalizations.of(context).directions,
                                                                            style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.SymbolMalibu, fontWeight: FontWeight.w400, fontSize: 14

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
                                                  )),

                                              ///Map
                                              Flexible(
                                                flex: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    String address = orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name;
                                                    //Utils.openMap(lat, lng);
                                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: orderDetails.itemList.length > 1 ? orderDetails.business.name : orderDetails.itemList.first.name, businessState: businessState,)),);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => BuytimeMap(
                                                              user: true,
                                                              title: address,
                                                              businessState: businessState,
                                                              serviceState: ServiceState().toEmpty(),

                                                              ///TODO service address
                                                              tourist: false,
                                                            )));
                                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                                  },
                                                  child: Container(
                                                    width: 174,
                                                    height: 125,
                                                    //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: getShopLocationImage(businessState.coordinate),
                                                      imageBuilder: (context, imageProvider) => Container(
                                                        decoration: BoxDecoration(
                                                            color: BuytimeTheme.BackgroundWhite,
                                                            //borderRadius: BorderRadius.all(Radius.circular(5)),
                                                            image: DecorationImage(
                                                              image: imageProvider,
                                                              fit: BoxFit.cover,
                                                            )),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                BuytimeTheme.BackgroundWhite,
                                                                BuytimeTheme.BackgroundWhite.withOpacity(0.1),
                                                              ],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                              //tileMode: TileMode.
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder: (context, url) => Utils.imageShimmer(174, 125),
                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                              : Container(),

                                          ///Divider
                                          orderDetails.itemList.first.time != null
                                              ? Container(
                                            //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                            height: 15,
                                            color: BuytimeTheme.DividerGrey,
                                          )
                                              : Container(),

                                          ///Order status
                                          Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 2),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    Utils.translateOrderStatusUser(context, orderDetails.progress).toUpperCase(),
                                                    style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: Utils.colorOrderStatusUser(context, orderDetails.progress), fontWeight: FontWeight.w600, fontSize: 14

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              orderDetails.progress == Utils.enumToString(OrderStatus.paid) || orderDetails.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)
                                                  ? Container(
                                                margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    " - " + AppLocalizations.of(context).paid,
                                                    style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: Utils.colorOrderStatusUser(context, orderDetails.progress), fontWeight: FontWeight.w600, fontSize: 14

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : Container()
                                            ],
                                          ),

                                          ///Date
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                orderDetails.itemList.first.time != null ? whichDate(orderDetails.itemList.first.date) : whichDate(orderDetails.date),
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w600, fontSize: 18

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///Location
                                          orderDetails.itemList.first.time == null && orderDetails.location.isNotEmpty
                                              ? Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).location.toUpperCase().replaceAll(' ', ''),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          )
                                              : Container(),

                                          ///Location value
                                          orderDetails.itemList.first.time == null && orderDetails.location.isNotEmpty
                                              ? Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                orderDetails.location,
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          )
                                              : Container(),
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
                                                AppLocalizations.of(context).choosePaymentMethod.substring(7, AppLocalizations.of(context).choosePaymentMethod.length).toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///Chosen Payment Method
                                          ///orderDetails.cardType == Utils.enumToString(PaymentType.onSite)
                                          Container(child: chosenPaymentMethod(orderDetails.cardType)),

                                          ///Supplied by
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).suppliedBy.toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///Supplied Value
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                businessState.name.isEmpty ? 'Loading ...' : businessState.name,
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.SymbolMalibu, fontWeight: FontWeight.w500, fontSize: 16

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),

                                          ///Condition Text
                                         serviceState.condition != null &&  serviceState.condition.isNotEmpty ?
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1.5),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).conditions.toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ) : Container(),
                                          ///Condition Value
                                          serviceState.condition != null && serviceState.condition.isNotEmpty ?
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                Utils.retriveField(Localizations.localeOf(context).languageCode, serviceState.condition),
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ) : Container(),

                                          ///Price
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).price.toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),

                                          /*  orderDetails.cardType != null && (!orderDetails.cardType.contains('room') && orderDetails.cardType.isNotEmpty && orderDetails.cardLast4Digit != null) ?
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
                                      ) : Container(), */

                                          orderDetails.itemList.first.time == null
                                              ? orderDetails.itemList.length > 1
                                              ? (() {
                                            List<Widget> tmpOrders = [];
                                            orderDetails.itemList.forEach((element) {
                                              tmpOrders.add(Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      element.number > 1
                                                          ? '${element.number} x ${Utils.retriveField(Localizations.localeOf(context).languageCode, element.name)}'
                                                          : '${element.number} x ${Utils.retriveField(Localizations.localeOf(context).languageCode, element.name)}',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                    Text(
                                                      '${element.number} x ${element.price.toStringAsFixed(2)} €',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                            });
                                            return Column(
                                              children: tmpOrders.map((e) => e).toList(),
                                            );
                                          }())
                                              : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      orderDetails.itemList.first.number > 1
                                                          ? '${orderDetails.itemList.first.number} x ${AppLocalizations.of(context).products}'
                                                          : '${orderDetails.itemList.first.number} x ${AppLocalizations.of(context).product}',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                    Text(
                                                      '${orderDetails.itemList.first.number} x ${orderDetails.itemList.first.price.toStringAsFixed(2)} €',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              order.carbonCompensation != null && order.carbonCompensation?
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${orderDetails.itemList.first.number} x Eco',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                    Text(
                                                      '${orderDetails.itemList.first.number} x ${Utils.calculateEcoTax(order).toStringAsFixed(2)} €',
                                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ) : Container()
                                            ],
                                          )
                                              : Container(),
                                          order.totalPromoDiscount > 0 ?
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * .5),
                                            child: order.totalPromoDiscount > 0 ? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context).promo}:',
                                                  style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                ),
                                                Text(
                                                  '-${(order.totalPromoDiscount.toStringAsFixed(2))}${AppLocalizations.of(context).euroSpace}',
                                                  style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 14
                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                )
                                              ],
                                            ): Container(),
                                          ) : Container(),
                                          ///Price value
                                          orderDetails.itemList.first.time == null
                                              ? Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context).onlyTotal}',
                                                  style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold, fontSize: 16

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                ),
                                                Text(
                                                  order.carbonCompensation != null && order.carbonCompensation?
                                                  '${AppLocalizations.of(context).euroSpace} ${(orderDetails.total + Utils.calculateEcoTax(order)).toStringAsFixed(2)}' :
                                                  '${AppLocalizations.of(context).euroSpace} ${(orderDetails.total.toStringAsFixed(2))}',
                                                  style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold, fontSize: 16

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                              : Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                order.carbonCompensation != null && order.carbonCompensation?
                                                '${AppLocalizations.of(context).euroSpace} ${(orderDetails.total + Utils.calculateEcoTax(order)).toStringAsFixed(2)}':
                                                '${AppLocalizations.of(context).euroSpace} ${orderDetails.total.toStringAsFixed(2)}',
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold, fontSize: 16

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),
                                          orderDetails.progress == Utils.enumToString(OrderStatus.paid)
                                              ? Container(
                                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                              alignment: Alignment.center,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    onTap: refundAsked
                                                        ? null
                                                        : () {
                                                      refundAsked = true;
                                                      StoreProvider.of<AppState>(context).dispatch(RefundOrderByUser(orderDetails.orderId));
                                                    },
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    child: Container(
                                                      padding: EdgeInsets.all(5.0),
                                                      child: Text(
                                                        AppLocalizations.of(context).askForRefund,
                                                        style: TextStyle(
                                                            letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: refundAsked ? BuytimeTheme.TextGrey : BuytimeTheme.SymbolMalibu,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16),
                                                      ),
                                                    )),
                                              ))
                                              : Container(),
                                          orderDetails.cardType == Utils.enumToString(PaymentType.onSite)
                                              ? Padding(
                                            padding: const EdgeInsets.only(top: 20.0),
                                            child: Container(
                                                margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                alignment: Alignment.center,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: QrImage(
                                                    data: '$link',
                                                    version: QrVersions.auto,
                                                    size: 150.0,
                                                  ),
                                                )),
                                          )
                                              : Container(),
                                        ],
                                      )

                                    ],
                                  ),
                                ),

                              ],
                            );

                            OrderState orderState = OrderState.fromJson(orderSnapshot.data.data());
                            order = orderState.itemList != null ? (orderState.itemList.length > 0 ? orderState : OrderState().toEmpty()) : OrderState().toEmpty();
                            debugPrint('UI_U_order_details => CART COUNT: ${order.cartCounter}');
                          },
                        );
                        /*OrderState orderState = OrderState.fromJson(orderSnapshot.data.data());
                        order = orderState.itemList != null ? (orderState.itemList.length > 0 ? orderState : OrderState().toEmpty()) : OrderState().toEmpty();
                        debugPrint('UI_U_order_details => CART COUNT: ${order.cartCounter}');*/
                      },
                    ),
                  ),
                ],
              )
              ,
            ),
          ),
          /* )*/
        ),
      ),
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
                  color: BuytimeTheme.SymbolMalibu.withOpacity(.8),
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
