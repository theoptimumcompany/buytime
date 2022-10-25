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

import 'dart:async';
import 'dart:io';

import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/navigation/route_aware_widget.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'UI/management/service_internal/RUI_M_service_list.dart';
import 'UI/user/service/UI_U_service_reserve.dart';
import 'UI/user/turist/RUI_U_service_explorer.dart';
import 'app_routes.dart';
import 'app_state.dart';
import 'combined_epics.dart';

void main() {
  // runZonedGuarded(() async {
    final epics = combinedEpics;
    final _initialState = appState;
    final store = new Store<AppState>(
      appReducer,
      initialState: _initialState,
      middleware: createNavigationMiddleware(epics),
    );
    WidgetsFlutterBinding.ensureInitialized();
    const String environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: Environment.PROD,
    );
    Environment().initConfig(environment);
    runApp(
        MultiProvider(
          providers: [
            //ChangeNotifierProvider(create: (_) => NavigationState()),
            ChangeNotifierProvider(create: (_) => Spinner(true, [], [], [])),
            ChangeNotifierProvider(create: (_) => ReserveList([], OrderReservableState().toEmpty(),[], [], [], [])),
            ChangeNotifierProvider(create: (_) => Explorer(false, [])),
          ],
          child: Buytime(store: store),
        ));
  // }, (Object error, StackTrace stack) {
  //   Container(child: Text(error.toString() + stack.toString()),);
  //   exit(1);
  // });
}

class Buytime extends StatelessWidget {
  final Store<AppState> store;

  Buytime({this.store});

  MaterialPageRoute _getRoute(RouteSettings settings) {
    return appRoutes(settings);
  }


  @override
  Widget build(BuildContext context) {
    print("MAIN PROD/DEV STRIPE CONFIGURATION : " + Environment().config.stripePublicKey);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    //SizeConfig().init(context);
    //ScreenUtil.init(bcontext, width: 1125, height: 2436, allowFontScaling: true);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('it', ''),
          const Locale('es', ''),
          const Locale('ca', ''),
          const Locale('de', ''),
          const Locale('fr', ''),
        ],
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
        title: 'Buytime',
        debugShowCheckedModeBanner: false,
        theme: BuytimeTheme().userTheme,
        home: SplashScreen() /*LogConsoleOnShake(
          dark: true,
          child: SplashScreen(),
        )*/
        ,
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          /*'/home': (BuildContext context) => Home(),
          '/login': (BuildContext context) => Login(),
          '/registration': (BuildContext context) => Registration(),
          '/orderDetail': (BuildContext context) => UI_U_OrderDetail(),
          '/tabs': (BuildContext context) => UI_U_Tabs(),
          '/bookingDetails': (BuildContext context) => BookingDetails(),*/
        },
        //onGenerateRoute: ,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

