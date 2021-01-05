import 'dart:async';

import 'package:BuyTime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingConfirmation extends StatefulWidget {


  @override
  _BookingConfirmationState createState() => _BookingConfirmationState();
}

class _BookingConfirmationState extends State<BookingConfirmation> {
  TextEditingController bookingCodeController = new TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: BuytimeTheme.BackgroundCerulean,
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Confirm new booking Text
              Expanded(
                flex: 3,
                child: Container(
                  color: BuytimeTheme.BackgroundCerulean,
                  //height: SizeConfig.safeBlockVertical * 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                        margin: EdgeInsets.only(left: 25.0),
                        child: Text(
                          'Confirm new booking',
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 7
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 18,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 1.5),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/img/placeholder.png'),
                              fit: BoxFit.contain
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ///Hotel Name Text
                          Container(
                            child: Text(
                              'HotelName',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          ///Location & Country Text
                          Container(
                            child: Text(
                              'Location, Country',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          ///Guest Number
                          Container(
                            child: Text(
                              '## guests',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          ///Holiday Period
                          Container(
                            child: Text(
                              '12 June - 18 June 2021',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                          ///Confirm Booking
                          Container(
                              width: SizeConfig.safeBlockHorizontal * 50,
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2),
                              child: RaisedButton(
                                onPressed: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);
                                  /*Timer(Duration(milliseconds: 5000), (){
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => BookingPage()),
                                    );
                                  });*/
                                },
                                textColor: BuytimeTheme.TextWhite,
                                color: BuytimeTheme.UserPrimary,
                                padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "CONFIRM BOOKING",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ),
                          ///Something Isnt Right
                          Container(
                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 10),
                              alignment: Alignment.center,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: (){
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        'SOMETHING ISN\'T RIGHT',
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xff207cc3),
                                            fontWeight: FontWeight.w400,
                                            fontSize: SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    )
                                ),
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}