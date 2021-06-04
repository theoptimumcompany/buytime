import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/snippet/device.dart';
import 'package:Buytime/reblox/model/snippet/token.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/area_list_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/notification_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'UI/user/booking/RUI_U_notifications.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print('state = $state');
  //   if (state == AppLifecycleState.paused) {
  //     StatisticsState().log('PAUSED', StoreProvider.of<AppState>(context).state.statistics);
  //     StatisticsState().writeToStorage(StoreProvider.of<AppState>(context).state.statistics);
  //   }
  // }
  StatisticsState statisticsState;

  readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setBool('first_run', true);
    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();

      await storage.deleteAll();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      prefs.setBool('first_run', false);
    }
    // statisticsState = await StatisticsState().readFromStorage();
    // StatisticsState().log('INITIALIZE', statisticsState);
    // StoreProvider.of<AppState>(context).dispatch(UpdateStatistics(statisticsState));

    List<CardState> cards = await CardState().readFromStorage();
    StoreProvider.of<AppState>(context).dispatch(AddCardToList(cards));

    List<AutoCompleteState> completes = await AutoCompleteState().readFromStorage();
    debugPrint('splash_screen => AUTO COMPLETE LENGTH: ${completes.length}');

    StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(completes));
  }


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();



    Firebase.initializeApp().then((value) {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      if (!kIsWeb) {
        //TODO: TEST Funzionamento notifiche dopo upgrade pacchetto firebase_messaging
        firebaseMessaging.requestPermission();
        StoreProvider.of<AppState>(context)..dispatch(AreaListRequest());

        FirebaseMessaging.onMessage.first.then((message) => () {
              print("onMessage: $message");
              var data = message.data['data'] ?? message;
              RemoteNotification notification = message.notification;
              String orderId = data['orderId'];
              //StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId)); //TODO statistics
              //StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.clear();
              StoreProvider.of<AppState>(context)..dispatch(UserOrderListRequest());
              //StoreProvider.of<AppState>(context).dispatch(RequestNotificationList(StoreProvider.of<AppState>(context).state.user.uid, StoreProvider.of<AppState>(context).state.business.id_firestore));
              notifyFlushbar('OMF: ' + notification.title);
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
              );*/
            });
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        /// Triggers to manage the messages when the app is in foreground (otherwise the notification is not displayed in android)
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification notification = message.notification;
          AndroidNotification android = message.notification?.android;

          // If `onMessage` is triggered with a notification, construct our own
          // local notification to show to users using the created channel.
          if (notification != null && android != null) {
            //String messages = AppLocalizations.of(context).sendEmail;
            //StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.clear();
            StoreProvider.of<AppState>(context)..dispatch(UserOrderListRequest());
            //StoreProvider.of<AppState>(context).dispatch(RequestNotificationList(StoreProvider.of<AppState>(context).state.user.uid, StoreProvider.of<AppState>(context).state.business.id_firestore));
            notifyFlushbar('OM: ' + notification.title);
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UI_U_OrderDetail()), /// TODO: @nipuna, redirect the user to the right UI (notification list?)
            );*/
          }
        });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          var data = message.data['data'] ?? message;
          RemoteNotification notification = message.notification;
          String orderId = data['orderId'];
          //StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId)); //TODO statistics
         // StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.clear();
          StoreProvider.of<AppState>(context)..dispatch(UserOrderListRequest());
          //StoreProvider.of<AppState>(context).dispatch(RequestNotificationList(StoreProvider.of<AppState>(context).state.user.uid, StoreProvider.of<AppState>(context).state.business.id_firestore));
          notifyFlushbar('OMOA: ' + notification.title);
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
          );*/
        });

        firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);

        firebaseMessaging.getToken().then((String token) {
          assert(token != null);
          print("Token " + token);
          serverToken = token;
        });
      }

      firebaseMessaging.onTokenRefresh.listen((newToken) {
        // Save newToken
        serverToken = newToken;
      });
      readFromStorage();
      Timer(Duration(seconds: 1), () => check_logged());
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });
    checkIfNativePayReady();
    initPlatformState();
  }

  Flushbar notifyFlushbar(String message) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20),

      ///2% - 20% - 20%
      borderRadius: BorderRadius.all(Radius.circular(8)),
      backgroundColor: BuytimeTheme.SymbolLightGrey,
      //onTap: tapFlushbar(),
      onTap: (ciao) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => RNotifications(orderStateList: StoreProvider.of<AppState>(context).state.orderList.orderListState, tourist: false,)));
      },
      /*mainButton: Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: MaterialButton(
                color: BuytimeTheme.Secondary,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications(orderStateList: StoreProvider.of<AppState>(context).state.orderList.orderListState)));
                },
                child: Text(
                  'OPEN',
                  style: TextStyle(
                      color: BuytimeTheme.TextBlack
                  ),
                ),
              ),
            ),*/
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      duration: Duration(seconds: 4),
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      messageText: Text(
        message,
        style: TextStyle(color: BuytimeTheme.TextBlack, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    )..show(context);
  }

  void checkIfNativePayReady() async {
    StripePayment.setOptions(StripeOptions(publishableKey: "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz", merchantId: "Test", androidPayMode: 'test'));

    debugPrint('splash_screen: started to check if native pay ready');
    bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    bool isNativeReady = await StripePayment.canMakeNativePayPayments(['american_express', 'visa', 'maestro', 'master_card']);
    debugPrint('splash_screen: deviceSupportNativePay: ' + deviceSupportNativePay.toString() + ' - isNativeReady: ' + isNativeReady.toString());

    // deviceSupportNativePay && isNativeReady ? createPaymentMethodNative() : createPaymentMethod();
  }

  /// Replace with server token from firebase console settings.
  String serverToken = 'AAAA6xUtyfE:APA91bGHhEzVUY9fnj4FbTXJX57qcgF-8GBrfBbGIa8kEpEIdsXRgQxbtsvbhL-w-_MQYKIj0XVlSaDSf2s6O3D3SM3o-z_AZnHQwBNLiw1ygyZOuVAKa5YmXeu6Da9eBqRD9uwFHSPi';

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<Map<String, dynamic>> sendAndRetrieveMessage(FirebaseMessaging firebaseMessaging) async {
    await firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: false);

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': 'this is a body', 'title': 'this is a title'},
          'priority': 'high',
          'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
          'to': await firebaseMessaging.getToken(),
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     completer.complete(message);
    //   },
    // );

    return completer.future;
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    if (message.data.containsKey('data')) {
      // Handle data message
      final dynamic data = message.data['data'];
      print("Data");
    }

    if (message.data.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message.data['notification'];
    }

    // Or do other work.
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
    if (auth.FirebaseAuth != null && auth.FirebaseAuth.instance != null && auth.FirebaseAuth.instance.currentUser != null) {
      auth.User user = auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Sign out with google
        // Loggato e lo mando alla View Principale
        print("Ecco l'utente ----->>> " + user.email + ' id: ' + user.uid);
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
        StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, [serverToken])));
        Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
        TokenB token = TokenB(name: "token", id: serverToken, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));

        //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
      } else {
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
        Navigator.of(context).pushNamed(Home.route);
      }
    } else {
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);
      Navigator.of(context).pushNamed(Home.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    // double spinnerX = 120;
    // double spinnerY = 120;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF207CC3),
      body: Center(
        child: new Image.asset('assets/img/brand/logo_b.png', width: 200, height: 200),
      ),
    );
    /*Scaffold(
      // body: OldSplashScreen(spinnerX: spinnerX, spinnerY: spinnerY, arrowAnimationController: _arrowAnimationController, arrowAnimation: _arrowAnimation),
      body: ,
    )*/
    ;
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
                    "Buytime",
                    style: TextStyle(color: BuytimeTheme.UserPrimary, fontWeight: FontWeight.bold, fontSize: 24.0),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*BuytimeSpinner(
                    spinnerX: spinnerX,
                    spinnerY: spinnerY,
                    arrowAnimationController: _arrowAnimationController,
                    arrowAnimation: _arrowAnimation),*/
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                ),
                Text(
                  //Flutkart.store,
                  "Some Time to Buy",
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: BuytimeTheme.UserPrimary),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}
