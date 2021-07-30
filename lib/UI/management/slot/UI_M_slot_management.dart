
import 'dart:convert';

import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/UI/management/business/widget/W_invite_user.dart';
import 'package:Buytime/UI/management/category/widget/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/reusable/slot_management_service_list_item.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../environment_abstract.dart';


class SlotManagement extends StatefulWidget {
  static String route = '/slot';

  SlotManagement({Key key}) : super(key: key);

  @override
  _SlotManagementState createState() => _SlotManagementState();
}

class _SlotManagementState extends State<SlotManagement> {
  List<BookingState> bookingList = [];
  int networkServices = 0;

  List<CategorySnippetState> internalCategories = [];
  List<CategorySnippetState> externalCategories = [];
  List<CategorySnippetState> tmpInternalCategoriesTable = [];
  List<CategorySnippetState> tmpExternalCategoriesTable = [];

  @override
  void initState() {
    super.initState();
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

  List<ServiceState> serviceList = [];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        List<String> businessIds = [];
        store.state.businessList.businessListState.forEach((element) {
          businessIds.add(element.id_firestore);
        });

        store.dispatch(ServiceListRequestByBusinessIds(businessIds));
        noActivity = true;
        startRequest = true;

      },
      builder: (context, snapshot) {
        Locale myLocale = Localizations.localeOf(context);
        List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
        //print("UI_M_Business => Categories : ${snapshot.serviceListSnippetState.businessSnippet}");
        /*if(snapshot.serviceListSnippetState.businessSnippet != null && snapshot.serviceListSnippetState.businessSnippet.isNotEmpty){
          categories = snapshot.serviceListSnippetState.businessSnippet;
        }*/
        //debugPrint('UI_M_Business => IMPORTED SERVICE LENGTH: ${snapshot.externalServiceImportedListState.externalServiceImported.length}');
        if(snapshot.serviceList.serviceListState.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(snapshot.serviceList.serviceListState.isNotEmpty){
            print("UI_M_slot_management=> Service List Length: ${snapshot.serviceList.serviceListState.length}");
            serviceList = snapshot.serviceList.serviceListState;
            serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));

            //serviceList.sort((a,b) => a.name.compareTo(b.name));
            noActivity = false;
            startRequest = false;
          }
        }
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
                  Utils.barTitle('${AppLocalizations.of(context).slotManagement}'),
                  SizedBox(
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
                      serviceList.isNotEmpty ?
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                          child: CustomScrollView(
                              shrinkWrap: true, slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                //MenuItemModel menuItem = menuItems.elementAt(index);
                                ServiceState service = serviceList.elementAt(index);
                                return Column(
                                  children: [
                                    SlotManagementServiceListItem(service, false, index),
                                    Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                      height: SizeConfig.safeBlockVertical * .2,
                                      color: BuytimeTheme.DividerGrey,
                                    )
                                  ],
                                );
                                // return InkWell(
                                //   onTap: () {
                                //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                //   },
                                //   //child: MenuItemListItemWidget(menuItem),
                                //   child: CategoryListItemWidget(categoryItem),
                                // );
                              },
                              childCount: serviceList.length,
                            ),
                          ),
                      ]),
                        ),) : noActivity ?
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate((context, index){
                                  //ExternalBusinessState item = externalBuinessList.elementAt(index);
                                  return Column(
                                    children: [
                                      Container(
                                        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
                                          child: Container(
                                            height: 91,  ///SizeConfig.safeBlockVertical * 15
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    ///Service Image
                                                    Utils.imageShimmer(91, 91),
                                                    ///Service Name & Description
                                                    Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                                      child:  Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Service Name
                                                          FittedBox(
                                                            fit: BoxFit.scaleDown,
                                                            child: Container(
                                                                //width: SizeConfig.safeBlockHorizontal * 50,
                                                                child: Utils.textShimmer(100, 12.5)
                                                            ),
                                                          ),
                                                          ///Description
                                                          /*FittedBox(
                                                            fit: BoxFit.fitHeight,
                                                            child: Container(
                                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                                child: Utils.textShimmer(150, 10)
                                                            ),
                                                          ),*/
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                /*Icon(
                      Icons.arrow_forward_ios,
                      color: BuytimeTheme.SymbolLightGrey,
                    )*/
                                              ],
                                            ),
                                          )
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                        height: SizeConfig.safeBlockVertical * .2,
                                        color: BuytimeTheme.DividerGrey,
                                      )
                                    ],
                                  );
                                },
                                  childCount: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ) : Container(
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
                      ),
                      //Expanded(child: calendarButtonOrCalendar()),
                    ],
                  ),
                ),
              )
          ),
        );
      },
    );
  }
}