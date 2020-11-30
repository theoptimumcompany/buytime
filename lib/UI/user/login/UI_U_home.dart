import 'package:BuyTime/UI/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/login/UI_U_business_data.dart';
import 'package:BuyTime/UI/user/login/UI_U_login_widget.dart';
import 'package:BuyTime/UI/user/login/UI_U_registration_widget.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  final Widget child;

  Home({@required this.child});

  @override
  createState() => _HomeState();

}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation _animation;
  Animation _animation2;
  Animation _animation3;


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

    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: media.width * 0.11),
                Container(
                  child: Image.asset('assets/img/img_buytime.png',
                      height: media.height * 0.22),
                ),
                SizedBox(
                  height: media.height * .005,
                ),
                Container(
                    // width: media.width * .8,
                    child: Wrap(
                      children: [
                        FadeTransition(
                          opacity: _animation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              "Ciao, benvenuto sul tuo centro servizi!",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 28,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )),
                SizedBox(
                  height: media.height * .005,
                ),
                Container(
                    // width: media.width * .6,
                    child: Wrap(children: [
                      FadeTransition(
                        opacity: _animation2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "Iscriviti come utente o come business",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 24,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ])),
                SizedBox(
                  height: media.height * 0.05,
                ),
                Container(
                    width: media.width * .7,
                    child: FadeTransition(
                      opacity: _animation3,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationWidget()),
                          );
                        },
                        textColor: BuytimeTheme.TextWhite,
                        color: BuytimeTheme.UserPrimary,
                        padding: EdgeInsets.all(media.width * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(500.0),
                        ),
                        child: Text(
                          "Cerco un servizio",
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                Container(
                    width: media.width * .7,
                    child: FadeTransition(
                      opacity: _animation3,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusinessData()),
                          );
                        },
                        textColor: BuytimeTheme.TextWhite,
                        color: BuytimeTheme.UserPrimary,
                        padding: EdgeInsets.all(media.width * 0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(500.0),
                        ),
                        child: Text(
                          "Ho un'attività",
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: media.height * 0.001,
                ),
                FadeTransition(
                  opacity: _animation3,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginWidget()),
                        );
                      },
                      child: Text(
                        "Ho già un account",
                        style: TextStyle(
                          fontSize: 22,
                          color: BuytimeTheme.TextDark,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.normal,
                        ),
                      )),
                )
              ],
            )),
            /* )*/
          )),
    );
  }
}
