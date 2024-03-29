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

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/login/UI_U_t_o_s_terms_conditons.dart';
import 'package:Buytime/UI/user/login/UI_U_login.dart';
import 'package:Buytime/UI/user/login/UI_U_registration.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  //final Widget child;
  static String route = '/home';

  //Home();

  @override
  createState() => _HomeState();
}
VideoPlayerController controller;
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  ///Controllers
  AnimationController _animationController;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);

  ///Animations
  Animation _animation;
  Animation _animation2;
  Animation _animation3;

  ///List
  List backgroundVideoList = new List();

  int randomNumber = 0;
  //String _authStatus = 'Unknown';

  String tcPdfPath = '';
  String tosPdfPath = '';
  String urlPdf = '';

  // Future<void> initPlugin() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  //     setState(() => _authStatus = '$status');
  //     // If the system can show an authorization request dialog
  //     if (status == TrackingStatus.notDetermined) {
  //         final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
  //         setState(() => _authStatus = '$status');
  //
  //     }
  //   } on PlatformException {
  //     setState(() => _authStatus = 'PlatformException was thrown');
  //   }
  // }

  @override
  void initState() {
   // WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5));

    _animation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _animationController, curve: new Interval(0.0, 0.3, curve: Curves.ease)));

    _animation2 = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _animationController, curve: new Interval(0.28, 0.5, curve: Curves.ease)));

    _animation3 = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _animationController, curve: new Interval(0.6, 1.0, curve: Curves.ease)));

    super.initState();
    // backgroundVideoList.add('waves.mp4');
    backgroundVideoList.add('waves_2.mp4');
    backgroundVideoList.add('sea_trees.mp4');
    // backgroundVideoList.add('castle.mp4');
    // backgroundVideoList.add('sail.mp4');

    Random random = new Random();
    randomNumber = random.nextInt(backgroundVideoList.length); // from 0 upto 99 included
    // Pointing the video controller to our local asset.
    controller = VideoPlayerController.asset("assets/video/${backgroundVideoList[randomNumber]}", videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        controller.play();
        controller.setLooping(true);
        controller.setVolume(0.0);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });

    /// Get User manual from assets folder
    getFileFromAssets("assets/documents/Buytime_t_c.pdf", 'Buytime_t_c.pdf').then((f) {
      setState(() {
        tcPdfPath = f.path;
        debugPrint('UI_U_home => full path tc: ' + tcPdfPath);
      });
    });

    getFileFromAssets("assets/documents/Buytime_p_p.pdf", 'Buytime_p_p.pdf').then((f) {
      setState(() {
        tosPdfPath = f.path;
        debugPrint('UI_U_home => full path tos: ' + tosPdfPath);
      });
    });

    /*createFileOfPdfUrl().then((f) {
      setState(() {
        urlPdf = f.path;
        debugPrint('UI_U_home => full path url: ' + urlPdf);
      });
    });*/
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    debugPrint("UI_U_home => Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = "http://www.pdf995.com/samples/pdf.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      debugPrint("UI_U_home => Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  /// PDF loader from assets
  Future<File> getFileFromAssets(String asset, String fileName) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
    controller.dispose();
    debugPrint('UI_U_home => home dispose');
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    _animationController.forward();

    SizeConfig().init(context);
    //ScreenUtil.init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ///Background video & Logo & Buytime text & Slogan
            Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    ///Background video
                    Positioned.fill(
                      child: Align(
                          alignment: Alignment.center,
                          child: controller.value.isInitialized
                              ? SizedBox.expand(
                                  child: FittedBox(
                                    // If your background video doesn't look right, try changing the BoxFit property.
                                    // BoxFit.fill created the look I was going for.
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: controller.value.size?.width ?? 0,
                                      height: controller.value.size?.height ?? 0,
                                      child: VideoPlayer(
                                        controller,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()),
                    ),

                    ///Opacity layer
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Color(0xff1b4c72).withOpacity(0.5),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                    ///Logo & Buytime text
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            ///Logo
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                /*boxShadow: [
                                      BoxShadow(
                                        color: BuytimeTheme.BackgroundBlack.withOpacity(0.3),
                                        spreadRadius: 7,
                                        blurRadius: 3,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],*/
                              ),
                              child: Image.asset(
                                'assets/img/brand/logo.png',
                                height: 96,

                                ///media.height * 0.12
                              ),
                            ),
                            SizedBox(
                              height: media.height * .05,
                            ),

                            ///Buytime text
                            Container(
                                // width: media.width * .8,
                                child: Wrap(
                              children: [
                                FadeTransition(
                                  opacity: _animation,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      AppLocalizations.of(context).buytime,
                                      style: BuytimeTheme.whiteTitle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),

                    ///Slogan
                    Positioned.fill(
                      bottom: SizeConfig.safeBlockVertical * 12.5,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            // width: media.width * .6,
                            child: Wrap(children: [
                          FadeTransition(
                            opacity: _animation2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Text(
                                AppLocalizations.of(context).joinHotel,
                                style: BuytimeTheme.whiteSubtitle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ])),
                      ),
                    )
                  ],
                )),

            ///Sign up & Sign in & ToS % Privacy policy
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*SizeConfig.screenHeight < 537 ?
                      Column(
                        children: [
                          ///Sign up
                          Container(
                              width: 247, ///media.width * .6 | 247 | izeConfig.safeBlockHorizontal * 57
                              height: 50, ///50 | SizeConfig.safeBlockVertical * 6.5
                              margin: EdgeInsets.only(top: 48, bottom: 24), ///SizeConfig.safeBlockVertical * 5 | SizeConfig.safeBlockVertical * 2
                              child: FadeTransition(
                                opacity: _animation3,
                                child: MaterialButton(
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);
                                  },
                                  textColor: BuytimeTheme.TextWhite,
                                  color: BuytimeTheme.ButtonMalibu,
                                  padding: EdgeInsets.all(media.width * 0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).startStay,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )),
                          ///Sign in
                          Container(
                              width: 247, ///media.width * .6 | 247 | izeConfig.safeBlockHorizontal * 57
                              height: 50, ///50 | SizeConfig.safeBlockVertical * 6.5
                              child: FadeTransition(
                                opacity: _animation3,
                                child: MaterialButton(
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                  */
                  /*onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusinessData()),
                                  );
                                },*/
                  /*
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()),
                                    );
                                  },
                                  textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(media.width * 0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).logBack,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        color: BuytimeTheme.ButtonMalibu
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ) :
                      Column(
                        children: [
                          ///Sign up
                          Container(
                              width: 247, ///media.width * .6 | 247 | izeConfig.safeBlockHorizontal * 57
                              height: 50, ///50 | SizeConfig.safeBlockVertical * 6.5
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2),
                              child: FadeTransition(
                                opacity: _animation3,
                                child: MaterialButton(
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);
                                  },
                                  textColor: BuytimeTheme.TextWhite,
                                  color: BuytimeTheme.ButtonMalibu,
                                  padding: EdgeInsets.all(media.width * 0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).startStay,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )),
                          ///Sign in
                          Container(
                              width: 247, ///media.width * .6 | 247 | izeConfig.safeBlockHorizontal * 57
                              height: 50, ///50 | SizeConfig.safeBlockVertical * 6.5
                              child: FadeTransition(
                                opacity: _animation3,
                                child: MaterialButton(
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                  */
                  /*onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusinessData()),
                                  );
                                },*/
                  /*
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Login()),
                                    );
                                  },
                                  textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                                  color: Colors.white,
                                  padding: EdgeInsets.all(media.width * 0.03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).logBack,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        color: BuytimeTheme.ButtonMalibu
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),*/
                  Column(
                    children: [
                      ///Register
                      Container(
                          width: 247,

                          /// media.width * .6 | 247 | SizeConfig.safeBlockHorizontal * 68
                          height: 50,

                          /// 50 | SizeConfig.safeBlockVertical * 8.5
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),

                          /// 48 | SizeConfig.safeBlockVertical * 5 | 24 | SizeConfig.safeBlockVertical * 2
                          child: FadeTransition(
                            opacity: _animation3,
                            child: MaterialButton(
                              key: Key('home_register_key'),
                              elevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              onPressed: () {
                                setState(() {
                                  controller.pause();
                                });
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);
                                Navigator.of(context).pushNamed(Registration.route);
                              },
                              textColor: BuytimeTheme.TextWhite,
                              color: BuytimeTheme.ButtonMalibu,
                              //padding: EdgeInsets.all(media.width * 0.03),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context).register.toUpperCase(),
                                  style: TextStyle(
                                    letterSpacing: 1.25,
                                    fontSize: 14,

                                    ///16 | SizeConfig.safeBlockHorizontal * 4.5
                                    fontFamily: BuytimeTheme.FontFamily,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )),

                      ///Login
                      FadeTransition(
                        opacity: _animation3,
                        child: Container(
                            width: 247,

                            /// media.width * .6 | 247 | SizeConfig.safeBlockHorizontal * 68
                            height: 50,

                            /// 50 | SizeConfig.safeBlockVertical * 8.5
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            decoration: BoxDecoration(borderRadius: new BorderRadius.circular(5), border: Border.all(color: BuytimeTheme.SymbolLightGrey)),
                            child: MaterialButton(
                              key: Key('home_login_key'),
                              elevation: 0,
                              hoverElevation: 0,
                              focusElevation: 0,
                              highlightElevation: 0,
                              /*onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusinessData()),
                                  );
                                },*/
                              onPressed: () {
                                controller.pause();
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),;
                                Navigator.of(context).pushNamed(Login.route);
                              },
                              textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                              color: Colors.white,
                              //padding: EdgeInsets.all(media.width * 0.03),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(5),
                              ),
                              child: Text(
                                AppLocalizations.of(context).logIn.toUpperCase(),
                                style: TextStyle(
                                    letterSpacing: 1.25,
                                    fontSize: 14,

                                    ///18 | SizeConfig.safeBlockHorizontal * 5
                                    fontFamily: BuytimeTheme.FontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: BuytimeTheme.ButtonMalibu),
                              ),
                            )),
                      ),

                      ///Free Access (Tourist)
                      FadeTransition(
                          opacity: _animation3,
                          child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                              alignment: Alignment.center,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  key: Key('free_access_key'),
                                    onTap: () {
                                      controller.pause();
                                      Navigator.of(context).pushNamed(RServiceExplorer.route);
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        AppLocalizations.of(context).exploreNetwork,
                                        style: TextStyle(letterSpacing: 1.25, fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, color: BuytimeTheme.TextMalibu),
                                      ),
                                    )),
                              )))
                    ],
                  ),

                  ///ToS & Privacy Policy
                  FadeTransition(
                    opacity: _animation3,
                    child: Container(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0.0, bottom: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ///By signing ...
                              Container(
                                child: Text(
                                  "${AppLocalizations.of(context).bySigningUpYourAgreeToOur} ",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ),

                              ///Tod
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: BuytimeTheme.userPrimarySwatch[300], fontSize: 14, fontWeight: FontWeight.w400),
                                  text: AppLocalizations.of(context).tos,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      debugPrint('UI_U_home => ToS Clicked: ' + tcPdfPath);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TosTermsConditons(tcPdfPath)));
                                    },
                                ),
                              ),

                              ///And
                              Container(
                                child: Text(
                                  " ${AppLocalizations.of(context).and} ",
                                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ),

                              ///Privacy Policies
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(color: BuytimeTheme.userPrimarySwatch[300], fontSize: 14, fontWeight: FontWeight.w400),
                                  text: AppLocalizations.of(context).privacyPolicy,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      debugPrint('UI_U_home => Privacy Policy Clicked: ' + tosPdfPath);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => TosTermsConditons(tosPdfPath)));
                                    },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
        /* )*/
      ),
    );
  }
}
