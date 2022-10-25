/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/UI/management/business/UI_M_create_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'RUI_M_business_list.dart';

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
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store){
          print("Oninitbusinesslist");
          store.state.serviceListSnippetListState.serviceListSnippetListState.clear();
          store.state.businessList.businessListState.clear();
          store.dispatch(BusinessListRequest(store.state.user.uid, store.state.user.getRole(), 150));
          startRequest = true;
          },
        builder: (context, snapshot) {
          businessListState = snapshot.businessList.businessListState;
          if (businessListState.isEmpty && startRequest) {
            noActivity = true;
            startRequest = false;
          } else {
            if(businessListState.isNotEmpty && businessListState.first.name == null){
              businessListState.removeLast();
            }

            if(!generated){
              generated = true;
              debugPrint('UI_M_business_list => REQUEST SNIPPET');
              StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetListRequest(businessListState));
            }
            if(snapshot.serviceListSnippetListState.serviceListSnippetListState.isNotEmpty){
              debugPrint('UI_M_business_list => BUSINESS SNIPPETS: ${snapshot.serviceListSnippetListState.serviceListSnippetListState.length}');
              if(snapshot.serviceListSnippetListState.serviceListSnippetListState.first.businessId == null){
                startRequest = false;
                snapshot.serviceListSnippetListState.serviceListSnippetListState.removeLast();
              }

                for(int i = 0; i < businessListState.length; i++){
                  networkServicesList.add(0);
                  if(snapshot.serviceListSnippetListState.serviceListSnippetListState.isNotEmpty && snapshot.serviceListSnippetListState.serviceListSnippetListState.first.businessId != null) {
                    snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((element) {
                      if(businessListState[i].id_firestore == element.businessId){
                        int networkServices = 0;
                        networkServices = element.businessServiceNumberInternal + element.businessServiceNumberExternal;
                        networkServicesList.last = networkServices;
                      }
                    });
                  }

                }
                if(networkServicesList.length == businessListState.length)
                  noActivity = false;
              }

            //startRequest = false;
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
                          Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateBusiness(), exitPage: UI_M_BusinessList(), from: true));
                        },
                      ),
                    ) :  SizedBox(
                      width: 56.0,
                    ),
                  ],
                ),
                drawer: ManagerDrawer(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    businessListState != null && businessListState.length > 0 && networkServicesList.isNotEmpty?
                    Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: businessListState.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 1.0),
                                  child: new OptimumBusinessCardMediumManager(
                                    businessState: businessListState[index],
                                    networkServices: networkServicesList[index] ?? 0,
                                    onBusinessCardTap: (BusinessState businessState) async{
                                      StoreProvider.of<AppState>(context).dispatch(SetBusiness(businessListState[index]));
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                                      Navigator.push(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: RBusinessList(), from: true));
                                    },
                                    imageUrl: businessListState[index].profile,
                                    mediaSize: media,
                                  ),
                                );
                              }
                          )

                      ),
                    ): noActivity
                        ? Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                        )
                      ],
                    ))
                        : Container(
                      height: SizeConfig.safeBlockVertical * 8,
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                  ],
                )),
          );
        });
  }
}
