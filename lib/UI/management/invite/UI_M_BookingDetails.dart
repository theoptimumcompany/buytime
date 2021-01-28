import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookingDetails extends StatefulWidget {
  static String route = '/bookingDetails';

  BookingState bookingState;
  BookingDetails({Key key, this.bookingState}) : super(key: key);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

  ///Global key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///Text controller
  final TextEditingController _checkIn = TextEditingController();
  final TextEditingController _checkOut = TextEditingController();
  final TextEditingController _numberOfGuests = TextEditingController();

  ///Booking code
  String bookingCode;

  BookingState bookingState;

  @override
  void initState() {
    super.initState();

    bookingState = widget.bookingState;

    _checkIn.text = bookingState.start_date.toString() ?? '';
    _checkOut.text = bookingState.end_date.toString() ?? '';
    _numberOfGuests.text = bookingState.guest_number_booked_for.toString() ?? '';
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
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
                "Invite Guest",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: media.height * 0.025,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        drawer: UI_M_BusinessListDrawer(),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Container(
                    height: (SizeConfig.safeBlockVertical * 100) - 56,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Title
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 2),
                            child: Text(
                              'GUEST DETAILS',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          ///Booking Code & Email & Name & Surname & Check In & Check Out & Number Of Guests
                          Container(
                            height: SizeConfig.safeBlockVertical * 70,
                            child: Column(
                              children: [
                                ///Booking code
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                  child:  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          child: Text(
                                            'Booking id',
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextDark,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                bookingState.booking_code,
                                                style: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextDark,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 26
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
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
                                            child: TextFormField(
                                              controller: _checkIn,
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
                                                  labelText: 'Check-in',
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
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w800,
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter a date';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),

                                          ),
                                          ///Check Out
                                          Expanded(
                                            child: TextFormField(
                                              controller: _checkOut,
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
                                                  labelText: 'Check-out',
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
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w800,
                                              ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter a date';
                                                }
                                                return null;
                                              },
                                            ),
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
                                        controller: _numberOfGuests,
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
                                          labelText: 'Number of guests',
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
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
