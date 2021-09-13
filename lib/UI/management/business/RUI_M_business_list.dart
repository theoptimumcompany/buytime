import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/business/optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RBusinessList extends StatefulWidget {
  static String route = '/businessList';

  @override
  State<StatefulWidget> createState() => RBusinessListState();
}

class RBusinessListState extends State<RBusinessList> {
  List<BusinessState> businessListState = [];
  List<ServiceListSnippetState> businessSnippetListState = [];
  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  bool startRequest = false;
  bool noActivity = false;
  bool generated = false;

  ///Storage
  final storage = new FlutterSecureStorage();
  emptyCategoryInvite() async{
    await storage.write(key: 'categoryInvite', value: '');
  }
  String orderId = '';
  String userId = '';
  @override
  void initState() {
    super.initState();
    emptyCategoryInvite();
    initDynamicLinks();
  }
  onSitePaymentFound() async {
    userId = await storage.read(key: 'onSiteUserId') ?? '';
    orderId = await storage.read(key: 'onSiteOrderId') ?? '';
    debugPrint('UI_U_landing: DEEP LINK EMPTY | userId: $userId | orderId: $orderId');
    await storage.delete(key: 'onSiteUserId');
    await storage.delete(key: 'onSiteOrderId');

    if (userId.isNotEmpty && orderId.isNotEmpty) {
      if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user) {
        StoreProvider.of<AppState>(context).dispatch(OrderRequest(orderId));
        await Future.delayed(Duration(milliseconds: 3000));
        StoreProvider.of<AppState>(context).state.order.progress = 'paid';
        StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(StoreProvider.of<AppState>(context).state.order, OrderStatus.paid));
      } else {
        debugPrint('USER NO PERMISSION');
      }

