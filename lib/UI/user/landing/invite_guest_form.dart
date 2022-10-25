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

import 'package:Buytime/UI/user/booking/UI_U_confirm_booking.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteGuestForm extends StatefulWidget {

  String id;
  bool fromLanding;
  //InviteGuestForm(this.id);
  InviteGuestForm({Key key, this.id, this.fromLanding}) : super(key: key);
  @override
  _InviteGuestFormState createState() => _InviteGuestFormState();
}

class _InviteGuestFormState extends State<InviteGuestForm> {
  TextEditingController bookingCodeController = new TextEditingController();

  String bookingRequest = '';

  BookingState state;
  @override
  void initState() {
    super.initState();
    bookingCodeController.text = widget.id;
    if(bookingCodeController.text.isNotEmpty)
      WidgetsBinding.instance.addPostFrameCallback((_) => onBookingCode());
    state = new BookingState(business_id: null, business_name: null, business_address: null, guest_number_booked_for: null, start_date: null, end_date: null, booking_code: null, user: null, status: null, wide: null);
  }

  onBookingCode(){
    FocusScope.of(context).unfocus();
    ///Ripple
    /*showDialog(context: context, builder: (context) {return  WillPopScope(
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
          );});*/
    setState(() {
      bookingRequest = 'send';
    });
    StoreProvider.of<AppState>(context).dispatch(BookingRequest(bookingCodeController.text));

    /*Timer(Duration(seconds: 3), () => setState(() {
      bookingRequest = '';
    }));*/
  }

  ///Storage
  final storage = new FlutterSecureStorage();


  @override
  void dispose() {
    debugPrint('invite_guest_form: Dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    FocusScopeNode currentFocus = FocusScope.of(context);
     //bool bookingRequest = false;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          debugPrint('invite_quest_form => BOOKING CODE: ${snapshot.booking.booking_code}');
          if(snapshot.booking.booking_code != '' && bookingRequest == 'send')
            bookingRequest = '';
          //order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
          return  Stack(
            children: [
              ///Edit Business
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Scaffold(
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
                        centerTitle: true,
                        title: Text(
                          AppLocalizations.of(context).bookingCode,
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: BuytimeTheme.TextWhite,
                              fontWeight: FontWeight.w700,
                              fontSize: 20 ///SizeConfig.safeBlockHorizontal * 8
                          ),
                        ),
                        leading: IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ),
                          onPressed: () async{

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            await storage.delete(key: 'bookingCode');
                            await storage.write(key: 'bookingCodeRead', value: 'false');
                            await Future.delayed(const Duration(milliseconds: 500));
                            StoreProvider.of<AppState>(context).dispatch(BookingRequestResponse(BookingState().toEmpty()));
                            if(widget.fromLanding)
                              Navigator.of(context).pop();
                            else
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                          },
                        ),
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            height: (SizeConfig.safeBlockVertical * 100) - 56,
                            color: BuytimeTheme.BackgroundCerulean,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Enter Booking Code Title
                                /*Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                  child: Text(
                                    AppLocalizations.of(context).bookingCode.toUpperCase(),
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextWhite,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26 ///SizeConfig.safeBlockHorizontal * 8
                                    ),
                                  ),
                                ),*/
                                ///Enter Booking Code Subtitle
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                  child: Text(
                                    AppLocalizations.of(context).enterYourBookingCode,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextWhite,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24 ///SizeConfig.safeBlockHorizontal * 5
                                    ),
                                  ),
                                ),
                                ///Booking Code
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                  height: SizeConfig.safeBlockHorizontal * 40, ///SizeConfig.safeBlockHorizontal * 40
                                  child: TextFormField(
                                    autofocus: bookingCodeController.text.isNotEmpty ? false : true,
                                    controller: bookingCodeController,
                                    textAlign: TextAlign.center,
                                    maxLength: 6,
                                    // maxLengthEnforced: false,
                                    //inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                    decoration: InputDecoration(
                                      counter: Offstage(),
                                      fillColor: BuytimeTheme.TextWhite,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                      labelText: currentFocus.hasFocus ? '' : AppLocalizations.of(context).bookingCode,
                                      //hintText: 'Booking Code',
                                      helperText: AppLocalizations.of(context).yourBookingCodeIs,
                                      //StoreProvider.of<AppState>(context).state.booking.booking_code != 'error' ? AppLocalizations.of(context).yourBookingCodeIs : 'Your booking code does not appear to be valid.',
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
                                      onBookingCode();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ),
              ///Ripple Effect
              bookingRequest.isNotEmpty ? Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
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
                  ),
                ),
              ) : Container()
            ],
          );
        }
    );
  }
}