import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:BuyTime/UI/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/UI_U_Tabs.dart';
import 'package:BuyTime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reblox/reducer/user_reducer.dart';
import 'package:BuyTime/UI/user/login/UI_U_home.dart';
import 'package:BuyTime/reusable/buytime_widget.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;

class Tock extends CustomPainter {
  final Paint tock;

  Tock() : tock = new Paint() {
    tock.color = BuytimeTheme.Secondary;
    tock.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.translate(radius, radius);

    Path path = new Path();

    //Qui se si vuole si gestisce la testa della lancetta

    /* path.moveTo(0.0, -radius + 15.0);
    path.quadraticBezierTo(-3.5, -radius + 25.0, -15.0, -radius + radius / 4);
    path.quadraticBezierTo(
        -20.0, -radius + radius / 3, -7.5, -radius + radius / 3);
    path.lineTo(0.0, -radius + radius / 4);
    path.lineTo(7.5, -radius + radius / 3);
    path.quadraticBezierTo(
        20.0, -radius + radius / 3, 15.0, -radius + radius / 4);
    path.quadraticBezierTo(3.5, -radius + 25.0, 0.0, -radius + 15.0); */

    //Braccio lancetta
    path.moveTo(-1.0, -radius + radius / 4);
    path.lineTo(-5.0, -radius + radius / 2);
    path.lineTo(-2.0, 0.0);
    path.lineTo(2.0, 0.0);
    path.lineTo(5.0, -radius + radius / 2);
    path.lineTo(1.0, -radius);
    path.close();

    canvas.drawPath(path, tock);
    canvas.drawShadow(path, Colors.black, 2.0, false);
  }

  @override
  bool shouldRepaint(Tock oldDelegate) {
    return true;
  }
}

class CirclePainter extends CustomPainter {
  var wavePaint = Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.0
    ..isAntiAlias = true;
  var clock = Paint()
    ..color = Colors.orangeAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6.0
    ..isAntiAlias = true;
  var point_paint = Paint()
    ..color = Colors.blue
    ..strokeWidth = 4
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    final pointMode = PointMode.points;
    final points = [
      Offset(size.width / 2.0, size.height / 2.0),
    ];

    double centerX = size.width / 2.0;
    double centerY = size.height / 2.0;
    canvas.drawCircle(Offset(centerX, centerY), 60.0, wavePaint);
  }

  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Animation _arrowAnimation;
  AnimationController _arrowAnimationController;

  // Replace with server token from firebase console settings.
  String serverToken =
      'AAAA6xUtyfE:APA91bGHhEzVUY9fnj4FbTXJX57qcgF-8GBrfBbGIa8kEpEIdsXRgQxbtsvbhL-w-_MQYKIj0XVlSaDSf2s6O3D3SM3o-z_AZnHQwBNLiw1ygyZOuVAKa5YmXeu6Da9eBqRD9uwFHSPi';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': 'this is a body', 'title': 'this is a title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }

  static Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("Data");
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      if (!kIsWeb) {
        firebaseMessaging.requestNotificationPermissions();
        firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            print("onMessage: $message");
            var data = message['data'] ?? message;
            String orderId = data['orderId'];
            await StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
            );
          },
          onBackgroundMessage: myBackgroundMessageHandler,
          onLaunch: (Map<String, dynamic> message) async {
            print("onLaunch: $message");
            var data = message['data'] ?? message;
            String orderId = data['orderId'];
            await StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
            );
          },
          onResume: (Map<String, dynamic> message) async {
            print("onResume: $message");
            var data = message['data'] ?? message;
            String orderId = data['orderId'];
            await StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
            );
          },
        );
        firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
        firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
          print("Settings registered: $settings");
        });
        firebaseMessaging.getToken().then((String token) {
          assert(token != null);
          print("Token " + token);
          serverToken = token;
        });
      }
      Timer(Duration(seconds: 1), () => check_logged());
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });

    FirebaseMessaging().onTokenRefresh.listen((newToken) {
      // Save newToken
      serverToken = newToken;
    });

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    if (!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        }
      } on PlatformException {
        deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
      }
    } else {}

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  void check_logged() async {
    if (auth.FirebaseAuth != null &&
        auth.FirebaseAuth.instance != null &&
        auth.FirebaseAuth.instance.currentUser != null) {
      auth.User user = auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Sign out with google
        // Loggato e lo mando alla View Principale
        print("Ecco l'utente ----->>> " + user.email);
        String deviceId = "web";
        if (!kIsWeb) {
          try {
            if (Platform.isAndroid) {
              var build = await deviceInfoPlugin.androidInfo;
              deviceId = build.androidId; //UUID for Android
            } else if (Platform.isIOS) {
              var data = await deviceInfoPlugin.iosInfo;
              deviceId = data.identifierForVendor; //UUID for iOS
            }
          } on PlatformException {
            print('Failed to get platform version');
          }
        }
        print("Device ID : " + deviceId);
        StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, serverToken)));
        ObjectState field = ObjectState(name: "device", id: deviceId, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
        ObjectState token = ObjectState(name: "token", id: serverToken, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UI_U_Tabs()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _arrowAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double spinnerX = 120;
    // double spinnerY = 120;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // body: OldSplashScreen(spinnerX: spinnerX, spinnerY: spinnerY, arrowAnimationController: _arrowAnimationController, arrowAnimation: _arrowAnimation),
      body: Scaffold(
        backgroundColor: Color(0xFF207CC4),
        body: Container(
          margin: EdgeInsets.only(
            bottom: height / 5,
          ),
          child: Center(child: new Image.asset('assets/img/brand/logo.png', width: width * 0.7)),
        ),
      ),
    );
  }
}

class OldSplashScreen extends StatelessWidget {
  const OldSplashScreen({
    Key key,
    @required this.spinnerX,
    @required this.spinnerY,
    @required AnimationController arrowAnimationController,
    @required Animation arrowAnimation,
  })  : _arrowAnimationController = arrowAnimationController,
        _arrowAnimation = arrowAnimation,
        super(key: key);

  final double spinnerX;
  final double spinnerY;
  final AnimationController _arrowAnimationController;
  final Animation _arrowAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: BuytimeTheme.BackgroundWhite),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/img/img_buytime.png', width: 225),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),
                  Text(
                    "BuyTime",
                    style: TextStyle(
                        color: BuytimeTheme.UserPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BuyTimeSpinner(
                    spinnerX: spinnerX,
                    spinnerY: spinnerY,
                    arrowAnimationController: _arrowAnimationController,
                    arrowAnimation: _arrowAnimation),
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Text(
                  //Flutkart.store,
                  "Some Time to Buy",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18.0, color: BuytimeTheme.UserPrimary),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