      await storage.write(key: 'onSiteUserIdRead', value: 'false');
      await storage.write(key: 'onSiteOrderIdRead', value: 'false');
    }
  }
  void initDynamicLinks() async {
    print("Dentro initial dynamic");
    Uri deepLink;

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      deepLink = null;
      deepLink = dynamicLink?.link;
      debugPrint('UI_U_landing: DEEPLINK onLink: $deepLink');
      if (deepLink != null) {
        String onSiteUserIdRead = await storage.containsKey(key: 'onSiteUserIdRead') ? await storage.read(key: 'onSiteUserIdRead') ?? '' : '';
        String onSiteOrderIdRead = await storage.containsKey(key: 'onSiteOrderIdRead') ? await storage.read(key: 'onSiteOrderIdRead') ?? '' : '';

        if (deepLink.queryParameters.containsKey('userId') && deepLink.queryParameters.containsKey('orderId') && onSiteUserIdRead != 'true' && onSiteOrderIdRead != 'true') {
          debugPrint('ON SITE PAYMENT ON LINK');
          String orderId = deepLink.queryParameters['orderId'];
          String userId = deepLink.queryParameters['userId'];
          debugPrint('UI_U_landing: userId onLink: $userId - orderId onLink: $orderId');
          await storage.write(key: 'onSiteUserId', value: userId);
          await storage.write(key: 'onSiteOrderId', value: orderId);
          await storage.write(key: 'onSiteUserIdRead', value: 'true');
          await storage.write(key: 'onSiteOrderIdRead', value: 'true');
          /*setState(() {
            onBookingCode = true;
          });*/
          //StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(BookingState(booking_code: id)));
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: false,)), (Route<dynamic> route) => false);
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: true,)));
            if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user) {
              StoreProvider.of<AppState>(context).dispatch(OrderRequest(orderId));
              await Future.delayed(Duration(milliseconds: 3000));
              StoreProvider.of<AppState>(context).state.order.progress = 'paid';
              StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(StoreProvider.of<AppState>(context).state.order, OrderStatus.paid));
            } else {
              debugPrint('USER NO PERMISSION in LINK');
            }

            await storage.write(key: 'onSiteUserIdRead', value: 'false');
            await storage.write(key: 'onSiteOrderIdRead', value: 'false');
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
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
      String onSiteUserIdRead = await storage.containsKey(key: 'onSiteUserIdRead') ? await storage.read(key: 'onSiteUserIdRead') ?? '' : '';
      String onSiteOrderIdRead = await storage.containsKey(key: 'onSiteOrderIdRead') ? await storage.read(key: 'onSiteOrderIdRead') ?? '' : '';

      if (deepLink.queryParameters.containsKey('userId') && deepLink.queryParameters.containsKey('orderId') && onSiteUserIdRead != 'true' && onSiteOrderIdRead != 'true') {
          String orderId = deepLink.queryParameters['orderId'];
          String userId = deepLink.queryParameters['userId'];
          debugPrint('UI_U_landing: userId onLink: $userId - orderId onLink: $orderId');
          await storage.write(key: 'onSiteUserId', value: userId);
          await storage.write(key: 'onSiteOrderId', value: orderId);
          await storage.write(key: 'onSiteUserIdRead', value: 'true');
          await storage.write(key: 'onSiteOrderIdRead', value: 'true');
          /*setState(() {
            onBookingCode = true;
          });*/
          //StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(BookingState(booking_code: id)));
          //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: false,)), (Route<dynamic> route) => false);
          if (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser.uid.isNotEmpty) {
            debugPrint('UI_U_landing: USER Is LOGGED in onLink');
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteGuestForm(id: id, fromLanding: true,)));
            if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user) {
              StoreProvider.of<AppState>(context).dispatch(OrderRequest(orderId));
              await Future.delayed(Duration(milliseconds: 3000));
              StoreProvider.of<AppState>(context).state.order.progress = 'paid';
              StoreProvider.of<AppState>(context).dispatch(UpdateOrderByManager(StoreProvider.of<AppState>(context).state.order, OrderStatus.paid));
            } else {
              debugPrint('USER NO PERMISSION in LINK');
            }

            await storage.write(key: 'onSiteUserIdRead', value: 'false');
            await storage.write(key: 'onSiteOrderIdRead', value: 'false');
          } else
            debugPrint('UI_U_landing: USER NOT LOGGED in onLink');
        }
    }
  }

  List<int> networkServicesList = [];


  @override
  Widget build(BuildContext context) {
    onSitePaymentFound();
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);
    Stream<QuerySnapshot> _businessStream;
    int limit = 150;
    Role userRole = StoreProvider.of<AppState>(context).state.user.getRole();
    if (userRole == Role.manager || userRole == Role.worker) {
      _businessStream =  FirebaseFirestore.instance
          .collection("business")
          .where("hasAccess", arrayContains: StoreProvider.of<AppState>(context).state.user.email)
          .limit(limit)
          .snapshots(includeMetadataChanges: true);
    } else if (userRole == Role.owner) {
      _businessStream = FirebaseFirestore.instance
          .collection("business")
          .where("ownerId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
          .limit(limit)
          .snapshots(includeMetadataChanges: true);
    } else if (userRole == Role.salesman) {
      _businessStream = FirebaseFirestore.instance
          .collection("business")
          .where("salesmanId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
          .limit(limit)
          .snapshots(includeMetadataChanges: true);
    } else if (userRole == Role.admin) {
      _businessStream = FirebaseFirestore.instance
          .collection("business")
          .limit(limit)
          .snapshots(includeMetadataChanges: true);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _drawerKeyTabs,
          appBar: BuytimeAppbar(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Drawer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: IconButton(
                      key: Key('business_drawer_key'),
                      icon: const Icon(
                        Icons.menu,
                        color: BuytimeTheme.TextWhite,
                        size: 30.0,
                      ),
                      tooltip: AppLocalizations.of(context).showMenu,
                      onPressed: () {
                        _drawerKeyTabs.currentState.openDrawer();
                      },
                    ),
                  ),
                ],
              ),
              ///Title
              Utils.barTitle(AppLocalizations.of(context).businessManagement),
              ///Add Icon
              StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: BuytimeTheme.TextWhite,
                    size: 30.0,
                  ),
                  tooltip: AppLocalizations.of(context).createBusinessPlain,
                  onPressed: () {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateBusiness()));
                    Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateBusiness(), exitPage: RBusinessList(), from: true));
                  },
                ),
              ) :  SizedBox(
                width: 56.0,
              ),
            ],
          ),
          drawer: UI_M_BusinessListDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _businessStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> businessSnippet) {
                    businessListState.clear();
                    if (businessSnippet.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator()
                        ],
                      );
                    }

                    if (businessSnippet.hasError || (businessSnippet.data != null && businessSnippet.data.docs.isEmpty)) {
                      return Container(
                        height: SizeConfig.safeBlockVertical * 8,
                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                        decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context).noActiveBusinesses,
                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            )),
                      );
                    }

                    businessSnippet.data.docs.forEach((element) {
                      BusinessState businesState = BusinessState.fromJson(element.data());
                      businessListState.add(businesState);
                    });
                    businessListState.sort((a,b) => a.name.compareTo(b.name));
                    StoreProvider.of<AppState>(context).state.businessList.businessListState.clear();
                    StoreProvider.of<AppState>(context).dispatch(BusinessListReturned(businessListState));


                   // debugPrint('RUI_M_business_list => BUSINESS LENGTH: ${businessListState.length}');

                    /*Stream<QuerySnapshot> _businessSnippetStream = FirebaseFirestore.instance.collection("business")
                        .where("businessId", whereIn: businessIdList.sublist(0, 10).doc()
                        .collection('service_list_snippet').snapshots(includeMetadataChanges: true);*/


                    return Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: businessListState.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                BusinessState businessState = businessListState.elementAt(index);
                                Stream<QuerySnapshot> _businessSnippetStream = FirebaseFirestore.instance.collection("business")
                                    .doc(businessState.id_firestore)
                                    .collection('service_list_snippet').snapshots();
                                return StreamBuilder<QuerySnapshot>(
                                    stream: _businessSnippetStream,
                                    builder: (context, AsyncSnapshot<QuerySnapshot> businessSnippetSnapshot) {
                                      businessSnippetListState.clear();
                                      int networkServices = 0;

                                      if (businessSnippetSnapshot.hasError || businessSnippetSnapshot.connectionState == ConnectionState.waiting) {
                                        return Row(
                                          children: [
                                            Utils.imageShimmer(100, 100),
                                            SizedBox(
                                              width: media.width * 0.025,
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 100,//mediaSize.height * 0.13,
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(bottom: 10.0),
                                                                child: Utils.textShimmer(150, 12.5),
                                                              ),
                                                              Utils.textShimmer(100, 10),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 6.0),
                                                                child: Utils.textShimmer(125, 10),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Icon(
                                                              Icons.keyboard_arrow_right,
                                                              size: media.height * 0.035,
                                                              color: Colors.black.withOpacity(0.6),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      ServiceListSnippetState serviceListSnippetState  = ServiceListSnippetState().toEmpty();
                                      businessSnippetSnapshot.data.docs.forEach((element) {
                                        serviceListSnippetState = ServiceListSnippetState.fromJson(element.data());
                                        //businessSnippetListState.add(serviceListSnippetState);
                                      });

                                      // debugPrint('RUI_M_business_list => BUSINESS SNIPPET | ${businessState.name}');

                                      for(int i = 0; i < businessListState.length; i++){
                                        if(serviceListSnippetState.businessId != null) {
                                          if(businessListState[i].id_firestore == serviceListSnippetState.businessId){
                                            networkServices = serviceListSnippetState.businessServiceNumberInternal + serviceListSnippetState.businessServiceNumberExternal;
                                            networkServices = networkServices;
                                          }
                                        }

                                      }
                                      return  Padding(
                                        padding: const EdgeInsets.only(top: 1.0),
                                        child: new OptimumBusinessCardMediumManager(
                                          index: index,
                                          businessState: businessListState[index],
                                          networkServices: networkServices ?? 0,
                                          onBusinessCardTap: (BusinessState businessState) async{
                                            StoreProvider.of<AppState>(context).dispatch(SetBusiness(businessListState[index]));
                                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                                            Navigator.push(context, EnterExitRoute(enterPage: RBusiness(), exitPage: RBusinessList(), from: true));
                                          },
                                          imageUrl: businessState.profile,
                                          mediaSize: media,
                                        ),
                                      );
                                    }
                                );
                              }
                          )

                      ),
                    );
                  }
              )
            ],
          )
      ),
    );
  }
}
