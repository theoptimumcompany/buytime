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

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExternalServiceShowcase extends StatefulWidget {
  List<CategoryState> categoryRootList;

  ExternalServiceShowcase({this.categoryRootList});

  @override
  State<StatefulWidget> createState() => ExternalServiceShowcaseState();
}

class ExternalServiceShowcaseState extends State<ExternalServiceShowcase> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ///External Services
          Container(
              margin: EdgeInsets.only(left: 20.0, top: 15.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
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
                  InkWell(
                    onTap: () {
                      Navigator.push(context, EnterExitRoute(enterPage: ExternalServiceList(), exitPage: UI_M_Business(), from: true));
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

          ///Categories list & Invite user
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1)),
                  child: Container(
                    height: SizeConfig.screenHeight * 0.1,
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context).thereAreNoExternalServicesAttached,
                        style: TextStyle(fontWeight: FontWeight.w500, fontFamily: BuytimeTheme.FontFamily, fontSize: 13, color: BuytimeTheme.TextBlack,),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
