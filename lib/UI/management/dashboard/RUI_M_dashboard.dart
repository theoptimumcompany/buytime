import 'dart:convert';

import 'package:Buytime/UI/management/broadcast/RUI_M_broadcast_business_list.dart';
import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/dashboard/widget/W_filter_tile.dart';
import 'package:Buytime/UI/management/dashboard/widget/W_financial_detail.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/finance/finance_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
import 'package:Buytime/services/category_service_epic.dart';
import 'package:Buytime/utils/chart/chart.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/UI/management/business/widget/w_optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RDashboard extends StatefulWidget {
  static String route = '/';

  @override
  State<StatefulWidget> createState() => RDashboardState();
}

class RDashboardState extends State<RDashboard> {

  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();



  @override
  void initState() {
    super.initState();

  }

  List<CategoryState> categories = [];

  Map<String, bool> categorieSelected = Map();
  List<bool> dWMYFilter = [false, true, false, false];
  bool startRequest = false;
  bool noActivity = false;
  Finance financeState = Finance();
  BusinessState businessState = BusinessState().toEmpty();
  DocumentSnapshot finance;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);
    Stream<DocumentSnapshot> _broadcastStream;
    int limit = 150;
    Role userRole = StoreProvider.of<AppState>(context).state.user.getRole();

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        businessState = store.state.business;
        store.dispatch(RequestListCategory(businessState.id_firestore));
        noActivity = true;
        startRequest = true;
        _broadcastStream =  FirebaseFirestore.instance
            .collection("business").doc('29FdcpS1TBA4gQj6xRRg').collection('finance').doc('finance')
            .snapshots(includeMetadataChanges: true);

         finance = await FirebaseFirestore.instance
            .collection("business").doc('29FdcpS1TBA4gQj6xRRg').collection('finance').doc('finance').get();

      },
      builder: (context, snapshot) {
        if(finance != null){
          print("RUI_M_dashboard => finance data: ${finance.data()}");
          financeState = Finance.fromJson(finance.data());
        }
        Locale myLocale = Localizations.localeOf(context);
        businessState = snapshot.business;
        //print("UI_M_Business => Categories : ${snapshot.serviceListSnippetState.businessSnippet}");
        /*if(snapshot.serviceListSnippetState.businessSnippet != null && snapshot.serviceListSnippetState.businessSnippet.isNotEmpty){
          categories = snapshot.serviceListSnippetState.businessSnippet;
        }*/
        //debugPrint('UI_M_slot_management => IMPORTED SERVICE LENGTH: ${snapshot.externalServiceImportedListState.externalServiceImported.length}');
        if(snapshot.categoryList.categoryListState.isEmpty && financeState == null && startRequest && financeState.activeUserMonthly == null){
          noActivity = true;
        }else{
          if(snapshot.categoryList.categoryListState.isNotEmpty && financeState != null ){
            //serviceList.clear();
            print("RUI_M_dashboard => Category List Length: ${snapshot.categoryList.categoryListState.length}");
            categories = snapshot.categoryList.categoryListState ?? [];
            if(categories.first.id.isNotEmpty){
              categories.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
              categories.forEach((element) {
                categorieSelected.putIfAbsent(element.name, () => false);
              });
            }else{
              categories.removeLast();
            }

            if(financeState != null && financeState.activeUserMonthly != null && financeState.week.totalRevenue != null){
              print("RUI_M_dashboard => finance data: ${financeState.toJson()}");
              print("RUI_M_dashboard => CFinance day length: ${financeState.today.hour.length}");
              print("RUI_M_dashboard => CFinance week length: ${financeState.week.day.length}");
              print("RUI_M_dashboard => CFinance month length: ${financeState.month.day.length}");
              //print("RUI_M_dashboard => CFinance year length: ${financeState.year.month.length}");
              noActivity = false;
              startRequest = false;
            }

            //serviceList.sort((a,b) => a.name.compareTo(b.name));

          }
        }
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              key: _drawerKeyTabs,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.dark,
                elevation: 1,
                title: Text(
                  '${businessState.name} ${AppLocalizations.of(context).financeDashboard}',
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      color: BuytimeTheme.TextBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
                  ),
                ),
                centerTitle: true,
                leading: IconButton(
                  //key: Key('business_drawer_key'),
                  icon: const Icon(
                    Icons.chevron_left,
                    color: BuytimeTheme.TextBlack,
                    //size: 30.0,
                  ),
                  tooltip: AppLocalizations.of(context).dashboard,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [

                ],
              ),
              drawer: ManagerDrawer(),
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*StreamBuilder<DocumentSnapshot>(
                          stream: _broadcastStream,
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
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
                            debugPrint('${snapshot.data.data().toString()}');
                            return Container();
                          }
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///Total text
                                Container(
                                  margin: EdgeInsets.only(top: 24),
                                  child: Text(
                                    AppLocalizations.of(context).total,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontSize: 14,
                                        color: BuytimeTheme.TextGrey
                                    ),
                                  ),
                                ),
                                ///Total value
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: Text(
                                    '€${dWMYFilter[0] ?
                                    financeState.today.totalRevenue.toStringAsFixed(2) :
                                    dWMYFilter[1] ?
                                    financeState.week.totalRevenue.toStringAsFixed(2) :
                                    dWMYFilter[2] ?
                                    financeState.month.totalRevenue.toStringAsFixed(2) :
                                    financeState.year.totalRevenue.toStringAsFixed(2)
                                    }',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontSize: 25,
                                        color: BuytimeTheme.TextBlack
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        ///Categories
                        ConstrainedBox(
                            constraints: new BoxConstraints(
                              maxHeight: SizeConfig.safeBlockVertical * 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Container(
                                      margin: EdgeInsets.only(left: 16, top: 14, bottom: 7, right: 16),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Wrap(
                                            spacing: 5,
                                            children: categories.map((e) => InputChip(
                                              selected: false,
                                              backgroundColor: categorieSelected[e.name] ?
                                              BuytimeTheme.ManagerPrimary : BuytimeTheme.SymbolLightGrey.withOpacity(.5),
                                              label: Container(
                                                margin: EdgeInsets.only(top: 2.5, bottom: 2.5),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(right: 5),
                                                      child: CachedNetworkImage(
                                                        imageUrl: e.categoryImage,
                                                        imageBuilder: (context, imageProvider) => Container(
                                                          //margin: EdgeInsets.only(right: 5), ///5%
                                                          height: 24,
                                                          width: 24,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(12)), ///12.5%
                                                              image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                              )),
                                                        ),
                                                        placeholder: (context, url) => Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(12)), ///12.5%
                                                          ),
                                                          child: Utils.imageShimmer(24, 24),
                                                        ),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                      ),
                                                    ),
                                                    Text(
                                                      e.name,
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.w500,
                                                          color: categorieSelected[e.name] ? BuytimeTheme.TextWhite : BuytimeTheme.TextBlack
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              //avatar: FlutterLogo(),
                                              onPressed: (){
                                                setState(() {
                                                  categorieSelected[e.name] = !categorieSelected[e.name];
                                                });
                                              },
                                            ))
                                                .toList(),
                                          ),
                                        ],
                                      )
                                  ),
                                )
                              ],
                            )
                        ),
                        ///Filter
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///D
                              Container(
                                margin: EdgeInsets.only(left: 16, right: 8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () async{
                                        for(int i = 0; i < dWMYFilter.length; i++){
                                          if(i == 0)
                                            dWMYFilter[i] = true;
                                          else
                                            dWMYFilter[i] = false;
                                        }
                                        setState(() {

                                        });
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: WFilterTile(AppLocalizations.of(context).d, dWMYFilter[0])
                                  ),
                                ),
                              ),
                              ///W
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () async{
                                        for(int i = 0; i < dWMYFilter.length; i++){
                                          if(i == 1)
                                            dWMYFilter[i] = true;
                                          else
                                            dWMYFilter[i] = false;
                                        }
                                        setState(() {

                                        });
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: WFilterTile(AppLocalizations.of(context).w, dWMYFilter[1])
                                  ),
                                ),
                              ),
                              ///M
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () async{
                                        for(int i = 0; i < dWMYFilter.length; i++){
                                          if(i == 2)
                                            dWMYFilter[i] = true;
                                          else
                                            dWMYFilter[i] = false;
                                        }
                                        setState(() {

                                        });
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: WFilterTile(AppLocalizations.of(context).m, dWMYFilter[2])
                                  ),
                                ),
                              ),
                              ///Y
                              Container(
                                margin: EdgeInsets.only(left: 8, right: 16),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () async{
                                        for(int i = 0; i < dWMYFilter.length; i++){
                                          if(i == 3)
                                            dWMYFilter[i] = true;
                                          else
                                            dWMYFilter[i] = false;
                                        }
                                        setState(() {

                                        });
                                      },
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      child: WFilterTile(AppLocalizations.of(context).y, dWMYFilter[3])
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            child: BarChartSample1(dWMYFilter[0], dWMYFilter[1], dWMYFilter[2], dWMYFilter[3], financeState)),
                        noActivity ?
                            Column(
                              children: [
                                Row(
                                  children: [
                                    CircularProgressIndicator()
                                  ],
                                )
                              ],
                            ):
                        Container(
                            width: double.infinity,
                            //height: double.infinity,
                            color: Color(0xffededed),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 24, left: 16),
                                  child: Text(
                                    AppLocalizations.of(context).dataInEvidence,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontSize: 25,
                                        color: BuytimeTheme.TextBlack
                                    ),
                                  ),
                                ),
                                WFinancialDetail(AppLocalizations.of(context).averageGain, '',
                                    '€${dWMYFilter[0] ?
                                    financeState.today.mediumRevenue.toStringAsFixed(2) :
                                    dWMYFilter[1] ?
                                    financeState.week.mediumRevenue.toStringAsFixed(2) :
                                    dWMYFilter[2] ?
                                    financeState.month.mediumRevenue.toStringAsFixed(2) :
                                    financeState.year.mediumRevenue.toStringAsFixed(2)
                                    }'),
                                WFinancialDetail(AppLocalizations.of(context).activeUsersBroughtIntoTheApp, '${AppLocalizations.of(context).bringAtLest} ?? ${AppLocalizations.of(context).inTheApp} ??%', '${financeState.activeUserMonthly}'),
                                WFinancialDetail('${AppLocalizations.of(context).giveback} ??%', '', '€${financeState.monthlyGiveback.toStringAsFixed(2)}'),
                                businessState.hub ?
                                WFinancialDetail(AppLocalizations.of(context).externalServicesAddedToYourNetwork, AppLocalizations.of(context).theMore, '?') : Container(),
                                businessState.hub ?
                                WFinancialDetail(AppLocalizations.of(context).montlyEarningsForExternalServices, '', '€000,00'): Container(),
                                businessState.hub ?
                                WFinancialDetail(AppLocalizations.of(context).givebackExternalServices, '', '€000,00'): Container(),
                                WFinancialDetail(AppLocalizations.of(context).realGain, '',
                                    '€${dWMYFilter[0] ?
                                    financeState.today.mediumRevenue.toStringAsFixed(2) :
                                    dWMYFilter[1] ?
                                    financeState.week.mediumRevenue.toStringAsFixed(2) :
                                    dWMYFilter[2] ?
                                    financeState.month.mediumRevenue.toStringAsFixed(2) :
                                    financeState.year.mediumRevenue.toStringAsFixed(2)
                                    }'),
                                Container(
                                  height: 10,
                                )
                              ],
                            )
                        ),

                      ],
                    ),
                  ),
                )
              )

          ),
        );
      },
    );
  }
}
