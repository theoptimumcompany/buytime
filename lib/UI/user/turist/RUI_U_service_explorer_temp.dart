
import 'dart:io';

import 'package:Buytime/UI/management/activity/RUI_M_activity_management.dart';
import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/UI/user/booking/RUI_U_all_bookings.dart';
import 'package:Buytime/UI/user/booking/RUI_U_my_bookings.dart';
import 'package:Buytime/UI/user/booking/RUI_notification_bell.dart';
import 'package:Buytime/UI/user/booking/UI_U_all_bookings.dart';
import 'package:Buytime/UI/user/booking/UI_U_my_bookings.dart';
import 'package:Buytime/UI/user/category/UI_U_new_filter_by_category.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/UI/user/login/UI_U_registration.dart';
import 'package:Buytime/UI/user/payment/paypal_payment.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/helper/payment/satispay/satispay_service.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reusable/w_custom_bottom_button.dart';
import 'package:Buytime/reusable/w_landing_card.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:animations/animations.dart';
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
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/w_service_list_item.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  List<LandingCardWidget> cards = [];
  List<ServiceState> popularList = [];
  List<ServiceState> recommendedList = [];
  List<CategoryState> categoryList = [];
  List<OrderState> userOrderList = [];
  List<OrderState> orderList = [];
  List<BusinessState> businessList = [];
  String sortBy = '';
  OrderState order = OrderState().toEmpty();
  DynamicLinkHelper dynamicLinkHelper = DynamicLinkHelper();

  ///Storage
  String selfBookingCode = '';
  String bookingCode = '';
  String categoryCode = '';

  String orderId = '';
  String userId = '';

  bool onBookingCode = false;
  bool rippleLoading = false;
  bool secondRippleLoading = false;
  bool requestingBookings = false;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searched;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StoreProvider.of<AppState>(context).dispatch(PromotionListRequest());
    });
  }


  List<dynamic> searchedList = [];
  Map<String, List<String>> categoryListIds = Map();
  String categoryRootId = '';

  bool searchCategoryAndServiceOnSnippetList(String serviceId, String categoryId) {
    bool sub = false;
    List<ServiceListSnippetState> serviceListSnippetListState = StoreProvider.of<AppState>(context).state.serviceListSnippetListState.serviceListSnippetListState;
    for (var z = 0; z < serviceListSnippetListState.length; z++) {
      for (var w = 0; w < serviceListSnippetListState[z].businessSnippet.length; w++) {
        for (var y = 0; y < serviceListSnippetListState[z].businessSnippet[w].serviceList.length; y++) {
          if (serviceId != null && categoryId != null &&
              serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(serviceId) &&
              serviceListSnippetListState[z].businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(categoryId)) {
            sub = true;
          }
        }
      }
    }
    return sub;
  }

  void searchCategory(List<CategoryState> list) {
    setState(() {
      List<CategoryState> categoryState = list;
      categoryList.clear();
      if (_searchController.text.isNotEmpty) {
        categoryState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
              if (service.categoryId.contains(element.id)) {
                createCategoryList(element);
              }
            });
          }
          if (element.customTag != null && element.customTag.isNotEmpty && element.customTag.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
              if (service.categoryId.contains(element.id)) {
                createCategoryList(element);
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
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
        found = true;
      }
    });

    if (!found) {
      categoryList.add(element);
      categoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      if (!categoryListIds[element.name].contains(element.id)) {
        categoryListIds[element.name].add(element.id);
      }
    }
  }

  void searchPopular(List<ServiceState> list) {
    debugPrint('RUI_U_service_explorer => POPULAR SEARCH - SERVICE LENGTH: ${list.length}');
    setState(() {
      List<ServiceState> serviceState = list;
      List<ServiceState> tmp = [];
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            tmp.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
                if (!tmp.contains(element)) {
                  tmp.add(element);
                }
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
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
    debugPrint('RUI_U_service_explorer => RECCOMENDED SEARCH');
    setState(() {
      List<ServiceState> serviceState = list;
      List<ServiceState> tmpList = [];
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            tmpList.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
                if (!tmpList.contains(element)) {
                  tmpList.add(element);
                }
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
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
      searchedList.add(tmp);
    });
  }


  void searchByQR(List<CategoryState> cList, List<ServiceState> list){

    List<CategoryState> categoryState = cList;
    categoryList.clear();
    if (_searchController.text.isNotEmpty) {
      categoryState.forEach((element) {
        if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
          StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
            if (service.categoryId.contains(element.id)) {
              createCategoryList(element);
            }
          });
        }
        if (element.customTag != null && element.customTag.isNotEmpty && element.customTag.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
          StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((service) {
            if (service.categoryId.contains(element.id)) {
              createCategoryList(element);
            }
          });
        }

        businessList.forEach((business) {
          if (business.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            if (business.id_firestore == element.businessId && element.businessId == DynamicLinkHelper.discoverBusinessId) {
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
    searchedList.add(categoryList);

    setState(() {
      List<ServiceState> serviceState = list;
      List<ServiceState> tmp = [];
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            tmp.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
                if (!tmp.contains(element)) {
                  tmp.add(element);
                }
              }
            });
          }
          businessList.forEach((business) {
            if (business.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
              if (business.id_firestore == element.businessId && element.businessId == DynamicLinkHelper.discoverBusinessId) {
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

  _getLocation() async {
    loc.Location location = new loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;
    loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
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
        return;
      }
    }

    _locationData = await location.getLocation();
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
  }

  bool first = false;
  bool once = false;


  Future<Color> getDominatColor(String image) async {
    ImageProvider imageProvider = Image.network(image).image;
    PaletteGenerator p = await PaletteGenerator.fromImageProvider(imageProvider,timeout: Duration(milliseconds: 1100));
    //debugPrint('RUI_U_service_explorer => Category domina color: ${p.dominantColor.color}');
    return p.dominantColor.color;
  }

  String searchCategoryRootId(String categoryId, String serviceId) {
    ServiceListSnippetState serviceListSnippetState = StoreProvider.of<AppState>(context).state.serviceListSnippetState;
    for (var w = 0; w < serviceListSnippetState.businessSnippet.length; w++) {
      for (var y = 0; y < serviceListSnippetState.businessSnippet[w].serviceList.length; y++) {
        if (serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(categoryId)  &&  serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.contains(serviceId)) {
          return serviceListSnippetState.businessSnippet[w].serviceList[y].serviceAbsolutePath.split('/')[1];
        }
      }
    }
  }

  openwhatsapp() async{
    var whatsapp ="+447411204508";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }else{
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("whatsapp no installed")));
      }
    }

  }

  /*Future<void> checkout()async{
    /// retrieve data from the backend
    final paymentSheetData = backend.fetchPaymentSheetData();

    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          testEnv: true,
          merchantCountryCode: 'DE',
          merchantDisplayName: 'Flutter Stripe Store Demo',
          customerId: _paymentSheetData!['customer'],
          paymentIntentClientSecret: _paymentSheetData!['paymentIntent'],
          customerEphemeralKeySecret: _paymentSheetData!['ephemeralKey'],
        ));

    await Stripe.instance.presentPaymentSheet();
  }*/

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    var isManagerOrAbove = false;
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    final Stream<QuerySnapshot> _orderStream =  FirebaseFirestore.instance
        .collection("order")
        .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
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
        store.dispatch(UserBookingListRequest(store.state.user.email, false));
        dynamicLinkHelper.onSitePaymentFound(context);
        dynamicLinkHelper.bookingCodeFound(context);
        dynamicLinkHelper.selfCheckInFound(context);
        dynamicLinkHelper.categoryInviteFound(context);
        dynamicLinkHelper.onSitePaymentFound(context);
        dynamicLinkHelper.searchBusiness();
        store.state.categoryList.categoryListState.clear();
        store.state.serviceList.serviceListState.clear();
        startRequest = true;
        await _getLocation();
        store.dispatch(AllRequestListCategory(''));
        if (auth.FirebaseAuth != null && auth.FirebaseAuth.instance != null && auth.FirebaseAuth.instance.currentUser != null) {
          auth.User user = auth.FirebaseAuth.instance.currentUser;
          if (user != null) {
            store.state.notificationListState.notificationListState.clear();
            store.dispatch(RequestNotificationList(store.state.user.uid, store.state.business.id_firestore));
          }
        }
      },
      builder: (context, snapshot) {
        cards.clear();
        cards.add(LandingCardWidget(AppLocalizations.of(context).enterBookingCode, AppLocalizations.of(context).ifYouHaveABooking, 'assets/img/key.jpg', null, false));
        businessList = snapshot.businessList.businessListState;
        isManagerOrAbove = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;
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
                  if (element.opened != null && !element.opened) {
                    hasNotifications = true;
                  }
                });
                notifications.sort((b, a) => a.timestamp.compareTo(b.timestamp));
              }
              first = true;
            }
            if (categoryList.isNotEmpty && categoryList.first.name == null) categoryList.removeLast();
            noActivity = false;
          }
        }
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();

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
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Scaffold(
                      appBar: BuytimeAppbar(
                        background: BuytimeTheme.BackgroundCerulean ,
                        width: media.width,
                        children: [
                          ///Back Button
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty ?
                                SizedBox(
                                  width: 50.0,
                                ) : Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                  child: IconButton(
                                    key: Key('action_button_discover'),
                                    icon: Icon(
                                      Icons.person_outline,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    tooltip: AppLocalizations.of(context).comeBack,
                                    onPressed: () {
                                      FirebaseAnalytics().logEvent(
                                          name: 'back_button_discover',
                                          parameters: {
                                            'user_email': snapshot.user.email,
                                            'date': DateTime.now().toString(),
                                          });
                                      //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Registration(true)),);
                                      /*Future.delayed(Duration.zero, () {

                                      Future.delayed(Duration.zero, () {
                                        Navigator.of(context).pop();
                                      });*/
                                    },
                                  ),
                                )  ,
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
                                  /*IconButton(
                                    key: Key('action_button_discover'),
                                    icon: Icon(
                                      Icons.payment,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    tooltip: AppLocalizations.of(context).comeBack,
                                    onPressed: () async {
                                      *//*Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) => PaypalPayment(
                                            onFinish: (number) async {

                                              // payment done
                                              debugPrint('order id: '+number);

                                            },
                                            tourist: true,
                                          ),
                                        ),
                                      );*//*
                                      await SatispayServices().createPaypalPayment();
                                    },
                                  ),*/
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
                                                  key: Key('cart_key'),
                                                  icon: Icon(
                                                    BuytimeIcons.shopping_cart,
                                                    color: BuytimeTheme.TextWhite,
                                                    size: 24.0,
                                                  ),
                                                  onPressed: () {
                                                    debugPrint("RUI_U_service_explorer => + cart_discover");
                                                    FirebaseAnalytics().logEvent(
                                                        name: 'cart_discover',
                                                        parameters: {
                                                          'user_email': snapshot.user.email,
                                                          'date': DateTime.now().toString(),
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
                                        top: SizeConfig.safeBlockVertical * 2,
                                        left: SizeConfig.safeBlockHorizontal * 3.5,
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
                                              //textCapitalization: TextCapitalization.sentences,
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
                                                    debugPrint('RUI_U_service_explorer =>  done');
                                                    debugPrint('RUI_U_service_explorer => SEARCH - SERVICE LENGTH: ${Provider.of<Explorer>(context, listen: false).serviceList.length}');
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
                                                      'user_email': snapshot.user.email,
                                                      'date': DateTime.now().toString(),
                                                      'string_searched': _searchController.text
                                                    });
                                                debugPrint('RUI_U_service_explorer => done');
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
                                                DynamicLinkHelper.discoverBusinessName = '';
                                                //DynamicLinkHelper.discoverBusinessId = '';
                                                first = false;
                                              });
                                            },
                                          ),
                                        )
                                            : Container()
                                      ],
                                    ),
                                  ),
                                  ///My bookings if user
                                  FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty && _searchController.text.isEmpty /*&& cards.isNotEmpty*/?
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5,right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                    child: _OpenContainerWrapper(
                                      index: 0,
                                      closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                        cards[0].callback = openContainer;
                                        return cards[0];
                                      },
                                    ),
                                  ) : Container()
                                  /*Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5,right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                      child: Utils.imageShimmer(SizeConfig.safeBlockVertical * 80, 100))*/,
                                  ///My bookings & View all
                                  _searchController.text.isEmpty && snapshot.user.getRole() == Role.user && auth.FirebaseAuth.instance.currentUser != null
                                      ? StreamBuilder<QuerySnapshot>(
                                      stream: _orderStream,
                                      builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                                        userOrderList.clear();
                                        orderList.clear();
                                        if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting || noActivity) {
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
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
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
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                                  child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                              order.progress == Utils.enumToString(OrderStatus.accepted))
                                          /*|| ((order.itemList.first.date.isAtSameMomentAs(currentTime) || order.itemList.first.date.isBefore(currentTime)) && order.progress != Utils.enumToString(OrderStatus.paid))*/)
                                            /*(order.itemList.first.date.isAtSameMomentAs(currentTime) || order.itemList.first.date.isAfter(currentTime)) && order.itemList.first.time != null*/

                                            userOrderList.add(order);
                                          orderList.add(order);
                                        });
                                        //debugPrint('RUI_U_service_explorer =>  asdsd');
                                        userOrderList.sort((a,b) => a.itemList.first.date.isBefore(b.itemList.first.date) ? -1 : a.itemList.first.date.isAtSameMomentAs(b.itemList.first.date) ? 0 : 1);
                                        orderList.sort((a,b) => a.date.isBefore(b.date) ? -1 : a.date.isAtSameMomentAs(b.date) ? 0 : 1);
                                        return userOrderList.isNotEmpty || orderList.isNotEmpty ? Container(
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
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
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
                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => RAllBookings(fromConfirm: false, tourist: true,)),);
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
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                                child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                              debugPrint('RUI_U_service_explorer => SERVICE WAITING');
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ///Discover
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * 2),
                                                      //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 150,
                                                      width: double.infinity,
                                                      color: BuytimeTheme.BackgroundWhite,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Discover
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: 5, bottom: 5),
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
                                                            child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    CategoryState category = CategoryState().toEmpty();
                                                                    debugPrint('RUI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
                                                                    return  Container(
                                                                      width: 100,
                                                                      height: 100,
                                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                      child: Utils.imageShimmer(100, 100),
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
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
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
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
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
                                                            child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
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
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
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
                                                            child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                            debugPrint('RUI_U_service_explorer => LIST: ${list.length}');

                                            if(!once){
                                              StoreProvider.of<AppState>(context).dispatch(ServiceListReturned(list));
                                              once = true;
                                            }
                                            List<ServiceState> tmp = Provider.of<Explorer>(context, listen: false).serviceList;
                                            debugPrint('RUI_U_service_explorer => TMP SERVICE FORM BUILDER: ${tmp.length}');
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
                                              //debugPrint('RUI_U_service_explorer => CATEGORY NAME => ${cLS.name} ${cLS.level}');
                                              if (cLS.level == 0) {
                                                if (cLS.name.contains('Diving')) {
                                                  //debugPrint('RUI_U_service_explorer =>  CATEGORY NAME => ${cLS.name} ${cLS.id} ${cLS.businessId} ${cLS.level}');
                                                }
                                                Provider.of<Explorer>(context, listen: false).serviceList.forEach((service) {
                                                  if ((service.categoryId != null && service.categoryId.contains(cLS.id) || searchCategoryAndServiceOnSnippetList(service.serviceId, cLS.id))) {
                                                    //debugPrint('RUI_U_service_explorer =>  ${cLS.name} AND LEVEL ${cLS.level}');
                                                    createCategoryList(cLS);
                                                  }
                                                });
                                              }
                                            });

                                            debugPrint('RUI_U_service_explorer => SERVICE FORM BUILDER: ${Provider.of<Explorer>(context, listen: false).serviceList.length}');
                                            debugPrint('RUI_U_service_explorer => LIST SERVICE FORM BUILDER: ${list.length}');
                                            debugPrint('RUI_U_service_explorer => POPULAR SERVICE FORM BUILDER: ${popularList.length}');
                                            debugPrint('RUI_U_service_explorer => RECCOMENDED SERVICE FORM BUILDER: ${recommendedList.length}');

                                            //popularList.shuffle();
                                            //recommendedList.shuffle();

                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              debugPrint('RUI_U_service_explorer => SEARCHED BUSINESS NAME: ${DynamicLinkHelper.discoverBusinessName} | SEARCHED BUSIENSS ID:${DynamicLinkHelper.discoverBusinessId}');
                                              if(Provider.of<Explorer>(context, listen: false).serviceList.isNotEmpty && DynamicLinkHelper.discoverBusinessName.isNotEmpty && DynamicLinkHelper.discoverBusinessId.isNotEmpty){
                                                _searchController.text = DynamicLinkHelper.discoverBusinessName;
                                                FocusScope.of(context).unfocus();
                                                searchedList.clear();
                                                ///TODO make a new search system for the dynamic link
                                                searchByQR(snapshot.categoryList.categoryListState, Provider.of<Explorer>(context, listen: false).serviceList);
                                                /*searchCategory(snapshot.categoryList.categoryListState);
                                                searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                                searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);*/
                                              }
                                            });

                                            List<Widget> childrens = [];

                                            ///Discover
                                            childrens.add(Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * 2),
                                                //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                height: 150,
                                                width: double.infinity,
                                                color: BuytimeTheme.BackgroundWhite,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Discover
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: 5, bottom: 5),
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
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              CategoryState category = categoryList.elementAt(index);
                                                              return Container(
                                                                width: 100,
                                                                height: 100,
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                child: DiscoverCardWidget(100, 100, category, true, categoryListIds[category.name], index),
                                                              );
                                                            },
                                                            childCount: categoryList.length,
                                                          ),
                                                        ),
                                                      ]),
                                                    )
                                                        : noActivity
                                                        ? Flexible(
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                        SliverList(
                                                          delegate: SliverChildBuilderDelegate(
                                                                (context, index) {
                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                              CategoryState category = CategoryState().toEmpty();
                                                              return  Container(
                                                                width: 100,
                                                                height: 100,
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                child: Utils.imageShimmer(100, 100),
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
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                                //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                                height: popularList.isNotEmpty || noActivity ? 320 : 200,
                                                color: Color(0xff1E3C4F),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Popular
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
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
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
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
                                                      height: 240,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
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
                                                //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                height: recommendedList.isNotEmpty || noActivity ? 320 : 200,
                                                color: BuytimeTheme.BackgroundWhite,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Recommended
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
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
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
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
                                                      height: 240,
                                                      width: double.infinity,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                    ///No List
                                                    Container(
                                                      height: SizeConfig.safeBlockVertical * 8,
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
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
                                                    if (!tmpServiceList.contains(service)) {
                                                      if(categoryListIds[element.name].contains(element2)) {
                                                        tmpServiceList.add(service);
                                                      }
                                                    }
                                                    snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sl) {
                                                      sl.businessSnippet.forEach((c) {
                                                        if(!tmpServiceList.contains(service) && (c.categoryAbsolutePath.contains(element2) && categoryListIds[element.name].contains(c.categoryAbsolutePath.split('/')[1]))){
                                                          tmpServiceList.add(service);
                                                        }
                                                      });
                                                    });
                                                  });
                                                }});
                                              if(tmpServiceList.length >= 4)
                                                childrens.add(Flexible(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                    height: tmpServiceList.isNotEmpty || noActivity ? 320 : 200,
                                                    color: BuytimeTheme.BackgroundWhite,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ///Category name
                                                        Container(
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                          child: Text(
                                                            element.name,
                                                            style: TextStyle(
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
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                          child: Text(
                                                            '${AppLocalizations.of(context).discoverStart} ${element.name} ${AppLocalizations.of(context).discoverEnd}',
                                                            style: TextStyle(
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
                                                          height: 240,
                                                          width: double.infinity,
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                          child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                            SliverList(
                                                              delegate: SliverChildBuilderDelegate(
                                                                    (context, index) {
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
                                                          child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                            SliverList(
                                                              delegate: SliverChildBuilderDelegate(
                                                                    (context, index) {
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
                                                        ///No List
                                                        Container(
                                                          height: SizeConfig.safeBlockVertical * 8,
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
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
                                              i++;
                                            });
                                            ///Go to business management IF manager role or above.
                                            if(isManagerOrAbove)
                                              childrens.add(Container(
                                                color: Colors.white,
                                                height: 64,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => drawerSelection == DrawerSelection.BusinessList ? RBusinessList() : RActivityManagement()),
                                                      );
                                                    },
                                                    child: CustomBottomButtonWidget(
                                                        Container(
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                          child: Text(
                                                            AppLocalizations.of(context).goToBusiness,
                                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16),
                                                          ),
                                                        ),
                                                        '',
                                                        Container(
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                          child: Icon(
                                                            Icons.business_center,
                                                            color: BuytimeTheme.SymbolGrey,
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                              ));
                                            ///contact us
                                            childrens.add(
                                                Container(
                                                    color: Colors.white,
                                                    height: 64,
                                                    margin: EdgeInsets.only(top: 10),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                          onTap: () async {
                                                            String url = BuytimeConfig.ArunasNumber.trim();
                                                            debugPrint('RUI_U_service_explorer => Restaurant phonenumber: ' + url);
                                                            if (await canLaunch('tel:$url')) {
                                                              await launch('tel:$url');
                                                            } else {
                                                              throw 'Could not launch $url';
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 64,
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 8,
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                                            child: Text(
                                                                              AppLocalizations.of(context).contactUs,
                                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context).haveAnyQuestion,
                                                                            style: TextStyle(
                                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                                color: BuytimeTheme.TextBlack,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 14
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: Container(
                                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                                          child: Icon(
                                                                            Icons.call,
                                                                            color: BuytimeTheme.SymbolGrey,
                                                                          ),
                                                                        )),
                                                                    Expanded(
                                                                        flex: 1,
                                                                        child: GestureDetector(
                                                                          onTap: (){
                                                                            openwhatsapp();
                                                                          },
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(top: 10),
                                                                            height: 24,
                                                                            width: 24,
                                                                            decoration: BoxDecoration(
                                                                              image: DecorationImage(
                                                                                  image: AssetImage('assets/img/whatsapp.png'),
                                                                                  fit: BoxFit.contain
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ))
                                                                  ],
                                                                ),
                                                                Container(
                                                                  width: double.infinity,
                                                                  height: SizeConfig.safeBlockVertical * .2,
                                                                  color: BuytimeTheme.DividerGrey,
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                      ),)));
                                            ///Log out
                                            childrens.add(
                                                Container(
                                                  color: Colors.white,
                                                  height: 64,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        key: Key('log_out_key'),
                                                        onTap: () async {
                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                          dynamicLinkHelper.clearBooking();
                                                          FirebaseAuth.instance.signOut().then((_) {
                                                            googleSignIn.signOut();
                                                            Provider.of<Explorer>(context, listen: false).clear();
                                                            Provider.of<Spinner>(context, listen: false).clear();
                                                            Provider.of<ReserveList>(context, listen: false).clear();
                                                            Provider.of<CategoryService>(context, listen: false).clear();
                                                            StoreProvider.of<AppState>(context).dispatch(SetAppStateToEmpty());
                                                            drawerSelection = DrawerSelection.BusinessList;
                                                            Navigator.of(context).pushReplacementNamed(Home.route);
                                                          });
                                                        },
                                                        child: CustomBottomButtonWidget(
                                                            Container(
                                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                              child: Text(
                                                                AppLocalizations.of(context).logOut,
                                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16),
                                                              ),
                                                            ),
                                                            '',
                                                            Container(
                                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                              child: Icon(
                                                                MaterialDesignIcons.exit_to_app,
                                                                color: BuytimeTheme.SymbolGrey,
                                                              ),
                                                            ))),
                                                  ),
                                                ));

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
                                        child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.vertical, slivers: [
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate(
                                                  (context, index) {
                                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                                if (index == 0) {
                                                  return Container(
                                                    height: categoryList.isEmpty ? 0 : 80,
                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4.5, bottom: SizeConfig.safeBlockVertical * 1),
                                                    child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                      SliverList(
                                                        delegate: SliverChildBuilderDelegate(
                                                              (context, index) {
                                                            //MenuItemModel menuItem = menuItems.elementAt(index);

                                                            CategoryState category = categoryList.elementAt(index);
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
                                                  debugPrint('RUI_U_service_explorer => searched index: $index | service list: ${serviceList.length}');
                                                  return CustomScrollView(shrinkWrap: true, physics: NeverScrollableScrollPhysics(), scrollDirection: Axis.vertical, slivers: [
                                                    SliverList(
                                                      delegate: SliverChildBuilderDelegate(
                                                            (context, index) {
                                                          //MenuItemModel menuItem = menuItems.elementAt(index);
                                                          ServiceState service = serviceList.elementAt(index);
                                                          return Column(
                                                            children: [
                                                              ServiceListItem(service, true, index),
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
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
    debugPrint('RUI_U_service_explorer => SEARCHING INIT');
    notifyListeners();
  }
  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('RUI_U_service_explorer => SERVICE LIST INIT');
    notifyListeners();
  }

  clear(){
    this.searching = false;
    this.serviceList.clear();
  }

}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({this.closedBuilder, this.transitionType, this.onClosed, this.index});

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final int index;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      key: index == 0
          ? StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isEmpty ?
      Key('invite_key') :
      Key('my_bookings_key')
          : Key('discover_key'),
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        if (index == 0) {
          if (StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isEmpty)
            return InviteGuestForm(
              id: '',
              fromLanding: true,
            );
          else
            return RMyBookings(
              fromLanding: true,
            );
        } else {
          return RServiceExplorer();
        }
      },
      onClosed: onClosed,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      tappable: false,
      closedBuilder: closedBuilder,
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}

