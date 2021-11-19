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

class CreateBroadcast extends StatefulWidget {
  static String route = '/createBroadcast';

  @override
  State<StatefulWidget> createState() => CreateBroadcastState();
}

class CreateBroadcastState extends State<CreateBroadcast> {

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

  TextEditingController messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    SizeConfig().init(context);


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _drawerKeyTabs,
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.dark,
            elevation: 0,
            title: Text(
              AppLocalizations.of(context).businessManagement,
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
          drawer: ManagerDrawer(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: TextFormField(
                  controller: messageController,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //labelText: AppLocalizations.of(context).writeSomething,
                    //helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                    hintText:AppLocalizations.of(context).writeSomething,
                    hintStyle: TextStyle(
                        color: Color(0xff666666),
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      fontFamily: BuytimeTheme.FontFamily
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
                  ),
                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                  onEditingComplete: () {
                    debugPrint('UI_M_add_external_service_list => done');
                    FocusScope.of(context).unfocus();

                  },
                ),
              )
            ],
          )
      ),
    );
  }
}
