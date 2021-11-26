
import 'dart:async';
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
import 'package:Buytime/UI/user/turist/UI_U_test.dart';
import 'package:Buytime/UI/user/turist/widget/new_discover_card_widget.dart';
import 'package:Buytime/UI/user/turist/widget/new_p_r_card_widget.dart';
import 'package:Buytime/helper/algolia_helper.dart';
import 'package:Buytime/helper/pagination/category_helper.dart';
import 'package:Buytime/helper/pagination/service_helper.dart';
import 'package:Buytime/helper/payment/satispay/satispay_service.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reusable/w_custom_bottom_button.dart';
import 'package:Buytime/reusable/w_landing_card.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:algolia/algolia.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emojis.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UI_U_view_more.dart';

class RServiceExplorer extends StatefulWidget {
  static String route = '/serviceExplorer';
  bool fromBookingPage;
  String searched;

  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Explorer>(
      create: (_) => Explorer(false, [], [], [], TextEditingController(), false, [], BusinessState().toEmpty(), [], '', []),
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

  ScrollController popularServiceScroller = ScrollController();
  ServicePagingBloc servicePagingBloc;
  CategoryBloc categoryBloc;

  Stream<QuerySnapshot> _orderStream;
  Stream<QuerySnapshot> _categoryStream;
  Stream<QuerySnapshot> _serviceStream;
  Stream<QuerySnapshot> _businessStream;
  Stream<QuerySnapshot> _bookingStream;
  Algolia algolia = AlgoliaHelper.algolia;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searched;
    servicePagingBloc = ServicePagingBloc();
    categoryBloc = CategoryBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StoreProvider.of<AppState>(context).dispatch(PromotionListRequest());
      //servicePagingBloc.requestServices(context);
      DateTime currentTime = DateTime.now();
      currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
      debugPrint('RUI_U_service_explorer => CURRENT TIME: $currentTime');

      _orderStream =  FirebaseFirestore.instance
          .collection("order")
          .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
          .where("date", isGreaterThanOrEqualTo: currentTime)
          .limit(50)
          .snapshots(includeMetadataChanges: true);

      _categoryStream =  FirebaseFirestore.instance
          .collection("category")
          .where("serviceCount", isGreaterThan: 0)
          .snapshots(includeMetadataChanges: true);

      if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
        _serviceStream = FirebaseFirestore.instance.collection("service")
            .where("tag", arrayContains: StoreProvider.of<AppState>(context).state.area.areaId)
            .where("visibility", isEqualTo: 'Active')
        //.orderBy("name")
            .limit(10)
            .snapshots(includeMetadataChanges: true);
      }else{
        _serviceStream = FirebaseFirestore.instance.collection("service")
            .where("visibility", isEqualTo: 'Active')
        //.orderBy("name")
            .limit(10)
            .snapshots(includeMetadataChanges: true);;
      }

      _businessStream =  FirebaseFirestore.instance
          .collection("business")
          .where("draft", isEqualTo: false)
          .snapshots(includeMetadataChanges: true);

