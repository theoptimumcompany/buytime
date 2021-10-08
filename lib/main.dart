
import 'dart:async';
import 'dart:io';

import 'package:Buytime/environment_abstract.dart';
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
import 'UI/management/service_internal/RUI_M_service_list.dart';
import 'UI/management/service_internal/UI_M_hub_convention.dart';
import 'UI/user/service/UI_U_service_reserve.dart';
import 'UI/user/turist/RUI_U_service_explorer.dart';
import 'app_routes.dart';
import 'app_state.dart';
import 'combined_epics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
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
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    var initialzationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
            ) async {
          didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
            ChangeNotifierProvider(create: (_) => Convention(false, [])),
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

