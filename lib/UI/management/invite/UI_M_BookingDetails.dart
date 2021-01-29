import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  final TextEditingController _numberOfGuestsController = TextEditingController();

  String fullName = '';
  String email = '';

  ///Booking code
  String bookingCode;

  BookingState bookingState;

  @override
  void initState() {
    super.initState();

    bookingState = widget.bookingState;

    fullName = '${bookingState.user.first.name} ${bookingState.user.first.surname}';
    email = bookingState.user.first.email;
    _checkInController.text = DateFormat('dd/MM/yyyy').format(bookingState.start_date);
    _checkOutController.text = DateFormat('dd/MM/yyyy').format(bookingState.end_date);
    _numberOfGuestsController.text = bookingState.guest_number_booked_for.toString() ?? '';
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
                            height: SizeConfig.safeBlockVertical * 55,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                ///Full Name
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            'Full Name',
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.DividerGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                          child: Text(
                                            fullName,
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextDark,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ///Email
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            'Email',
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.DividerGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                          child: Text(
                                            email,
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextDark,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
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
                                                  //await _selectDate(context, _checkInController, checkIn, checkOut);
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
                                                  /*validator: (String value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter a valid interval of dates';
                                                    }
                                                    return null;
                                                  },*/
                                                ),
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1, right: SizeConfig.blockSizeHorizontal * 1),

                                          ),
                                          ///Check Out
                                          Expanded(
                                              child: GestureDetector(
                                                onTap: () async{
                                                  //await _selectDate(context, _checkOutController, checkIn, checkOut);
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
                                                  /*validator: (String value) {
                                                    debugPrint('${checkIn.compareTo(checkOut)}');
                                                    if (value.isEmpty || checkIn.compareTo(checkOut) > 0) {
                                                      return 'Please enter a valid interval of dates';
                                                    }
                                                    return null;
                                                  },*/
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
                                        enabled: false,
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