      _bookingStream = FirebaseFirestore.instance
          .collection("booking")
          .where("userEmail", arrayContains: StoreProvider.of<AppState>(context).state.user.email)
          .where("status", isEqualTo: 'opened')
          .where("end_date", isGreaterThanOrEqualTo: currentTime)
          .orderBy("end_date", descending: true)
          .snapshots(includeMetadataChanges: true);
    });

    popularServiceScroller.addListener(popularServiceScrollListener);
  }

  void popularServiceScrollListener() {
    if (popularServiceScroller.offset >= popularServiceScroller.position.maxScrollExtent &&
        !popularServiceScroller.position.outOfRange) {
      debugPrint("RUI_U_service_explorer => POPULAR SERVICE LIST END -> REFRESH");
      servicePagingBloc.requestServices(context);
    }
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
  List<CategoryState> caso = [];
  void searchCategory(List<CategoryState> list) {
    debugPrint('RUI_U_service_explorer => CATOGORY LIST: ${list.length}');
    setState(() {
      List<CategoryState> categoryState = list;
      categoryList.clear();
      debugPrint('RUI_U_service_explorer => SEARCH TEXT IS NOT EMPTY: ${_searchController.text.isNotEmpty}');
      if (_searchController.text.isNotEmpty) {
        debugPrint('RUI_U_service_explorer => CATOGORY LIST: ${list.length}');
        categoryState.forEach((element) {
          debugPrint('RUI_U_service_explorer => ${element.name.toLowerCase()} - ${_searchController.text.toLowerCase().trim()} - ${element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())}');
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
            createCategoryList(element);
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
  void newSearchCategory(List<CategoryState> list) async{
    debugPrint('RUI_U_service_explorer => CATOGORY LIST: ${list.length}');

    List<CategoryState> tmp = [];
    List<ServiceState> tmpServices = [];
    List<CategoryState> categoryState = list;

    //categoryList.clear();
    debugPrint('RUI_U_service_explorer => SEARCH TEXT IS NOT EMPTY: ${_searchController.text.isNotEmpty}');
    if (_searchController.text.isNotEmpty) {
      debugPrint('RUI_U_service_explorer => CATOGORY LIST: ${list.length}');
      categoryState.forEach((element) {
        debugPrint('RUI_U_service_explorer => ${element.name.toLowerCase()} - ${_searchController.text.toLowerCase().trim()} - ${element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())}');
        if (element.name.toLowerCase().contains(_searchController.text.toLowerCase().trim())) {
          tmp.add(element);
        }
      });
    }

    if(_searchController.text.length >= 3){ ///TODO check if work
      AlgoliaQuery query = algolia.instance.index('service').query(_searchController.text);
      AlgoliaQuerySnapshot snap = await query.getObjects();
      debugPrint('RUI_U_service_explorer => ALGOLIA RESULT: ${snap}');
      setState(() {
        if(snap.hits.isNotEmpty){
          snap.hits.forEach((hit) {
            ServiceState service = ServiceState.fromJson(hit.data);
            tmpServices.add(service);
          });
          Provider.of<Explorer>(context, listen: false).searchedList.add(tmp);
          Provider.of<Explorer>(context, listen: false).searchedList.add(tmpServices);
        }else{
          Provider.of<Explorer>(context, listen: false).searchedList.add(tmp);
        }
      });
    }

    debugPrint('RUI_U_service_explorer => SEARCHED LIST LENGTH: ${Provider.of<Explorer>(context, listen: false).searchedList.length}');
  }

  List<Color> myColors = [];

  void createCategoryList(CategoryState element) {
    bool found = false;
    categoryList.forEach((cL) {
      if (cL.name == element.name) {
        found = true;
      }
    });
    caso.forEach((cL) {
      if (cL.name == element.name) {
        found = true;
      }
    });

    if (!found) {
      categoryList.add(element);
      caso.add(element);
      categoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      if (/*categoryListIds[element.name] != null && */!categoryListIds[element.name].contains(element.id)) {
        categoryListIds[element.name].add(element.id);
      }
    }
  }

  void newCreateCategoryList(CategoryState element) {
    bool found = false;
    Provider.of<Explorer>(context, listen: false).rootCategoryList.forEach((cL) {

      if (cL.name == element.name) {
        found = true;
      }
    });
    debugPrint('${element.name} - FOUND: $found');
    if (!found) {
      Provider.of<Explorer>(context, listen: false).rootCategoryList.add(element);
      categoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      if (categoryListIds[element.name] != null && !categoryListIds[element.name].contains(element.id)) {
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

  void searchPopularNoRebuild(List<ServiceState> list) {
    debugPrint('RUI_U_service_explorer => POPULAR SEARCH - SERVICE LENGTH: ${list.length}');
    debugPrint('RUI_U_service_explorer => POPULAR SEARCH - SEARCH TEXT: ${_searchController.text}');
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
    Provider.of<Explorer>(context, listen: false).searchedList.add(tmp);
    debugPrint('RUI_U_service_explorer => POPULAR SEARCH - SEARCHED SERVICE LENGTH: ${Provider.of<Explorer>(context, listen: false).searchedList.length}');
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
      await FirebaseMessaging.instance.subscribeToTopic('broadcast_gps');
      debugPrint('FIREBASE MESSAGING TOP SUBSCRIBTION TO: broadcast_gps');
      setState(() {
        gettingLocation = false;
        currentLat = _locationData.latitude;
        currentLng = _locationData.longitude;
        distanceFromCurrentPosition = 0.0;
      });

      /// set current area in the store
      AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
      AreaState areaState = Utils.getCurrentArea('$currentLat, $currentLng', areaListState);
      await FirebaseMessaging.instance.subscribeToTopic('broadcast_${areaState.areaId}');
      debugPrint('FIREBASE MESSAGING TOP SUBSCRIBTION TO: broadcast_${areaState.areaId}');
      StoreProvider.of<AppState>(context).dispatch(SetArea(areaState));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).problemsGettingYourPosition)));
    }
  }

  bool first = false;
  bool once = false;


  Future<Color> getDominatColor(String image) async {
    ImageProvider imageProvider = Image.network(image).image;
    PaletteGenerator p = await PaletteGenerator.fromImageProvider(imageProvider,timeout: Duration(milliseconds: 1100));
    debugPrint('RUI_U_service_explorer => Category domina color: ${p.dominantColor.color}');
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

  bool searching = false;
  static Key formKey = Key('search_field_key');
  Stream<QuerySnapshot> searchStream;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    var isManagerOrAbove = false;
    debugPrint('RUI_U_service_explorer - REBUILD');



    /*if(_searchController.text.isEmpty && !Provider.of<Explorer>(context, listen: false).searching && !first){
      servicePagingBloc.requestServices(context);
      //servicePagingBloc.loadService();
    }*/


    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        //store.dispatch(UserBookingListRequest(store.state.user.email, false));
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
        Locale myLocale = Localizations.localeOf(context);
        if(Provider.of<Explorer>(context, listen: false).searchedList.isNotEmpty){
          if (sortBy == 'A-Z') {
            Provider.of<Explorer>(context, listen: false).searchedList.first.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
            Provider.of<Explorer>(context, listen: false).searchedList.last.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
          } else if (sortBy == 'Z-A'){
            Provider.of<Explorer>(context, listen: false).searchedList.first.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
            Provider.of<Explorer>(context, listen: false).searchedList.last.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
          }
        }
        /*WidgetsBinding.instance.addPostFrameCallback((_) async {
          Provider.of<Explorer>(context, listen: false).businessState = BusinessState().toEmpty();
        });*/
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
                      appBar: !searching ? AppBar(
                        backgroundColor: Colors.white,
                        leading: Container(
                          margin: EdgeInsets.only(top: 5),
                          child: IconButton(
                            key: Key('action_search_button_key'),
                            icon: Icon(
                              Icons.search,
                              color: Colors.black,
                              //size: 30.0,
                            ),
                            //tooltip: AppLocalizations.of(context).comeBack,
                            onPressed: () {
                              setState(() {
                                searching = !searching;
                              });
                            },
                          ),
                        ),
                        /*Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          child: IconButton(
                            key: Key('action_button_discover'),
                            icon: Icon(
                              Icons.person_outline,
                              color: Colors.black,
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
                              *//*Future.delayed(Duration.zero, () {

                                      Future.delayed(Duration.zero, () {
                                        Navigator.of(context).pop();
                                      });*//*
                            },
                          ),
                        )*/
                        centerTitle: true,
                        title: Container(
                          width: SizeConfig.safeBlockHorizontal * 60,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).buytime,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      //letterSpacing: 0.15,
                                      color: BuytimeTheme.TextBlack
                                  ),
                                ),
                              )),
                        ),
                        actions: [
                          Container(
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
                                                key: Key('cart_key'),
                                                icon: Icon(
                                                  BuytimeIcons.shopping_cart,
                                                  color: BuytimeTheme.TextBlack,
                                                  size: 19.0,
                                                ),
                                                onPressed: () {
                                                  debugPrint("RUI_U_service_explorer => + cart_discover");
                                                  FirebaseAnalytics().logEvent(
                                                      name: 'cart_discover',
                                                      parameters: {
                                                        'user_email': StoreProvider.of<AppState>(context).state.user.email,
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
                                                  color: BuytimeTheme.TextBlack,
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
                          )
                        ],
                        elevation: 1,
                      ) :
                      AppBar(
                        backgroundColor: Colors.white,
                        centerTitle: true,
                        leading: IconButton(
                          key: Key('action_button_discover'),
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black,
                            size: 25.0,
                          ),
                          tooltip: AppLocalizations.of(context).comeBack,
                          onPressed: () {
                            setState(() {
                              searching = !searching;
                              _searchController.clear();
                              DynamicLinkHelper.discoverBusinessName = '';
                              //DynamicLinkHelper.discoverBusinessId = '';
                              first = false;
                              Provider.of<Explorer>(context, listen: false).searching = false;
                              //categoryListIds = Map();
                            });
                          },
                        ),
                        title: Container(
                          //alignment: Alignment.center,
                          height: 40,
                          margin: EdgeInsets.only(top: 2.5),
                          //width: SizeConfig.safeBlockHorizontal * 60,
                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: TextFormField(
                            key: formKey,
                            controller: _searchController,
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.search,
                            //textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 4, left: 10),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                              //labelText: AppLocalizations.of(context).whatAreYouLookingFor,
                              //helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                              hintText: AppLocalizations.of(context).whatAreYouLookingFor,
                              hintStyle: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w400,
                              ),
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
                              prefixIcon: InkWell(
                                key: Key('search_button_key'),
                                onTap: () {
                                  debugPrint('RUI_U_service_explorer =>  done');
                                  debugPrint('RUI_U_service_explorer => SEARCH - SERVICE LENGTH: ${Provider.of<Explorer>(context, listen: false).serviceList.length}');
                                  FocusScope.of(context).unfocus();
                                  Provider.of<Explorer>(context, listen: false).searchedList.clear();
                                  //searchCategory(Provider.of<Explorer>(context, listen: false).categoryList); ///CHANGE
                                  //searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                  //searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                                  //searchPopularNoRebuild(Provider.of<Explorer>(context, listen: false).serviceList);
                                  newSearchCategory(Provider.of<Explorer>(context, listen: false).rootCategoryList);
                                },
                                child: Icon(
                                  // Based on passwordVisible state choose the icon
                                  Icons.search,
                                  color: Colors.grey.withOpacity(.8),
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
                              Provider.of<Explorer>(context, listen: false).searchedList.clear();
                              //searchCategory(snapshot.categoryList.categoryListState);
                              //searchCategory(Provider.of<Explorer>(context, listen: false).categoryList); ///CHANGE
                              //searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                              //searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                              //searchPopularNoRebuild(Provider.of<Explorer>(context, listen: false).serviceList);
                              newSearchCategory(Provider.of<Explorer>(context, listen: false).rootCategoryList);
                            },
                          ),
                        ),
                        actions: [
                          _searchController.text.isNotEmpty
                              ? Container(
                            margin: EdgeInsets.only(top: 2.5),
                            child: IconButton(
                              key: Key('search_clear_button_key'),
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                BuytimeIcons.remove,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  DynamicLinkHelper.discoverBusinessName = '';
                                  //DynamicLinkHelper.discoverBusinessId = '';
                                  first = false;
                                  Provider.of<Explorer>(context, listen: false).searching = false;
                                  //categoryListIds = Map();
                                });

                              },
                            ),
                          ) : Container(
                            //margin: EdgeInsets.only(bottom: 20),
                            child: IconButton(
                              //key: Key('search_clear_button_key'),
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                BuytimeIcons.remove,
                                color: Colors.white,
                              ),
                              onPressed: null,
                            ),
                          )
                        ],
                        elevation: _searchController.text.isEmpty ? 1 : 0,
                      ),
                      // BuytimeAppbar(
                      //   background: BuytimeTheme.BackgroundCerulean ,
                      //   width: media.width,
                      //   children: [
                      //     ///Back Button
                      //     Expanded(
                      //       flex: 1,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty ?
                      //           SizedBox(
                      //             width: 50.0,
                      //           ) :
                      //           Padding(
                      //             padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      //             child: IconButton(
                      //               key: Key('action_button_discover'),
                      //               icon: Icon(
                      //                 Icons.person_outline,
                      //                 color: Colors.white,
                      //                 size: 25.0,
                      //               ),
                      //               tooltip: AppLocalizations.of(context).comeBack,
                      //               onPressed: () {
                      //                 FirebaseAnalytics().logEvent(
                      //                     name: 'back_button_discover',
                      //                     parameters: {
                      //                       'user_email': snapshot.user.email,
                      //                       'date': DateTime.now().toString(),
                      //                     });
                      //                 //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                      //                 Navigator.push(context, MaterialPageRoute(builder: (context) => Registration(true)),);
                      //                 /*Future.delayed(Duration.zero, () {
                      //
                      //                 Future.delayed(Duration.zero, () {
                      //                   Navigator.of(context).pop();
                      //                 });*/
                      //               },
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //
                      //     ///Title
                      //     Expanded(flex: 2, child: Utils.barTitle(AppLocalizations.of(context).buytime)),
                      //
                      //     ///Cart
                      //     ///Notification & Cart
                      //     Expanded(
                      //       flex: 1,
                      //       child: Container(
                      //         width: 100,
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             /*IconButton(
                      //               key: Key('action_button_discover'),
                      //               icon: Icon(
                      //                 Icons.payment,
                      //                 color: Colors.white,
                      //                 size: 25.0,
                      //               ),
                      //               tooltip: AppLocalizations.of(context).comeBack,
                      //               onPressed: () async {
                      //                 *//*Navigator.of(context).push(
                      //                   MaterialPageRoute(
                      //                     builder: (BuildContext context) => PaypalPayment(
                      //                       onFinish: (number) async {
                      //
                      //                         // payment done
                      //                         debugPrint('order id: '+number);
                      //
                      //                       },
                      //                       tourist: true,
                      //                     ),
                      //                   ),
                      //                 );*//*
                      //                 await SatispayServices().createPaypalPayment();
                      //               },
                      //             ),*/
                      //             ///Notification
                      //             Flexible(
                      //                 child: snapshot.user.uid != null && snapshot.user.uid.isNotEmpty
                      //                     ? RNotificationBell(
                      //                   orderList: orderList,
                      //                   userId: snapshot.user.uid,
                      //                   tourist: true,
                      //                 )
                      //                     : Container()),
                      //
                      //             ///Cart
                      //             Flexible(
                      //                 child: Container(
                      //                   margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                      //                   child: Stack(
                      //                     children: [
                      //                       Positioned.fill(
                      //                         child: Align(
                      //                           alignment: Alignment.center,
                      //                           child: IconButton(
                      //                             key: Key('cart_key'),
                      //                             icon: Icon(
                      //                               BuytimeIcons.shopping_cart,
                      //                               color: BuytimeTheme.TextWhite,
                      //                               size: 24.0,
                      //                             ),
                      //                             onPressed: () {
                      //                               debugPrint("RUI_U_service_explorer => + cart_discover");
                      //                               FirebaseAnalytics().logEvent(
                      //                                   name: 'cart_discover',
                      //                                   parameters: {
                      //                                     'user_email': snapshot.user.email,
                      //                                     'date': DateTime.now().toString(),
                      //                                   });
                      //                               if (order.cartCounter > 0) {
                      //                                 // dispatch the order
                      //                                 StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                      //                                 // go to the cart page
                      //                                 Navigator.push(
                      //                                   context,
                      //                                   MaterialPageRoute(
                      //                                       builder: (context) => Cart(
                      //                                         tourist: true,
                      //                                       )),
                      //                                 );
                      //                               } else {
                      //                                 showDialog(
                      //                                     context: context,
                      //                                     builder: (_) => new AlertDialog(
                      //                                       title: new Text(AppLocalizations.of(context).warning),
                      //                                       content: new Text(AppLocalizations.of(context).emptyCart),
                      //                                       actions: <Widget>[
                      //                                         MaterialButton(
                      //                                           elevation: 0,
                      //                                           hoverElevation: 0,
                      //                                           focusElevation: 0,
                      //                                           highlightElevation: 0,
                      //                                           child: Text(AppLocalizations.of(context).ok),
                      //                                           onPressed: () {
                      //                                             Navigator.of(context).pop();
                      //                                           },
                      //                                         )
                      //                                       ],
                      //                                     ));
                      //                               }
                      //                             },
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       order.cartCounter > 0
                      //                           ? Positioned.fill(
                      //                         bottom: 20,
                      //                         left: 3,
                      //                         child: Align(
                      //                           alignment: Alignment.center,
                      //                           child: Text(
                      //                             '${order.cartCounter}',
                      //                             textAlign: TextAlign.start,
                      //                             style: TextStyle(
                      //                               fontSize: SizeConfig.safeBlockHorizontal * 3,
                      //                               color: BuytimeTheme.TextWhite,
                      //                               fontWeight: FontWeight.w400,
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       )
                      //                           : Container(),
                      //                     ],
                      //                   ),
                      //                 ))
                      //           ],
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
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
                                  /*Container(
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
                                              key: formKey,
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
                                                    Provider.of<Explorer>(context, listen: false).searchedList.clear();
                                                    //searchCategory(snapshot.categoryList.categoryListState);
                                                    //searchCategory(Provider.of<Explorer>(context, listen: false).categoryList); ///CHANGE
                                                    //searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                                    //searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                                                    searchPopularNoRebuild(Provider.of<Explorer>(context, listen: false).serviceList);
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
                                                Provider.of<Explorer>(context, listen: false).searchedList.clear();
                                                //searchCategory(snapshot.categoryList.categoryListState);
                                                //searchCategory(Provider.of<Explorer>(context, listen: false).categoryList); ///CHANGE
                                                //searchPopular(Provider.of<Explorer>(context, listen: false).serviceList);
                                                //searchRecommended(Provider.of<Explorer>(context, listen: false).serviceList);
                                                searchPopularNoRebuild(Provider.of<Explorer>(context, listen: false).serviceList);
                                              },
                                              onTap: () {
                                                // setState(() {
                                                //   searching = !searching;
                                                // });
                                                Provider.of<Explorer>(context, listen: false).searching = true;
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
                                                Provider.of<Explorer>(context, listen: false).searching = false;
                                                //categoryListIds = Map();

                                              });

                                            },
                                          ),
                                        ) : Container()
                                      ],
                                    ),
                                  ),*/

                                  _searchController.text.isEmpty ?
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///My bookings if user
                                      FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty /*&& cards.isNotEmpty*/?
                                      StreamBuilder<QuerySnapshot>(
                                          stream: _bookingStream,
                                          builder: (context, AsyncSnapshot<QuerySnapshot> bookingSnapshot) {
                                            //myList.clear();
                                            if (bookingSnapshot.hasError || bookingSnapshot.connectionState == ConnectionState.waiting) {
                                              debugPrint('RUI_U_service_explorer => BOOKING WAITING');
                                              return Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        CircularProgressIndicator()
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                            List<BookingState> bookingList = [];
                                            if(bookingSnapshot.data != null){
                                              bookingSnapshot.data.docs.forEach((element) {
                                                BookingState bookingState = BookingState.fromJson(element.data());
                                                bookingList.add(bookingState);
                                              });
                                            }

                                            if(bookingList.isNotEmpty){
                                              BookingState bookingState = bookingList.first;

                                              bool sameMonth = false;
                                              String startMonth = DateFormat('MM').format(bookingState.start_date);
                                              String endMonth = DateFormat('MM').format(bookingState.end_date);

                                              if (startMonth == endMonth)
                                                sameMonth = true;
                                              else
                                                sameMonth = false;

                                              DateTime endTime = bookingState.end_date;
                                              endTime = new DateTime(endTime.year, endTime.month, endTime.day, 0, 0, 0, 0, 0);
                                              DateTime currentTime = DateTime.now();
                                              currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);

                                              return StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore.instance
                                                      .collection("business")
                                                      //.where("draft", isEqualTo: false)
                                                      .where("id_firestore", isEqualTo: bookingState.business_id)
                                                      .snapshots(includeMetadataChanges: true),
                                                  builder: (context, AsyncSnapshot<QuerySnapshot> businessSnapshot) {
                                                    //myList.clear();
                                                    if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                                      debugPrint('RUI_U_service_explorer => BOOKING BUSINESS WAITING');
                                                      return Flexible(
                                                        child: Container(
                                                          //height: SizeConfig.safeBlockVertical * 30,
                                                          width: double.infinity,
                                                          color: BuytimeTheme.BackgroundWhite,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              ///Greetings & Portfolio & Search
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  ///Greetings
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 3),
                                                                    child: Text(
                                                                      //AppLocalizations.of(context).hi + bookingState.user.first.name,
                                                                      '${AppLocalizations.of(context).hi} ${Emojis.wavingHand}',
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w700, fontSize: 24

                                                                        ///SizeConfig.safeBlockHorizontal * 7
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ///Portfolio
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 2),
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          AppLocalizations.of(context).yourHolidayInSpace + ' ' ,
                                                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16

                                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                                          ),
                                                                        ),
                                                                        Utils.textShimmer(50, 16)
                                                                      ],
                                                                    )
                                                                  ),
                                                                  ///Date & Share
                                                                  Row(
                                                                    children: [
                                                                      ///Date
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                                        child: Utils.textShimmer(100, 16),
                                                                      ),
                                                                      ///Share
                                                                      Container(
                                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                                          alignment: Alignment.center,
                                                                          child: Material(
                                                                            color: Colors.transparent,
                                                                            child: InkWell(
                                                                                onTap: () {
                                                                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                                                  //Navigator.of(context).pop();
                                                                                  final RenderBox box = context.findRenderObject();
                                                                                  Share.share(AppLocalizations.of(context).share, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                                                                },
                                                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(5.0),
                                                                                  child: Text(
                                                                                    AppLocalizations.of(context).share,
                                                                                    style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.SymbolMalibu, fontWeight: FontWeight.w400, fontSize: 14

                                                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              ///Business Logo
                                                              Container(
                                                                //margin: EdgeInsets.only(left: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                                width: 125,

                                                                ///25% SizeConfig.safeBlockVertical * 20
                                                                height: 125,

                                                                ///25% SizeConfig.safeBlockVertical * 20
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xffE6E7E8),
                                                                  /*gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.orange.withOpacity(.5),
                                          Colors.white,
                                        ],
                                      )*/
                                                                ),
                                                                child: Container(
                                                                  //width: 300,
                                                                  height: 125,
                                                                  child: Utils.imageShimmer(125, 125),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    BusinessState businessState = BusinessState().toEmpty();
                                                    businessSnapshot.data.docs.forEach((element) {
                                                      businessState = BusinessState.fromJson(element.data());
                                                    });
                                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                      Provider.of<Explorer>(context, listen: false).businessState = businessState;
                                                    });

                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        ///Busienss Booking Cover info
                                                        Flexible(
                                                          child: Container(
                                                            //height: SizeConfig.safeBlockVertical * 30,
                                                            width: double.infinity,
                                                            color: BuytimeTheme.BackgroundWhite,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                ///Greetings & Portfolio & Search
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    ///Greetings
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 3),
                                                                      child: Text(
                                                                        //AppLocalizations.of(context).hi + bookingState.user.first.name,
                                                                        '${AppLocalizations.of(context).hi} ${Emojis.wavingHand}',
                                                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w700, fontSize: 24

                                                                          ///SizeConfig.safeBlockHorizontal * 7
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    ///Portfolio
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 2),
                                                                      child: Text(
                                                                        AppLocalizations.of(context).yourHolidayInSpace + ' ' + (businessState != null ? businessState.municipality : ""),
                                                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16

                                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    ///Date & Share
                                                                    Row(
                                                                      children: [
                                                                        ///Date
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                                          child: Text(
                                                                            sameMonth
                                                                                ? '${DateFormat('dd', Localizations.localeOf(context).languageCode).format(bookingState.start_date)} - ${DateFormat('dd MMMM', Localizations.localeOf(context).languageCode).format(bookingState.end_date)}'
                                                                                : '${DateFormat('dd MMM', Localizations.localeOf(context).languageCode).format(bookingState.start_date)} - ${DateFormat('dd MMM', Localizations.localeOf(context).languageCode).format(bookingState.end_date)}',
                                                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16

                                                                              ///izeConfig.safeBlockHorizontal * 4
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        ///Share
                                                                        Container(
                                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                                            alignment: Alignment.center,
                                                                            child: Material(
                                                                              color: Colors.transparent,
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                                                    //Navigator.of(context).pop();
                                                                                    final RenderBox box = context.findRenderObject();
                                                                                    Share.share(AppLocalizations.of(context).share, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                                                                  },
                                                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.all(5.0),
                                                                                    child: Text(
                                                                                      AppLocalizations.of(context).share,
                                                                                      style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.SymbolMalibu, fontWeight: FontWeight.w400, fontSize: 14

                                                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                            )),
                                                                      ],
                                                                    ),

                                                                    ///ECO Label
                                                                    businessState.business_type == 'ECO'?
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1),
                                                                      child: Row(
                                                                        children: [
                                                                          Image( image: AssetImage('assets/img/eco.png')),
                                                                          Padding(
                                                                            padding: EdgeInsets.only(left: 10.0,top: 5.0),
                                                                            child: Text(
                                                                              '${AppLocalizations.of(context).youAreInAnEcoHotel}',
                                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ): Container(),
                                                                  ],
                                                                ),
                                                                ///Business Logo
                                                                Container(
                                                                  //margin: EdgeInsets.only(left: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                                  width: 125,

                                                                  ///25% SizeConfig.safeBlockVertical * 20
                                                                  height: 125,

                                                                  ///25% SizeConfig.safeBlockVertical * 20
                                                                  decoration: BoxDecoration(
                                                                    color: Color(0xffE6E7E8),
                                                                    /*gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.orange.withOpacity(.5),
                                          Colors.white,
                                        ],
                                      )*/
                                                                  ),
                                                                  child: Container(
                                                                    //width: 300,
                                                                    height: 125,
                                                                    child: CachedNetworkImage(
                                                                      //width: 125,
                                                                      imageUrl: businessState != null && businessState.logo != null
                                                                          ? businessState.logo
                                                                          : 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                        //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                                        decoration: BoxDecoration(
                                                                          //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                                            image: DecorationImage(
                                                                              image: imageProvider,
                                                                              fit: BoxFit.fitWidth,
                                                                            )),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(
                                                                            //color: Color(0xffE6E7E8),
                                                                              /*gradient: LinearGradient(
                                                                                begin: Alignment.bottomCenter,
                                                                                end: Alignment.topCenter,
                                                                                stops: [0.01, 0.3],
                                                                                colors: [Colors.white.withOpacity(1), Colors.white.withOpacity(0.01)],
                                                                              )*/),
                                                                        ),
                                                                      ),
                                                                      placeholder: (context, url) => Utils.imageShimmer(125, 125),
                                                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            }else{

                                              return Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 1),
                                                child: _OpenContainerWrapper(
                                                  index: 0,
                                                  closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                                    cards[0].callback = openContainer;
                                                    return cards[0];
                                                  },
                                                ),
                                              );
                                            }
                                          }
                                      ) : Container(),
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
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 18

                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                            ),
                                                          ),
                                                        ),
                                                        ///View more
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
                                                                          color: BuytimeTheme.SymbolMalibu,
                                                                          fontWeight: FontWeight.w400,
                                                                          fontSize: 14

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
                                                      child: CustomScrollView(
                                                          physics: new ClampingScrollPhysics(),
                                                          shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                              fontWeight: FontWeight.w700,
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
                                                                        color: BuytimeTheme.SymbolMalibu,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontSize: 14

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
                                                    child: CustomScrollView(
                                                        physics: new ClampingScrollPhysics(),
                                                        shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                      /*Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5,right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                      child: Utils.imageShimmer(SizeConfig.safeBlockVertical * 80, 100))*/
                                      ///Discover & Popular & Recommended & Log out
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          /*StreamBuilder<QuerySnapshot>(
                                          stream: _businessStream,
                                          builder: (context, AsyncSnapshot<QuerySnapshot> businessSnapshot) {
                                            //myList.clear();
                                            List<BusinessState> businessListState = [];
                                            if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                              debugPrint('RUI_U_service_explorer => BUSINESS WAITING');
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
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    CategoryState category = CategoryState().toEmpty();
                                                                    //debugPrint('RUI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
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
                                                      color: Colors.white,
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
                                                  // Flexible(
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                  //     padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                  //     height: 310,
                                                  //     color: BuytimeTheme.BackgroundWhite,
                                                  //     child: Column(
                                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //       children: [
                                                  //         ///Recommended
                                                  //         Container(
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                  //           child: Text(
                                                  //             AppLocalizations.of(context).recommended,
                                                  //             style: TextStyle(
                                                  //               //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                  //                 fontFamily: BuytimeTheme.FontFamily,
                                                  //                 color: BuytimeTheme.TextBlack,
                                                  //                 fontWeight: FontWeight.w700,
                                                  //                 fontSize: 18
                                                  //
                                                  //               ///SizeConfig.safeBlockHorizontal * 4
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         ///Text
                                                  //         Container(
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                  //           child: Text(
                                                  //             AppLocalizations.of(context).recommendedSlogan,
                                                  //             style: TextStyle(
                                                  //               //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                  //                 fontFamily: BuytimeTheme.FontFamily,
                                                  //                 color: BuytimeTheme.TextBlack,
                                                  //                 fontWeight: FontWeight.w500,
                                                  //                 fontSize: 14
                                                  //
                                                  //               ///SizeConfig.safeBlockHorizontal * 4
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         Container(
                                                  //           height: 220,
                                                  //           width: double.infinity,
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                  //           child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                  //             SliverList(
                                                  //               delegate: SliverChildBuilderDelegate(
                                                  //                     (context, index) {
                                                  //                   //MenuItemModel menuItem = menuItems.elementAt(index);
                                                  //                   //ServiceState service = popularList.elementAt(index);
                                                  //                   return Column(
                                                  //                     mainAxisAlignment: MainAxisAlignment.start,
                                                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                     children: [
                                                  //                       Container(
                                                  //                         margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                  //                         child: Utils.imageShimmer(182, 182),
                                                  //                       ),
                                                  //                       Container(
                                                  //                         width: 180,
                                                  //                         alignment: Alignment.topLeft,
                                                  //                         margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                  //                         child: Utils.textShimmer(150, 10),
                                                  //                       )
                                                  //                     ],
                                                  //                   );
                                                  //                 },
                                                  //                 childCount: 10,
                                                  //               ),
                                                  //             ),
                                                  //           ]),
                                                  //         )
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              );
                                            }
                                            businessSnapshot.data.docs.forEach((element) {
                                              BusinessState businessState = BusinessState.fromJson(element.data());
                                              businessListState.add(businessState);
                                            });
                                            debugPrint('RUI_U_service_explorer => BUSINESS LENGTH: ${businessListState.length}');
                                            categoryBloc.requestCategories(context, businessListState);
                                            return Container();
                                          }
                                      ),*/
                                          StreamBuilder<QuerySnapshot>(
                                              stream: _serviceStream,
                                              builder: (context, AsyncSnapshot<QuerySnapshot> serviceSnapshot) {
                                                popularList.clear();
                                                recommendedList.clear();
                                                List<ServiceState> list = [];
                                                //first = false;
                                                if (serviceSnapshot.hasError || serviceSnapshot.connectionState == ConnectionState.waiting || serviceSnapshot.data == null) {
                                                  debugPrint('RUI_U_service_explorer => SERVICE WAITING');
                                                  debugPrint('RUI_U_service_explorer => SERVICE HAS ERROR: ${serviceSnapshot.hasError}');
                                                  debugPrint('RUI_U_service_explorer => SERVICE CONNECTION: ${serviceSnapshot.connectionState}');
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
                                                                child: CustomScrollView(
                                                                    physics: new ClampingScrollPhysics(),
                                                                    shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                  SliverList(
                                                                    delegate: SliverChildBuilderDelegate(
                                                                          (context, index) {
                                                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                        CategoryState category = CategoryState().toEmpty();
                                                                        //debugPrint('RUI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
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
                                                      Provider.of<Explorer>(context, listen: false).businessState != null && Provider.of<Explorer>(context, listen: false).businessState.id_firestore.isNotEmpty ?
                                                      Flexible(
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                          padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                          height: 310,
                                                          color: BuytimeTheme.BackgroundSoftGrey,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ///Hub
                                                              Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                child: Text(
                                                                  AppLocalizations.of(context).hubsTopServices,
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
                                                                  AppLocalizations.of(context).discoverHub,
                                                                  style: TextStyle(
                                                                    //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.TextBlack.withOpacity(.6),
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 14

                                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 220,
                                                                width: double.infinity,
                                                                margin: EdgeInsets.only(left: Platform.isIOS ? SizeConfig.safeBlockHorizontal * 3.5: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                                child: CustomScrollView(
                                                                    physics: new ClampingScrollPhysics(),
                                                                    shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                      ) : Container(),
                                                      ///Popular
                                                      Flexible(
                                                        child: Container(
                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                          padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                          height: 310,
                                                          color: Colors.white,
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
                                                                  AppLocalizations.of(context).popularSlogan,
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
                                                                margin: EdgeInsets.only(left: Platform.isIOS ? SizeConfig.safeBlockHorizontal * 3.5: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                                child: CustomScrollView
                                                                  (physics: new ClampingScrollPhysics(),
                                                                    shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                      /*Flexible(
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
                                                      ),*/
                                                    ],
                                                  );
                                                }
                                                ///Double check with the business List
                                                /*snapshot.businessList.businessListState.forEach((businessState) {
                                              serviceSnapshot.data.forEach((serviceState) {
                                                //ServiceState serviceState = ServiceState.fromJson(element.data());
                                                if(businessState.id_firestore == serviceState.businessId){
                                                  //popularList.add(serviceState);
                                                  //recommendedList.add(serviceState);
                                                  list.add(serviceState);
                                                }
                                              });
                                            });*/
                                                //list = serviceSnapshot.data;
                                                serviceSnapshot.data.docs.forEach((element) {
                                                  ServiceState serviceState = ServiceState.fromJson(element.data());
                                                  list.add(serviceState);
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
                                                  recommendedList.add(Provider.of<Explorer>(context, listen: false).serviceList[i]);
                                                }
                                                popularList = Provider.of<Explorer>(context, listen: false).serviceList;

                                                ///CHANGE
                                                /*snapshot.categoryList.categoryListState.forEach((cLS) {
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
                                                });*/

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
                                                childrens.add(
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
                                                            ///NEW CHANGE
                                                            /*StreamBuilder<List<CategoryState>>(
                                                                  stream: categoryBloc.serviceStream,
                                                                  builder: (context, AsyncSnapshot<List<CategoryState>> orderSnapshot) {
                                                                    //myList.clear();
                                                                    List<CategoryState> categorie = [];
                                                                    if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
                                                                      return Flexible(
                                                                        child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                                      );
                                                                    }
                                                                    debugPrint('NEW CATEGORY LENGTH: ${orderSnapshot.data.length}');
                                                                    categorie = orderSnapshot.data;
                                                                    categorie.forEach((cLS) {
                                                                      //debugPrint('RUI_U_service_explorer => CATEGORY NAME => ${cLS.name} ${cLS.level}');
                                                                      if (cLS.level == 0) {
                                                                        if (cLS.name.contains('Diving')) {
                                                                          //debugPrint('RUI_U_service_explorer =>  CATEGORY NAME => ${cLS.name} ${cLS.id} ${cLS.businessId} ${cLS.level}');
                                                                        }
                                                                        Provider.of<Explorer>(context, listen: false).serviceList.forEach((service) {
                                                                          if ((service.categoryId != null && service.categoryId.contains(cLS.id) || searchCategoryAndServiceOnSnippetList(service.serviceId, cLS.id))) {
                                                                            //debugPrint('RUI_U_service_explorer =>  ${cLS.name} AND LEVEL ${cLS.level}');
                                                                            newCreateCategoryList(cLS);
                                                                          }
                                                                        });
                                                                      }
                                                                    });
                                                                    return Flexible(
                                                                      child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                        SliverList(
                                                                          delegate: SliverChildBuilderDelegate(
                                                                                (context, index) {
                                                                              //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                              CategoryState category = Provider.of<Explorer>(context, listen: false).categoryList.elementAt(index);
                                                                              debugPrint('RUI_U_service_explorer => ${categoryListIds[category.name]}');
                                                                              return categoryListIds[category.name] != null ? Container(
                                                                                width: 100,
                                                                                height: 100,
                                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                                child: DiscoverCardWidget(100, 100, category, true, categoryListIds[category.name], index),
                                                                              ) : Container();
                                                                            },
                                                                            childCount: Provider.of<Explorer>(context, listen: false).categoryList.length,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                    );
                                                                  }
                                                              ),*/
                                                            ///CHANGE
                                                            StreamBuilder<QuerySnapshot>(
                                                                stream: _categoryStream,
                                                                builder: (context, AsyncSnapshot<QuerySnapshot> categorySnaphot) {
                                                                  debugPrint('----------');
                                                                  Provider.of<Explorer>(context, listen: false).rootCategoryList.clear();
                                                                  Provider.of<Explorer>(context, listen: false).allCategoryList.clear();
                                                                  if (categorySnaphot.hasError || categorySnaphot.connectionState == ConnectionState.waiting) {
                                                                    debugPrint('RUI_U_service_explorer => CATEGORY SNAPSHOT ERROR => ${categorySnaphot.hasError}');
                                                                    debugPrint('RUI_U_service_explorer => CATEGORY CONNECTION STATE => ${categorySnaphot.connectionState}');
                                                                    return Flexible(
                                                                      child: CustomScrollView(
                                                physics: new ClampingScrollPhysics(),
                                                shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                                    );
                                                                  }
                                                                  DateTime currentTime = DateTime.now();
                                                                  List<CategoryState> tmpRoots = [];
                                                                  List<CategoryState> tmpNonRoots = [];
                                                                  categorySnaphot.data.docs.forEach((element) {
                                                                    //allUserOrderList.add(element);
                                                                    CategoryState category = CategoryState.fromJson(element.data());
                                                                    //Provider.of<Explorer>(context, listen: false).allCategoryList.add(category);
                                                                    if(category.level == 0){
                                                                      tmpRoots.add(category);
                                                                      //Provider.of<Explorer>(context, listen: false).rootCategoryList.add(category);
                                                                      //debugPrint('RUI_U_service_explorer => CATEGORY IDS => ${category.categoryIdList}');
                                                                    }else{
                                                                      tmpNonRoots.add(category);

                                                                    }
                                                                  });
                                                                  tmpRoots.forEach((category) {
                                                                    debugPrint('CATEGORY NAME: ${category.name} - SERVICE COUNT: ${category.serviceCount} - ACTIVE SERVICE COUNT: ${category.activeServiceCount}');
                                                                    Provider.of<Explorer>(context, listen: false).rootCategoryList.add(category);
                                                                    Provider.of<Explorer>(context, listen: false).allCategoryList.add(category);
                                                                    bool sub = false;
                                                                    bool remove = false;
                                                                    if(category.activeServiceCount == 0){
                                                                      tmpNonRoots.forEach((c){
                                                                        if(c.parent.id == category.id){
                                                                          sub = true;
                                                                          debugPrint('SUB CATEGORY: ${c.name} OF ${category.name} - SERVICE COUNT: ${c.serviceCount} - ACTIVE SERVICE COUNT: ${c.activeServiceCount}');
                                                                          if(c.activeServiceCount == 0){
                                                                            remove = true;
                                                                          }else{
                                                                            Provider.of<Explorer>(context, listen: false).allCategoryList.add(c);
                                                                          }
                                                                        }
                                                                      });
                                                                      if(sub && remove){
                                                                        debugPrint('SUB REMOVE CATEGORY: ${Provider.of<Explorer>(context, listen: false).rootCategoryList.last.name}');
                                                                        Provider.of<Explorer>(context, listen: false).rootCategoryList.removeLast();
                                                                        Provider.of<Explorer>(context, listen: false).allCategoryList.removeLast();
                                                                      }
                                                                      if(!sub){
                                                                        debugPrint('REMOVE CATEGORY: ${Provider.of<Explorer>(context, listen: false).rootCategoryList.last.name}');
                                                                        Provider.of<Explorer>(context, listen: false).rootCategoryList.removeLast();
                                                                        Provider.of<Explorer>(context, listen: false).allCategoryList.removeLast();
                                                                      }
                                                                    }
                                                                  });
                                                                  Provider.of<Explorer>(context, listen: false).allCategoryList.forEach((category) {
                                                                    debugPrint('RUI_U_service_explorer => CATEGORY WITH ACTIVE SERVICES => ${category.name}');
                                                                    debugPrint('RUI_U_service_explorer => CATEGORY ID LIST => ${category.categoryIdList}');
                                                                    Provider.of<Explorer>(context, listen: false).rootCategoryList.forEach((c) {
                                                                      if(category.parent.id == c.id && category.id != c.id){
                                                                        c.categoryIdList.addAll(category.categoryIdList);
                                                                      }
                                                                    });
                                                                  });


                                                                  debugPrint('RUI_U_service_explorer => CATEGORY LENGTH => ${Provider.of<Explorer>(context, listen: false).rootCategoryList.length}');
                                                                  debugPrint('RUI_U_service_explorer => SERVICE LENGTH => ${Provider.of<Explorer>(context, listen: false).serviceList.length}');

                                                                  /*Provider.of<Explorer>(context, listen: false).categoryList.forEach((cLS) {
                                                                      //debugPrint('RUI_U_service_explorer => CATEGORY NAME => ${cLS.name} ${cLS.level}');
                                                                      if (cLS.level == 0) {
                                                                        if (cLS.name.contains('Diving')) {
                                                                          //debugPrint('RUI_U_service_explorer =>  CATEGORY NAME => ${cLS.name} ${cLS.id} ${cLS.businessId} ${cLS.level}');
                                                                        }
                                                                        Provider.of<Explorer>(context, listen: false).serviceList.forEach((service) {
                                                                          if ((service.categoryId != null && service.categoryId.contains(cLS.id) || searchCategoryAndServiceOnSnippetList(service.serviceId, cLS.id))) {
                                                                            debugPrint('RUI_U_service_explorer =>  ${cLS.name} AND LEVEL ${cLS.level}');
                                                                            newCreateCategoryList(cLS);
                                                                          }
                                                                        });
                                                                      }
                                                                    });*/

                                                                  Provider.of<Explorer>(context, listen: false).rootCategoryList.sort((a,b) => (a.name).compareTo((b.name)));
                                                                  debugPrint('----------');
                                                                  return Flexible(
                                                                    child: CustomScrollView(
                                                physics: new ClampingScrollPhysics(),
                                                shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                      SliverList(
                                                                        delegate: SliverChildBuilderDelegate(
                                                                              (context, index) {
                                                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                            CategoryState category = Provider.of<Explorer>(context, listen: false).rootCategoryList.elementAt(index);

                                                                            return Container(
                                                                              width: 100,
                                                                              height: 100,
                                                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                              child: NewDiscoverCardWidget(100, 100, category, true, Provider.of<Explorer>(context, listen: false).allCategoryList, index, orderList),
                                                                            );
                                                                          },
                                                                          childCount: Provider.of<Explorer>(context, listen: false).rootCategoryList.length,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                  );
                                                                }
                                                            )
                                                            ///OLD
                                                            /*categoryList.isNotEmpty ?
                                                            ///List
                                                            Flexible(
                                                              child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                            ) :
                                                            noActivity ?
                                                            Flexible(
                                                              child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                            ) :
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
                                                            ),*/
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                                ///Hub Services
                                                if(Provider.of<Explorer>(context, listen: false).businessState != null && Provider.of<Explorer>(context, listen: false).businessState.id_firestore.isNotEmpty){
                                                  childrens.add(
                                                      StreamBuilder<QuerySnapshot>(
                                                          stream: FirebaseFirestore.instance.collection("service")
                                                              .where("visibility", isEqualTo: 'Active')
                                                              .where("businessId", isEqualTo: Provider.of<Explorer>(context, listen: false).businessState.id_firestore)
                                                              //.where('categoryId', arrayContainsAny: category.categoryIdList.length > 10 ? category.categoryIdList.sublist(0, 10) : category.categoryIdList)
                                                              .limit(5)
                                                              .snapshots(includeMetadataChanges: true),
                                                          builder: (context, AsyncSnapshot<QuerySnapshot> categorySnapshot) {
                                                            if (categorySnapshot.hasError || categorySnapshot.connectionState == ConnectionState.waiting) {
                                                              debugPrint('RUI_U_service_explorer => SERVICE CATEGORY WAITING');
                                                              return Flexible(
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                                  height: 310,
                                                                  color: BuytimeTheme.BackgroundSoftGrey,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      ///Hub top services
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                        child: Text(
                                                                          AppLocalizations.of(context).hubsTopServices,
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
                                                                          '${AppLocalizations.of(context).discoverHub}',
                                                                          style: TextStyle(
                                                                            //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                              fontFamily: BuytimeTheme.FontFamily,
                                                                              color: BuytimeTheme.TextBlack.withOpacity(.6),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14

                                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 220,
                                                                        width: double.infinity,
                                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                                        child: CustomScrollView(
                                                physics: new ClampingScrollPhysics(),
                                                shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                              );
                                                            }
                                                            List<ServiceState> tmpHubServices = [];
                                                            categorySnapshot.data.docs.forEach((service) {
                                                              ServiceState serviceState = ServiceState.fromJson(service.data());
                                                              tmpHubServices.add(serviceState);
                                                            });
                                                            debugPrint('RUI_U_service_explorer => HUB SERVICE LENGTH: ${tmpHubServices.length}');
                                                            return tmpHubServices.length >= 4 ?
                                                            Flexible(
                                                              child: Container(
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                                height: tmpHubServices.isNotEmpty || noActivity ? 320 : 200,
                                                                color: BuytimeTheme.BackgroundSoftGrey,
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        ///Hub name
                                                                        Flexible(
                                                                          flex: 3,
                                                                          child: Container(
                                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                            child: Text(
                                                                              AppLocalizations.of(context).hubsTopServices,
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
                                                                        ),
                                                                        ///View more
                                                                        Flexible(
                                                                          flex: 1,
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(top: 20),
                                                                              alignment: Alignment.center,
                                                                              child: Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMore(AppLocalizations.of(context).hubsTopServices, orderList, false, [], true)),);
                                                                                    },
                                                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                    child: Container(
                                                                                      padding: EdgeInsets.all(5.0),
                                                                                      child: Text(
                                                                                        AppLocalizations.of(context).viewMore,
                                                                                        // !showAll ? AppLocalizations.of(context).showAll : AppLocalizations.of(context).showLess,
                                                                                        style: TextStyle(
                                                                                            letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                                            fontFamily: BuytimeTheme.FontFamily,
                                                                                            color: BuytimeTheme.SymbolMalibu,
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontSize: 14

                                                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                                                        ),
                                                                                      ),
                                                                                    )),
                                                                              )),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    ///Text
                                                                    Container(
                                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                                      child: Text(
                                                                        '${AppLocalizations.of(context).discoverHub}',
                                                                        style: TextStyle(
                                                                            fontFamily: BuytimeTheme.FontFamily,
                                                                            color: BuytimeTheme.TextBlack.withOpacity(.6),
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14

                                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    tmpHubServices.isNotEmpty ?
                                                                    ///List
                                                                    Container(
                                                                      height: 240,
                                                                      width: double.infinity,
                                                                      margin: EdgeInsets.only(left: Platform.isIOS ? SizeConfig.safeBlockHorizontal * 3.5: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                                      child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                        SliverList(
                                                                          delegate: SliverChildBuilderDelegate(
                                                                                (context, index) {
                                                                              ServiceState service = tmpHubServices.elementAt(index);
                                                                              return Container(
                                                                                child: NewPRCardWidget(182, 182, service, false, true, index, AppLocalizations.of(context).hubsTopServices),
                                                                              );
                                                                            },
                                                                            childCount: tmpHubServices.length,
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                    )
                                                                        : noActivity ?
                                                                    Container(
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
                                                                    ) :
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
                                                            ) : Container();
                                                          }
                                                      )
                                                  );
                                                }
                                                ///Popular
                                                childrens.add(Flexible(
                                                  child: Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0,),
                                                    //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                                    height: popularList.isNotEmpty || noActivity ? 320 : 200,
                                                    color: Colors.white,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            ///Popular
                                                            Flexible(
                                                              flex: 3,
                                                              child: Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                child: Text(
                                                                  AppLocalizations.of(context).popular,
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
                                                            ),
                                                            ///View more
                                                            Flexible(
                                                              flex: 1,
                                                              child: Container(
                                                                  margin: EdgeInsets.only(top: 20),
                                                                  alignment: Alignment.center,
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    child: InkWell(
                                                                        onTap: () {
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMore(AppLocalizations.of(context).popular, orderList, true, [], false)),);
                                                                        },
                                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                        child: Container(
                                                                          padding: EdgeInsets.all(5.0),
                                                                          child: Text(
                                                                            AppLocalizations.of(context).viewMore,
                                                                            // !showAll ? AppLocalizations.of(context).showAll : AppLocalizations.of(context).showLess,
                                                                            style: TextStyle(
                                                                                letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                                color: BuytimeTheme.SymbolMalibu,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontSize: 14

                                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                                            ),
                                                                          ),
                                                                        )),
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                        ///Text
                                                        Container(
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                          child: Text(
                                                            AppLocalizations.of(context).popularSlogan,
                                                            style: TextStyle(
                                                              //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: BuytimeTheme.TextBlack.withOpacity(.6),
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
                                                            margin: EdgeInsets.only(left: Platform.isIOS ? SizeConfig.safeBlockHorizontal * 3.5: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                            child: Stack(
                                                              children: [
                                                                ///Paged service list
                                                                Positioned.fill(
                                                                  child: Align(
                                                                    alignment: Alignment.center,
                                                                    child: CustomScrollView(
                                                physics: new ClampingScrollPhysics(),
                                                                      //controller: popularServiceScroller,
                                                                        shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                      SliverList(
                                                                        delegate: SliverChildBuilderDelegate(
                                                                              (context, index) {
                                                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                            ServiceState service = popularList.elementAt(index);
                                                                            return Container(
                                                                              //width: 160,
                                                                              //margin: EdgeInsets.only(right: 5),
                                                                              child: NewPRCardWidget(182, 182, service, false, true, index, 'popular'),
                                                                            );
                                                                          },
                                                                          childCount: popularList.length,
                                                                        ),
                                                                      ),
                                                                    ]),
                                                                  ),
                                                                ),
                                                                ///Page loading indicator
                                                                Positioned.fill(
                                                                  bottom: 35,
                                                                  right: 10,
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: StreamBuilder<bool>(
                                                                        stream: servicePagingBloc.getShowIndicatorStream,
                                                                        builder: (context, AsyncSnapshot<bool> businessSnapshot) {
                                                                          //myList.clear();
                                                                          List<BusinessState> businessListState = [];
                                                                          if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                                                            debugPrint('RUI_U_service_explorer => SERVICE LOADER WAITING');
                                                                            return Container();
                                                                          }
                                                                          return businessSnapshot.data ? Container(
                                                                            height: 30,
                                                                            width: 30,
                                                                            padding: EdgeInsets.all(5),
                                                                            decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                                border: Border.all(color: Colors.black, width: .5)
                                                                            ),
                                                                            child: CircularProgressIndicator(
                                                                              strokeWidth: 2.5,
                                                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                                                            ),
                                                                          ) : Container();
                                                                        }
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                        ):
                                                        noActivity ?
                                                        Container(
                                                          height: 220,
                                                          width: double.infinity,
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                          child: CustomScrollView(physics: new ClampingScrollPhysics(),
                                                shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
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
                                                        ) :
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
                                                /*childrens.add(
                                                Flexible(
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
                                            ));*/
                                                int i = 0;

                                                List<CategoryState> tmpCategoryList = [];
                                                Provider.of<Explorer>(context, listen: false).rootCategoryList.forEach((category) async {
                                                  int total = category.activeServiceCount;
                                                  Provider.of<Explorer>(context, listen: false).allCategoryList.forEach((element) {
                                                    if(element.parent.id == category.id && category.id != element.id){
                                                      total += element.activeServiceCount;
                                                    }
                                                  });
                                                  bool enoughServices = false;
                                                  if(total >= 4){
                                                    enoughServices = true;
                                                  }

                                                  if(enoughServices){
                                                    debugPrint('RUI_U_service_explorer => CATEGORY IDS: ${category.categoryIdList}');
                                                    debugPrint('RUI_U_service_explorer => CATEGORY SERVICE COUNT: ${category.serviceCount}');

                                                    Stream<QuerySnapshot> thisCategory;
                                                    if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
                                                      thisCategory = FirebaseFirestore.instance.collection("service")
                                                         // .where("tag", arrayContainsAny: [StoreProvider.of<AppState>(context).state.area.areaId])
                                                          .where("visibility", isEqualTo: 'Active')
                                                          .where('categoryId', arrayContainsAny: category.categoryIdList.length > 10 ? category.categoryIdList.sublist(0, 10) : category.categoryIdList)
                                                          .limit(4)
                                                          .snapshots(includeMetadataChanges: true);
                                                    }else{
                                                      thisCategory = FirebaseFirestore.instance.collection("service")
                                                          .where("visibility", isEqualTo: 'Active')
                                                          .where('categoryId', arrayContainsAny: category.categoryIdList.length > 10 ? category.categoryIdList.sublist(0, 10) : category.categoryIdList)
                                                          .limit(4)
                                                          .snapshots(includeMetadataChanges: true);
                                                    }

                                                    childrens.add(
                                                        StreamBuilder<QuerySnapshot>(
                                                            stream: thisCategory,
                                                            builder: (context, AsyncSnapshot<QuerySnapshot> categorySnapshot) {
                                                              if (categorySnapshot.hasError || categorySnapshot.connectionState == ConnectionState.waiting) {
                                                                debugPrint('RUI_U_service_explorer => SERVICE CATEGORY WAITING');
                                                                return Flexible(
                                                                  child: Container(
                                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                                    height: 310,
                                                                    color: Colors.white,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        ///Category
                                                                        Container(
                                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                          child: Text(
                                                                            category.name,
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
                                                                            '${AppLocalizations.of(context).discoverStart} ${category.name} ${AppLocalizations.of(context).discoverEnd}',
                                                                            style: TextStyle(
                                                                              //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                                color: BuytimeTheme.TextBlack.withOpacity(.6),
                                                                                fontWeight: FontWeight.w500,
                                                                                fontSize: 14

                                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          height: 220,
                                                                          width: double.infinity,
                                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
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
                                                                );
                                                              }
                                                              List<ServiceState> tmpCategoryServices = [];
                                                              categorySnapshot.data.docs.forEach((service) {
                                                                ServiceState serviceState = ServiceState.fromJson(service.data());
                                                                tmpCategoryServices.add(serviceState);
                                                              });
                                                              debugPrint('RUI_U_service_explorer => SERVICE LENGTH: ${tmpCategoryServices.length} FOR ${category.name}');
                                                              return tmpCategoryServices.length >= 4 ?
                                                              Flexible(
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                                  height: tmpCategoryServices.isNotEmpty || noActivity ? 320 : 200,
                                                                  color: BuytimeTheme.BackgroundWhite,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          ///Category name
                                                                          Flexible(
                                                                            flex: 3,
                                                                            child: Container(
                                                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                                              child: Text(
                                                                                category.name,
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
                                                                          ),
                                                                          ///View more
                                                                          Flexible(
                                                                            flex: 1,
                                                                            child: Container(
                                                                                margin: EdgeInsets.only(top: 20),
                                                                                alignment: Alignment.center,
                                                                                child: Material(
                                                                                  color: Colors.transparent,
                                                                                  child: InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewMore(category.name, orderList, false, category.categoryIdList, false)),);
                                                                                      },
                                                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          AppLocalizations.of(context).viewMore,
                                                                                          // !showAll ? AppLocalizations.of(context).showAll : AppLocalizations.of(context).showLess,
                                                                                          style: TextStyle(
                                                                                              letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                                              fontFamily: BuytimeTheme.FontFamily,
                                                                                              color: BuytimeTheme.SymbolMalibu,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              fontSize: 14

                                                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                )),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      ///Text
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                                        child: Text(
                                                                          '${AppLocalizations.of(context).discoverStart} ${category.name} ${AppLocalizations.of(context).discoverEnd}',
                                                                          style: TextStyle(
                                                                              fontFamily: BuytimeTheme.FontFamily,
                                                                              color: BuytimeTheme.TextBlack.withOpacity(.6),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 14

                                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      tmpCategoryServices.isNotEmpty ?
                                                                      ///List
                                                                      Container(
                                                                        height: 240,
                                                                        width: double.infinity,
                                                                        margin: EdgeInsets.only(left: Platform.isIOS ? SizeConfig.safeBlockHorizontal * 3.5: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                                        child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                          SliverList(
                                                                            delegate: SliverChildBuilderDelegate(
                                                                                  (context, index) {
                                                                                ServiceState service = tmpCategoryServices.elementAt(index);
                                                                                return Container(
                                                                                  child: NewPRCardWidget(182, 182, service, false, true, index, category.name),
                                                                                );
                                                                              },
                                                                              childCount: tmpCategoryServices.length,
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                      )
                                                                          : noActivity ?
                                                                      Container(
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
                                                                      ) :
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
                                                              ) : Container();
                                                            }
                                                        )
                                                    );
                                                  }
                                                });
                                                ///Go to business management IF manager role or above.
                                                if(isManagerOrAbove)
                                                  childrens.add(
                                                      Container(
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
                                                    FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty /*&& cards.isNotEmpty*/?
                                                    Container(
                                                      color: Colors.white,
                                                      height: 64,
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: InkWell(
                                                            key: Key('log_out_key'),
                                                            onTap: () async {
                                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                                              await FirebaseMessaging.instance.unsubscribeFromTopic('broadcast_user');
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
                                                    ) : Container()
                                                );

                                                return Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: childrens,
                                                );
                                              }
                                          ),

                                        ],
                                      ),
                                    ],
                                  ) :
                                  _searchController.text.isNotEmpty ?
                                  Flexible(
                                    child: Container(
                                        height: SizeConfig.safeBlockVertical * 99,
                                        margin: EdgeInsets.only(
                                          top: SizeConfig.safeBlockVertical * 0,
                                          left: SizeConfig.safeBlockHorizontal * 0,
                                          //bottom: 5
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ///Sort
                                            Container(
                                              //width: SizeConfig.safeBlockHorizontal * 20,
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    //width: SizeConfig.safeBlockHorizontal * 20,
                                                    margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                    child: DropdownButton(
                                                      underline: Container(),
                                                      hint: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.sort,
                                                            color: BuytimeTheme.TextMedium,
                                                            size: 24,
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 10.0),
                                                              child: Text(
                                                                AppLocalizations.of(context).sortBy,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontSize: 14,

                                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                                  color: BuytimeTheme.TextMedium,
                                                                  fontWeight: FontWeight.w400,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 4),
                                                              child: Text(
                                                                sortBy,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontSize: 14,

                                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                                  color: BuytimeTheme.TextBlack,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      isExpanded: false,
                                                      iconSize: 0,
                                                      style: TextStyle(color: Colors.blue),
                                                      items: ['A-Z', 'Z-A'].map(
                                                            (val) {
                                                          return DropdownMenuItem<String>(
                                                            value: val,
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Container(
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.only(left: 10.0),
                                                                    child: Text(
                                                                      val,
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: BuytimeTheme.TextMedium,
                                                                        fontWeight: FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                sortBy == val
                                                                    ? Icon(
                                                                  MaterialDesignIcons.done,
                                                                  color: BuytimeTheme.TextMedium,
                                                                  size: SizeConfig.safeBlockHorizontal * 5,
                                                                )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                      onChanged: (val) {
                                                        setState(
                                                              () {
                                                            //_dropDownValue = val;
                                                            sortBy = val;
                                                            if(Provider.of<Explorer>(context, listen: false).searchedList.isNotEmpty){
                                                              if (sortBy == 'A-Z') {
                                                                Provider.of<Explorer>(context, listen: false).searchedList.first.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
                                                                Provider.of<Explorer>(context, listen: false).searchedList.last.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
                                                              } else if (sortBy == 'Z-A'){
                                                                Provider.of<Explorer>(context, listen: false).searchedList.first.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
                                                                Provider.of<Explorer>(context, listen: false).searchedList.last.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
                                                              }
                                                            }
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 5
                                                ),
                                                child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.vertical, slivers: [
                                                  SliverList(
                                                    delegate: SliverChildBuilderDelegate(
                                                          (context, index) {
                                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                                        if(Provider.of<Explorer>(context, listen: false).searchedList.length > 1 ||
                                                            (Provider.of<Explorer>(context, listen: false).searchedList.length == 1 && Provider.of<Explorer>(context, listen: false).searchedList.first.isNotEmpty)){
                                                          if (index == 0) {
                                                            return Container(
                                                              height: Provider.of<Explorer>(context, listen: false).searchedList.elementAt(index).isEmpty ? 0 : 80,
                                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4.5, bottom: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * 1),
                                                              child: CustomScrollView(physics: new ClampingScrollPhysics(),shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                                SliverList(
                                                                  delegate: SliverChildBuilderDelegate(
                                                                        (context, i) {
                                                                      //MenuItemModel menuItem = menuItems.elementAt(index);

                                                                      CategoryState category = Provider.of<Explorer>(context, listen: false).searchedList.elementAt(index).elementAt(i);
                                                                      return Container(
                                                                        width: 80,
                                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: SizeConfig.safeBlockHorizontal * 1),
                                                                        child: DiscoverCardWidget(80, 80, category, true, categoryListIds[category.name], index),
                                                                      );
                                                                    },
                                                                    childCount: Provider.of<Explorer>(context, listen: false).searchedList.elementAt(index).length,
                                                                  ),
                                                                ),
                                                              ]),
                                                            );
                                                          }
                                                          else {
                                                            List<ServiceState> serviceList = Provider.of<Explorer>(context, listen: false).searchedList.elementAt(index);
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
                                                        }else{
                                                          return Container(
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
                                                          );
                                                        }

                                                      },
                                                      childCount: Provider.of<Explorer>(context, listen: false).searchedList.length,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ) :
                                  Container()

                                  //Test(),

                                  /*_searchController.text.isEmpty
                                      ?  :
                                  ///Searched list
                                  Provider.of<Explorer>(context, listen: false).searchedList.isNotEmpty
                                      ?
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
                                  ),*/
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
  bool first;
  List<ServiceState> serviceList;
  List<CategoryState> rootCategoryList;
  List<CategoryState> allCategoryList;
  List<dynamic> searchedList;
  TextEditingController searchController;
  BusinessState businessState;
  List<ServiceState> cartServiceList;
  List<ServiceState> cartReservableServiceList;
  String promotionCode;
  Explorer(this.searching, this.serviceList, this.rootCategoryList, this.searchedList, this.searchController, this.first, this.allCategoryList, this.businessState, this.cartServiceList, this.promotionCode, this.cartReservableServiceList);

  initSearching(bool searching){
    this.searching = searching;
    debugPrint('RUI_U_service_explorer => SEARCHING INIT');
    notifyListeners();
  }
  initFirst(bool first){
    this.first = first;
    debugPrint('RUI_U_service_explorer => FIRST INIT');
    notifyListeners();
  }
  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('RUI_U_service_explorer => SERVICE LIST INIT');
    notifyListeners();
  }
  initRootCategoryList(List<CategoryState> categoryList){
    this.rootCategoryList = categoryList;
    debugPrint('RUI_U_service_explorer => ROOT CATEGORY LIST INIT');
    notifyListeners();
  }
  initAllCategoryList(List<CategoryState> categoryList){
    this.allCategoryList = categoryList;
    debugPrint('RUI_U_service_explorer => ALL CATEGORY LIST INIT');
    notifyListeners();
  }
  initSearchController(TextEditingController searchController){
    this.searchController = searchController;
    debugPrint('RUI_U_service_explorer => SEARCH CONTROLLER INIT');
    notifyListeners();
  }
  initSearchedList(List<dynamic> searchedList){
    this.searchedList = searchedList;
    debugPrint('RUI_U_service_explorer => SEARCHED LIST INIT');
    notifyListeners();
  }

  clear(){
    this.searching = false;
    this.first = false;
    this.serviceList.clear();
    this.rootCategoryList.clear();
    this.allCategoryList.clear();
    this.searchedList.clear();
    this.searchController = TextEditingController();
    this.businessState = BusinessState().toEmpty();
    this.cartServiceList = [];
    this.cartReservableServiceList = [];
    this.promotionCode = '';
    notifyListeners();
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

