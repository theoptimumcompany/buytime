import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/services/business_service_epic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';


import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class BookingCreation extends StatefulWidget {
  static String route = '/bookingCreation';

  BookingCreation({Key key}) : super(key: key);

  @override
  _BookingCreationState createState() => _BookingCreationState();
}

class _BookingCreationState extends State<BookingCreation> {

  ///Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Text controller
  final TextEditingController _emailToInviteController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _numberOfGuestsController = TextEditingController();


  DateTime checkIn = DateTime.now().toUtc();
  DateTime checkOut = DateTime.now().toUtc();

  String bookingRequest = '';

  @override
  void initState() {
    super.initState();
  }

  ///Drawer Key
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  BookingState bookingState = BookingState().toEmpty();


  Future<void> _selectDate(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: cIn, end: cOut),
        firstDate: new DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
        lastDate: new DateTime(2025)
    );
    if (picked != null && picked.start != null && picked.end != null) {
      print(picked);
      _checkInController.text = DateFormat('dd/MM/yyyy').format(picked.start);
      _checkOutController.text = DateFormat('dd/MM/yyyy').format(picked.end);
      setState(() {
        /*checkIn = picked.start.toUtc();
        checkOut = picked.end.toUtc();*/
        checkIn = DateTime.utc(picked.start.year, picked.start.month, picked.start.day);
        checkOut = DateTime.utc(picked.end.year, picked.end.month, picked.end.day);
      });
    }
    return null;
  }

  bool checkOutCheck = false;

  bool validateDates(){
    if(_checkInController.text.isEmpty || _checkOutController.text.isEmpty || checkIn.compareTo(checkOut) > 0)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {

    FocusScopeNode currentFocus = FocusScope.of(context);

    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {
        BusinessState businessState = snapshot.business;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,
            ///Appbar
            appBar: AppBar(
              backgroundColor: BuytimeTheme.ManagerPrimary,
              title: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: Text(
                    //AppLocalizations.of(context).inviteGuest,
                    AppLocalizations.of(context).createInvite,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: media.height * 0.025,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
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
            //drawer: UI_M_BusinessListDrawer(),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                        height: (SizeConfig.safeBlockVertical * 100) - 60,
                        child: Stack(
                          children: [
                            ///Booking Code
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Title
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 3),
                                            child: Text(
                                              AppLocalizations.of(context).enterGuestDetails,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                  letterSpacing: 1.5
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                      ///Booking Code & Email & Name & Surname & Check In & Check Out & Number Of Guests
                                      Container(
                                        height: SizeConfig.safeBlockVertical * 70,
                                        child: Column(
                                          children: [
                                            ///Booking code
                                            /*Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                              child:  Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  // Expanded( // this is generated during booking creation for the database so it is shown AFTER the booking is created.
                                                  //   flex: 2,
                                                  //   child: Container(
                                                  //     child: Text(
                                                  //       'Booking id',
                                                  //       style: TextStyle(
                                                  //           fontFamily: BuytimeTheme.FontFamily,
                                                  //           color: BuytimeTheme.TextDark,
                                                  //           fontWeight: FontWeight.w500,
                                                  //           fontSize: 18
                                                  //       ),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Expanded(  // this is generated during booking creation for the database so it is shown AFTER the booking is created.
                                                  //   flex: 3,
                                                  //   child: Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.start,
                                                  //     children: [
                                                  //       Container(
                                                  //         child: Text(
                                                  //           bookingCode,
                                                  //           style: TextStyle(
                                                  //               fontFamily: BuytimeTheme.FontFamily,
                                                  //               color: BuytimeTheme.TextDark,
                                                  //               fontWeight: FontWeight.bold,
                                                  //               fontSize: 26
                                                  //           ),
                                                  //         ),
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),*/
                                            ///Email address
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    controller: _emailToInviteController,
                                                    textAlign: TextAlign.start,
                                                    keyboardType: TextInputType.emailAddress,
                                                    autofillHints: [AutofillHints.email],
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xff666666)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      labelText: AppLocalizations.of(context).emailToInvite,
                                                      //hintText: "email *",
                                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                                      labelStyle: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Color(0xff666666),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      errorStyle: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.AccentRed,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: BuytimeTheme.FontFamily,
                                                      color: BuytimeTheme.TextMedium,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 16
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty && !EmailValidator.validate(value)) {
                                                        return AppLocalizations.of(context).pleaseEnterAValidEmail;
                                                      }
                                                      return null;
                                                    },
                                                  )
                                              ),
                                            ),
                                            ///Name
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    controller: _nameController,
                                                    textAlign: TextAlign.start,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xff666666)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      labelText: AppLocalizations.of(context).name,
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
                                                        color: BuytimeTheme.TextMedium,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return AppLocalizations.of(context).pleaseEnterAValidName;
                                                      }
                                                      return null;
                                                    },
                                                  )
                                              ),
                                            ),
                                            ///Surname
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    controller: _surnameController,
                                                    textAlign: TextAlign.start,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xff666666)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      labelText: AppLocalizations.of(context).surname,
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
                                                        color: BuytimeTheme.TextMedium,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    ),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        return AppLocalizations.of(context).pleaseEnterAValidSurname;
                                                      }
                                                      return null;
                                                    },
                                                  )
                                              ),
                                            ),
                                            ///Check In & Check Out
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ///Check In
                                                      Expanded(
                                                          child:  GestureDetector(
                                                            onTap: ()async{
                                                              await _selectDate(context, checkIn, checkOut);
                                                            },
                                                            child: TextFormField(
                                                              enabled: false,
                                                              controller: _checkInController,
                                                              textAlign: TextAlign.start,
                                                              keyboardType: TextInputType.datetime,
                                                              decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: BuytimeTheme.DividerGrey,
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Color(0xff666666)),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                  ),
                                                                  labelText: AppLocalizations.of(context).checkIn,
                                                                  //hintText: "email *",
                                                                  //hintStyle: TextStyle(color: Color(0xff666666)),
                                                                  labelStyle: TextStyle(
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: Color(0xff666666),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                  suffixIcon: Icon(
                                                                      Icons.calendar_today
                                                                  )
                                                              ),
                                                              style: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextMedium,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 16
                                                              ),
                                                              validator: (String value) {
                                                                if (value.isEmpty) {
                                                                  return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          )),
                                                      Container(
                                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),

                                                      ),
                                                      ///Check Out
                                                      Expanded(
                                                          child: GestureDetector(
                                                            onTap: () async{
                                                              await _selectDate(context, checkIn, checkOut);
                                                            },
                                                            child: TextFormField(
                                                              enabled: false,
                                                              controller: _checkOutController,
                                                              textAlign: TextAlign.start,
                                                              keyboardType: TextInputType.datetime,
                                                              decoration: InputDecoration(
                                                                  filled: true,
                                                                  fillColor: BuytimeTheme.DividerGrey,
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                  ),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(color: Color(0xff666666)),
                                                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                  ),
                                                                  labelText: AppLocalizations.of(context).checkOut,
                                                                  //hintText: "email *",
                                                                  //hintStyle: TextStyle(color: Color(0xff666666)),
                                                                  labelStyle: TextStyle(
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: Color(0xff666666),
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                  suffixIcon: Icon(
                                                                      Icons.calendar_today
                                                                  )
                                                              ),
                                                              style: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.TextMedium,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 16
                                                              ),
                                                              validator: (String value) {
                                                                debugPrint('${checkIn.compareTo(checkOut)}');
                                                                if (value.isEmpty || checkIn.compareTo(checkOut) > 0) {
                                                                  return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ),
                                            ///Number of guests
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    controller: _numberOfGuestsController,
                                                    textAlign: TextAlign.start,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Color(0xff666666)),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      errorBorder: OutlineInputBorder(
                                                          borderSide: BorderSide(color: Colors.redAccent),
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                      ),
                                                      labelText: AppLocalizations.of(context).numberOfGuest,
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
                                                        color: BuytimeTheme.TextMedium,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16
                                                    ),
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      ///Create Invite
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 180, ///media.width * .5
                                              height: 44,
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),
                                              child: RaisedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState.validate()) {

                                                    setState(() {
                                                      bookingRequest = 'send';
                                                    });

                                                    bookingState.business_id = businessState.id_firestore;
                                                    bookingState.business_name = businessState.name;
                                                    bookingState.guest_number_booked_for = _numberOfGuestsController.text.isNotEmpty ? int.parse(_numberOfGuestsController.text) : 1;

                                                    UserSnippet currentUser = UserSnippet(
                                                        name: _nameController.text,
                                                        surname: _surnameController.text,
                                                        email: _emailToInviteController.text
                                                    );

                                                    bookingState.user.add(currentUser);

                                                    bookingState.wide = businessState.wide;

                                                    bookingState.start_date = checkIn;
                                                    bookingState.end_date = checkOut;

                                                    debugPrint('UI_M_BookingCreation => Start date: ${bookingState.start_date}');
                                                    debugPrint('UI_M_BookingCreation => End date: ${bookingState.end_date}');

                                                    bookingState.status = Utils.enumToString(BookingStatus.created);

                                                    bookingState.userEmail.add(_emailToInviteController.text);

                                                    StoreProvider.of<AppState>(context).dispatch(CreateBookingRequest(bookingState));


                                                    Timer(
                                                      Duration(seconds: 1), () {
                                                        setState(() {
                                                          bookingRequest = '';
                                                        });
                                                      }
                                                    );
                                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails(bookingState: bookingState)));

                                                  }
                                                },
                                                textColor: BuytimeTheme.TextDark,
                                                color: BuytimeTheme.Secondary,
                                                padding: EdgeInsets.all(media.width * 0.03),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).createInviteUpper,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          fontWeight: FontWeight.w600,
                                                          color: BuytimeTheme.TextDark,
                                                          letterSpacing: 1.25
                                                      ),
                                                    )],
                                                ),
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ///Ripple Effect
                            bookingRequest.isNotEmpty ? Positioned.fill(
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
                      )
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
