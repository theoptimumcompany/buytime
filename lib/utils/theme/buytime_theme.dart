import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/material.dart';

class BuytimeTheme {

  static const MaterialColor UserPrimary = MaterialColor(0xFF019FE0, userPrimarySwatch);
  static const Map<int, Color> userPrimarySwatch =  {
    50: Color.fromRGBO(225, 243, 251, 1.0),
    100: Color.fromRGBO(179, 226, 246, 1.0),
    200: Color.fromRGBO(128, 207, 240, 1.0),
    300: Color.fromRGBO(77, 188, 233, 1.0),
    400: Color.fromRGBO(39, 173, 229, 1.0),
    500: Color.fromRGBO(34, 159, 224, 1.0),
    600: Color.fromRGBO(31, 151, 220, 1.0),
    700: Color.fromRGBO(28, 141, 215, 1.0),
    800: Color.fromRGBO(24, 131, 211, 1.0),
    900: Color.fromRGBO(16, 114, 203, 1.0),
  };


  static const Color TextWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color TextDark = Color.fromARGB(255, 16, 5, 14);
  static const Color TextMedium = Color.fromARGB(255, 117, 117, 117);
  static const Color IconGrey = Color.fromARGB(255, 117, 117, 117);
  static const Color BackgroundWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color BackgroundCerulean = Color.fromARGB(255, 119, 148, 170);
  static const Color BackgroundLightGrey = Color.fromARGB(255, 237, 237, 237);
  static const Color DividerGrey = Color.fromARGB(255, 196, 196, 196);
  static const Color ManagerPrimary = Color.fromARGB(255, 0, 103, 145);
  static const Color Secondary = Color.fromARGB(255, 253, 192, 47);
  static const Color AccentRed = Color.fromARGB(255, 255, 99, 99);

  static const String FontFamily = 'Roboto';

  static const TextTheme themeText =  TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.normal),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: FontFamily, fontStyle: FontStyle.normal),
  );

  static TextStyle whiteTitle = TextStyle(
      fontFamily: FontFamily,
      fontSize: SizeConfig.safeBlockVertical * 5,
      fontWeight: FontWeight.normal,
      color: Colors.white
  );

  static TextStyle whiteSubtitle = TextStyle(
      fontFamily: FontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );

  static const TextStyle menuEntry = TextStyle(
    color: TextMedium,
    // fontSize: media.height * 0.025,
  );

  get managerTheme => ThemeData(
    primarySwatch: ManagerPrimary,
    appBarTheme: AppBarTheme(brightness: Brightness.light, color: TextDark),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: TextMedium),
      labelStyle: TextStyle(color: TextMedium),
    ),
    fontFamily: BuytimeTheme.FontFamily,
    textTheme: BuytimeTheme.themeText,
    brightness: Brightness.light,
    canvasColor: BackgroundWhite,
    accentColor: Secondary,
    accentIconTheme: IconThemeData(color: Colors.white),
  );

  get userTheme => ThemeData(
    primarySwatch: UserPrimary,
    fontFamily: BuytimeTheme.FontFamily,
    textTheme: BuytimeTheme.themeText,
    appBarTheme:
    AppBarTheme(brightness: Brightness.light, color: TextDark,),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: TextMedium),
      labelStyle: TextStyle(color: TextMedium),
    ),
    canvasColor: BackgroundWhite,
    brightness: Brightness.light,
    accentColor: Secondary,
    accentIconTheme: IconThemeData(color: Colors.black),
  );
}