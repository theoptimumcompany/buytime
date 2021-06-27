import 'dart:io';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/device.dart';
import 'package:Buytime/reblox/model/snippet/token.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/user/user_state.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../reblox/model/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  final String title = '/forgotPassword';

  @override
  State<StatefulWidget> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  ///Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Text controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool _isRequestFlying = false;
  bool _success = false;
  bool _commited = false;

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

  @override
  void initState() {
    super.initState();
  }

  ///Validation
  void checkFormValidation() {
    setState(() {
      if (_success == null) {
        responseMessage = '';
      } else {
        if (emailHasError) responseMessage = AppLocalizations.of(context).pleaseEnterAValidEmail;
      }
    });
  }

  ///Request new password
  Future<void> requestNewPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() {
        setState(() {
          _success = true;
          responseMessage = AppLocalizations.of(context).mailSendToEmailAddress;
        });
      });
    } catch (error) {
      _success = false;
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          responseMessage = AppLocalizations.of(context).invalidEmailAddress;
          break;
        case "ERROR_USER_NOT_FOUND":
          responseMessage = AppLocalizations.of(context).noUserFoundForInsertedEmail;
          break;
        default:
          responseMessage = AppLocalizations.of(context).invalidEmailAddress;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: BuytimeTheme.UserPrimary,
            ),
            onPressed: () {
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: (SizeConfig.safeBlockVertical * 100) - 56),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    ///Logo & Email & Password & & Error message & Log in button
                    Flexible(
                      flex: 6,
                      child: Container(
                        //height: SizeConfig.safeBlockVertical * 75,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ///Logo
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
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
                                'assets/img/img_buytime.png',
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
                                              AppLocalizations.of(context).insertYourEmail,
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
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                        height: 55,

                                        ///SizeConfig.safeBlockHorizontal * 14
                                        //width: 328,
                                        child: TextFormField(
                                          controller: _emailController,
                                          textAlign: TextAlign.start,
                                          keyboardType: TextInputType.emailAddress,
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
                                        ),
                                      ),

                                      ///Error message
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            //alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(top: 12.0),
                                            child: Text(
                                              responseMessage,
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
                                          onPressed: !_success ? () async {
                                            if (_formKey.currentState.validate()) {
                                              requestNewPassword(_emailController.text);
                                            }
                                          } : null,
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
                  ]),
                ),
              ),
            )));
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

      StoreProvider.of<AppState>(context).dispatch(new LoggedUser(UserState.fromFirebaseUser(user, deviceId, [Environment().config.serverToken])));
      Device device = Device(name: "device", id: deviceId, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserDevice(device));
      TokenB token = TokenB(name: "token", id: Environment().config.serverToken, user_uid: user.uid);
      StoreProvider.of<AppState>(context).dispatch(new UpdateUserToken(token));
      setState(() {
        _success = true;

        if (StoreProvider.of<AppState>(context).state.user.getRole() != Role.user)
          Navigator.push(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
        else
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.landing, (Route<dynamic> route) => false);
        //Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.myBookings, ModalRoute.withName(AppRoutes.landing));
        //StoreProvider.of<AppState>(context).dispatch(new UserBookingRequest(user.email));
      });
    } else {
      Navigator.of(context).pop();
      debugPrint('response: $responseMessage');
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
