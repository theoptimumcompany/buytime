import 'dart:math';

import 'package:BuyTime/UI/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/login/UI_U_business_data.dart';
import 'package:BuyTime/UI/user/login/UI_U_login_widget.dart';
import 'package:BuyTime/UI/user/login/UI_U_registration_widget.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class Home extends StatefulWidget {
  final Widget child;

  Home({@required this.child});

  @override
  createState() => _HomeState();

}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  ///Controllers
  AnimationController _animationController;
  VideoPlayerController _controller;

  ///Animations
  Animation _animation;
  Animation _animation2;
  Animation _animation3;

  ///List
  List backgroundVideoList = new List();

  int randomNumber = 0;

  @override
  void initState() {

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 5)
    );

    _animation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(
        parent: _animationController,
        curve: new Interval(0.0 , 0.3, curve: Curves.ease)));

    _animation2 = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _animationController, curve: new Interval(0.28 , 0.5, curve: Curves.ease)));

    _animation3 = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _animationController, curve: new Interval(0.6 , 1.0, curve: Curves.ease)));

    super.initState();

    backgroundVideoList.add('star_trails.mp4');
    backgroundVideoList.add('duomo.mov');
    backgroundVideoList.add('waves.mp4');
    backgroundVideoList.add('snow.mov');
    //backgroundVideoList.add('world.mp4');

    Random random = new Random();
    randomNumber = random.nextInt(backgroundVideoList.length); // from 0 upto 99 included
    // Pointing the video controller to our local asset.
    _controller = VideoPlayerController.asset("assets/video/${backgroundVideoList[randomNumber]}")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    _animationController.forward();

    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Background video & Logo & Buytime text & Slogan
                    Expanded(
                      flex: 5,
                      child: Stack(
                        children: [
                          ///Background video
                          Positioned.fill(
                            child: Align(
                                alignment: Alignment.center,
                                child: _controller.value.initialized
                                    ? SizedBox.expand(
                                  child: FittedBox(
                                    // If your background video doesn't look right, try changing the BoxFit property.
                                    // BoxFit.fill created the look I was going for.
                                    fit: BoxFit.cover,
                                    child: SizedBox(
                                      width: _controller.value.size?.width ?? 0,
                                      height: _controller.value.size?.height ?? 0,
                                      child: VideoPlayer(_controller),
                                    ),
                                  ),
                                ) : Container()
                            ),
                          ),
                          ///Opacity layer
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.black54.withOpacity(0.2),
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
                                    margin: EdgeInsets.only(top: SizeConfig.safeAreaVertical * 3.5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54.withOpacity(0.3),
                                          spreadRadius: 7,
                                          blurRadius: 3,
                                          offset: Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Image.asset('assets/img/img_buytime.png',
                                        height: media.height * 0.15),
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
                                                "Buytime",
                                                style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 28,
                                                    fontWeight: FontWeight.normal,
                                                    color: Colors.white
                                                ),
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
                            bottom: SizeConfig.safeAreaVertical * 3.5,
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
                                          "Unisciti a un nuovo mondo di servizi per il tuo soggiorno in hotel",
                                          style: TextStyle(
                                            //fontFamily: 'Roboto',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ])),
                            ),
                          )
                        ],
                      )
                    ),
                    ///Sign up & Sign in & ToS % PRivacy policy
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              ///Sign up
                              Container(
                                  width: media.width * .6,
                                  margin: EdgeInsets.only(top: 20.0, bottom: 10.0),
                                  child: FadeTransition(
                                    opacity: _animation3,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationWidget()),);
                                      },
                                      textColor: BuytimeTheme.TextWhite,
                                      color: BuytimeTheme.UserPrimary,
                                      padding: EdgeInsets.all(media.width * 0.03),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "Inizia Il Mio Soggiorno",
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
                                  width: media.width * .6,
                                  child: FadeTransition(
                                    opacity: _animation3,
                                    child: RaisedButton(
                                      /*onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BusinessData()),
                                    );
                                  },*/
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginWidget()),
                                        );
                                      },
                                      textColor: BuytimeTheme.UserPrimary.withOpacity(0.3),
                                      color: Colors.white,
                                      padding: EdgeInsets.all(media.width * 0.03),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "Riloggati",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w500,
                                            color: BuytimeTheme.UserPrimary
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          ///ToS & Privacy Policy
                          FadeTransition(
                            opacity: _animation3,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      'Iscrivendoti accetti i nostri ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: BuytimeTheme.userPrimarySwatch[300],
                                          fontWeight: FontWeight.w500
                                      ),
                                      text: 'ToS',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          debugPrint('ToS Clicked');
                                        },
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ' e ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: BuytimeTheme.userPrimarySwatch[300],
                                          fontWeight: FontWeight.w500
                                      ),
                                      text: 'Privacy Policy',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = (){
                                          debugPrint('Privacy Policy Clicked');
                                        },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            /* )*/
          )),
    );
  }
}
