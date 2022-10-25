/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/UI/management/business/RUI_M_business_list.dart';
import 'package:Buytime/UI/user/login/UI_U_forgot_password.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/autoComplete/auto_complete_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/device.dart';
import 'package:Buytime/reblox/model/snippet/token.dart';
import 'package:Buytime/reblox/reducer/auto_complete_list_reducer.dart';
import 'package:Buytime/helper/messaging/messaging_helper.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/w_branded_button.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:keychain_plugin/keychain_plugin.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../environment_abstract.dart';
import '../../../reblox/model/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'UI_U_home.dart';
import 'UI_U_registration.dart';

class Login extends StatefulWidget {
  static String route = '/login';
  bool fromDiscover;
  Login(this.fromDiscover);
  @override
  State<StatefulWidget> createState() => LoginState();
}

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

OverlayEntry overlayEntry;
bool isMenuOpen = false;

class LoginState extends State<Login> with SingleTickerProviderStateMixin {
  ///Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool _isRequestFlying = false;
  bool _success;
  bool _commited = false;

  bool remeberMe = false;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};


  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  ///Validation variables
  bool emailHasError = true;
  bool passwordHasError = true;
  String responseMessage = '';

  bool passwordVisible = true;

  ///Init platform
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

  ///Init Google sign in
  void initiateGoogleSignIn() {
    signInWithGoogle(context).then((result) {
      if (result == 1) {
        setState(() {
          isLoggedIn = true;
          Future.delayed(Duration(milliseconds: 1500), () async {
            if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user){
              debugPrint('UI_U_login => Account authority: > User');
              Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
            }else{
              debugPrint('UI_U_login => Account authority: <= User');
              await FirebaseMessaging.instance.subscribeToTopic('broadcast_user');
              debugPrint('FIREBASE MESSAGING TOP SUBSCRIBTION TO: broadcast_user');
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.serviceExplorer, (Route<dynamic> route) => false);
            }
            //Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.myBookings, ModalRoute.withName(AppRoutes.landing));
            //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
          });
        });
      } else {
        print("No result");
      }
    });
  }

  ///Sign in with Google
  Future<int> signInWithGoogle(context) async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      ProgressDialog pr = new ProgressDialog(context);
      pr.style(
          message: AppLocalizations.of(context).authentication,
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(color: Colors.blue, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
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
      StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, [MessagingHelper.serverToken])));
      Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
      TokenB token = TokenB(name: "token", id: MessagingHelper.serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));
      // return 'signInWithGoogle succeeded: $user';
      await pr.hide();
      return 1;
    }
    return 0;
  }

  ///Sign out Google
  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  ///Init Apple sign in
  void initiateAppleSignIn() {
    signInWithApple().then((result) {
      if (result == 1) {
        setState(() {
          isLoggedIn = true;
          Future.delayed(Duration(milliseconds: 1500), () async {
            if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user){
              debugPrint('UI_U_login => Account authority: > User');
              Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
            }else{
              debugPrint('UI_U_login => Account authority: <= User');
              await FirebaseMessaging.instance.subscribeToTopic('broadcast_user');
              debugPrint('FIREBASE MESSAGING TOP SUBSCRIBTION TO: broadcast_user');
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.serviceExplorer, (Route<dynamic> route) => false);
            }
            //Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.myBookings, ModalRoute.withName(AppRoutes.landing));
            //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
          });
        });
      } else {
        print("No result");
      }
    });
  }

  ///Sign in with Apple
  Future<int> signInWithApple() async {
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

    if (oauthCredential != null) {
      ProgressDialog pr = new ProgressDialog(context);
      pr.style(
          message: AppLocalizations.of(context).authentication,
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(color: Colors.blue, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
      await pr.show();

      final dynamic authResult = await _auth.signInWithCredential(oauthCredential);
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

      StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, [MessagingHelper.serverToken])));
      Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
      TokenB token = TokenB(name: "token", id: MessagingHelper.serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));


      // return 'signInWithGoogle succeeded: $user';
      await pr.hide();
      return 1;
    }
    return 0;
  }

  List<AutoCompleteState> autoCompleteList = [];

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _key = LabeledGlobalKey("button_icon");

    super.initState();
    Firebase.initializeApp().then((value) {
      firebaseMessaging.requestPermission();

      firebaseMessaging.getToken().then((String token) {
        assert(token != null);

        print("Token " + token);
        MessagingHelper.serverToken = token;
      });

      //   check_logged();
    }).catchError((onError) {
      print("error on firebase application start: " + onError.toString());
    });
    initPlatformState();
    //checkAuth();
  }

  var localAuth = LocalAuthentication();

  void checkAuth() async {
    bool didAuthenticate = await localAuth.authenticateWithBiometrics(localizedReason: AppLocalizations.of(context).pleaseAuthenticateShowAccountBalance);
    debugPrint('UI_U_login => $didAuthenticate');
  }

  ///Validation
  void checkFormValidation() {
    setState(() {
      if (_success == null) {
        responseMessage = '';
      } else {
        if (emailHasError && passwordHasError)
          responseMessage = AppLocalizations.of(context).pleaseEmailAndPass;
        else if (emailHasError)
          responseMessage = AppLocalizations.of(context).pleaseEmail;
        else if (passwordHasError)
          responseMessage = AppLocalizations.of(context).pleasePass;
        else if (!_success)
          responseMessage = AppLocalizations.of(context).registrationFail;
        else
          responseMessage = AppLocalizations.of(context).successSign;
      }
    });
  }

  ///Password validator
  bool passwordValidator(String value) {
    //String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  ///Autocomplete section
  GlobalKey _key;
  Offset buttonPosition;
  Size buttonSize;
  OverlayEntry _overlayEntry;
  AnimationController _animationController;
  bool didAuthenticate = false;

  findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    if (autoCompleteList.isNotEmpty) {
      overlayEntry.remove();
      _animationController.reverse();
      isMenuOpen = !isMenuOpen;
    }
  }

  void openMenu() {
    if (autoCompleteList.isNotEmpty) {
      findButton();
      _animationController.forward();
      overlayEntry = _overlayEntryBuilder();
      Overlay.of(context).insert(overlayEntry);
      isMenuOpen = !isMenuOpen;
    }
  }

  //var localAuth = LocalAuthentication();
  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          //right: buttonPosition.dx - 268,
          width: SizeConfig.screenWidth - (SizeConfig.safeBlockHorizontal * 10 * 2),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                /*autoCompleteList.isNotEmpty
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: ClipPath(
                          clipper: ArrowClipper(),
                          child: Container(
                            width: 17,
                            height: 17,
                            color: BuytimeTheme.SymbolLightGrey,
                          ),
                        ),
                      )
                    : Container(),*/
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    height: autoCompleteList.length == 1 ? 45 : autoCompleteList.length == 2 ? 90 : autoCompleteList.length == 3 ? 135 : SizeConfig.safeBlockVertical * 20,
                    decoration: BoxDecoration(
                      color: BuytimeTheme.BackgroundWhite,
                      //border: Border.all(color: BuytimeTheme.ButtonMalibu, width: 2),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(5.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: BuytimeTheme.BackgroundBlack.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: BuytimeTheme.TextBlack,
                        ),
                      ),
                      child: CustomScrollView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  //MenuItemModel menuItem = menuItems.elementAt(index);
                                  //CategoryState categoryItem = categoryRootList.elementAt(index);
                                  return GestureDetector(
                                    onTap: () async {
                                      if(!didAuthenticate){
                                        didAuthenticate = await localAuth.authenticate(localizedReason: AppLocalizations.of(context).pleaseAuthenticateUseCredentials);
                                        /*if(!didAuthenticate)
                                  didAuthenticate = true;*/
                                      }

                                      //didAuthenticate = true;

                                      //didAuthenticate = true;
                                      if (didAuthenticate) {
                                        _emailController.text = autoCompleteList.elementAt(index).email;
                                        /*if(Platform.isIOS){
                                          _passwordController.text = await KeychainPlugin.getKeychainValue(autoCompleteList.elementAt(index).email, '');
                                        }else{
                                          _passwordController.text = autoCompleteList.elementAt(index).password;
                                        }*/
                                        _passwordController.text = autoCompleteList.elementAt(index).password;
                                        if (_formKey.currentState.validate() && !_isRequestFlying) {
                                          _signInWithEmailAndPassword();
                                        }
                                        closeMenu();
                                      }
                                    },
                                    child: Container(
                                        width: SizeConfig.screenWidth - (SizeConfig.safeBlockHorizontal * 10 * 2),
                                        height: 45,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            ///Email Icon & Email
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                ///Email Icon
                                                Container(
                                                  margin: EdgeInsets.only(left: 10.0, top: 0),
                                                  child: Icon(
                                                    Icons.email_outlined,
                                                    color: BuytimeTheme.SymbolGrey,
                                                  ),
                                                ),

                                                ///Email
                                                Container(
                                                  margin: EdgeInsets.only(left: 10.0, top: 0),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      '${autoCompleteList[index].email}',
                                                      style: TextStyle(color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ///Buytime Logo
                                            /*Container(
                                      margin: EdgeInsets.only(right: 10.0, top: 0),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage('assets/img/img_buytime.png'),
                                      )),
                                    ),*/
                                          ],
                                        )),
                                  );
                                  // return InkWell(
                                  //   onTap: () {
                                  //     debugPrint('UI_U_login => Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                  //   },
                                  //   //child: MenuItemListItemWidget(menuItem),
                                  //   child: CategoryListItemWidget(categoryItem),
                                  // );
                                },
                                childCount: autoCompleteList.length,
                              ),
                            ),
                          ])
                      /*Column(
                        mainAxisSize: MainAxisSize.min,
                        children:[

                        ]

                        *//*List.generate(
                            autoCompleteList.length,
                                (index) {
                          return GestureDetector(
                            onTap: () async {
                              if(!didAuthenticate){
                                didAuthenticate = await localAuth.authenticateWithBiometrics(localizedReason: 'Please authenticate to use the credentials');
                                *//**//*if(!didAuthenticate)
                                  didAuthenticate = true;*//**//*
                              }

                              //didAuthenticate = true;

                              //didAuthenticate = true;
                              if (didAuthenticate) {
                                _emailController.text = autoCompleteList.elementAt(index).email;
                                _passwordController.text = autoCompleteList.elementAt(index).password;
                                if (_formKey.currentState.validate() && !_isRequestFlying) {
                                  _signInWithEmailAndPassword();
                                }
                                closeMenu();
                              }
                            },
                            child: Container(
                                width: SizeConfig.screenWidth - (SizeConfig.safeBlockHorizontal * 10 * 2),
                                height: 60 - 4.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ///Email Icon & Email
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ///Email Icon
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0, top: 0),
                                          child: Icon(
                                            Icons.email_outlined,
                                            color: BuytimeTheme.SymbolGrey,
                                          ),
                                        ),

                                        ///Email
                                        Container(
                                          margin: EdgeInsets.only(left: 10.0, top: 0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${autoCompleteList[index].email}',
                                              style: TextStyle(color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ///Buytime Logo
                                    *//**//*Container(
                                      margin: EdgeInsets.only(right: 10.0, top: 0),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage('assets/img/img_buytime.png'),
                                      )),
                                    ),*//**//*
                                  ],
                                )),
                          );
                        })*//*,
                      )*/,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {
        autoCompleteList = snapshot.autoCompleteListState.autoCompleteListState;
        debugPrint('UI_U_login => Auto complete List LENGTH: ${autoCompleteList.length}');
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            //Overlay.of(context).insert(overlayEntry);
            if (overlayEntry != null && isMenuOpen) {
              overlayEntry.remove();
              isMenuOpen = !isMenuOpen;
            }
          },
          onPanDown: (d) {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            //Overlay.of(context).insert(overlayEntry);
            if (overlayEntry != null && isMenuOpen) {
              overlayEntry.remove();
              isMenuOpen = !isMenuOpen;
            }
          },
          child: Scaffold(
            //resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: IconButton(
                  key: Key('home_from_login_key'),
                  icon: Icon(
                    Icons.keyboard_arrow_left,
                    color: BuytimeTheme.SymbolBlack,
                  ),
                  onPressed: () {
                    controller.play();
                    if (overlayEntry != null && isMenuOpen) {
                      overlayEntry.remove();
                      isMenuOpen = !isMenuOpen;
                    }
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
                    child: SingleChildScrollView(
                      child: Container(
                        height: (SizeConfig.safeBlockVertical * 100) - 56,
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          ///Logo & Email & Password & & Error message & Log in button
                          Expanded(
                            flex: 6,
                            child: Container(
                              //height: SizeConfig.safeBlockVertical * 75,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///Logo
                                  Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      /*boxShadow: [
                                BoxShadow(
                                  color: Colors.black54.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],*/
                                    ),
                                    child: Image.asset(
                                      'assets/img/brand/logo.png',
                                      height: 96,

                                      ///media.height * 0.12
                                    ),
                                  ),

                                  ///Email & Password & Error message
                                  Flexible(
                                    flex: 3,
                                    child: Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),

                                        ///8% - 8%
                                        child: Column(
                                          //mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ///Log in text
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  //width: 328,
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 8),
                                                  child: Text(
                                                    AppLocalizations.of(context).pleaseLogin,
                                                    style: TextStyle(
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextBlack,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 16,

                                                      ///SizeConfig.safeBlockHorizontal * 3
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            ///Email address
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                    child: Container(
                                                      key: _key,
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                      height: 55,

                                                      ///SizeConfig.safeBlockHorizontal * 14
                                                      //width: 2,
                                                      child: TextFormField(
                                                        //autofillHints: [AutofillHints.username],
                                                        key: Key('email_key'),
                                                        controller: _emailController,
                                                        textAlign: TextAlign.start,
                                                        keyboardType: TextInputType.emailAddress,
                                                        textInputAction: TextInputAction.next,
                                                        autofillHints: [AutofillHints.email],
                                                        decoration: InputDecoration(
                                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                          labelText: AppLocalizations.of(context).emailAddress,
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
                                                            } else
                                                              emailHasError = true;
                                                          });
                                                          return null;
                                                        },
                                                        onTap: autoCompleteList.isNotEmpty
                                                            ? () async {
                                                          if (isMenuOpen) {
                                                            closeMenu();
                                                          } else {
                                                            openMenu();
                                                          }
                                                        }
                                                            : null,
                                                        onFieldSubmitted: (submit) {
                                                          if (overlayEntry != null && isMenuOpen) {
                                                            overlayEntry.remove();
                                                            isMenuOpen = !isMenuOpen;
                                                          }
                                                        },
                                                      ),
                                                    )),
                                                /*Container(
                                                      //width: 10,
                                                      //margin: EdgeInsets.only(left: 1),
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                                      child: AutoCompleteMenu(
                                                        items: autoCompleteList == null ? [] : autoCompleteList,
                                                        iconColor: BuytimeTheme.TextWhite,
                                                        backgroundColor: BuytimeTheme.BackgroundWhite,
                                                        textColor: BuytimeTheme.TextBlack,
                                                        overlayEntry: overlayEntry,
                                                        onChange: (index) {
                                                          print(index);
                                                          setState(() {
                                                            //countryNotValid();
                                                          });
                                                          _emailController.text = autoCompleteList.elementAt(index).email;
                                                          _passwordController.text = autoCompleteList.elementAt(index).password;
                                                        },
                                                      ),
                                                    )*/
                                              ],
                                            ),

                                            ///Password
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 4),
                                              height: 55,

                                              ///SizeConfig.safeBlockHorizontal * 14
                                              //width: 328,
                                              child: TextFormField(
                                                key: Key('password_key'),
                                                controller: _passwordController,
                                                textAlign: TextAlign.start,
                                                obscureText: passwordVisible,
                                                decoration: InputDecoration(
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    labelText: AppLocalizations.of(context).password,
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
                                                    )),
                                                style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Color(0xff666666),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                                validator: (String value) {
                                                  setState(() {
                                                    if (passwordValidator(value)) {
                                                      passwordHasError = false;
                                                    } else
                                                      passwordHasError = true;
                                                  });
                                                  return null;
                                                },
                                              ),
                                            ),

                                            ///Error message
                                            Flexible(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: SizeConfig.safeBlockHorizontal * 80,
                                                    //alignment: Alignment.centerLeft,
                                                    margin: EdgeInsets.only(top: 12.0),
                                                    child: Text(
                                                      responseMessage,
                                                      key: Key('error_key'),
                                                      style: TextStyle(
                                                          color: _success != null
                                                              ? _success
                                                              ? Colors.greenAccent
                                                              : Colors.redAccent
                                                              : Colors.redAccent,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            ///Remeber Me & Forgot Password
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                ///Forgot Password
                                                Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                    alignment: Alignment.center,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                                                          );
                                                        },
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        child: Container(
                                                          //width: 328,
                                                          width: 139,
                                                          height: 28,
                                                          padding: EdgeInsets.all(5.0),
                                                          child: FittedBox(
                                                            child: Text(
                                                              AppLocalizations.of(context).forgotPassword,
                                                              style: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: BuytimeTheme.ManagerPrimary,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16,

                                                                ///SizeConfig.safeBlockHorizontal * 3
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )),

                                                ///Remeber Me
                                                /*Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 15,
                                                        height: 15,
                                                        child: Checkbox(
                                                          checkColor: BuytimeTheme.TextWhite,
                                                          activeColor: BuytimeTheme.TextGrey,
                                                          value: remeberMe,
                                                          onChanged: (bool value) {
                                                            setState(() {
                                                              remeberMe = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        //padding: EdgeInsets.all(5.0),
                                                        margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                                                        width: 100,
                                                        height: 28,
                                                        child: FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            AppLocalizations.of(context).saveCredentials,
                                                            style: TextStyle(
                                                                letterSpacing: 1.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16

                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),*/
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),

                                  ///Log in button
                                  Flexible(
                                      flex: 1,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: SizeConfig.safeBlockVertical * 2.5,
                                              bottom: SizeConfig.safeBlockVertical * 2.5,
                                              left: SizeConfig.safeBlockHorizontal * 8,
                                              right: SizeConfig.safeBlockHorizontal * 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FloatingActionButton(
                                                key: Key('login_key'),
                                                onPressed: () async {
                                                  if (_formKey.currentState.validate() && !_isRequestFlying) {
                                                    _signInWithEmailAndPassword();
                                                  }
                                                },
                                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(500.0)),
                                                child: Icon(
                                                  Icons.chevron_right,
                                                  size: 30,
                                                  color: BuytimeTheme.SymbolGrey,
                                                ),
                                              )
                                            ],
                                          )))
                                ],
                              ),
                            ),
                          ),
                          ///Google & Facebook & Apple Sign up buttons
                          Expanded(
                            flex: 2,
                            child: Container(
                              //height: SizeConfig.safeBlockVertical * 30,
                              //height: 243, ///285
                              padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                              color: BuytimeTheme.BackgroundCerulean,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                                BrandedButton("assets/img/google_logo.png", AppLocalizations.of(context).logInWithGoogle, initiateGoogleSignIn),
                                Container(
                                  height: 5,
                                ),
                                Platform.isIOS ?
                                BrandedButton("assets/img/apple_logo.png", AppLocalizations.of(context).logInWithApple, initiateAppleSignIn) : Container(),
                                widget.fromDiscover ?
                                Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                    alignment: Alignment.center,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        key: Key('tourist_registration'),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => Registration(widget.fromDiscover)),
                                          );
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: Container(
                                          //width: 328,
                                          width: 80,
                                          height: 28,
                                          padding: EdgeInsets.all(5.0),
                                          child: FittedBox(
                                            child: Text(
                                              AppLocalizations.of(context).register,
                                              style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextWhite,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,

                                                ///SizeConfig.safeBlockHorizontal * 3
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )) : Container(),
                                //BrandedButton("assets/img/facebook_logo.png", AppLocalizations.of(context).signFacebook, initiateFacebookSignIn),
                              ]),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ))),
        );
      },
    );
  }

  void _signInWithEmailAndPassword() async {
    setState(() {
      responseMessage = '';
    });

    showDialog(
        context: context,
        builder: (context) {
          return WillPopScope(
              onWillPop: () async {
                FocusScope.of(context).unfocus();
                return false;
              },
              child: Container(
                  height: SizeConfig.safeBlockVertical * 100,
                  decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: SizeConfig.safeBlockVertical * 20,
                          height: SizeConfig.safeBlockVertical * 20,
                          child: Center(
                            child: SpinKitRipple(
                              color: Colors.white,
                              size: SizeConfig.safeBlockVertical * 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
        });

    setState(() {
      _isRequestFlying = true;
    });

    auth.User user;
    auth.UserCredential tmpUserCredential;
    if (!emailHasError && !passwordHasError)
      tmpUserCredential = (await _auth
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
          .catchError(onError));

    if (tmpUserCredential != null) user = tmpUserCredential.user;

    setState(() {
      _isRequestFlying = false;
    });
    //await KeychainPlugin.setKeychainValue(_emailController.text, _passwordController.text, '');
    if (user != null) {
      AutoCompleteState autoComplete = AutoCompleteState().toEmpty();
      autoComplete.email = _emailController.text;
      autoComplete.password = _passwordController.text;
      if (autoCompleteList.isNotEmpty) {
        int i = 0;
        autoCompleteList.forEach((element) {
          if (element.email == autoComplete.email) ++i;
        });
        if (i == 0) {
          autoCompleteList.add(autoComplete);
          await autoComplete.writeToStorage(autoCompleteList);
          StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(autoCompleteList));
        }
        debugPrint('UI_U_login => AUTOMPLETE LIST ON LOGIN: ${autoCompleteList.length}');
      } else {
        List<AutoCompleteState> list = [];
        list.add(autoComplete);
        await autoComplete.writeToStorage(list);
        debugPrint('UI_U_login => AUTOMPLETE LIST ON LOGIN: ${list.length}');
        StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(list));
      }
      /*if (remeberMe) {
        AutoCompleteState autoComplete = AutoCompleteState().toEmpty();
        autoComplete.email = _emailController.text;
        autoComplete.password = _passwordController.text;
        if (autoCompleteList.isNotEmpty) {
          int i = 0;
          autoCompleteList.forEach((element) {
            if (element.email == autoComplete.email) ++i;
          });
          if (i == 0) {
            autoCompleteList.add(autoComplete);
            await autoComplete.writeToStorage(autoCompleteList);
            StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(autoCompleteList));
          }
        } else {
          List<AutoCompleteState> list = [];
          list.add(autoComplete);
          await autoComplete.writeToStorage(list);
          StoreProvider.of<AppState>(context).dispatch(AddAutoCompleteToList(list));
        }
      }*/

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

      StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, [MessagingHelper.serverToken])));
      Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
      TokenB token = TokenB(name: "token", id: MessagingHelper.serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));
      setState(() {
        _success = true;
        Future.delayed(Duration(milliseconds: 1500), () async {
          if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user){
            debugPrint('UI_U_login => Account authority: > User');
            Navigator.push(context, MaterialPageRoute(builder: (context) => RBusinessList()));
          }else{
            debugPrint('UI_U_login => Account authority: <= User');
            await FirebaseMessaging.instance.subscribeToTopic('broadcast_user');
            debugPrint('FIREBASE MESSAGING TOP SUBSCRIBTION TO: broadcast_user');
            Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.serviceExplorer, (Route<dynamic> route) => false);
          }
          //Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.myBookings, ModalRoute.withName(AppRoutes.landing));
          //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
        });

      });
    } else {
      Navigator.of(context).pop();
      debugPrint('UI_U_login => esponse: $responseMessage');
      if (responseMessage.isEmpty) {
        setState(() {
          _success = false;
        });
        checkFormValidation();
      }
    }
  }

  void onError(error) {
    setState(() {
      //_success = false;
      print("error is: " + error.toString());
      if (!emailHasError && !passwordHasError) {
        responseMessage = error.message;
        /*showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(error.message, "ok");
          });*/
      }
      _isRequestFlying = false;
    });
  }
}
