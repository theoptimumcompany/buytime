import 'dart:async';
import 'dart:core';
import 'dart:math';
import 'package:Buytime/UI/management/activity/RUI_M_activity_management.dart';
import 'package:Buytime/UI/management/activity/UI_M_activity_management.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/user/booking/UI_U_booking_self_creation.dart';
import 'package:Buytime/UI/user/booking/UI_U_my_bookings.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/UI/user/turist/UI_U_service_explorer.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/landing_card_widget.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../../environment_abstract.dart';

class Landing extends StatefulWidget {
  static String route = '/landing';

  @override
  State<StatefulWidget> createState() => LandingState();
}

bool switchToClient = false;
class LandingState extends State<Landing> {
  List<LandingCardWidget> cards = new List();

  bool onBookingCode = false;
  bool rippleLoading = false;
  bool secondRippleLoading = false;
  bool requestingBookings = false;

  List<BookingState> bookingList = [];
  String selfBookingCode = '';
  String bookingCode = '';
  String categoryCode = '';

  ///Storage
  final storage = new FlutterSecureStorage();

  bookingCodeFound() async {
    bookingCode = await storage.read(key: 'bookingCode') ?? '';
    debugPrint('UI_U_landing: DEEP LINK EMPTY | BOOKING CODE: $bookingCode');
    await storage.delete(key: 'bookingCode');

    if (bookingCode.isNotEmpty)
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InviteGuestForm(
                id: bookingCode,
                fromLanding: true,
              )));
  }

  selfCheckInFound() async {
    selfBookingCode = await storage.read(key: 'selfBookingCode') ?? '';
    debugPrint('UI_U_landing: DEEP LINK EMPTY | selfBookingCode : $selfBookingCode');
    await storage.delete(key: 'selfBookingCode');


    if (bookingCode.isNotEmpty) {
      StoreProvider.of<AppState>(context).dispatch(BusinessRequest(selfBookingCode));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookingSelfCreation()));
    }
  }

  categoryInviteFound() async {
    categoryCode = await storage.read(key: 'categoryInvite') ?? '';
    debugPrint('UI_U_landing: DEEP LINK EMPTY | CATEGORY INVITE: $categoryCode');
    // await storage.delete(key: 'categoryInvite');
    if (categoryCode.isNotEmpty) {
      StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email, false));
      Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
    }
  }
  ///List
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('UI_U_Landing => initState()');
    });
    initDynamicLinks();
  }

  void initDynamicLinks() async {
    print("Dentro initial dynamic");
    Uri deepLink;

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      deepLink = null;
      deepLink = dynamicLink?.link;
      debugPrint('UI_U_landing: DEEPLINK onLink: $deepLink');
      if (deepLink != null) {
        String bookingCodeRead = await storage.containsKey(key: 'bookingCodeRead') ? await storage.read(key: 'bookingCodeRead') ?? '' : '';
        String categoryInviteRead = await storage.containsKey(key: 'categoryInviteRead') ? await storage.read(key: 'categoryInviteRead') ?? '' : '';
        String orderIdRead = await storage.containsKey(key: 'orderIdRead') ? await storage.read(key: 'orderIdRead') ?? '' : '';
        debugPrint('UI_U_landing: after reading secure storage');

        if (deepLink.queryParameters.containsKey('booking') && bookingCodeRead != 'true') {
          String id = deepLink.queryParameters['booking'];
          debugPrint('UI_U_landing: booking onLink: $id');
          await storage.write(key: 'bookingCode', value: id);
          await storage.write(key: 'bookingCodeRead', value: 'true');
          setState(() {
            onBookingCode = true;
          });
          //StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(BookingState(booking_code: id)));
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: false,)), (Route<dynamic> route) => false);
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InviteGuestForm(
                      id: id,
                      fromLanding: true,
                    )));
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
        } else if (deepLink.queryParameters.containsKey('categoryInvite') && categoryInviteRead != 'true') {
          String categoryInvite = deepLink.queryParameters['categoryInvite'];
          debugPrint('UI_U_landing: categoryInvite: $categoryInvite');
          await storage.write(key: 'categoryInvite', value: categoryInvite);
          await storage.write(key: 'categoryInviteRead', value: 'true');

          //StoreProvider.of<AppState>(context).dispatch(BusinessRequestAndNavigate(businessId));
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email, false));
            Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
        } else if (deepLink.queryParameters.containsKey('orderId') && orderIdRead != 'true') {
          String orderId = deepLink.queryParameters['orderId'];
          debugPrint('UI_U_landing: orderId from dynamic link: $orderId');
          await storage.write(key: 'orderId', value: orderId);
          await storage.write(key: 'orderIdRead', value: 'true');
          //StoreProvider.of<AppState>(context).dispatch(BusinessRequestAndNavigate(businessId));
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigatePopOrderId(orderId));
            Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
        } else if (deepLink.queryParameters.containsKey('selfBookingCode') && deepLink.queryParameters['selfBookingCode'].length > 5) {
          String selfBookingCode = deepLink.queryParameters['selfBookingCode'];
          debugPrint('UI_U_landing: selfBookingCode from dynamic link: $selfBookingCode');
          await storage.write(key: 'selfBookingCode', value: selfBookingCode);

          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            StoreProvider.of<AppState>(context).dispatch(BusinessRequest(selfBookingCode));
            await storage.write(key: 'selfBookingCode', value: '');
            await Future.delayed(Duration(milliseconds: 1000));
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingSelfCreation()));
          } else {
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
          }
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    await Future.delayed(Duration(seconds: 2)); // TODO: vi spezzo le gambine. AHAHAHAH Riccaa attentoooo.

    ///Serve un delay che altrimenti getInitialLink torna NULL
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    deepLink = null;
    deepLink = data?.link;
    debugPrint('UI_U_landing: DEEPLINK getInitialLink: $deepLink');
    if (deepLink != null) {
      String bookingCodeRead = await storage.read(key: 'bookingCodeRead') ?? '';
      String categoryInviteRead = await storage.read(key: 'categoryInviteRead') ?? '';
      String orderIdRead = await storage.read(key: 'orderIdRead') ?? '';

      if (deepLink.queryParameters.containsKey('booking') && bookingCodeRead != 'true') {
        String id = deepLink.queryParameters['booking'];
        debugPrint('UI_U_landing: booking getInitialLink: $id');
        await storage.write(key: 'bookingCode', value: id);
        await storage.write(key: 'bookingCodeRead', value: 'true');
        setState(() {
          onBookingCode = true;
        });
        if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
          debugPrint('UI_U_landing: USER IS LOGGED in getInitialLink');
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: false)), ModalRoute.withName('/landing'));
        } else
          debugPrint('UI_U_landing: USER NOT LOGGED in getInitialLink');
      } else if (deepLink.queryParameters.containsKey('selfBookingCode') && deepLink.queryParameters['selfBookingCode'].length > 5) {
        String id = deepLink.queryParameters['selfBookingCode'];
        debugPrint('UI_U_landing: selfBookingCode getInitialLink: $id');
        await storage.write(key: 'selfBookingCode', value: id);

        if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
          debugPrint('UI_U_landing: USER IS LOGGED in getInitialLink');
          StoreProvider.of<AppState>(context).dispatch(BusinessRequest(id));
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => BookingSelfCreation()), ModalRoute.withName('/bookingSelfCreation'));
        } else
          debugPrint('UI_U_landing: USER NOT LOGGED in getInitialLink');
      } else if (deepLink.queryParameters.containsKey('categoryInvite') && categoryInviteRead != 'true') {
        String categoryInvite = deepLink.queryParameters['categoryInvite'];
        debugPrint('UI_U_landing: categoryInvite: $categoryInvite');
        await storage.write(key: 'categoryInvite', value: categoryInvite);
        await storage.write(key: 'categoryInviteRead', value: 'true');
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: false)), (Route<dynamic> route) => false);
        if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
          debugPrint('UI_U_landing: USER Is LOGGED in onLink');
          StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email, false));
          Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
        } else if (deepLink.queryParameters.containsKey('orderId') && orderIdRead != 'true') {
          String orderId = deepLink.queryParameters['orderId'];
          debugPrint('UI_U_landing: orderId from dynamic link: $orderId');
          await storage.write(key: 'orderId', value: orderId);
          await storage.write(key: 'orderIdRead', value: 'true');
          //StoreProvider.of<AppState>(context).dispatch(BusinessRequestAndNavigate(businessId));
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigatePopOrderId(orderId));
            Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
        } else
          debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    var isManagerOrAbove = false;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        distinct: true,
        onInit: (store) {
          /// Used for android to get the code
          bookingCodeFound();
          selfCheckInFound();
          categoryInviteFound();
          //debugPrint('UI_U_Landing => Booking code: ${store.state.booking.booking_code}');
          debugPrint('UI_U_Landing => onInit()');
          debugPrint('UI_U_Landing => store on init()');
          cards.add(LandingCardWidget(/*AppLocalizations.of(context).enterBookingCode*/ '', AppLocalizations.of(context).startYourJourney, 'assets/img/booking_code.png', null));
          cards.add(LandingCardWidget(/*AppLocalizations.of(context).aboutBuytime*/ '', AppLocalizations.of(context).discoverOurNetwork, 'assets/img/beach_girl.png', null));
        },
        builder: (context, snapshot) {
          bookingList.clear();
          bookingList.addAll(snapshot.bookingList.bookingListState);
          isManagerOrAbove = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;

          if (isManagerOrAbove && !switchToClient && !requestingBookings) {
            snapshot.bookingList.bookingListState.clear();
            requestingBookings = true;
            debugPrint('UI_U_Landing => USER EMAIL: ${snapshot.user.email}');
            //categoryInviteFound();
            StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(snapshot.user.email, false));

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (bookingCode.isEmpty) Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
            });
          } else {
            if (bookingList.isEmpty && snapshot.user.email.isNotEmpty && !onBookingCode && !requestingBookings && !isManagerOrAbove) {
              rippleLoading = true;
              requestingBookings = true;
              debugPrint('UI_U_Landing => USER EMAIL: ${snapshot.user.email}');
              StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(snapshot.user.email, false));
              //rippleLoading = false;
            }

            if (bookingList.isNotEmpty && !onBookingCode && rippleLoading && !isManagerOrAbove) {
              rippleLoading = false;
              debugPrint('UI_U_Landing => FIRST BUSINESS ID: ${bookingList.first.business_id}');
              if (bookingList.first.business_id == null) {
                snapshot.bookingList.bookingListState.removeLast();
                bookingList.removeLast();
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceExplorer()));
                });
              } else {
                DateTime currentTime = DateTime.now();
                currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
                DateTime endTime = DateTime.now();
                //DateTime startTime = DateTime.now();
                endTime = new DateTime(bookingList.first.end_date.year, bookingList.first.end_date.month, bookingList.first.end_date.day, 0, 0, 0, 0, 0);
                if (endTime.isBefore(currentTime)) {
                  //bookingStatus = 'Closed';
                  debugPrint('UI_U_Landing => No active booking found!');
                  //rippleLoading = false;
                } else if (bookingList.first.start_date.isAtSameMomentAs(currentTime)) {
                  //bookingStatus = 'Active';
                  debugPrint('UI_U_Landing => Active booking found!');
                  //StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(bookingList.first));
                  //StoreProvider.of<AppState>(context).dispatch(BusinessAndNavigateRequest(bookingList.first.business_id));
                } else if (bookingList.first.start_date.isAfter(currentTime)) {
                  //bookingStatus = 'Upcoming';
                  debugPrint('UI_U_Landing => Upcoming booking found!');
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    if (bookingCode.isEmpty)
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBookings(
                                    fromLanding: true,
                                  )));
                  });
                } else {
                  //bookingStatus = 'Active';
                  secondRippleLoading = true;
                  debugPrint('UI_U_Landing => Active booking found!');
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage()));
                  if (bookingCode.isEmpty) {
                    StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(bookingList.first));
                    StoreProvider.of<AppState>(context).dispatch(BusinessServiceListAndNavigateRequest(bookingList.first.business_id));
                  } else
                    secondRippleLoading = false;
                }
              }
            }
          }

          //debugPrint('UI_U_Landing => BOOKINGS: ${bookingList.length}');

          return Stack(children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: WillPopScope(
                    onWillPop: () async {
                      FocusScope.of(context).unfocus();
                      return false;
                    },
                    child: Scaffold(
                      body: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: (SizeConfig.safeBlockVertical * 100)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Celurian Part
                                Flexible(
                                    //flex: 10,
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Welcome text & Share icon & Description
                                    Container(
                                      // margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                      width: double.infinity,
                                      //height: SizeConfig.safeBlockVertical * 40,
                                      color: BuytimeTheme.BackgroundCerulean,
                                      child: Column(
                                        //mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ///Welcome text & Share icon
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///Welcome text
                                              Flexible(
                                                flex: 2,
                                                child: Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 6, left: SizeConfig.safeBlockHorizontal * 8),
                                                    /*width: double.infinity,
                                        height: double.infinity,*/
                                                    child: Text(
                                                      AppLocalizations.of(context).welcomeToBuytime,
                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Colors.white, fontWeight: FontWeight.w700, fontSize: 32 //SizeConfig.safeBlockHorizontal * 7.5
                                                          ),
                                                    )),
                                              ),

                                              ///Share icon
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.topRight,
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 6, right: SizeConfig.safeBlockHorizontal * 4),
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      Share.share(
                                                        '${AppLocalizations.of(context).checkOutBuytimeApp} ${Environment().config.dynamicLink}/shareBuytime',
                                                        subject: '${AppLocalizations.of(context).takeYourTime}',
                                                      );

                                                      //LogConsole.init();
                                                      /*final RenderBox box = context.findRenderObject();
                                          Uri link = await createDynamicLink('prova');
                                          Share.share(AppLocalizations.of(context).checkYourBuytimeApp + link.toString(), subject: AppLocalizations.of(context).takeYourTime, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                          Share.share('Share', subject:
                                          Platform.isAndroid ?
                                              'https://play.google.com/store/apps/details?id=com.theoptimumcompany.buytime' :
                                          'Test'
                                              , sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/

                                                      /*EmailState emailState = EmailState();
                                                          TemplateState templateState = TemplateState();
                                                          TemplateDataState templateDataState = TemplateDataState();
                                                          emailState.to = 'rukshannipuna12@gmail.com';
                                                          emailState.cc = 'f.romeo.f@gmail.com';
                                                          templateState.name = 'search';
                                                          //templateDataState.name = 'Nipuna Perera';
                                                          //templateDataState.link = 'https://buytime.network/';
                                                          templateDataState.userEmail = 'test_owner@buytime.network';
                                                          templateDataState.businessName = 'Test Business';
                                                          templateDataState.businessId = '22pBIWUaCnIKc5jZVDaM';
                                                          templateDataState.searched = 'chilly';
                                                          templateState.data = templateDataState;
                                                          emailState.template = templateState;
                                                          StoreProvider.of<AppState>(context).dispatch(SendEmail(emailState));*/
                                                    },
                                                    icon: Icon(
                                                      Icons.share,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),

                                          ///Description
                                          Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 16),
                                              child: Text(
                                                AppLocalizations.of(context).whenYouBookWith,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18 //SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                              ))
                                        ],
                                      ),
                                    ),

                                    ///Card list
                                    Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4, top: SizeConfig.safeBlockVertical * 4),
                                        alignment: Alignment.centerLeft,
                                        height: 190,
                                        child: CustomScrollView(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          slivers: [
                                            SliverList(
                                              delegate: SliverChildBuilderDelegate(
                                                (context, index) {
                                                  LandingCardWidget landingCard = cards.elementAt(index);
                                                  return Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: _OpenContainerWrapper(
                                                      index: index,
                                                      closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                                        landingCard.callback = openContainer;
                                                        return landingCard;
                                                      },
                                                    ),
                                                  );
                                                },
                                                childCount: cards.length,
                                              ),
                                            ),
                                          ],
                                        )),

                                    ///Booking history
                                    //!isManagerOrAbove ?
                                    /*Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 6.5, bottom: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * 1),
                                            alignment: Alignment.centerLeft,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookings()),);
                                                    //StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(StoreProvider.of<AppState>(context).state.user.email));
                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyBookings()));
                                                  },
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  child: Container(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Text(
                                                      AppLocalizations.of(context).viewBookings,
                                                      style: TextStyle(
                                                          letterSpacing: 1.25,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextMalibu,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 14 //SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                  )),
                                            )):*/
                                    //Container(),
                                  ],
                                )),

                                ///Contact us & Log out
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ///Go to business management IF manager role or above.
                                    isManagerOrAbove
                                        ? Container(
                                            color: Colors.white,
                                            height: 64,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () async {
                                                  /*StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                      StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());*/
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
                                          )
                                        : Container(),

                                    ///Contact us
                                    Container(
                                      color: Colors.white,
                                      height: 64,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            String url = BuytimeConfig.FlaviosNumber.trim();
                                            debugPrint('Restaurant phonenumber: ' + url);
                                            if (await canLaunch('tel:$url')) {
                                              await launch('tel:$url');
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: CustomBottomButtonWidget(
                                              Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                child: Text(
                                                  AppLocalizations.of(context).contactUs,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16),
                                                ),
                                              ),
                                              AppLocalizations.of(context).haveAnyQuestion,
                                              Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                child: Icon(
                                                  Icons.call,
                                                  color: BuytimeTheme.SymbolGrey,
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),

                                    ///Log out
                                    Container(
                                      color: Colors.white,
                                      height: 64,
                                      //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: () async {
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              await storage.write(key: 'bookingCode', value: '');
                                              FirebaseAuth.instance.signOut().then((_) {
                                                googleSignIn.signOut();
                                                //Resetto il carrello
                                                //cartCounter = 0;
                                                //Svuotare lo Store sul Logout
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetBookingToEmpty(''));
                                                StoreProvider.of<AppState>(context).dispatch(SetBookingListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetCategoryListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetCategoryToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(''));
                                                StoreProvider.of<AppState>(context).dispatch(SetPipelineListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetPipelineToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceSlotToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetStripeToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetUserStateToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderReservableToEmpty(''));
                                                StoreProvider.of<AppState>(context).dispatch(SetCategoryInviteToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetExternalBusinessListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderDetailToEmpty(''));
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderReservableListToEmpty());
                                                //Torno al Login
                                                drawerSelection = DrawerSelection.BusinessList;

                                                //Navigator.of(context).pushNamedAndRemoveUntil(Home.route, (Route<dynamic> route) => false);
                                                //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
                                                //Navigator.replace(context, (Route<dynamic> route) => Landing.route)

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
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ),

            ///Ripple Effect
            rippleLoading || secondRippleLoading
                ? Positioned.fill(
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
                  )
                : Container(),
          ]);
        });
  }
}

/// TODO create dynamic link
Future<Uri> createDynamicLink(String id) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: Environment().config.dynamicLink,
    link: Uri.parse('${Environment().config.dynamicLink}/booking/?booking=$id'),
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
  print("Link dinamico creato " + dynamicUrl.toString());
  return dynamicUrl;
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
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        if (index == 0) {
          if (StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isEmpty)
            return InviteGuestForm(
              id: '',
              fromLanding: true,
            );
          else
            return MyBookings(
              fromLanding: true,
            );
        } else {
          return ServiceExplorer();
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
