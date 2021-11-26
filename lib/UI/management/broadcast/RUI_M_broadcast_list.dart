import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/helper/dynamic_links/dynamic_links_helper.dart';
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

import 'UI_M_create_broadcast.dart';

class RBroadcastList extends StatefulWidget {
  static String route = '/broadcastList';

  @override
  State<StatefulWidget> createState() => RBroadcastListState();
}

class RBroadcastListState extends State<RBroadcastList> {
  List<BroadcastState> broadcastListState = [];
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
    //initDynamicLinks();

  }


  List<int> networkServicesList = [];


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);
    Stream<QuerySnapshot> _broadcastStream;
    int limit = 150;
    Role userRole = StoreProvider.of<AppState>(context).state.user.getRole();
    _broadcastStream =  FirebaseFirestore.instance
        .collection("broadcast")
        .where("senderId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
        //.limit(limit)
        .snapshots(includeMetadataChanges: true);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _drawerKeyTabs,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.dark,
            elevation: 1,
            title: Text(
              AppLocalizations.of(context).broadcastMessages,
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
                Icons.menu,
                color: BuytimeTheme.TextBlack,
                //size: 30.0,
              ),
              tooltip: AppLocalizations.of(context).showMenu,
              onPressed: () {
                _drawerKeyTabs.currentState.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: BuytimeTheme.TextBlack,
                  //size: 30.0,
                ),
                tooltip: AppLocalizations.of(context).createBusinessPlain,
                onPressed: () {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateBusiness()));
                  Navigator.push(context, EnterExitRoute(enterPage: CreateBroadcast(false, BroadcastState().toEmpty()), exitPage: RBroadcastList(), from: true));
                },
              )
              /*StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: BuytimeTheme.TextBlack,
                    //size: 30.0,
                  ),
                  tooltip: AppLocalizations.of(context).createBusinessPlain,
                  onPressed: () {
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateBusiness()));
                    Navigator.push(context, EnterExitRoute(enterPage: CreateBroadcast(false, BroadcastState().toEmpty()), exitPage: RBroadcastList(), from: true));
                  },
                ),
              ) :  Container()*/
            ],
          ),
          drawer: ManagerDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: _broadcastStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
                    broadcastListState.clear();
                    if (broadcastSnapshot.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator()
                        ],
                      );
                    }

                    if (broadcastSnapshot.hasError || (broadcastSnapshot.data != null && broadcastSnapshot.data.docs.isEmpty)) {
                      return Center(
                          child: Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).noBroadcastMessages,
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ));
                    }

                    broadcastSnapshot.data.docs.forEach((element) {
                      BroadcastState broadcastState = BroadcastState.fromJson(element.data());
                      broadcastListState.add(broadcastState);
                    });



                   // debugPrint('RUI_M_business_list => BUSINESS LENGTH: ${businessListState.length}');

                    /*Stream<QuerySnapshot> _businessSnippetStream = FirebaseFirestore.instance.collection("business")
                        .where("businessId", whereIn: businessIdList.sublist(0, 10).doc()
                        .collection('service_list_snippet').snapshots(includeMetadataChanges: true);*/


                    return Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: broadcastListState.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                BroadcastState broadcast = broadcastListState.elementAt(index);

                                return Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: 8, right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          borderRadius: BorderRadius.all(Radius.circular(5)),
                                        onTap: () async {
                                          Navigator.push(context, EnterExitRoute(enterPage: CreateBroadcast(true, broadcast), exitPage: RBroadcastList(), from: true));
                                        },
                                        child: Container(
                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(left: 8),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          broadcast.body,
                                                          style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(top: 6),
                                                        child: Text(
                                                          DateFormat('dd/MM/yyyy').format(broadcast.timestamp),
                                                          style: TextStyle(
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                        ),
                                      )
                                  ),
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
