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