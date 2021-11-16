import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/material.dart';

class BuytimeTheme {

  ///Primary Color
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

  ///Custom Colors ordered as Figma
  //static const Color ManagerPrimary = Color.fromARGB(255, 0, 103, 145);
  static const MaterialColor ManagerPrimary = MaterialColor(0xFF006791, managerPrimarySwatch);
  static const MaterialColor ManagerPrimary2 = MaterialColor(0xFF006791, managerPrimarySwatch2);
  static const Map<int, Color> managerPrimarySwatch =  {
    900: Color.fromARGB(255, 0, 103, 145),
  };
  static const Map<int, Color> managerPrimarySwatch2 =  {
    900: Color.fromARGB(255, 0, 50, 145),
  };
  static const Color Secondary = Color.fromARGB(255, 253, 192, 47);
  static const Color TextDark = Color.fromARGB(255, 16, 5, 14);
  static const Color TextMedium = Color.fromARGB(255, 117, 117, 117);
  static const Color PrimaryMalibu = Color.fromARGB(255, 32, 124, 195);
  static const Color ActionButton = Color.fromARGB(255, 1, 175, 81);
  static const Color ActionBlackPurple = Color.fromARGB(255, 37, 30, 42);
  static const Color AccentRed = Color.fromARGB(255, 255, 99, 99);
  static const Color BackgroundCerulean = Color.fromARGB(255, 119, 148, 170);
  static const Color BackgroundLightGrey = Color.fromARGB(255, 237, 237, 237);
  static const Color BackgroundSoftGrey = Color.fromARGB(255, 243, 243, 243);
  static const Color BackgroundLightBlue = Color.fromARGB(255, 118, 216, 237);
  static const Color DividerGrey = Color.fromARGB(255, 237, 237, 237);
  static const Color BackgroundWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color SymbolWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color ButtonWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color TextWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color TextMalibu = Color.fromARGB(255, 32, 124, 195);
  static const Color SymbolMalibu = Color.fromARGB(255, 32, 124, 195);
  static const Color TextBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color SymbolBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color ButtonMalibu = Color.fromARGB(255, 32, 124, 195);
  static const Color TextGrey = Color.fromARGB(255, 114, 114, 114);
  static const Color SymbolGrey = Color.fromARGB(255, 117, 117, 117);
  static const Color TextLightGrey = Color.fromARGB(255, 237, 237, 237);
  static const Color TextPurple = Color.fromARGB(255, 186, 104, 200);
  static const Color SymbolPurple = Color.fromARGB(255, 186, 104, 200);
  static const Color BackgroundBlack = Color.fromARGB(255, 0, 0, 0);
  static const Color SymbolLime = Color.fromARGB(255, 175, 180, 43);
  static const Color BackgroundAntracite = Color.fromARGB(255, 33, 33, 33);
  static const Color ErrorRed = Color.fromARGB(255, 251, 36, 36);
  static const Color SymbolLightGrey = Color.fromARGB(255, 196, 196, 196);
  static const Color Indigo = Color.fromARGB(255, 121, 134, 203);
  static const Color GreenChoice = Color.fromARGB(255, 1, 191, 165);
  static const Color Promotion = Color.fromARGB(255, 251, 36, 36);






  static const String FontFamily = 'Inter';

  static const TextTheme themeText =  TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.normal),
    headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
    bodyText2: TextStyle(fontSize: 14.0, fontFamily: FontFamily, fontStyle: FontStyle.normal),
  );

  static TextStyle whiteTitle = TextStyle(
      fontFamily: FontFamily,
      fontSize: 32, //SizeConfig.safeBlockVertical * 5
      fontWeight: FontWeight.w400,
      color: Colors.white
  );

  static TextStyle whiteSubtitle = TextStyle(
      fontFamily: FontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.white
  );

  static TextStyle appbarTitle = TextStyle(
      fontFamily: FontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      //letterSpacing: 0.15,
      color: TextWhite
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