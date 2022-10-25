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
import 'package:flutter/material.dart';

class W_GreenChoice extends StatefulWidget {
  bool onlyIcon;
  W_GreenChoice(this.onlyIcon);
  @override
  _W_GreenChoiceState createState() => _W_GreenChoiceState();
}

class _W_GreenChoiceState extends State<W_GreenChoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        //width: 130,

        ///SizeConfig.safeBlockHorizontal * 40
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: BuytimeTheme.GreenChoice,
        ),
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage('assets/img/ecoWhite.png')),
              !widget.onlyIcon ?
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  AppLocalizations.of(context).greenChoice.toUpperCase(),
                  style: TextStyle(color: BuytimeTheme.TextWhite, fontSize: 12, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.bold, letterSpacing: 1.25),
                ),
              ) : Container(),
            ],
          ),
        ));
  }
}
