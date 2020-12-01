import 'package:BuyTime/UI/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool check_remember = false;

class EasyCheckIn extends StatefulWidget {
  // Classe di Gestione Dialog per Accesso Con NFC o QR-Code
  @override
  State<StatefulWidget> createState() => EasyCheckInState();
}

class EasyCheckInState extends State<EasyCheckIn>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  bool _supportsNFC = false;

  @override
  void initState() {
    super.initState();
    NFC.isNDEFSupported.then((bool isSupported) {
      setState(() {
        _supportsNFC = isSupported;
        if (_supportsNFC) {
          print("Supporta NFC " + isSupported.toString());
        } else {
          print("Non Supporta NFC " + isSupported.toString());
        }
      });
    });

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: media.width * 0.8,
            height: _supportsNFC ? media.height * 0.8 : media.height * 0.6,
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Easy Check-In",
                            style: TextStyle(
                              //color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          endIndent: 30,
                          indent: 30,
                          // height: media.height * 0.05,
                        ),
                        Container(
                          child: Text(
                            "Are you inside the facility?",
                            style: TextStyle(
                              //color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.0),
                          ),
                        ),

                        /* Parte NFC */
                        // Far vedere solo se _supportsNFC is True

                        Container(
                            child: _supportsNFC
                                ? Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/img/hand_nfc.png",
                                    // height: media.height * 0.10,
                                  ),
                                  Image.asset(
                                    "assets/img/nfc.png",
                                    // height: media.height * 0.10,
                                  ),
                                ],
                              ),
                              Container(
                                  width: 300,
                                  //padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "We have detected that your device has NFC, Search the NFC symbol to go directly to the service menu",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  )),
                              Divider(
                                color: Colors.grey,
                                endIndent: 30,
                                indent: 30,
                                // height: media.height * 0.05,
                              ),
                            ])
                                : null),

                        /* Fine Parte NFC */

                        /* Parte QR-Code */

                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10.0))),
                                    padding: EdgeInsets.all(5),
                                    width: media.width * 0.15,
                                    child: Image.asset(
                                      "assets/img/qr_code.png",
                                    ),
                                  ),
                                  Container(
                                      width: 275,
                                      //margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        "find the QR Code around you to quickly check in the service list",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      )),
                                ])),
                        Divider(
                          color: Colors.grey,
                          endIndent: 30,
                          indent: 30,
                          // height: media.height * 0.05,
                        ),

                        /* Button and Remember*/

                        Container(
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Checkbox(
                                    value: check_remember,
                                    onChanged: (bool value) {
                                      /// manage the state of each value
                                      setState(() {
                                        check_remember = value;
                                        print("Valore Check Box : " +
                                            value
                                                .toString()); //Si possono usare Shared Preferences per mantenere la memoria della scelta
                                      });
                                    },
                                  ),
                                  Text(
                                    "Do not show again",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  width: media.width * 0.7,
                                  child: RaisedButton(
                                    onPressed: () async {
                                      print("Spunta " + check_remember.toString());
                                      SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                      await prefs.setBool(
                                          'easy_check_in', check_remember);
                                      Navigator.of(context).pop();
                                    },
                                    padding: EdgeInsets.all(media.width * 0.025),
                                    textColor: Colors.white,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(500.0)),
                                    child: Text(
                                      "Ok I got it!",
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ])),
                      ])),
            ),
          ),
        ),
      ),
    );
  }
}