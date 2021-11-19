import 'dart:async';
import 'dart:io';
import 'package:Buytime/UI/management/activity/RUI_M_activity_management.dart';
import 'package:Buytime/UI/user/booking/RUI_U_notifications.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main.dart';
import '../../splash_screen.dart';

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
class MessagingHelper {
  static String serverToken = '';

  void init(BuildContext context) async{
    final NotificationAppLaunchDetails notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
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
            ///Write the other cases for redirect user to  the right place
            debugPrint('main => notification payload: $payload');
            if(payload == 'New booking request!' || payload == 'New order accepted!'){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RActivityManagement()));
            }else{
              Navigator.push(context, MaterialPageRoute(builder: (context) => RNotifications(orderStateList: StoreProvider.of<AppState>(context).state.orderList.orderListState, tourist: false,)));
            }
          }
          selectNotificationSubject.add(payload);
        });
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void messagingManagement(FirebaseMessaging firebaseMessaging, BuildContext context) {
    _requestPermissions();
    firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);
    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      debugPrint("messaging_helper => token: " + token);
      serverToken = token;
    });
    firebaseMessaging.onTokenRefresh.listen((newToken) {
      serverToken = newToken;
    });
    firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    onMessageFirst(context);
    onMessage(context);
    onMessageOpenedApp(context);
  }
  void onMessageOpenedApp(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('messaging_helper => ON MESSAGE OPENED APP');
      RemoteNotification notification = message.notification;
      messageDataRetriveNotify(context, notification);
    });
  }
  void onMessage(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('mmessaging_helper => ON MESSAGE');
      RemoteNotification notification = message.notification;
      List<String> notificationBodyList = notification.body.split('|');
      bool can = false;
      if(notificationBodyList.isNotEmpty && notificationBodyList.length == 4)
        can = true;
      String customNotificationTime = '';
      if(can){
        DateTime notificationTime = DateTime.now();
        notificationTime = DateTime.fromMillisecondsSinceEpoch(int.parse(notificationBodyList[1]));
        customNotificationTime = DateFormat('E, dd/M/yyyy, HH:mm').format(notificationTime);
      }
      if(Platform.isAndroid)
      {
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notificationBodyBuilder(can, notificationBodyList, customNotificationTime, notification, context),
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: android?.smallIcon,
                ),
              ),
            payload: notification.title
          );
          messageDataRetriveNotify(context, notification);
        }
      }
      else if(Platform.isIOS)
      {
        AppleNotification apple = message.notification?.apple;
        if (notification != null && apple != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                iOS: IOSNotificationDetails(sound: 'slow_spring_board.aiff'),
              ),
              payload: notification.title);
          messageDataRetriveNotify(context, notification);
        }
      }
    });
  }

  String notificationBodyBuilder(bool can, List<String> notificationBodyList, String customNotificationTime, RemoteNotification notification, BuildContext context) {
    if (can) {
      if (notificationBodyList[3] == 'orderPaid') {
        return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenPaid}, € ${notificationBodyList[2]}';
      } else if (notificationBodyList[3] == 'paymentError') {
          return '${AppLocalizations.of(context).thePaymentFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenRefusedMethod}';
      } else if (notificationBodyList[3] == 'acceptedBuyer') {
          return '${notificationBodyList[0]}  ${AppLocalizations.of(context).on} $customNotificationTime';
      } else if (notificationBodyList[3] == 'declinedBuyer') {
          return '${AppLocalizations.of(context).unfortunatelyYourBooking} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasNotBeenAccepted}';
      } else if (notificationBodyList[3] == 'canceledBuyer') {
          return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCanceledFor} ${notificationBodyList[4]} ${AppLocalizations.of(context).aRefundFor} €${notificationBodyList[2]} ${AppLocalizations.of(context).hasBeenInitiated}';
      } else if (notificationBodyList[3] == 'canceledBusiness') {
          return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCanceledRefundFor} €${notificationBodyList[2]} ${AppLocalizations.of(context).hasBeenPaid}';
      } else if (notificationBodyList[3] == 'createdAutoAcceptedBusiness') {
          return '${AppLocalizations.of(context).aNewOrder} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCreated}';
      } else if (notificationBodyList[3] == 'actionRequiredBusiness') {
          return '${AppLocalizations.of(context).aNewRequestFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).needsConfirmation} ';
      }
    }
    return notification.body;
  }

  void onMessageFirst(BuildContext context) {
    FirebaseMessaging.onMessage.first.then((message) => () {
      debugPrint('messaging_helper => ON MESSAGE FIRST');
      RemoteNotification notification = message.notification;
      messageDataRetriveNotify(context, notification);
    });
  }
  void messageDataRetriveNotify(BuildContext context, RemoteNotification notification) {
    StoreProvider.of<AppState>(context).dispatch(UserOrderListRequest());
    StoreProvider.of<AppState>(context).dispatch(RequestNotificationList(StoreProvider.of<AppState>(context).state.user.uid, StoreProvider.of<AppState>(context).state.business.id_firestore));
    // notifyFlushbar(notification.title, context);
  }
  Flushbar notifyFlushbar(String message, BuildContext context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20),
      borderRadius: BorderRadius.all(Radius.circular(8)),
      backgroundColor: BuytimeTheme.SymbolLightGrey,
      onTap: (ciao) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RNotifications(orderStateList: StoreProvider.of<AppState>(context).state.orderList.orderListState, tourist: false,)));
      },
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      messageText: Text(
        message,
        style: TextStyle(color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    )..show(context);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (message.data.containsKey('data')) {
      final dynamic data = message.data['data'];
      debugPrint("messaging_helper => data: " + data);
    }
    if (message.data.containsKey('notification')) {
      final dynamic notification = message.data['notification'];
      debugPrint("messaging_helper => notification: " + notification);
    }
  }
}






