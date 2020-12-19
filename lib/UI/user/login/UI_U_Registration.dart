import 'dart:io';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/user/user_state.dart';
import 'package:BuyTime/reblox/reducer/user_reducer.dart';
import 'package:BuyTime/reusable/branded_button.dart';
import 'package:BuyTime/reusable/error_dialog.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../UI_U_Tabs.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset ='0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}




class Registration extends StatefulWidget {
  final String title = 'Registration';

  @override
  State<StatefulWidget> createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {

  ///Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRequestFlying = false;
  bool _success;
  String _userEmail;
  bool isLoggedIn = false;

  ///Firebase auth
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  String uid;
  String serverToken;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  bool emailHasError = true;
  bool passwordHasError = true;
  String responseMessage = '';

  bool passwordVisible = true;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      firebaseMessaging.requestNotificationPermissions();
      firebaseMessaging.getToken().then((String token) {
        assert(token != null);
        print("UI_U_Registration Token " + token);
        serverToken = token;
      });
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });
    initPlatformState();
  }

  ///Init platform state
  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData;
    if(!kIsWeb) {
      try {
        if (Platform.isAndroid) {
          deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        }
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }
    }
    if (!mounted) return;
    setState(() {
      _deviceData = deviceData;
    });
  }

  ///Read android data
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

  ///Read ios data
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

  ///Google sign in
  Future<int> signInWithGoogle(context) async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount != null){
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final auth.AuthCredential credential =
      auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      ProgressDialog pr = new ProgressDialog(context);
      pr.style(
          message: 'Authentication ...',
          borderRadius: 10.0,
          backgroundColor: BuytimeTheme.BackgroundWhite,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: BuytimeTheme.UserPrimary, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: BuytimeTheme.TextDark, fontSize: 19.0, fontWeight: FontWeight.w600));
      await pr.show();

      final dynamic authResult = await _auth.signInWithCredential(credential);
      final dynamic user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final auth.User currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);

      String deviceId = "web";
      if(!kIsWeb) {
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
      ObjectState field =
      ObjectState(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
      ObjectState token =
      ObjectState(name: "token", id: serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
      await pr.hide();
      return 1;
    }
    return 0;
  }

  ///Google sign out
  void signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Sign Out");
  }

  ///Init google sign in
  void initiateGoogleSignIn() {
    signInWithGoogle(context).then((result) {
      if (result == 1) {
        setState(() {
          isLoggedIn = true;
          Navigator.push(context, MaterialPageRoute(builder: (context) => UI_U_Tabs()),
          );
        });
      } else {}
    });
  }

  ///Sign in with Apple
  Future<auth.UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = auth.OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return _auth.signInWithCredential(oauthCredential);
  }

  ///Init facebook sign in
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

  ///Facebook sign in
  Future<int> _handleSignIn() async {
    FacebookLoginResult facebookLoginResult = await _handleFBSignIn();
    if (facebookLoginResult.accessToken != null) {
      final accessToken = facebookLoginResult.accessToken.token;

      ProgressDialog pr = new ProgressDialog(context);
      pr.style(
          message: 'Authentication ...',
          borderRadius: 10.0,
          backgroundColor: BuytimeTheme.BackgroundWhite,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: BuytimeTheme.UserPrimary, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: BuytimeTheme.TextDark,
              fontSize: 19.0,
              fontWeight: FontWeight.w600));
      await pr.show();

      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        final facebookAuthCred =
        auth.FacebookAuthProvider.credential(accessToken);
        final facebookUserFromFirebase =
        await _auth.signInWithCredential(facebookAuthCred);
        await pr.hide();

        String deviceId = "web";
        if(!kIsWeb) {
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
        ObjectState field = ObjectState(
            name: "device",
            id: deviceId,
            user_uid: facebookUserFromFirebase.user.uid);
        StoreProvider.of<AppState>(context)
            .dispatch(new UpdateUserField(field));
        ObjectState token = ObjectState(
            name: "token",
            id: serverToken,
            user_uid: facebookUserFromFirebase.user.uid);
        StoreProvider.of<AppState>(context)
            .dispatch(new UpdateUserField(token));
        return 1;
      } else
        await pr.hide();
      return 0;
    }
  }

  ///Handle facebook sign in
  Future<FacebookLoginResult> _handleFBSignIn() async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult facebookLoginResult =
    await facebookLogin.logIn(['email']);
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

  ///Validation
  void checkFormValidation(){
    setState(() {
      if(_success == null){
        responseMessage = '';
      }else{
        if(emailHasError && passwordHasError)
          responseMessage = 'Please enter a valid Email and Password';
        else if(emailHasError)
          responseMessage = 'Please enter a valid Email address';
        else if(passwordHasError)
          responseMessage = 'Password has a minimum of 6 characters and at least 1 digit, 1 lowercase char and 1 uppercase char';
        else if(!_success)
          responseMessage = 'Registration failed';
        else
          responseMessage = 'Successfully registered with ' + _userEmail;
      }
    });
  }

  ///Password validator
  bool passwordValidator(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: BuytimeTheme.UserPrimary,
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
        ),
        body: Form(
            key: _formKey,
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Logo & Email & Password & & Error message & Sign up button
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Logo
                              Container(
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black54.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Image.asset('assets/img/img_buytime.png',
                                    height: media.height * 0.12),
                              ),
                              ///Email & Password & Error message
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8), ///8% - 8%
                                  child: SizeConfig.screenHeight < 537 ?
                                  Column(
                                    children: [
                                      ///Sign in text
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 5),
                                            child: Text(
                                              'Please Sign in:',
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ///Email address
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        height: SizeConfig.safeBlockHorizontal * 16,
                                        child: TextFormField(
                                          controller: _emailController,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.emailAddress,
                                          autofillHints: [AutofillHints.email],
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xff666666)),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.redAccent),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            labelText: 'Email address',
                                            //hintText: "email *",
                                            //hintStyle: TextStyle(color: Color(0xff666666)),
                                            labelStyle: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Color(0xff666666),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.w800,
                                          ),
                                          validator: (String value) {
                                            setState(() {
                                              if (value.isNotEmpty && EmailValidator.validate(value)) {
                                                emailHasError = false;
                                              }else
                                                emailHasError = true;
                                            });
                                            return null;
                                          },
                                        ),
                                      ),
                                      ///Password
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 2),
                                        height: SizeConfig.safeBlockHorizontal * 16,
                                        child: TextFormField(
                                          controller: _passwordController,
                                          textAlign: TextAlign.start,
                                          obscureText: passwordVisible,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff666666)),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.redAccent),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              labelText: 'Password',
                                              //hintText: "email *",
                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                              labelStyle: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                  color: Color(0xff666666),
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    passwordVisible = !passwordVisible;
                                                  });
                                                },
                                              )
                                          ),
                                          style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          validator: (String value) {
                                            setState(() {
                                              if (passwordValidator(value)) {
                                                passwordHasError = false;
                                              }else
                                                passwordHasError = true;
                                            });
                                            return null;
                                          },
                                        ),
                                      ),
                                      ///Error message
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          responseMessage,
                                          style: TextStyle(
                                              color: _success != null ? _success ? Colors.greenAccent : Colors.redAccent : Colors.redAccent,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  ) :
                                  Column(
                                    children: [
                                      ///Sign in text
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top:  SizeConfig.safeBlockVertical * 5),
                                            child: Text(
                                              'Please Sign in:',
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      ///Email address
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: TextFormField(
                                          controller: _emailController,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.emailAddress,
                                          autofillHints: [AutofillHints.email],
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Color(0xff666666)),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.redAccent),
                                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                                            ),
                                            labelText: 'Email address',
                                            //hintText: "email *",
                                            //hintStyle: TextStyle(color: Color(0xff666666)),
                                            labelStyle: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: Color(0xff666666),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.w800,
                                          ),
                                          validator: (String value) {
                                            setState(() {
                                              if (value.isNotEmpty && EmailValidator.validate(value)) {
                                                emailHasError = false;
                                              }else
                                                emailHasError = true;
                                            });
                                            return null;
                                          },
                                        ),
                                      ),
                                      ///Password
                                      Container(
                                        margin: EdgeInsets.only(top: 10.0),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          textAlign: TextAlign.start,
                                          obscureText: passwordVisible,
                                          decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xff666666)),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.redAccent),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                              ),
                                              labelText: 'Password',
                                              //hintText: "email *",
                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                              labelStyle: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                  color: Color(0xff666666),
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    passwordVisible = !passwordVisible;
                                                  });
                                                },
                                              )
                                          ),
                                          style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff666666),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          validator: (String value) {
                                            setState(() {
                                              if (passwordValidator(value)) {
                                                passwordHasError = false;
                                              }else
                                                passwordHasError = true;
                                            });
                                            return null;
                                          },
                                        ),
                                      ),
                                      ///Error message
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          responseMessage,
                                          style: TextStyle(
                                              color: _success != null ? _success ? Colors.greenAccent : Colors.redAccent : Colors.redAccent,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ///Sign up button
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FloatingActionButton(
                                            onPressed: () async {
                                              if (_formKey.currentState.validate() && !_isRequestFlying) {
                                                _register();
                                                checkFormValidation();
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(500.0)),
                                            child: Icon(
                                              Icons.chevron_right,
                                              size: 30,
                                              color: BuytimeTheme.UserPrimary,
                                            ),
                                          )
                                        ],
                                      )
                                  )
                              )
                            ],
                          ),
                        ),
                        ///Google & Facebook & Apple Sign up buttons
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Color(0xff7694aa),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BrandedButton("assets/img/google_logo.png",'Sign up with Google', initiateGoogleSignIn),
                                  BrandedButton("assets/img/apple_logo.png",'Sign up with Apple', signInWithApple),
                                  BrandedButton("assets/img/facebook_logo.png",'Sign up with Facebook', initiateFacebookSignIn),
                                ]
                            ),
                          ),
                        )
                      ]
                  ),
                ),
              ),
            )
        )
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
     auth.User user;
     auth.UserCredential tmpUserCredential;
     if(!emailHasError && !passwordHasError)
       tmpUserCredential = (await _auth.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text,).catchError(onError));

     if(tmpUserCredential != null)
       user = tmpUserCredential.user;

     if (user != null) {
      String deviceId = "web";
      if(!kIsWeb) {
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
      ObjectState field =
      ObjectState(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(field));
      ObjectState token =
      ObjectState(name: "token", id: serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserField(token));
      setState(() {
        _success = true;
        _userEmail = user.email;
        Navigator.push(context, MaterialPageRoute(builder: (context) => UI_U_Tabs()),);
      });
    }else{
       setState(() {
         _success = false;
       });
     }
  }

  void onError(error) {
    setState(() {
      _success = false;
      print("error is: " + error.toString());
      if (!emailHasError && !passwordHasError) {
        responseMessage = error.message;
        /*showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(error.message, "ok");
          });*/
      }
      //_isRequestFlying = false;
    });
  }

}


