
import 'dart:async';
import 'dart:io';

import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/reblox/navigation/route_aware_widget.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'UI/management/broadcast/UI_M_create_broadcast.dart';
import 'UI/management/service_internal/RUI_M_service_list.dart';
import 'UI/management/service_internal/UI_M_hub_convention_edit.dart';
import 'UI/user/booking/RUI_U_notifications.dart';
import 'UI/user/category/UI_U_new_filter_by_category.dart';
import 'UI/user/service/UI_U_service_reserve.dart';
import 'UI/user/turist/RUI_U_service_explorer.dart';
import 'app_routes.dart';
import 'app_state.dart';
import 'combined_epics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:responsive_framework/responsive_framework.dart';


Future<void> main() async {
  // runZonedGuarded(() async {
    final epics = combinedEpics;
    final _initialState = appState;
    final store = new Store<AppState>(
      appReducer,
      initialState: _initialState,
      middleware: createNavigationMiddleware(epics),
    );
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

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
            ChangeNotifierProvider(create: (_) => Explorer(false, [], [], [], TextEditingController(), false, [], BusinessState().toEmpty(), [], '', [])),
            ChangeNotifierProvider(create: (_) => CategoryService([], [])),
            ChangeNotifierProvider(create: (_) => Broadcast([], Map())),
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
    debugPrint("main => MAIN PROD/DEV STRIPE CONFIGURATION : " + Environment().config.stripePublicKey);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    //SizeConfig().init(context);
    //ScreenUtil.init(bcontext, width: 1125, height: 2436, allowFontScaling: true);
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        // builder: (context, widget) => ResponsiveWrapper.builder(
        //     BouncingScrollWrapper.builder(context, widget),
        //     maxWidth: 1200,
        //     minWidth: 400,
        //     defaultScale: true,
        //     breakpoints: [
        //       ResponsiveBreakpoint.resize(450, name: MOBILE),
        //       ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //       ResponsiveBreakpoint.autoScale(1000, name: TABLET),
        //       ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        //       ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        //     ],
        //     background: Container(color: Color(0xFFF5F5F5))),
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

