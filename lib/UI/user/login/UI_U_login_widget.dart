import 'dart:io';

import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/user_reducer.dart';
import 'package:BuyTime/reusable/back_button_blue.dart';
import 'package:BuyTime/reusable/branded_button.dart';
import 'package:BuyTime/reusable/container_shape_top_circle.dart';
import 'package:BuyTime/reusable/error_dialog.dart';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../../reblox/model/app_state.dart';
import '../UI_U_Tabs.dart';

class LoginWidget extends StatefulWidget {
  final String title = 'Login';

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool _isRequestFlying = false;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  String serverToken = 'AAAA6xUtyfE:APA91bGHhEzVUY9fnj4FbTXJX57qcgF-8GBrfBbGIa8kEpEIdsXRgQxbtsvbhL-w-_MQYKIj0XVlSaDSf2s6O3D3SM3o-z_AZnHQwBNLiw1ygyZOuVAKa5YmXeu6Da9eBqRD9uwFHSPi';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

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
    }

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

  Future<int> signInWithGoogle(context) async {
    print("Ho pigiato il sign google sul Login");
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    print("Dopo google sign_in");
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    print("Dopo google authentication");
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
        message: 'Authentication ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle:
            TextStyle(color: Colors.blue, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle:
            TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();

    final dynamic authResult = await _auth.signInWithCredential(credential);
    final auth.User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final auth.User currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);

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

    StoreProvider.of<AppState>(context)
        .dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, serverToken)));
    ObjectState field = ObjectState(name: "device", id: deviceId, user_uid: user.uid);
    StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
    ObjectState token = ObjectState(name: "token", id: serverToken, user_uid: user.uid);
    StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
    // return 'signInWithGoogle succeeded: $user';
    await pr.hide();
    return 1;
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  void initiateGoogleSignIn() {
    signInWithGoogle(context).then((result) {
      if (result == 1) {
        setState(() {
          isLoggedIn = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UI_U_Tabs()),
          );
        });
      } else {
        print("No result");
      }
    });
  }

  void initiateFacebookSignIn() {
    _handleSignIn().then((result) {
      if (result == 1) {
        setState(() {
          isLoggedIn = true;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UI_U_Tabs()),
          );
        });
      } else {}
    });
  }

  Future<int> _handleSignIn() async {
    FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
    final accessToken = facebookLoginResult.accessToken.token;

    ProgressDialog pr = new ProgressDialog(context);
    pr.style(
        message: 'Authentication ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle:
            TextStyle(color: Colors.blue, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle:
            TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();

    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final facebookAuthCred = auth.FacebookAuthProvider.credential(accessToken);
      final facebookUserFromFirebase = await _auth.signInWithCredential(facebookAuthCred);
      /*print("User : " + user.displayName);*/
      await pr.hide();

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

      StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(facebookUserFromFirebase.user, deviceId, serverToken)));
      ObjectState field =
          ObjectState(name: "device", id: deviceId, user_uid: facebookUserFromFirebase.user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
      ObjectState token =
          ObjectState(name: "token", id: serverToken, user_uid: facebookUserFromFirebase.user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
      return 1;
    } else
      await pr.hide();
    return 0;
  }

  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.cancelledByUser:
        print("Cancelled");
        break;
      case FacebookLoginStatus.error:
        print("error");
        break;
      case FacebookLoginStatus.loggedIn:
        print("Logged In");
        break;
    }
    return facebookLoginResult;
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      firebaseMessaging.requestNotificationPermissions();

      firebaseMessaging.getToken().then((String token) {
        assert(token != null);

        print("Token " + token);
        serverToken = token;
      });

      //   check_logged();
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
              key: _formKey,
              child: Container(
                  child: Column(children: [
                Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [BackButtonBlue(media: media, externalContext: context)])),
                Center(
                    child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Image.asset('assets/img/img_buytime.png', height: media.height * 0.22),
                    ),
                    SizedBox(
                      height: media.height * .015,
                    ),
                    Container(
                      width: media.width * 0.65,
                      child: TextFormField(
                        controller: _emailController,
                        textAlign: TextAlign.start,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelText: 'E-Mail',
                          hintText: "email *",
                          hintStyle: TextStyle(color: Colors.redAccent),
                          labelStyle: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        validator: (String value) {
                          if (value.isNotEmpty && EmailValidator.validate(value)) {
                            return null;
                          }
                          return 'Please enter a valid email address';
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.01,
                    ),
                    Container(
                      width: media.width * 0.65,
                      child: TextFormField(
                        controller: _passwordController,
                        textAlign: TextAlign.start,
                        obscureText: true,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          labelText: 'Password',
                          hintText: "password *",
                          hintStyle: TextStyle(color: Colors.redAccent),
                          labelStyle: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Colors.blue,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: media.height * 0.05,
                    ),
                    Container(
                        width: media.width * 0.65,
                        height: media.height * 0.07,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate() && !_isRequestFlying) {
                              _signInWithEmailAndPassword();
                            }
                          },
                          textColor: Colors.white,
                          color: _isRequestFlying ? Colors.grey : Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(500.0)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: BuytimeTheme.FontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ],
                )),
                SizedBox(
                  height: media.height * 0.125,
                ),
                Expanded(
                  child: CustomPaint(
                    painter: ContainerShapeTopCircle(Color.fromRGBO(1, 159, 224, 1.0)),
                    child: Container(
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        BrandedButton("assets/img/google_logo.png", 'sign in with Google',
                            initiateGoogleSignIn),
                        //  BrandedButton("assets/img/facebook_logo.png", 'sign in with Facebook', initiateFacebookSignIn),
                      ]),
                    ),
                  ),
                )
              ]))),
        ));
  }

  void _signInWithEmailAndPassword() async {
    setState(() {
      _isRequestFlying = true;
    });
    final auth.User user = (await _auth
            .signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            )
            .catchError(onError))
        .user;
    setState(() {
      _isRequestFlying = false;
    });

    if (user != null) {
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

      StoreProvider.of<AppState>(context)
          .dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, serverToken)));
      ObjectState field = ObjectState(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
      ObjectState token = ObjectState(name: "token", id: serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UI_U_Tabs()),
        );
      });
    } else {
      onError(new PlatformException(code: "1111", message: "user not found"));
    }
  }

  void onError(error) {
    print("error is: " + error.toString());
    showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(error.message, "ok");
        });
    setState(() {
      _isRequestFlying = false;
    });
  }
}
