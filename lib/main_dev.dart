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

// import 'package:Buytime/app_routes.dart';
// import 'package:Buytime/environment_abstract.dart';
// import 'package:Buytime/utils/theme/buytime_theme.dart';
// import 'package:Buytime/reblox/model/app_state.dart';
// import 'package:Buytime/reblox/reducer/app_reducer.dart';
// import 'package:Buytime/reblox/navigation/route_aware_widget.dart';
// import 'package:Buytime/splash_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
// import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'app_state.dart';
// import 'combined_epics.dart';
//
// void main() {
//   final epics = combinedEpics;
//   final _initialState = appState;
//   final store = new Store<AppState>(
//     appReducer,
//     initialState: _initialState,
//     middleware: createNavigationMiddleware(epics),
//   );
//
//   // Ensure that plugin services are initialized so that `availableCameras()`
// // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();
//
//   const String environment = String.fromEnvironment(
//     'ENVIRONMENT',
//     defaultValue: Environment.DEV,
//   );
//
//   Environment().initConfig(environment);
//
//   runApp(
//       Buytime(store: store)
//   );
//   //log();
// }
//
// class Buytime extends StatelessWidget {
//   final Store<AppState> store;
//
//   Buytime({this.store});
//
//   MaterialPageRoute _getRoute(RouteSettings settings) {
//     return appRoutes(settings);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     debugPrint("main => MAIN DEV STRIPE CONFIGURATION : " + Environment().config.stripePublicKey);
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//     //SizeConfig().init(context);
//     //ScreenUtil.init(bcontext, width: 1125, height: 2436, allowFontScaling: true);
//     return StoreProvider<AppState>(
//       store: store,
//       child: MaterialApp(
//         localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
//         supportedLocales: [
//           /// NOTE: IMPORTANT: IF YOU ADD A LANGUAGE HERE YOU ALSO HAVE TO ADD IN THE OTHER main_**.dart files!!
//           const Locale('en', ''),
//           const Locale('it', ''),
//           const Locale('es', ''),
//           const Locale('ca', ''),
//           const Locale('de', ''),
//           const Locale('fr', ''),
//         ],
//         navigatorKey: navigatorKey,
//         navigatorObservers: [routeObserver],
//         onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
//         title: 'Buytime',
//         debugShowCheckedModeBanner: true,
//         theme: BuytimeTheme().userTheme,
//         home: SplashScreen() /*LogConsoleOnShake(
//           dark: true,
//           child: SplashScreen(),
//         )*/
//         ,
//         routes: <String, WidgetBuilder>{
//           // Set routes for using the Navigator.
//           /*'/home': (BuildContext context) => Home(),
//           '/login': (BuildContext context) => Login(),
//           '/registration': (BuildContext context) => Registration(),
//           '/orderDetail': (BuildContext context) => UI_U_OrderDetail(),
//           '/tabs': (BuildContext context) => UI_U_Tabs(),
//           '/bookingDetails': (BuildContext context) => BookingDetails(),*/
//         },
//         //onGenerateRoute: ,
//       ),
//     );
//   }
// }
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
