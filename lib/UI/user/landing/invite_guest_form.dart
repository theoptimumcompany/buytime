import 'dart:async';

import 'package:BuyTime/UI/user/booking/UI_U_ConfirmBooking.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InviteGuestForm extends StatefulWidget {


  @override
  _InviteGuestFormState createState() => _InviteGuestFormState();
}

class _InviteGuestFormState extends State<InviteGuestForm> {
  TextEditingController bookingCodeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    FocusScopeNode currentFocus = FocusScope.of(context);
     bool bookingRequest = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BuytimeTheme.BackgroundCerulean,
        brightness: Brightness.dark,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: (){

            },
          ),
        ],
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
          onPressed: () async{

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }

            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: SizeConfig.safeBlockVertical * 100 - 56,
              color: BuytimeTheme.BackgroundCerulean,
              child: Stack(
                children: [
                  ///Bookin Code
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Enter Booking Code Title
                          Container(
                            margin: EdgeInsets.only(top: 10.0, left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                            child: Text(
                              'Booking Code'.toUpperCase(),
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.safeBlockHorizontal * 8
                              ),
                            ),
                          ),
                          ///Enter Booking Code Subtitle
                          Container(
                            margin: EdgeInsets.only(top: 50.0, left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                            child: Text(
                              'Enter your booking code',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: SizeConfig.safeBlockHorizontal * 5
                              ),
                            ),
                          ),
                          ///Booking Code
                          Container(
                            margin: EdgeInsets.only(top: 20.0, left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                            height: SizeConfig.safeBlockHorizontal * 40,
                            child: TextFormField(
                              autofocus: true,
                              controller: bookingCodeController,
                              textAlign: TextAlign.center,
                              maxLength: 6,
                              decoration: InputDecoration(
                                counter: Offstage(),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                labelText: currentFocus.hasFocus ? '' : 'Booking Code',
                                //hintText: 'Booking Code',
                                helperText: 'Your booking code is a ## digits code included in the email and text notification the hotel sent you',
                                //hintText: "email *",
                                //hintStyle: TextStyle(color: Color(0xff666666)),
                                labelStyle: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Color(0xff666666),
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.0,
                                ),
                                helperMaxLines: 3,
                                helperStyle: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.0,
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Color(0xff666666),
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                letterSpacing: 5.0,
                              ),
                              onEditingComplete: (){
                                debugPrint('done');
                                ///Ripple
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return  WillPopScope(
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
                                              )
                                          )
                                      );
                                    });

                                Timer(Duration(milliseconds: 5000), (){
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ConfirmBooking()),
                                  );
                                });

                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ///Ripple Effect
                  bookingRequest ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
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
                                  width: 50,
                                  height: 50,
                                  child: Center(
                                    child: SpinKitRipple(
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ) : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}