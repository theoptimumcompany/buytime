import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_M_BusinessList extends StatefulWidget {
  static String route = '/businessList';

  @override
  State<StatefulWidget> createState() => UI_M_BusinessListState();
}

class UI_M_BusinessListState extends State<UI_M_BusinessList> {
  List<BusinessState> businessListState;
  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

  bool startRequest = false;
  bool noActivity = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    return StoreConnector<AppState, BusinessListState>(
        converter: (store) => store.state.businessList,
        onInit: (store) => {print("Oninitbusinesslist"), store.dispatch(BusinessListRequest(store.state.user.uid, store.state.user.getRole())), startRequest = true},
        builder: (context, snapshot) {
          if (snapshot.businessListState.isEmpty && startRequest) {
            noActivity = true;
          } else {
            noActivity = false;
          }
          businessListState = snapshot.businessListState;
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
                    Padding(
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
                          Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateBusiness(), exitPage: UI_M_BusinessList(), from: true));
                        },
                      ),
                    ),
                  ],
                ),
                drawer: UI_M_BusinessListDrawer(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: businessListState != null && businessListState.length > 0
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: businessListState.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: new OptimumBusinessCardMediumManager(
                                      businessState: businessListState[index],
                                      onBusinessCardTap: (BusinessState businessState) {
                                        StoreProvider.of<AppState>(context).dispatch(SetBusiness(businessListState[index]));
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                                        Navigator.push(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: UI_M_BusinessList(), from: true));
                                      },
                                      imageUrl: businessListState[index].profile,
                                      mediaSize: media,
                                    ),
                                  );
                                })
                            : noActivity
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                                      )
                                    ],
                                  )
                                : Container(
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
                                  ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
