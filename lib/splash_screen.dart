import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/device.dart';
import 'package:Buytime/reblox/model/snippet/token.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/reducer/area_list_reducer.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/services/messaging/messaging_helper.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
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
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'UI/management/business/RUI_M_business_list.dart';
import 'UI/user/turist/RUI_U_service_explorer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with WidgetsBindingObserver {
  StatisticsState statisticsState;

  readFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.deleteAll();
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      prefs.setBool('first_run', false);
    }
    List<CardState> cards = await CardState().readFromStorage();
    StoreProvider.of<AppState>(context).dispatch(AddCardToList(cards));
    List<AutoCompleteState> completes = await AutoCompleteState().readFromStorage();
    debugPrint('splash_screen => AUTO COMPLETE LENGTH: ${completes.length}');
    StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(completes));
  }

  String version = '';
  getAppInfo()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    debugPrint('splash_screen => VERSION: $version');
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
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    Firebase.initializeApp().then((value) {
      getAppInfo();
      StoreProvider.of<AppState>(context).dispatch(AreaListRequest());
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      if (!kIsWeb) {
        MessagingHelper().messagingManagement(firebaseMessaging, context);
      }
      readFromStorage();
      Timer(Duration(seconds: 1), () => check_logged());
      StoreProvider.of<AppState>(context).dispatch(PromotionListRequest());

    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });
    checkIfNativePayReady();
    initPlatformState();
  }

  void checkIfNativePayReady() async {
    // String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
    // String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
    Stripe.publishableKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
    Stripe.instance.isApplePaySupported.addListener(() {
    });
    bool isApplePaySupported = await Stripe.instance.checkApplePaySupport();
    debugPrint('splash_screen: isApplePaySupported, ' + isApplePaySupported.toString() );
  }
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

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
        print("USER LOGGED IN IS: " + user.email + ' id: ' + user.uid);
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
        UserState tmpUser = UserState.fromFirebaseUser(user, deviceId, [MessagingHelper.serverToken]);
        StoreProvider.of<AppState>(context).dispatch(new LoggedUser(tmpUser));
        Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
        TokenB token = TokenB(name: "token", id: MessagingHelper.serverToken, user_uid: user.uid);
        StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));
        StoreProvider.of<AppState>(context).dispatch(StripeCardListRequest(user.uid));
        Future.delayed(Duration(seconds: 1), (){
          print("Device ID : " + deviceId + 'USER ROLE: ${StoreProvider.of<AppState>(context).state.user.getRole()}');
          if(StoreProvider.of<AppState>(context).state.user.getRole() != Role.user)
            Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
          else
           Navigator.push(context, MaterialPageRoute(builder: (context) => RServiceExplorer()));
        });
      } else {
        Navigator.of(context).pushNamed(Home.route);
      }
    } else {
      Navigator.of(context).pushNamed(Home.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF207CC3),
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('assets/img/brand/logo_b.png', width: 200, height: 200),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Text(
                    '$version',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: BuytimeTheme.TextWhite,
                        fontFamily: BuytimeTheme.FontFamily
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

