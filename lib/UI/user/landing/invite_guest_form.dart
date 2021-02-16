import 'dart:async';

import 'package:Buytime/UI/user/booking/UI_U_ConfirmBooking.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InviteGuestForm extends StatefulWidget {

  String id;
  InviteGuestForm(this.id);
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

    Timer(Duration(seconds: 2), () => setState(() {
      bookingRequest = '';
    }));

  }


  @override
  void dispose() {
    debugPrint('invite_guest_form: Dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    FocusScopeNode currentFocus = FocusScope.of(context);
     //bool bookingRequest = false;

    return Stack(
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Enter Booking Code Title
                            Container(
                              margin: EdgeInsets.only(top: 10.0, left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                              child: Text(
                                AppLocalizations.of(context).bookingCode.toUpperCase(),
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
                                AppLocalizations.of(context).enterYourBookingCode,
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
                                autofocus: bookingCodeController.text.isNotEmpty ? false : true,
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
                                  labelText: currentFocus.hasFocus ? '' : AppLocalizations.of(context).bookingCode,
                                  //hintText: 'Booking Code',
                                  helperText: AppLocalizations.of(context).yourBookingCodeIs,
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
    );
  }
}