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

import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double safeAreaHorizontal;
  static double safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    //debugPrint('Screen width: ' + screenWidth.toString());
    screenHeight = _mediaQueryData.size.height;
    //debugPrint('Screen height: ' + screenHeight.toString());
    blockSizeHorizontal = screenWidth / 100;
    //debugPrint('Screen block H: ' + blockSizeHorizontal.toString());
    blockSizeVertical = screenHeight / 100;
    //debugPrint('Screen block V: ' + blockSizeVertical.toString());

    safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    //debugPrint('Screen safe H: ' + safeAreaHorizontal.toString());
    safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    //debugPrint('Screen safe V: ' + safeAreaVertical.toString());
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    //debugPrint('Screen safe block H: ' + safeBlockHorizontal.toString());
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
    //debugPrint('Screen safe block V: ' + safeBlockVertical.toString());
  }
}