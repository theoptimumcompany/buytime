import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
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

  @override
  void initState() {
    super.initState();
    emptyCategoryInvite();
  }

  List<int> networkServicesList = [];


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    Stream<QuerySnapshot> _businessStream;
    int limit = 20;
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

                    if (businessSnippet.hasError || businessSnippet.data.docs.isEmpty) {
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

                    StoreProvider.of<AppState>(context).dispatch(BusinessListReturned(businessListState));


                    debugPrint('RUI_M_business_list => BUSINESS LENGTH: ${businessListState.length}');

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
                                            CircularProgressIndicator()
                                          ],
                                        );
                                      }

                                      ServiceListSnippetState serviceListSnippetState  = ServiceListSnippetState().toEmpty();
                                      businessSnippetSnapshot.data.docs.forEach((element) {
                                        serviceListSnippetState = ServiceListSnippetState.fromJson(element.data());
                                        //businessSnippetListState.add(serviceListSnippetState);
                                      });

                                      debugPrint('RUI_M_business_list => BUSINESS SNIPPET | ${businessState.name}');

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
                                          businessState: businessState,
                                          networkServices: networkServices ?? 0,
                                          onBusinessCardTap: (BusinessState businessState) async{
                                            StoreProvider.of<AppState>(context).dispatch(SetBusiness(businessListState[index]));
                                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                                            Navigator.push(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: RBusinessList(), from: true));
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