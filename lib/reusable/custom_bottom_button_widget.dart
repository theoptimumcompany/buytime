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
import 'package:flutter/material.dart';

class CustomBottomButtonWidget extends StatefulWidget {

  Widget topString;
  String bottomString;
  Widget icon;
  CustomBottomButtonWidget(this.topString, this.bottomString, this.icon);

@override
_CustomBottomButtonWidgetState createState() => _CustomBottomButtonWidgetState();
}

class _CustomBottomButtonWidgetState extends State<CustomBottomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 375,
      height: 64,
      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.topString,
                    widget.bottomString.isNotEmpty ? Container(
                      child: Text(
                        widget.bottomString,
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: BuytimeTheme.TextBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 14
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: widget.icon,
              )
            ],
          ),
          Container(
            width: double.infinity,
            //margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
            height: SizeConfig.safeBlockVertical * .2,
            color: BuytimeTheme.DividerGrey,
          )
        ],
      ),
    );
  }
}