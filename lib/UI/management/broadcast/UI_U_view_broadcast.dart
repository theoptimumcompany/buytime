import 'package:Buytime/UI/management/business/RUI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/user/turist/widget/new_p_r_card_widget.dart';
import 'package:Buytime/reblox/model/broadcast/broadcast_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
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
import 'package:another_flushbar/flushbar.dart';
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
import 'package:provider/provider.dart';

class ViewBroadcast extends StatefulWidget {
  static String route = '/createBroadcast';
  BroadcastState broadcastState;
  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Broadcast>(
      create: (_) => Broadcast([], Map()),
      child: ViewBroadcast(this.broadcastState),
    );
  }
  ViewBroadcast(this.broadcastState);
  @override
  State<StatefulWidget> createState() => ViewBroadcastState();
}

class ViewBroadcastState extends State<ViewBroadcast> {

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
  List<ServiceState> serviceList = [];

  @override
  void initState() {
    super.initState();
    emptyCategoryInvite();
    if(widget.broadcastState.senderId.isNotEmpty)
      messageController.text = widget.broadcastState.body;
    //initDynamicLinks();

  }

  TextEditingController messageController = TextEditingController();
  bool sending = false;


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.state.serviceList.serviceListState.clear();

        store.dispatch(ServiceListRequestByIds(widget.broadcastState.serviceIdList));
        noActivity = true;
        startRequest = true;

      },
      builder: (context, snapshot) {
        Locale myLocale = Localizations.localeOf(context);
        //print("UI_M_Business => Categories : ${snapshot.serviceListSnippetState.businessSnippet}");
        /*if(snapshot.serviceListSnippetState.businessSnippet != null && snapshot.serviceListSnippetState.businessSnippet.isNotEmpty){
          categories = snapshot.serviceListSnippetState.businessSnippet;
        }*/
        //debugPrint('UI_M_slot_management => IMPORTED SERVICE LENGTH: ${snapshot.externalServiceImportedListState.externalServiceImported.length}');

        if(snapshot.serviceList.serviceListState.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(snapshot.serviceList.serviceListState.isNotEmpty){
            //serviceList.clear();
            print("UI_M_crate_broadcast => Service List Length: ${snapshot.serviceList.serviceListState.length}");
            serviceList = snapshot.serviceList.serviceListState;
            if(serviceList.first.serviceId.isNotEmpty){
              serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
            }else{
              serviceList.removeLast();
            }

            //serviceList.sort((a,b) => a.name.compareTo(b.name));
            noActivity = false;
            startRequest = false;
          }
        }
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              key: _drawerKeyTabs,
              appBar: AppBar(
                backgroundColor: Colors.white,
                brightness: Brightness.dark,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  //key: Key('business_drawer_key'),
                  icon: const Icon(
                    Icons.close,
                    color: BuytimeTheme.TextBlack,
                    //size: 30.0,
                  ),
                  //tooltip: AppLocalizations.of(context).showMenu,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    //maxHeight: SizeConfig.safeBlockVertical * 92.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ///TextFiled
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 16),
                          child: Text(
                            widget.broadcastState.body,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                      ),
                      noActivity ? Container(
                        margin: EdgeInsets.only(top: 12),
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
                      ) :
                      Container(
                        //height: double.infinity,
                          width: double.infinity,
                          //height: SizeConfig.safeBlockVertical * 100,
                          //alignment: Alignment.center,
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
                          child: CustomScrollView(
                              physics: new ClampingScrollPhysics(),
                              //controller: popularScoller,
                              shrinkWrap: true, scrollDirection: Axis.vertical, slivers: [
                            SliverGrid(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //maxCrossAxisExtent: SizeConfig.screenWidth/2,
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 0.0,
                                  mainAxisExtent: 228
                                //childAspectRatio: .77,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  //MenuItemModel menuItem = menuItems.elementAt(index);
                                  ServiceState service = serviceList.elementAt(index);
                                  return NewPRCardWidget(182, 182, service, false, true, index, 'Popular')
                                  /*Container(
                                          height: 300,
                                          width: 182,
                                          child: PRCardWidget(182, 182, service, false, true, index, 'popular'),
                                        )*/;
                                },
                                childCount: serviceList.length,
                              ),
                            ),
                          ])
                      )
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

class Broadcast with ChangeNotifier{
  List<ServiceState> serviceList;
  Map<String, bool> serviceSelected;
  Broadcast(this.serviceList, this.serviceSelected);


  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('RUI_U_service_explorer => SERVICE LIST INIT');
    notifyListeners();
  }

  clear(){
    this.serviceList.clear();
    this.serviceSelected.clear();
    notifyListeners();
  }

}
