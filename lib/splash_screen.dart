import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:Buytime/UI/user/landing/UI_U_Landing.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/main.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/snippet/device.dart';
import 'package:Buytime/reblox/model/snippet/token.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/UI/user/login/UI_U_Home.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with WidgetsBindingObserver {
  Timer _timerLink;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    print('state = $state');
    if(state == AppLifecycleState.paused){
      StatisticsState().log('PAUSED', StoreProvider.of<AppState>(context).state.statistics);
      StatisticsState().writeToStorage(StoreProvider.of<AppState>(context).state.statistics);
    }

    /*if(state == AppLifecycleState.detached){
      //debugPrint('detached: Calls: ${StoreProvider.of<AppState>(context).state.statistics.numberOfCalls}, Documents: ${StoreProvider.of<AppState>(context).state.statistics.numberOfDocuments}');
      //StatisticsState().writeToStorage(StoreProvider.of<AppState>(context).state.statistics);
    }*/
  }

  StatisticsState statisticsState;

  readFromStorage() async{
    //await FlutterSecureStorage().delete(key: 'ccs');
    //await FlutterSecureStorage().delete(key: 'autoComplete');
    statisticsState = await StatisticsState().readFromStorage();
    StatisticsState().log('INITIALIZE', statisticsState);
    StoreProvider.of<AppState>(context).dispatch(UpdateStatistics(statisticsState));

    List<CardState> cards = await CardState().readFromStorage();
    StoreProvider.of<AppState>(context).dispatch(AddCardToList(cards));

    List<AutoCompleteState> completes = await AutoCompleteState().readFromStorage();
    debugPrint('splash_screen => AUTO COMPLETE LENGTH: ${completes.length}');
    StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(completes));
  }

  var TAG = "MyApp";
  var _my_log_file_name = "MyLogFile";
  var toggle = false;
  static Completer _completer = new Completer<String>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    readFromStorage();
    logger.d("Init Splash screen");
    //DynamicLinkService().retrieveDynamicLink(context);

    Firebase.initializeApp().then((value) {
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      if (!kIsWeb) {
        //TODO: TEST Funzionamento notifiche dopo upgrade pacchetto firebase_messaging
        firebaseMessaging.requestPermission();
        FirebaseMessaging.onMessage.first.then((message) => () {
              print("onMessage: $message");
              var data = message.data['data'] ?? message;
              String orderId = data['orderId'];
              StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId)); //TODO statistics
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
              );
            });

        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          var data = message.data['data'] ?? message;
          String orderId = data['orderId'];
          StoreProvider.of<AppState>(context).dispatch(new OrderRequest(orderId)); //TODO statistics
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
          );
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

      Timer(Duration(seconds: 1), () => check_logged());
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });

    initPlatformState();
    setUpLogs();
  }

  void setUpLogs() async {
    await FlutterLogs.initLogs(
        logLevelsEnabled: [
          LogLevel.INFO,
          LogLevel.WARNING,
          LogLevel.ERROR,
          LogLevel.SEVERE
        ],
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: [_my_log_file_name],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogs",
        logsExportDirectoryName: "MyLogs/Exported",
        debugFileOperations: true,
        isDebuggable: true);

    // [IMPORTANT] The first log line must never be called before 'FlutterLogs.initLogs'
    FlutterLogs.logInfo(TAG, "setUpLogs", "setUpLogs: Setting up logs..");

    // Logs Exported Callback
    FlutterLogs.channel.setMethodCallHandler((call) async {
      if (call.method == 'logsExported') {
        // Contains file name of zip
        FlutterLogs.logInfo(
            TAG, "setUpLogs", "logsExported: ${call.arguments.toString()}");

        // Notify Future with value
        _completer.complete(call.arguments.toString());
      } else if (call.method == 'logsPrinted') {
        FlutterLogs.logInfo(
            TAG, "setUpLogs", "logsPrinted: ${call.arguments.toString()}");
      }
    });
  }



  /// Replace with server token from firebase console settings.
  String serverToken = 'AAAA6xUtyfE:APA91bGHhEzVUY9fnj4FbTXJX57qcgF-8GBrfBbGIa8kEpEIdsXRgQxbtsvbhL-w-_MQYKIj0XVlSaDSf2s6O3D3SM3o-z_AZnHQwBNLiw1ygyZOuVAKa5YmXeu6Da9eBqRD9uwFHSPi';

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  Future<Map<String, dynamic>> sendAndRetrieveMessage(FirebaseMessaging firebaseMessaging) async {
    await firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: false);

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
        Token token = Token(name: "token", id: serverToken, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));

        //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
        Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
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
