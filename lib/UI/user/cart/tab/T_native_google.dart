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

import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NativeGoogle extends StatefulWidget {
  bool tourist = false;
  NativeGoogle({Key key, this.tourist = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NativeGoogleState();
}

class NativeGoogleState extends State<NativeGoogle> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 5),
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  ///Pay with Google Pay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            AppLocalizations.of(context).payWithGooglePay,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontFamily: BuytimeTheme.FontFamily,
                              color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
