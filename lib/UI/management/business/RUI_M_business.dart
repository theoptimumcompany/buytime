
import 'dart:convert';

import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/UI/management/business/widget/W_invite_user.dart';
import 'package:Buytime/UI/management/category/widget/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../environment_abstract.dart';


class RBusiness extends StatefulWidget {
  static String route = '/business';

  ManagerModel manager;
  ServiceModel service;

  RBusiness({Key key, this.service, this.manager}) : super(key: key);

  @override
  _RBusinessState createState() => _RBusinessState();
}

class _RBusinessState extends State<RBusiness> {
  List<BookingState> bookingList = [];
  int networkServices = 0;

  List<CategorySnippetState> internalCategories = [];
  List<CategorySnippetState> externalCategories = [];
  List<CategorySnippetState> tmpInternalCategoriesTable = [];
  List<CategorySnippetState> tmpExternalCategoriesTable = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      StoreProvider.of<AppState>(context).dispatch(ExternalServiceImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
      StoreProvider.of<AppState>(context).dispatch(ExternalBusinessImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
      debugPrint('RUI_M_business_list => BUSIENSS ID: ${StoreProvider.of<AppState>(context).state.business.id_firestore}');
      var urlManager = Uri.https(Environment().config.cloudFunctionLink, '/getCategoriesForManagerInBusiness', {'businessId': '${StoreProvider.of<AppState>(context).state.business.id_firestore}', 'userEmail': '${StoreProvider.of<AppState>(context).state.user.email}'});
      var urlWorker = Uri.https(Environment().config.cloudFunctionLink, '/getCategoriesForWorkerInBusiness', {'businessId': '${StoreProvider.of<AppState>(context).state.business.id_firestore}', 'userEmail': '${StoreProvider.of<AppState>(context).state.user.email}'});
      final http.Response responseManager = await http.get(urlManager);
      if(responseManager.statusCode == 200){
        debugPrint('RUI_M_business_list => RESPONSE MANAGER: ${responseManager.body}');
        debugPrint('RUI_M_business_list => RESPONSE FROM JSON MANAGER: ${jsonDecode(responseManager.body)}');
        debugPrint('RUI_M_business_list => RESPONSE JSON MANAGER: ${jsonDecode(responseManager.body)['accessTo']}');
        //store.state.user.accessTo = jsonDecode(response.body)['accessTo'];
        var tmpJson = jsonDecode(responseManager.body)['accessTo'];
        List<String> accessList = [];
        tmpJson.forEach((element) {
          accessList.add(element.toString());
        });
        //noActivity = false;
        isManagerComplete = true;
        StoreProvider.of<AppState>(context).dispatch(SetUserManagerAccessTo(accessList));
      }else{
        debugPrint('RUI_M_business_list => RESPONSE MANAGER: ${responseManager.body}');
      }
      final http.Response responseWorker = await http.get(urlWorker);
      if(responseWorker.statusCode == 200){
        debugPrint('RUI_M_business_list => RESPONSE WORKER: ${responseWorker.body}');
        debugPrint('RUI_M_business_list => RESPONSE FROM JSON WORKER: ${jsonDecode(responseWorker.body)}');
        debugPrint('RUI_M_business_list => RESPONSE JSON WORKER: ${jsonDecode(responseWorker.body)['accessTo']}');
        //store.state.user.accessTo = jsonDecode(response.body)['accessTo'];
        var tmpJson = jsonDecode(responseWorker.body)['accessTo'];
        List<String> accessList = [];
        tmpJson.forEach((element) {
          accessList.add(element.toString());
        });
        //noActivity = false;
        isWorkerComplete = true;
        StoreProvider.of<AppState>(context).dispatch(SetUserWorkerAccessTo(accessList));
      }else{
        debugPrint('RUI_M_business_list => RESPONSE WORKER: ${responseWorker.body}');
      }
    });
  }

  ///Prova Evento su Calendario
  // Widget calendarButtonOrCalendar() {
  //   //Returns a calendar button that displays 'Select Calendar' or Returns a
  //   // Calendar Page if the button was pressed
  //     return  TextButton(
  //         child: Text("Create Event",
  //             style: Theme.of(context).textTheme.body1),
  //         onPressed: () {
  //
  //           final Event event = Event(
  //             title: 'Nuovo Evento Buytime',
  //             description: 'Cazzarola',
  //             location: 'Poggibonsi',
  //             startDate: DateTime(2021,03,17),
  //          //   alarmInterval: Duration(days: 1), // on iOS, you can set alarm notification after your event.
  //             endDate: DateTime(2021,03,18),
  //           );
  //           Add2Calendar.addEvent2Cal(event);
  //
  //         });
  // }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool hotel = false;

  bool startRequest = false;
  bool noActivity = false;
  bool generated = false;

  bool isManagerComplete = false;
  bool isWorkerComplete = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    final Stream<QuerySnapshot> _businessStream =  FirebaseFirestore.instance.collection("business")
        .doc(StoreProvider.of<AppState>(context).state.business.id_firestore)
        .collection('service_list_snippet').snapshots(includeMetadataChanges: true);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: _drawerKey,
          ///Appbar
          appBar: BuytimeAppbar(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      tooltip: AppLocalizations.of(context).openMenu,
                      onPressed: () {
                        _drawerKey.currentState.openDrawer();
                      },
                    ),
                  ),
                ],
              ),
              ///Title
              //Utils.barTitle(AppLocalizations.of(context).dashboard),
              Utils.barTitle('${StoreProvider.of<AppState>(context).state.business.name}'),
              StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    onTap: () {
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditBusiness()),);
                      Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditBusiness(), exitPage: RBusiness(), from: true));
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (context, animation, anotherAnimation) {
                            return UI_M_EditBusiness();
                          },
                          transitionDuration: Duration(milliseconds: 500),
                          transitionsBuilder:
                              (context, animation, anotherAnimation, child) {
                            return  SlideTransition(
                              position: Tween(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset(0.0, 0.0))
                                  .animate(animation),
                              child: child,
                            );
                          }));

                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 1),
                      child: Text(
                        AppLocalizations.of(context).edit,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )) :  SizedBox(
                width: 50.0,
              ),
            ],
          ),
          drawer: UI_M_BusinessListDrawer(),
          body: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ///BusinessHeader(snapshot.serviceListSnippetState),
                        Column(
                          children: [
                            ///Worker card & Business logo
                            Container(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.transparent),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Worker card
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(top: 25.0, left: 20.0),
                                          color: Colors.transparent,
                                          child: StreamBuilder<QuerySnapshot>(
                                              stream: _businessStream,
                                              builder: (context, AsyncSnapshot<QuerySnapshot> businessSnapshot) {
                                                if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      CircularProgressIndicator()
                                                    ],
                                                  );
                                                }

                                                ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState.fromJson(businessSnapshot.data.docs.first.data());
                                                StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequestResponse(serviceListSnippetState));
                                                print("RUI_M_business => Business Id from snippet: ${serviceListSnippetState.businessId}");
                                                //print("RUI_M_business => BEFORE | Categories length: ${categories.length}");
                                                networkServices = serviceListSnippetState.businessServiceNumberInternal + serviceListSnippetState.businessServiceNumberExternal;


                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ///Welcome message 'Hi ...'
                                                    Container(
                                                      child: Text(
                                                        '${AppLocalizations.of(context).hi} ' + StoreProvider.of<AppState>(context).state.user.name,
                                                        style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 24, color: BuytimeTheme.TextBlack),
                                                      ),
                                                    ),

                                                    networkServices >= 0 ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ///Employees count
                                                        Container(
                                                          margin: EdgeInsets.only(top: 10),
                                                          child: Text(
                                                            (StoreProvider.of<AppState>(context).state.business.hasAccess != null && StoreProvider.of<AppState>(context).state.business.hasAccess.isNotEmpty && StoreProvider.of<AppState>(context).state.business.hasAccess.length > 1) ?
                                                            '${ StoreProvider.of<AppState>(context).state.business.hasAccess.length} ${AppLocalizations.of(context).justEmployees}':
                                                            (StoreProvider.of<AppState>(context).state.business.hasAccess != null &&StoreProvider.of<AppState>(context).state.business.hasAccess.isNotEmpty && StoreProvider.of<AppState>(context).state.business.hasAccess.length == 1) ?
                                                            '${ StoreProvider.of<AppState>(context).state.business.hasAccess.length} ${AppLocalizations.of(context).justEmployee}' :
                                                            '0 ${AppLocalizations.of(context).justEmployee}',
                                                            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
                                                          ),
                                                        ),

                                                        ///Menu items count
                                                        Container(
                                                          margin: EdgeInsets.only(top: 2.5),
                                                          child: Text(
                                                            networkServices > 1 ? '$networkServices ${AppLocalizations.of(context).networkServices}' : '$networkServices ${AppLocalizations.of(context).networkService}',
                                                            style: TextStyle(fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.TextMedium),
                                                          ),
                                                        )
                                                      ],
                                                    ) : Container(
                                                      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2,left: 20.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          CircularProgressIndicator()
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                          ),
                                        ),
                                      ),

                                      ///Business logo
                                      Expanded(
                                        flex: 2,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                          Container(
                                            //color: Colors.deepOrange,
                                              width: 140,

                                              ///Fixed width
                                              child: CachedNetworkImage(
                                                imageUrl: StoreProvider.of<AppState>(context).state.business.logo,
                                                imageBuilder: (context, imageProvider) => Container(
                                                  //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                  height: 140,
                                                  width: 140,
                                                  decoration: BoxDecoration(
                                                    //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      )),
                                                ),
                                                placeholder: (context, url) => Container(
                                                  height: 140,
                                                  width: 140,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        //padding: EdgeInsets.only(top: 80, bottom: 80, left: 50, right: 50),
                                                        child: CircularProgressIndicator(
                                                          //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              )

                                            //Image.network(StoreProvider.of<AppState>(context).state.business.logo, fit: BoxFit.cover, scale: 1.1),
                                          )
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: _businessStream,
                            builder: (context, AsyncSnapshot<QuerySnapshot> businessSnapshot) {
                              if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 25),
                                      child: CircularProgressIndicator(),
                                    )
                                  ],
                                );
                              }

                              ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState.fromJson(businessSnapshot.data.docs.first.data());
                              StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequestResponse(serviceListSnippetState));
                              print("RUI_M_business => Business Id from snippet: ${serviceListSnippetState.businessId}");
                              internalCategories.clear();
                              externalCategories.clear();
                              tmpInternalCategoriesTable.clear();
                              tmpExternalCategoriesTable.clear();
                              //print("RUI_M_business => BEFORE | Categories length: ${categories.length}");
                              networkServices = serviceListSnippetState.businessServiceNumberInternal + serviceListSnippetState.businessServiceNumberExternal;
                              //categories = snapshot.serviceListSnippetState.businessSnippet;
                              List<CategorySnippetState> tmpCategories = serviceListSnippetState.businessSnippet;
                              tmpCategories.forEach((element) {
                                if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                                  internalCategories.add(element);
                                if(element.categoryAbsolutePath.split('/').first != StoreProvider.of<AppState>(context).state.business.id_firestore)
                                  externalCategories.add(element);
                                element.serviceList.forEach((service) { 
                                  if(service.serviceAbsolutePath.split('/').first != StoreProvider.of<AppState>(context).state.business.id_firestore){
                                    if(!externalCategories.contains(element))
                                      externalCategories.add(element);
                                  }
                                });
                              });
                              //print("RUI_M_business => AFTER | Categories length: ${categories.length}");
                              tmpCategories.forEach((allC) {
                                //print("RUI_M_business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                                if(allC.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore){
                                  internalCategories.forEach((c) {
                                    //print("RUI_M_business => Category: INTERNAL | ${c.categoryName} | Category services: ${c.serviceList.length}");
                                    if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                                      //print("RUI_M_business => INTERNAL | Main category: ${c.categoryName}");
                                      //print("RUI_M_business => INTERNAL | Sub category: ${allC.categoryName}");
                                      //print("RUI_M_business => INTERNAL | Sub category service list length: ${allC.serviceList.length}");
                                      //print("RUI_M_business => INTERNAL | BEFORE | Main category service list length: ${c.serviceList.length}");
                                      allC.serviceList.forEach((s) {
                                        if(!c.serviceList.contains(s) && s.serviceAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                                          c.serviceList.add(s);
                                      });
                                      //print("RUI_M_business => INTERNAL | AFTER | Main category service list length: ${c.serviceList.length}");
                                      c.serviceNumberInternal = c.serviceList.length;
                                    }
                                  });
                                }

                                if(allC.categoryAbsolutePath.split('/').first != StoreProvider.of<AppState>(context).state.business.id_firestore){
                                  externalCategories.forEach((c) {
                                    //print("RUI_M_business => Category: EXTERNAL | ${c.categoryName} | Category services: ${c.serviceList.length}");
                                    if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                                      //print("RUI_M_business => EXTERNAL | Main category: ${c.categoryName}");
                                      //print("RUI_M_business => EXTERNAL | Sub category: ${allC.categoryName}");
                                      //print("RUI_M_business => EXTERNAL | Sub category service list length: ${allC.serviceList.length}");
                                      //print("RUI_M_business => EXTERNAL | BEFORE | Main category service list length: ${c.serviceList.length}");
                                      allC.serviceList.forEach((s) {
                                        if(!c.serviceList.contains(s) && s.serviceAbsolutePath.split('/').first != StoreProvider.of<AppState>(context).state.business.id_firestore)
                                          c.serviceList.add(s);
                                      });
                                      //print("RUI_M_business => EXTERNAL | AFTER | Main category service list length: ${c.serviceList.length}");
                                      c.serviceNumberExternal = c.serviceList.length;
                                    }
                                  });
                                }
                              });

                              internalCategories.sort((b,a) => a.serviceNumberInternal.compareTo(b.serviceNumberInternal));
                              externalCategories.sort((b,a) => a.serviceNumberExternal.compareTo(b.serviceNumberExternal));
                              if(hotel){
                                if(internalCategories.length > 4){
                                  tmpInternalCategoriesTable.addAll(internalCategories.sublist(0,4));
                                  CategorySnippetState categoryItem = CategorySnippetState().toEmpty();
                                  categoryItem.categoryName = AppLocalizations.of(context).others;
                                  for(int i = 4; i < internalCategories.length; i++){
                                    categoryItem.serviceNumberInternal += internalCategories[i].serviceNumberInternal;
                                  }
                                  tmpInternalCategoriesTable.add(categoryItem);
                                }else{
                                  tmpInternalCategoriesTable.addAll(internalCategories);
                                }
                              }else{
                                tmpInternalCategoriesTable.addAll(internalCategories);
                              }
                              tmpInternalCategoriesTable.forEach((element) {
                                //debugPrint('RUI_M_business => INTERNAL: ${element.categoryName} - ${element.serviceList.length}');
                              });

                              if(externalCategories.length > 4){
                                tmpExternalCategoriesTable.addAll(externalCategories.sublist(0,4));
                                CategorySnippetState categoryItem = CategorySnippetState().toEmpty();
                                categoryItem.categoryName = AppLocalizations.of(context).others;
                                for(int i = 4; i < externalCategories.length; i++){
                                  categoryItem.serviceNumberExternal += externalCategories[i].serviceNumberExternal;
                                }
                                tmpExternalCategoriesTable.add(categoryItem);
                              }else{
                                tmpExternalCategoriesTable.addAll(externalCategories);
                              }
                              tmpExternalCategoriesTable.forEach((element) {
                                //debugPrint('RUI_M_business => EXTERNAL: ${element.categoryName} - ${element.serviceList.length}');
                              });

                              return  Column(
                                children: [
                                  ///InternalServiceShowcase(categoryRootList: categoryRootList),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///Internal Services
                                      Container(
                                          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                  AppLocalizations.of(context).internalServices,
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.TextBlack),
                                                ),
                                              ),

                                              ///Manage Internal Services
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: RBusiness(), from: true));
                                                },
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    AppLocalizations.of(context).manageUpper,
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      ///Categories list top part
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                                        decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                        child: Row(
                                          children: [
                                            ///Menu item text
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Text(
                                                  AppLocalizations.of(context).categoriesUpper,
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                                                ),
                                              ),
                                            ),

                                            ///Most popular text
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Text(
                                                  AppLocalizations.of(context).mostPopularCaps,
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                      ///Categories list
                                      Flexible(
                                        flex: 1,
                                        child: internalCategories.isNotEmpty ?
                                        ///Categories list
                                        Container(
                                          color: Colors.blueGrey.withOpacity(0.1),
                                          //margin: EdgeInsets.only(bottom: 60.0),
                                          //height: 180,
                                          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                                          child: /*Column(
                                              children: tmpInternalCategoriesTable.map((CategorySnippetState categoryItem){
                                                return CategoryListItemWidget(categoryItem, BuytimeTheme.SymbolLime);
                                              }).toList(),
                                            )*/
                                          CustomScrollView(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true, slivers: [
                                            SliverList(
                                              delegate: SliverChildBuilderDelegate(
                                                    (context, index) {
                                                  //MenuItemModel menuItem = menuItems.elementAt(index);
                                                  CategorySnippetState categoryItem = tmpInternalCategoriesTable.elementAt(index);
                                                  return CategoryListItemWidget(categoryItem, BuytimeTheme.SymbolLime);
                                                  // return InkWell(
                                                  //   onTap: () {
                                                  //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                                  //   },
                                                  //   //child: MenuItemListItemWidget(menuItem),
                                                  //   child: CategoryListItemWidget(categoryItem),
                                                  // );
                                                },
                                                childCount: tmpInternalCategoriesTable.length,
                                              ),
                                            ),
                                          ])
                                          ,
                                        ) : noActivity ?
                                        Container(
                                          height: SizeConfig.screenHeight * 0.1,
                                          decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                          padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        ) : Container(
                                          decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                          child: Container(
                                            height: SizeConfig.screenHeight * 0.1,
                                            child:  Center(
                                              child: Text(
                                                AppLocalizations.of(context).thereAreNoServicesInThisBusiness,
                                                style: TextStyle(fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, fontSize: 13, color: BuytimeTheme.TextBlack,),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ///ExternalServiceShowcase(categoryRootList: categoryRootList),
                                  hotel ?
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ///External Services
                                      Container(
                                          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Text(
                                                  AppLocalizations.of(context).externalServices,
                                                  style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.TextBlack),
                                                ),
                                              ),
                                              ///Manage External Services
                                              StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
                                                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
                                                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ? InkWell(
                                                onTap: (){
                                                  Navigator.push(context, EnterExitRoute(enterPage: ExternalServiceList(), exitPage: RBusiness(), from: true));
                                                } ,
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    AppLocalizations.of(context).manageUpper,
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                                  ),
                                                ),
                                              ) : Container(),
                                            ],
                                          )),
                                      ///Categories list top part
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                                        decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                        child: Row(
                                          children: [
                                            ///Menu item text
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Text(
                                                  AppLocalizations.of(context).categoriesUpper,
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                                                ),
                                              ),
                                            ),

                                            ///Most popular text
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                child: Text(
                                                  AppLocalizations.of(context).mostPopularCaps,
                                                  style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 10, color: BuytimeTheme.TextBlack, letterSpacing: 1.5),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                      ),
                                      ///Categories list & Invite user
                                      Flexible(
                                          child: externalCategories.isNotEmpty ?
                                          ///Categories list
                                          Container(
                                            color: Colors.blueGrey.withOpacity(0.1),
                                            //margin: EdgeInsets.only(bottom: 60.0),
                                            //height: 180,
                                            padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                                            margin: EdgeInsets.only(bottom: 10.0),
                                            child: /*Column(
                                                children: tmpExternalCategoriesTable.map((CategorySnippetState categoryItem){
                                                  return CategoryListItemWidget(categoryItem, BuytimeTheme.Indigo);
                                                }).toList(),
                                              )*/
                                            CustomScrollView(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true, slivers: [
                                              SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                      (context, index) {
                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                    CategorySnippetState categoryItem = tmpExternalCategoriesTable.elementAt(index);
                                                    return CategoryListItemWidget(categoryItem, BuytimeTheme.SymbolLime);
                                                    // return InkWell(
                                                    //   onTap: () {
                                                    //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                                    //   },
                                                    //   //child: MenuItemListItemWidget(menuItem),
                                                    //   child: CategoryListItemWidget(categoryItem),
                                                    // );
                                                  },
                                                  childCount: tmpExternalCategoriesTable.length,
                                                ),
                                              ),
                                            ])
                                            ,
                                          ) : noActivity ?
                                          Container(
                                            height: SizeConfig.screenHeight * 0.1,
                                            decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                            padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator()
                                              ],
                                            ),
                                          )  :
                                          Container(
                                            decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                                            child: Container(
                                              height: SizeConfig.screenHeight * 0.1,
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context).thereAreNoExternalServicesAttached,
                                                  style: TextStyle(fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, fontSize: 13, color: BuytimeTheme.TextBlack,),
                                                ),
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  ) :
                                  Container(),
                                ],
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                  InviteUser(
                    hotel: hotel,
                  ),
                  //Expanded(child: calendarButtonOrCalendar()),
                ],
              ),
            ),
          )
      ),
    );
  }
}