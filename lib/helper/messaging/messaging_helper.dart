import 'dart:async';
import 'dart:io';
import 'package:Buytime/UI/user/booking/RUI_U_notifications.dart';
import 'package:Buytime/utils/size_config.dart';
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

import '../../main.dart';

class MessagingHelper {
  static String serverToken = '';

  void messagingManagement(FirebaseMessaging firebaseMessaging, BuildContext context) {
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
      if(Platform.isAndroid)
      {
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: android?.smallIcon,
                ),
              ));
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
              ));
          messageDataRetriveNotify(context, notification);
        }
      }
    });
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






