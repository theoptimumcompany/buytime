import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/UI/user/category/UI_U_new_filter_by_category.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/app_state.dart';
import 'package:Buytime/combined_epics.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/navigation/navigation_middleware.dart';
import 'package:Buytime/reblox/reducer/app_reducer.dart';
import 'package:Buytime/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:integration_test/integration_test.dart';
import 'package:Buytime/main.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
  debugPrint('main => ${message.data}');
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

class RegressionUtils{

  ///Load Application
  Future<void> loadApp(WidgetTester tester) async {
    final epics = combinedEpics;
    final _initialState = appState;
    final store = new Store<AppState>(
      appReducer,
      initialState: _initialState,
      middleware: createNavigationMiddleware(epics),
    );

    WidgetsFlutterBinding.ensureInitialized();

    final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
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
    debugPrint('main => User granted permission: ${settings.authorizationStatus}');
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
    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            debugPrint('notification payload: $payload');
          }
          selectNotificationSubject.add(payload);
        });

    const String environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: Environment.PROD,
    );
    Environment().initConfig(environment);
    ///App Load
    await tester.pumpWidget(MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (_) => NavigationState()),
        ChangeNotifierProvider(create: (_) => Spinner(true,[],[], [])),
        ChangeNotifierProvider(create: (_) => ReserveList([], OrderReservableState().toEmpty(),[], [], [], [])),
        ChangeNotifierProvider(create: (_) => Explorer(false, [], [], [], TextEditingController(), false, [], BusinessState().toEmpty(), [], '', [])),
        ChangeNotifierProvider(create: (_) => CategoryService([], [])),
      ],
      child: Buytime(store: store),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  ///User Login
  Future<void> login(WidgetTester tester, String email, String password) async {
    await tester.tap(find.byKey(ValueKey('home_login_key')));
    //await tester.tap(find.text('Log In'.toUpperCase()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.enterText(find.byKey(ValueKey('email_key')), email);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.enterText(find.byKey(ValueKey('password_key')), password);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byKey(ValueKey('login_key')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  Future<void> touristLogin(WidgetTester tester, String email, String password) async {
    await tester.enterText(find.byKey(ValueKey('email_key')), email);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.enterText(find.byKey(ValueKey('password_key')), password);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byKey(ValueKey('login_key')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  ///User Registration
  Future<void> register(WidgetTester tester, String email, String password) async {
    await tester.tap(find.byKey(ValueKey('home_register_key')));
    //await tester.tap(find.text('Register'.toUpperCase()));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.enterText(find.byKey(ValueKey('email_key')), email);
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.enterText(find.byKey(ValueKey('password_key')), password);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.byKey(ValueKey('eye_key')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.flingFrom(Offset(0, 400), Offset(0, -500), 1500);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byKey(ValueKey('registration_key')));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
}