import 'package:BuyTime/UI/management/invite/UI_M_BookingDetails.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/booking/booking_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:BuyTime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:BuyTime/services/business_service_epic.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
  final TextEditingController _checkIn = TextEditingController();
  final TextEditingController _checkOut = TextEditingController();
  final TextEditingController _numberOfGuests = TextEditingController();

  ///Booking code
  String bookingCode;

  @override
  void initState() {
    super.initState();

    bookingCode = 'AB3CD6';
  }

  ///Drawer Key
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  BookingState bookingState = new BookingState(
      business_id: null,
      business_name: null,
      business_address: null,
      guest_number_booked_for: null,
      start_date: null,
      end_date: null,
      booking_code: null,
      user: null,
      state: null,
      wide: null
  );

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) => {
        print("On Init Business : Request List of Root Categories"),
        store.dispatch(BusinessRequestService()),
      },
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
                                  'ENTER GUEST\'S DETAILS TO ADD THEM TO BUYTIME',
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
                                                    bookingCode,
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
                                              labelText: 'Email to invite',
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
                                              color: Color(0xff666666),
                                              fontWeight: FontWeight.w800,
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty && !EmailValidator.validate(value)) {
                                                return 'Please enter a valid email address';
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
                                            controller: _name,
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
                                              labelText: 'Name',
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
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Please enter a valid Name';
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
                                            controller: _surname,
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
                                              labelText: 'Surname',
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
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return 'Please enter a valid Surname';
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
                              ///Send Invite
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: media.width * .5,
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),
                                      child: RaisedButton(
                                        onPressed: () {
                                          if (_formKey.currentState.validate()) {

                                            bookingState.booking_code = bookingCode ?? '000000';
                                            bookingState.business_id = businessState.id_firestore;
                                            bookingState.business_name = businessState.name;
                                            bookingState.guest_number_booked_for = int.parse(_numberOfGuests.text) ?? 0;

                                            UserSnippet currentUser = UserSnippet(
                                              name: _name.text,
                                              surname: _surname.text
                                            );
                                            if(bookingState.user == null){
                                              List<UserSnippet> tmp = [currentUser];
                                              bookingState.user = tmp;
                                            }else
                                              bookingState.user.add(currentUser);

                                            bookingState.wide = businessState.wide;

                                            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails(bookingState: bookingState)));

                                          }
                                        },
                                        textColor: BuytimeTheme.TextDark,
                                        color: BuytimeTheme.Secondary,
                                        padding: EdgeInsets.all(media.width * 0.03),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "SEND INVITE",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Roboto',
                                              fontWeight: FontWeight.w500,
                                              color: BuytimeTheme.TextDark
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              )
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
      },
    );
  }
}
