
import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/user/booking/RUI_U_notifications.dart';
import 'package:Buytime/UI/user/booking/RUI_notification_bell.dart';
import 'package:Buytime/UI/user/booking/UI_U_all_bookings.dart';
import 'package:Buytime/UI/user/booking/UI_U_booking_self_creation.dart';
import 'package:Buytime/UI/user/booking/UI_U_notifications.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:Buytime/UI/user/booking/widget/user_service_card_widget.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/turist/widget/discover_card_widget.dart';
import 'package:Buytime/UI/user/turist/widget/p_r_card_widget.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/area_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

class RServiceExplorer extends StatefulWidget {
  static String route = '/serviceExplorer';
  bool fromBookingPage;
  String searched;

  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Explorer>(
      create: (_) => Explorer(false, []),
      child: RServiceExplorer(),
    );
  }

  RServiceExplorer({Key key, this.fromBookingPage, this.searched}) : super(key: key);

  @override
  _RServiceExplorerState createState() => _RServiceExplorerState();
}

class _RServiceExplorerState extends State<RServiceExplorer> {
  TextEditingController _searchController = TextEditingController();

  //List<ServiceState> serviceState = [];
  List<ServiceState> popularList = [];
  List<ServiceState> recommendedList = [];
  List<CategoryState> categoryList = [];
  List<OrderState> userOrderList = [];
  List<OrderState> orderList = [];
  List<BusinessState> businessList = [];
  String sortBy = '';
  OrderState order = OrderState().toEmpty();


  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searched;
  }

  /*void undoDeletion(index, item) {
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}

    setState(() {
      tmpServiceList.insert(index, item);
    });
  }*/

  List<dynamic> searchedList = [];
  Map<String, List<String>> categoryListIds = Map();
  String categoryRootId = '';

  bool searchCategoryAndServiceOnSnippetList(String serviceId, String categoryId) {
    bool sub = false;
    List<ServiceListSnippetState> serviceListSnippetListState = StoreProvider.of<AppState>(context).state.serviceListSnippetListState.serviceListSnippetListState;
    for (var z = 0; z < serviceListSnippetListState.length; z++) {
      for (var w = 0; w < serviceListSnippetListState[z].businessSnippet.length; w++) {
        for (var y = 0; y < serviceListSnippetListState[z].businessSnippet[w].serviceList.length; y++) {
          //debugPrint('INSIDE SERVICE PATH  => ${serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath} - $serviceId - $categoryId');
          if (serviceId != null && categoryId != null &&
              serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(serviceId) &&
              serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(categoryId)) {
            //  debugPrint('INSIDE CATEGORY ROOT => ${serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceName}');
            //debugPrint('INSIDE SERVICE PATH  => ${serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath}');
            sub = true;
          }
        }
      }
    }
    return sub;
  }

  void searchCategory(List<CategoryState> list) {
    debugPrint('UI_U_service_explorer => CATEGORY SEARCH');
    debugPrint('UI_U_service_explorer => CATEGORY SEARCH - SERVICE LENGTH: ${StoreProvider.of<AppState>(context).state.serviceList.serviceListState.length}');
    setState(() {
      List<CategoryState> categoryState = list;
      categoryList.clear();
      if (_searchController.text.isNotEmpty) {
        categoryState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
              if (service.categoryId.contains(element.id)) {
                createCategoryList(element);
              }
            });
          }
          if (element.customTag != null && element.customTag.isNotEmpty && element.customTag.toLowerCase().contains(_searchController.text.toLowerCase())) {
            StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
              if (service.categoryId.contains(element.id)) {
                createCategoryList(element);
              }
            });
          }

          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
              if (business.id_firestore == element.businessId) {
                StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
                  if (service.categoryId.contains(element.id)) {
                    createCategoryList(element);
                  }

                });
              }
            }
          });
        });
      }
      //popularList.shuffle();
      searchedList.add(categoryList);
    });
  }

  List<Color> myColors = [];

  void createCategoryList(CategoryState element) {
    bool found = false;
    categoryList.forEach((cL) {
      if (cL.name == element.name) {
        //debugPrint('UI_U_service_explorer => EQUAL CATEGORY NAME: ${element.name}');
        found = true;
      }
    });

    if (!found) {
      //debugPrint('UI_U_service_explorer => ADD CATEGORY NAME: ${element.name}');
      categoryList.add(element);
      categoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      if (!categoryListIds[element.name].contains(element.id)) {
        categoryListIds[element.name].add(element.id);
      }
    }

    /*categoryList.forEach((element) async {
      Color color = await getDominatColor(element.categoryImage);
      myColors.add(color);
    });*/
  }

  void searchPopular(List<ServiceState> list) {
    debugPrint('UI_U_service_explorer => POPULAR SEARCH - SERVICE LENGTH: ${list.length}');
    setState(() {
      List<ServiceState> serviceState = list;
      List<ServiceState> tmp = [];
      //popularList.clear();
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            tmp.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if (!tmp.contains(element)) {
                  tmp.add(element);
                }
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
              if (business.id_firestore == element.businessId) {
                if (!tmp.contains(element)) {
                  tmp.add(element);
                }
              }
            }
          });
        });
      }
      tmp.shuffle();
      searchedList.add(tmp);
    });
  }

  void searchRecommended(List<ServiceState> list) {
    debugPrint('UI_U_service_explorer => RECCOMENDED SEARCH');
    setState(() {
      //recommendedList.clear();
      List<ServiceState> serviceState = list;
      List<ServiceState> tmpList = [];
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            tmpList.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if (!tmpList.contains(element)) {
                  tmpList.add(element);
                }
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
              if (business.id_firestore == element.businessId) {
                if (!tmpList.contains(element)) {
                  tmpList.add(element);
                }
              }
            }
          });
        });
      }
      tmpList.shuffle();
      List<ServiceState> tmp = [];
      bool found = false;
      tmpList.forEach((rL) {
        searchedList[1].forEach((cL) {
          if (cL.serviceId == rL.serviceId) found = true;
        });

        tmp.forEach((cL) {
          if (cL.serviceId == rL.serviceId) found = true;
        });

        if (!found) {
          tmp.add(rL);
        }
      });
      //searchedList.add(recommendedList);
      searchedList.add(tmp);
    });
  }

  bool startRequest = false;
  bool noActivity = false;

  //bool searching = false;
  bool hasNotifications = false;
  double currentLat = 0;
  double currentLng = 0;
  Position _currentPosition;
  double distanceFromBusiness;
  double distanceFromCurrentPosition;
  bool gettingLocation = true;

  _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest, forceAndroidLocationManager: true, timeLimit: Duration(seconds: 30));
    setState(() {
      _currentPosition = position;
      debugPrint('UI_U_order_details => FROM GEOLOCATOR: $_currentPosition');
      currentLat = _currentPosition.latitude;
      currentLng = _currentPosition.longitude;
    });

    /// set current area in the store
    AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
    StoreProvider.of<AppState>(context).dispatch(SetArea(Utils.getCurrentArea('$currentLat, $currentLng', areaListState)));
  }

  _getLocation() async {
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
          distanceFromBusiness = 0.0;
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
    if (_locationData.latitude != null) {
      setState(() {
        gettingLocation = false;
        currentLat = _locationData.latitude;
        currentLng = _locationData.longitude;
        distanceFromCurrentPosition = 0.0;
      });

      /// set current area in the store
      AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
      StoreProvider.of<AppState>(context).dispatch(SetArea(Utils.getCurrentArea('$currentLat, $currentLng', areaListState)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).problemsGettingYourPosition)));
    }

    /// When more accuracy or options are needed.
    // try {
    //   await _getCurrentLocation();
    // } catch (exception) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:  Text(AppLocalizations.of(context).problemsGettingYourPosition)));
    // }
  }

  bool first = false;
  bool once = false;


  Future<Color> getDominatColor(String image) async {
    ImageProvider imageProvider = Image.network(image).image;
    PaletteGenerator p = await PaletteGenerator.fromImageProvider(imageProvider,timeout: Duration(milliseconds: 1100));
    //PaletteGenerator p = await PaletteGenerator.fromImage(Image.network(image));
    debugPrint('Category domina color: ${p.dominantColor.color}');
    return p.dominantColor.color;
  }

  String searchCategoryRootId(String categoryId, String serviceId) {
    ServiceListSnippetState serviceListSnippetState = StoreProvider.of<AppState>(context).state.serviceListSnippetState;
    for (var w = 0; w < serviceListSnippetState.businessSnippet.length; w++) {
      for (var y = 0; y < serviceListSnippetState.businessSnippet[w].serviceList.length; y++) {
        //debugPrint('INSIDE SERVICE PATH  => ${serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath}');
        if (serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(categoryId)  &&  serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(serviceId)) {
          return serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.split('/')[1];
          // debugPrint('searchCategoryRootId SERVICE PATH  => ${serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath}');
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    final Stream<QuerySnapshot> _orderStream =  FirebaseFirestore.instance
        .collection("order")
    //.where("businessId", isEqualTo: StoreProvider.of<AppState>(context).state.business.id_firestore)
        .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
    //.where("itemList[0][time]", isNotEqualTo: null)
        .where("date", isGreaterThanOrEqualTo: currentTime)
        .limit(50)
        .snapshots(includeMetadataChanges: true);

    Stream<QuerySnapshot> _serviceStream;
    if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
       _serviceStream =  FirebaseFirestore.instance.collection("service")
          .where("tag", arrayContains: StoreProvider.of<AppState>(context).state.area.areaId)
          .where("visibility", isEqualTo: 'Active').snapshots(includeMetadataChanges: true);
    } else {
      _serviceStream =  FirebaseFirestore.instance.collection("service")
          .where("visibility", isEqualTo: 'Active').snapshots(includeMetadataChanges: true);
    }

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        store.state.categoryList.categoryListState.clear();
        store.state.serviceList.serviceListState.clear();
        startRequest = true;

        await _getLocation();
        debugPrint('Service Explorer : OnInit Before AllRequestListCategory');

        store.dispatch(AllRequestListCategory(''));
        if (auth.FirebaseAuth != null && auth.FirebaseAuth.instance != null && auth.FirebaseAuth.instance.currentUser != null) {
          auth.User user = auth.FirebaseAuth.instance.currentUser;
          if (user != null) {
            //store.dispatch(UserOrderListRequest());
            store.state.notificationListState.notificationListState.clear();
            store.dispatch(RequestNotificationList(store.state.user.uid, store.state.business.id_firestore));
          }
        }
      },
      builder: (context, snapshot) {
        businessList = snapshot.businessList.businessListState;

        if (_searchController.text.isEmpty && !first) {
          categoryList.clear();
          popularList.clear();
          recommendedList.clear();
          categoryListIds.clear();
          List<NotificationState> notifications = snapshot.notificationListState.notificationListState;

          if (snapshot.categoryList.categoryListState.isEmpty && startRequest) {
            noActivity = true;
          } else {
            if (snapshot.categoryList.categoryListState.isNotEmpty && categoryList.isEmpty || _searchController.text.isEmpty) {
              if (notifications.isNotEmpty && notifications.first.userId.isEmpty) notifications.removeLast();

              if (notifications.isNotEmpty) {
                hasNotifications = false;
                notifications.forEach((element) {
                  //debugPrint('UI_U_booking_page => ${element.timestamp}');
                  //debugPrint('UI_U_booking_page => ${element.notificationId} | ${element.opened}');
                  if (element.opened != null && !element.opened) {
                    //debugPrint('UI_U_booking_page => ${element.notificationId} | ${element.data.state.orderId}');
                    hasNotifications = true;
                  }
                });
                //notifications.sort((b,a) => a.timestamp != null ? a.timestamp : 0 .compareTo(b.timestamp != null ? b.timestamp : 0));
                notifications.sort((b, a) => a.timestamp.compareTo(b.timestamp));
              }

              //categoryList.addAll(snapshot.categoryList.categoryListState);
              //popularList.addAll(snapshot.serviceList.serviceListState);
              //recommendedList.addAll(snapshot.serviceList.serviceListState);
              if (snapshot.categoryList.categoryListState.isNotEmpty && categoryList.isEmpty) {
                categoryList.shuffle();
              }
              first = true;
            }
            if (categoryList.isNotEmpty && categoryList.first.name == null) categoryList.removeLast();
            noActivity = false;
            //categoryList.shuffle();
            //popularList.shuffle();
            //recommendedList.shuffle();
          }
        }
        debugPrint('UI_U_service_explorer => CATEGORY LIST: ${categoryList.length}');
        debugPrint('UI_U_service_explorer => SERVICE LIST: ${popularList.length}');
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_BookingPage => Order List LENGTH: ${snapshot.orderList.orderListState.length}');

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Stack(
              children: [
                /*Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: widget.controller.value.isInitialized
                        ? SizedBox.expand(
                      child: FittedBox(
// If your background video doesn't look right, try changing the BoxFit property.
// BoxFit.fill created the look I was going for.
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: widget.controller.value.size?.width ?? 0,
                          height: widget.controller.value.size?.height ?? 0,
                          child: VideoPlayer(
                            widget.controller,
                          ),
                        ),
                      ),
                    )
                        : Container(
                      color: BuytimeTheme.TextWhite,
                    ),
                  ),
                ),*/

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Scaffold(
                      appBar: BuytimeAppbar(
                        background: BuytimeTheme.BackgroundCerulean,
                        width: media.width,
                        children: [
                          ///Back Button
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                  child: IconButton(
                                    icon: Icon(
                                      FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty ?
                                      Icons.home : Icons.login,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    tooltip: AppLocalizations.of(context).comeBack,
                                    onPressed: () {
                                      FirebaseAnalytics().logEvent(
                                          name: 'back_button_discover',
                                          parameters: {
                                            'userEmail': snapshot.user.email,
                                            'date': DateTime.now(),
                                          });
                                      //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                                      if(FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty)
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                                      else
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),);
                                      /*Future.delayed(Duration.zero, () {

                                      Future.delayed(Duration.zero, () {
                                        Navigator.of(context).pop();
                                      });*/
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///Title
                          Expanded(flex: 2, child: Utils.barTitle(AppLocalizations.of(context).buytime)),

                          ///Cart
                          ///Notification & Cart
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ///Notification
                                  Flexible(
                                      child: snapshot.user.uid != null && snapshot.user.uid.isNotEmpty
                                          ? RNotificationBell(
                                        orderList: orderList,
                                        userId: snapshot.user.uid,
                                        tourist: true,
                                      )
                                          : Container()),

                                  ///Cart
                                  Flexible(
                                      child: Container(
                                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
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
                                                  onPressed: () {
                                                    FirebaseAnalytics().logEvent(
                                                        name: 'cart_discover',
                                                        parameters: {
                                                          'userEmail': snapshot.user.email,
                                                          'date': DateTime.now(),
                                                        });
                                                    if (order.cartCounter > 0) {
                                                      // dispatch the order
                                                      StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                      // go to the cart page
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => Cart(
                                                              tourist: true,
                                                            )),
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
                                              bottom: 20,
                                              left: 3,
                                              child: Align(
                                                alignment: Alignment.center,
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
                                      ))
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Container(
                              width: double.infinity,
                              //color: BuytimeTheme.DividerGrey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Search
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.safeBlockVertical * 3,
                                        left: SizeConfig.safeBlockHorizontal * 5,
                                        bottom: SizeConfig.safeBlockVertical * 1,
                                        right: _searchController.text.isNotEmpty ? SizeConfig.safeBlockHorizontal * .5 : SizeConfig.safeBlockHorizontal * 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///Search
                                        Flexible(
                                          child: Container(
                                            //width: SizeConfig.safeBlockHorizontal * 60,
                                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                            child: TextFormField(
                                              key: Key('search_field_key'),
                                              controller: _searchController,
                                              textAlign: TextAlign.start,
                                              textInputAction: TextInputAction.search,
                                              decoration: InputDecoration(
                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                labelText: AppLocalizations.of(context).whatAreYouLookingFor,
                                                helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                                                //hintText: "email *",
                                                //hintStyle: TextStyle(color: Color(0xff666666)),
                                                labelStyle: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                helperStyle: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                suffixIcon: InkWell(
                                                  key: Key('search_button_key'),
                                                  onTap: () {
                                                    debugPrint('done');
                                                    debugPrint('SEARCH - SERVICE LENGTH: ${Provider.of<Explorer>(context, listen: false).serviceList.length}');
                                                    FocusScope.of(context).unfocus();
                                                    searchedList.clear();
                                                    searchCategory(snapshot.categoryList.categoryListState);
                                                    searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                                    searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                                                  },
                                                  child: Icon(
                                                    // Based on passwordVisible state choose the icon
                                                    Icons.search,
                                                    color: Color(0xff666666),
                                                  ),
                                                ),
                                              ),
                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                                              onEditingComplete: () {
                                                FirebaseAnalytics().logEvent(
                                                    name: 'search_discover',
                                                    parameters: {
                                                      'userEmail': snapshot.user.email,
                                                      'date': DateTime.now(),
                                                      'string_searched': _searchController.text
                                                    });
                                                debugPrint('done');
                                                FocusScope.of(context).unfocus();
                                                searchedList.clear();
                                                searchCategory(snapshot.categoryList.categoryListState);
                                                searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                                searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                                              },
                                              onTap: () {
                                                /*setState(() {
                                                  searching = !searching;
                                                });*/
                                                //Provider.of<Explorer>(context, listen: false).searching = !Provider.of<Explorer>(context, listen: false).searching;
                                              },
                                            ),
                                          ),
                                        ),
                                        _searchController.text.isNotEmpty
                                            ? Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: IconButton(
                                            key: Key('search_clear_button_key'),
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              BuytimeIcons.remove,
                                              color: Color(0xff666666),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _searchController.clear();
                                                first = false;
                                              });
                                            },
                                          ),
                                        )
                                            : Container()
                                      ],
                                    ),
                                  ),

                                  ///My bookings & View all
                                  _searchController.text.isEmpty && snapshot.user.getRole() == Role.user && auth.FirebaseAuth.instance.currentUser != null
                                      ? StreamBuilder<QuerySnapshot>(
                                      stream: _orderStream,
                                      builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                                        userOrderList.clear();
                                        orderList.clear();
                                        if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
                                          return Container(
                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    ///My bookings
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
                                                      child: Text(
                                                        AppLocalizations.of(context).myReservation,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 18

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    ///View All
                                                    Container(
                                                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                        alignment: Alignment.center,
                                                        child: Material(
                                                          color: Colors.transparent,
                                                          child: InkWell(
                                                              onTap: () {
                                                                //Navigator.push(context, MaterialPageRoute(builder: (context) => RAllBookings(fromConfirm: false, tourist: false,)),);
                                                                //Navigator.push(context, MaterialPageRoute(builder: (context) => AllBookings(orderStateList: orderList, tourist: true,)),);
                                                              },
                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                              child: Container(
                                                                padding: EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  AppLocalizations.of(context).viewAll,
                                                                  style: TextStyle(
                                                                      letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.BackgroundCerulean,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 16

                                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                                  ),
                                                                ),
                                                              )),
                                                        ))
                                                  ],
                                                ),
                                                ///List
                                                Container(
                                                  height: 120,
                                                  width: double.infinity,
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                                  child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                    SliverList(
                                                      delegate: SliverChildBuilderDelegate(
                                                            (context, index) {
                                                          return Container(
                                                            width: 151,
                                                            height: 100,
                                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                            child: Utils.imageShimmer(151, 100),
                                                          );
                                                        },
                                                        childCount: 5,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        DateTime currentTime = DateTime.now();
                                        orderSnapshot.data.docs.forEach((element) {
                                          //allUserOrderList.add(element);
                                          OrderState order = OrderState.fromJson(element.data());
                                          if((order.progress == Utils.enumToString(OrderStatus.paid) ||
                                              order.progress == Utils.enumToString(OrderStatus.pending) ||
                                              order.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout) ||
                                              order.progress == Utils.enumToString(OrderStatus.holding) ||
                                              order.progress == Utils.enumToString(OrderStatus.accepted)) &&
                                              (order.itemList.first.date.isAtSameMomentAs(currentTime) || order.itemList.first.date.isAfter(currentTime)) && order.itemList.first.time != null)
                                            userOrderList.add(order);
                                          orderList.add(order);
                                        });
                                        //debugPrint('asdsd');
                                        userOrderList.sort((a,b) => a.itemList.first.date.isBefore(b.itemList.first.date) ? -1 : a.itemList.first.date.isAtSameMomentAs(b.itemList.first.date) ? 0 : 1);
                                        orderList.sort((a,b) => a.date.isBefore(b.date) ? -1 : a.date.isAtSameMomentAs(b.date) ? 0 : 1);
                                        return userOrderList.isNotEmpty ? Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ///My bookings
                                                  Container(
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
                                                    child: Text(
                                                      AppLocalizations.of(context).myReservation,
                                                      style: TextStyle(
                                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                  ),
                                                  ///View All
                                                  Container(
                                                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                      alignment: Alignment.center,
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                            onTap: () {
                                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => RAllBookings(fromConfirm: false, tourist: false,)),);
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => AllBookings(orderStateList: orderList, tourist: true,)),);
                                                            },
                                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                            child: Container(
                                                              padding: EdgeInsets.all(5.0),
                                                              child: Text(
                                                                AppLocalizations.of(context).viewAll,
                                                                style: TextStyle(
                                                                    letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: BuytimeTheme.BackgroundCerulean,
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 16

                                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                                ),
                                                              ),
                                                            )),
                                                      ))
                                                ],
                                              ),
                                              ///List
                                              Container(
                                                height: 120,
                                                width: double.infinity,
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                                child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                  SliverList(
                                                    delegate: SliverChildBuilderDelegate(
                                                          (context, index) {
                                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                                        OrderState order = userOrderList.elementAt(index);
                                                        ServiceState service = ServiceState().toEmpty();
                                                        StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.forEach((element) {
                                                          if(element.notificationId != null && element.notificationId.isNotEmpty && order.orderId.isNotEmpty && order.orderId == element.data.state.orderId){
                                                            snapshot.serviceList.serviceListState.forEach((s) {
                                                              if(element.data.state.serviceId == s.serviceId)
                                                                service = s;
                                                            });
                                                          }
                                                        });
                                                        order.itemList.forEach((element) {
                                                          snapshot.serviceList.serviceListState.forEach((s) {
                                                            if(element.id == s.serviceId)
                                                              service = s;
                                                          });
                                                        });
                                                        return Container(
                                                          width: 151,
                                                          height: 100,
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                          child: UserServiceCardWidget(userOrderList.elementAt(index), true, service),
                                                        );
                                                      },
                                                      childCount: userOrderList.length,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          ),
                                        ): Container();
                                      }
                                  ) : Container(),

                                  ///Discover & Popular & Recommended & Log out
                                  _searchController.text.isEmpty
                                      ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _serviceStream,
                                          builder: (context, AsyncSnapshot<QuerySnapshot> serviceSnapshot) {
                                            popularList.clear();
                                            recommendedList.clear();
                                            List<ServiceState> list = [];
                                            //first = false;
                                            if (serviceSnapshot.hasError || serviceSnapshot.connectionState == ConnectionState.waiting && popularList.isEmpty) {
                                              debugPrint('SERVICE WAITING');
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ///Discover
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5),
                                                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 155,
                                                      width: double.infinity,
                                                      color: BuytimeTheme.BackgroundWhite,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Discover
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                                            child: Text(
                                                              AppLocalizations.of(context).discover,
                                                              style: TextStyle(
                                                                //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextBlack,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 32

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                          ///List
                                                          Flexible(
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    CategoryState category = CategoryState().toEmpty();
                                                                    //debugPrint('UI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
                                                                    return  Container(
                                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: SizeConfig.safeBlockHorizontal * 1),
                                                                      child: Utils.imageShimmer(80, 80),
                                                                    );
                                                                  },
                                                                  childCount: 10,
                                                                ),
                                                              ),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  ///Popular
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 310,
                                                      color: Color(0xff1E3C4F),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Popular
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                            child: Text(
                                                              AppLocalizations.of(context).popular,
                                                              style: TextStyle(
                                                                //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextWhite,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 18

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                          ///Text
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                            child: Text(
                                                              AppLocalizations.of(context).popularSlogan,
                                                              style: TextStyle(
                                                                //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextWhite,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 14

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 220,
                                                            width: double.infinity,
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    //ServiceState service = popularList.elementAt(index);
                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                          child: Utils.imageShimmer(182, 182),
                                                                        ),
                                                                        Container(
                                                                          width: 180,
                                                                          alignment: Alignment.topLeft,
                                                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                          child: Utils.textShimmer(150, 10),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                  childCount: 10,
                                                                ),
                                                              ),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  ///Recommended
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 310,
                                                      color: BuytimeTheme.BackgroundWhite,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Recommended
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                            child: Text(
                                                              AppLocalizations.of(context).recommended,
                                                              style: TextStyle(
                                                                //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextBlack,
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 18

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                          ///Text
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                            child: Text(
                                                              AppLocalizations.of(context).recommendedSlogan,
                                                              style: TextStyle(
                                                                //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextBlack,
                                                                  fontWeight: FontWeight.w500,
                                                                  fontSize: 14

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 220,
                                                            width: double.infinity,
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    //ServiceState service = popularList.elementAt(index);
                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                          child: Utils.imageShimmer(182, 182),
                                                                        ),
                                                                        Container(
                                                                          width: 180,
                                                                          alignment: Alignment.topLeft,
                                                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                          child: Utils.textShimmer(150, 10),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                  childCount: 10,
                                                                ),
                                                              ),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }

                                            snapshot.businessList.businessListState.forEach((businessState) {
                                              serviceSnapshot.data.docs.forEach((element) {
                                                ServiceState serviceState = ServiceState.fromJson(element.data());
                                                if(businessState.id_firestore == serviceState.businessId){
                                                  //popularList.add(serviceState);
                                                  //recommendedList.add(serviceState);
                                                  list.add(serviceState);
                                                }
                                              });
                                            });
                                            debugPrint('LIST: ${list.length}');

                                            if(!once){
                                              StoreProvider.of<AppState>(context).dispatch(ServiceListReturned(list));
                                              once = true;
                                            }
                                            List<ServiceState> tmp = Provider.of<Explorer>(context, listen: false).serviceList;
                                            debugPrint('TMP SERVICE FORM BUILDER: ${tmp.length}');
                                            list.forEach((el1) {
                                              //if(!Provider.of<Explorer>(context, listen: false).serviceList.contains(el1))
                                              Provider.of<Explorer>(context, listen: false).serviceList.add(el1);
                                            });
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              Provider.of<Explorer>(context, listen: false).initServiceList(Provider.of<Explorer>(context, listen: false).serviceList);
                                              //popularList.clear();
                                            });
                                            for(int i = Provider.of<Explorer>(context, listen: false).serviceList.length - 1; i >= 0; i--){
                                              popularList.add(Provider.of<Explorer>(context, listen: false).serviceList[i]);
                                            }
                                            recommendedList = Provider.of<Explorer>(context, listen: false).serviceList;

                                            snapshot.categoryList.categoryListState.forEach((cLS) {
                                              //debugPrint('UI_U_service_explorer CATEGORY NAME => ${cLS.name} ${cLS.level}');
                                              if (cLS.level == 0) {
                                                if (cLS.name.contains('Diving')) {
                                                  //debugPrint('UI_U_service_explorer CATEGORY NAME => ${cLS.name} ${cLS.id} ${cLS.businessId} ${cLS.level}');
                                                }
                                                Provider.of<Explorer>(context, listen: false).serviceList.forEach((service) {
                                                  if ((service.categoryId != null && service.categoryId.contains(cLS.id) || searchCategoryAndServiceOnSnippetList(service.serviceId, cLS.id))) {
                                                    //debugPrint('UI_U_service_explorer => ${cLS.name} AND LEVEL ${cLS.level}');
                                                    createCategoryList(cLS);
                                                  }
                                                });
                                              }
                                            });

                                            debugPrint('SERVICE FORM BUILDER: ${Provider.of<Explorer>(context, listen: false).serviceList.length}');
                                            debugPrint('LIST SERVICE FORM BUILDER: ${list.length}');
                                            debugPrint('POPULAR SERVICE FORM BUILDER: ${popularList.length}');
                                            debugPrint('RECCOMENDED SERVICE FORM BUILDER: ${recommendedList.length}');
                                            //popularList.shuffle();
                                            //recommendedList.shuffle();
                                            List<Widget> childrens = [];

                                            ///Discover
                                            childrens.add(Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5),
                                                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                height: 155,
                                                width: double.infinity,
                                                color: BuytimeTheme.BackgroundWhite,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Discover
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                                      child: Text(
                                                        AppLocalizations.of(context).discover,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 32

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    categoryList.isNotEmpty ?
                                                    ///List
                                                    Flexible(
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              CategoryState category = categoryList.elementAt(index);
                                                              debugPrint('UI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
                                                              return Container(
                                                                width: 80,
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: SizeConfig.safeBlockHorizontal * 1),
                                                                child: DiscoverCardWidget(80, 80, category, true, categoryListIds[category.name], index),
                                                              );
                                                            },
                                                            childCount: categoryList.length,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        : noActivity
                                                        ? Flexible(
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              CategoryState category = CategoryState().toEmpty();
                                                              debugPrint('UI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
                                                              return  Container(
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: SizeConfig.safeBlockHorizontal * 1),
                                                                child: Utils.imageShimmer(80, 80),
                                                              );
                                                            },
                                                            childCount: 10,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        :

                                                    ///No List
                                                    Container(
                                                      height: SizeConfig.safeBlockVertical * 8,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                                      decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              AppLocalizations.of(context).noCategoryFound,
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                            ///Popular
                                            childrens.add(Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                height: popularList.isNotEmpty || noActivity ? 310 : 200,
                                                color: Color(0xff1E3C4F),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Popular
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                      child: Text(
                                                        AppLocalizations.of(context).popular,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextWhite,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    ///Text
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                      child: Text(
                                                        AppLocalizations.of(context).popularSlogan,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextWhite,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    popularList.isNotEmpty ?
                                                    ///List
                                                    Container(
                                                      height: 220,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              ServiceState service = popularList.elementAt(index);
                                                              return Container(
                                                                child: PRCardWidget(182, 182, service, false, false, index, 'popular'),
                                                              );
                                                            },
                                                            childCount: popularList.length,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        : noActivity
                                                        ? Container(
                                                      height: 220,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              //ServiceState service = popularList.elementAt(index);
                                                              return Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                    child: Utils.imageShimmer(182, 182),
                                                                  ),
                                                                  Container(
                                                                    width: 180,
                                                                    alignment: Alignment.topLeft,
                                                                    margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                    child: Utils.textShimmer(150, 10),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                            childCount: 10,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        :
                                                    /*_searchController.text.isNotEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      )
                                          : popularList.isEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFound,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      ) :*/

                                                    ///No List
                                                    Container(
                                                      height: SizeConfig.safeBlockVertical * 8,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                                                      decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              AppLocalizations.of(context).noServiceFound,
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                            ///Recommended
                                            childrens.add(Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                height: recommendedList.isNotEmpty || noActivity ? 310 : 200,
                                                color: BuytimeTheme.BackgroundWhite,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Recommended
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                      child: Text(
                                                        AppLocalizations.of(context).recommended,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 18

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),

                                                    ///Text
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                      child: Text(
                                                        AppLocalizations.of(context).recommendedSlogan,
                                                        style: TextStyle(
                                                          //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    ),
                                                    recommendedList.isNotEmpty
                                                        ?

                                                    ///List
                                                    Container(
                                                      height: 220,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              ServiceState service = recommendedList.elementAt(index);
                                                              return Container(
                                                                //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                child: PRCardWidget(182, 182, service, false, true, index, 'recommended'),
                                                              );
                                                            },
                                                            childCount: recommendedList.length,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        : noActivity
                                                        ? Container(
                                                      height: 220,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              //ServiceState service = popularList.elementAt(index);
                                                              return Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                    child: Utils.imageShimmer(182, 182),
                                                                  ),
                                                                  Container(
                                                                    width: 180,
                                                                    alignment: Alignment.topLeft,
                                                                    margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                    child: Utils.textShimmer(150, 10),
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                            childCount: 10,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                    /*:
                                      _searchController.text.isNotEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      )
                                          : recommendedList.isEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFound,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      )*/
                                                        :

                                                    ///No List
                                                    Container(
                                                      height: SizeConfig.safeBlockVertical * 8,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                                                      decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                                      child: Center(
                                                          child: Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              AppLocalizations.of(context).noServiceFound,
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                                            ),
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                            int i = 0;

                                            List<CategoryState> tmpCategoryList = [];
                                            categoryList.forEach((element) async {
                                              List<ServiceState> s = [];
                                              List<ServiceState> tmpServiceList = [];
                                              s.addAll(popularList);
                                              s.forEach((service) {
                                                if (service.categoryId != null) {
                                                  service.categoryId.forEach((element2) {
                                                    //debugPrint('CATEGORY ID: ${element2}');
                                                    if (!tmpServiceList.contains(service)) {
                                                      if(categoryListIds[element.name].contains(element2)) {
                                                        //tmpServiceList.add(element);
                                                        //debugPrint('SERVICE CATEGORY ID: $element2 - CATEGORY ID: ${element.id} - CATEGORY LIST: ${categoryListIds[element.name]}' );
                                                        tmpServiceList.add(service);
                                                      }
                                                    }
                                                    //debugPrint('SERVICE NAME: ${service.name} - CATEGORY ID: ${element.id} - SERVICE CATEGORY ID: $element2' );
                                                    snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sl) {
                                                      sl.businessSnippet.forEach((c) {
                                                        if(!tmpServiceList.contains(service) && (c.categoryAbsolutePath.contains(element2) && categoryListIds[element.name].contains(c.categoryAbsolutePath.split('/')[1]))){
                                                          tmpServiceList.add(service);
                                                        }
                                                      });
                                                    });
                                                    /*snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sl) {
                                                      sl.businessSnippet.forEach((c) {
                                                        c.serviceList.forEach((s) {
                                                          if(!tmpServiceList.contains(service) && s.serviceAbsolutePath.contains(element2) && s.serviceAbsolutePath.contains(element.id) && s.serviceAbsolutePath.contains(service.serviceId))
                                                            tmpServiceList.add(service);
                                                        });
                                                       
                                                      });
                                                    });*/
                                                    /*snapshot.categoryList.categoryListState.forEach((element3) {
                                                      snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sl) {
                                                        sl.businessSnippet.forEach((c) {
                                                          //debugPrint('CATEGORY ABSOLUTE PATH: ${c.categoryAbsolutePath} - CATEGORY ID: ${element.id} - SERVICE CATEGORY ID: $element2' );
                                                          if(!tmpServiceList.contains(service) && c.categoryAbsolutePath.contains(element.id) && c.categoryAbsolutePath.contains(element2)  && c.categoryAbsolutePath.contains(element3.id)  && c.categoryAbsolutePath.contains(service.businessId))
                                                            tmpServiceList.add(service);
                                                        });
                                                      });
                                                    });*/
                                                  });
                                              }});
                                              childrens.add(Flexible(
                                                child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                  height: tmpServiceList.isNotEmpty || noActivity ? 310 : 200,
                                                  color: BuytimeTheme.BackgroundWhite,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ///Category name
                                                      Container(
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                        child: Text(
                                                          element.name,
                                                          style: TextStyle(
                                                            //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.TextBlack,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 18

                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      ),
                                                      ///Text
                                                      Container(
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                        child: Text(
                                                          '${AppLocalizations.of(context).discoverStart} ${element.name} ${AppLocalizations.of(context).discoverEnd}',
                                                          style: TextStyle(
                                                            //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.TextBlack,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 14

                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      ),
                                                      tmpServiceList.isNotEmpty ?
                                                      ///List
                                                      Container(
                                                        height: 220,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                        child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                          SliverList(
                                                            delegate: SliverChildBuilderDelegate(
                                                                  (context, index) {
                                                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                ServiceState service = tmpServiceList.elementAt(index);
                                                                return Container(
                                                                  child: PRCardWidget(182, 182, service, false, true, index, element.name),
                                                                );
                                                              },
                                                              childCount: tmpServiceList.length,
                                                            ),
                                                          ),
                                                        ]),
                                                      )
                                                          : noActivity
                                                          ? Container(
                                                        height: 220,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                        child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                          SliverList(
                                                            delegate: SliverChildBuilderDelegate(
                                                                  (context, index) {
                                                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                //ServiceState service = popularList.elementAt(index);
                                                                return Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                      child: Utils.imageShimmer(182, 182),
                                                                    ),
                                                                    Container(
                                                                      width: 180,
                                                                      alignment: Alignment.topLeft,
                                                                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                      child: Utils.textShimmer(150, 10),
                                                                    )
                                                                  ],
                                                                );
                                                              },
                                                              childCount: 10,
                                                            ),
                                                          ),
                                                        ]),
                                                      )
                                                          :
                                                      /*_searchController.text.isNotEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      )
                                          : popularList.isEmpty
                                          ? Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                        child: Center(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                AppLocalizations.of(context).noServiceFound,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                              ),
                                            )),
                                      ) :*/

                                                      ///No List
                                                      Container(
                                                        height: SizeConfig.safeBlockVertical * 8,
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                                                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                                        child: Center(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                AppLocalizations.of(context).noServiceFound,
                                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                                              ),
                                                            )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                              /*childrens.add(
                                                  Container(
                                                    height: 1,
                                                    width: SizeConfig.screenWidth,
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    color: BuytimeTheme.SymbolWhite,
                                                  ));*/
                                              i++;
                                            });

                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: childrens,
                                            );
                                          }
                                      ),
                                    ],
                                  )
                                      :
                                  ///Searched list
                                  categoryList.isNotEmpty || popularList.isNotEmpty || recommendedList.isNotEmpty
                                      ? Flexible(
                                    child: Container(
                                        height: SizeConfig.safeBlockVertical * 80,
                                        margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical * 0,
                                          left: SizeConfig.safeBlockHorizontal * 0,
                                        ),
                                        child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.vertical, slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                                  (context, index) {
                                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                                if (index == 0) {
                                                  return Container(
                                                    height: categoryList.isEmpty ? 0 : 80,
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4.5, bottom: SizeConfig.safeBlockVertical * 1),
                                                    child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                      SliverList(
                                                        delegate: SliverChildBuilderDelegate(
                                                              (context, index) {
                                                            //MenuItemModel menuItem = menuItems.elementAt(index);

                                                            CategoryState category = categoryList.elementAt(index);
                                                            debugPrint('UI_U_service_explorer => ${categoryListIds[category.name]}');
                                                            return Container(
                                                              width: 80,
                                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: SizeConfig.safeBlockHorizontal * 1),
                                                              child: DiscoverCardWidget(80, 80, category, true, categoryListIds[category.name], index),
                                                            );
                                                          },
                                                          childCount: categoryList.length,
                                                        ),
                                                      ),
                                                    ]),
                                                  );
                                                } else {
                                                  List<ServiceState> serviceList = searchedList.elementAt(index);
                                                  debugPrint('searched index: $index | service list: ${serviceList.length}');
                                                  return CustomScrollView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), scrollDirection: Axis.vertical, slivers: [
                                                    SliverList(
                                                      delegate: SliverChildBuilderDelegate(
                                                            (context, index) {
                                                          //MenuItemModel menuItem = menuItems.elementAt(index);
                                                          ServiceState service = serviceList.elementAt(index);
                                                          return Column(
                                                            children: [
                                                              BookingListServiceListItem(service, true),
                                                              Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                                                height: SizeConfig.safeBlockVertical * .2,
                                                                color: BuytimeTheme.DividerGrey,
                                                              )
                                                            ],
                                                          );
                                                        },
                                                        childCount: serviceList.length,
                                                      ),
                                                    ),
                                                  ]);
                                                  //return Container();
                                                }
                                              },
                                              childCount: searchedList.length,
                                            ),
                                          ),
                                        ])),
                                  )
                                      : Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).noResultsFor + ' \"${_searchController.text}\"',
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                /*categoryList.isEmpty ?
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                        height: double.infinity,
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
                ) :
                    Container()*/
              ],
            ),
          ),
        );
      },
    );
  }
}

class Explorer with ChangeNotifier{
  bool searching;
  List<ServiceState> serviceList;
  Explorer(this.searching, this.serviceList);

  initSearching(bool searching){
    this.searching = searching;
    debugPrint('SEARCHING INIT');
    notifyListeners();
  }
  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('SERVICE LIST INIT');
    notifyListeners();
  }

  clear(){
    this.searching = false;
    this.serviceList.clear();
  }

}


