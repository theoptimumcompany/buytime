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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

// ignore: must_be_immutable
class DashboardCard extends StatefulWidget {

  Color background;
  Icon icon;
  String count;
  String type;
  bool filter;
  OnFilterActive filterActive;
  DashboardCard({Key key, this.background, this.icon, this.count, this.type, this.filter, this.filterActive}) : super(key: key);

  @override
  _DashboardCardState createState() => _DashboardCardState();
}
typedef OnFilterActive = void Function(bool filter);

class _DashboardCardState extends State<DashboardCard> {

  String bookingStatus = '';
  bool closed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 100, ///SizeConfig.safeBlockVertical * 28
      width: 154, ///SizeConfig.safeBlockHorizontal * 80
      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.safeBlockHorizontal * 1),
      decoration: BoxDecoration(
          color: widget.background,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black.withOpacity(.3),
          onTap: (){
            widget.filterActive(!widget.filter);
          },
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Container(
            height: 100, ///SizeConfig.safeBlockVertical * 25
            width: 154, ///SizeConfig.safeBlockHorizontal * 50
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Icon & Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Icon
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                      child: widget.icon,
                    ),
                    ///Count
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                      child: Text(
                          widget.count,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 0.18,
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextWhite
                        ),
                      ),
                    )
                  ],
                ),
                ///Type
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                      child: Text(
                          widget.type,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            letterSpacing: 0.25,
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextWhite
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

