import 'dart:async';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingSelfCreation extends StatefulWidget {
  static String route = '/bookingSelfCreation';

  @override
  _BookingSelfCreationState createState() => _BookingSelfCreationState();
}

class _BookingSelfCreationState extends State<BookingSelfCreation> {
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
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    _numberOfGuestsController.text = '1';
  }

  ///Drawer Key
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  BookingState bookingState = BookingState().toEmpty();


  Future<void> _selectDate(BuildContext context, DateTime cIn, DateTime cOut) async {
    final DateTimeRange picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(start: cIn, end: cOut),
        firstDate: new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: new DateTime(2025),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(primaryColor: BuytimeTheme.ManagerPrimary, splashColor: BuytimeTheme.ManagerPrimary, colorScheme: ColorScheme.light(onPrimary: Colors.white, primary: BuytimeTheme.ManagerPrimary)),
            child: child,
          );
        });
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

  bool validateDates() {
    if (_checkInController.text.isEmpty || _checkOutController.text.isEmpty || checkIn.compareTo(checkOut) > 0) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    final node = FocusScope.of(context);

    debugPrint('ID Business da Link => ' + StoreProvider.of<AppState>(context).state.business.id_firestore);
    images.add(StoreProvider.of<AppState>(context).state.business.wide);
    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
          onTap: () {
            node.unfocus();
          },
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,

            ///Appbar
            appBar: BuytimeAppbar(
              width: media.width,
              background: BuytimeTheme.BackgroundCerulean,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: Icon(Icons.chevron_left, color: BuytimeTheme.BackgroundCerulean),
                        onPressed: () {
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                        }),
                  ],
                ),

                ///Title
                Utils.barTitle(AppLocalizations.of(context).checkIn),
                SizedBox(
                  width: 56.0,
                )
              ],
            ),
            //drawer: UI_M_BusinessListDrawer(),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child: Container(
                        height: (SizeConfig.safeBlockVertical * 126) - 60,
                        child: Stack(
                          children: [
                            ///Booking Code
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Form(
                                  key: _formKey,
                                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Business Image
                                      Container(
                                          height: 250,
                                          //width: double.infinity,
                                          child: images.isNotEmpty
                                              ? Carousel(
                                                  boxFit: BoxFit.cover,
                                                  autoplay: false,
                                                  animationCurve: Curves.bounceIn,
                                                  //animationDuration: Duration(milliseconds: 1000),
                                                  // dotSize: images.length > 1 ? SizeConfig.blockSizeVertical * 1 : SizeConfig.blockSizeVertical * 0,
                                                  dotSize: SizeConfig.blockSizeVertical * 0,

                                                  ///1%
                                                  dotIncreasedColor: BuytimeTheme.UserPrimary,
                                                  dotColor: BuytimeTheme.BackgroundWhite,
                                                  dotBgColor: Colors.transparent,
                                                  dotPosition: DotPosition.bottomCenter,
                                                  dotVerticalPadding: 10.0,
                                                  showIndicator: true,
                                                  indicatorBgPadding: 7.0,

                                                  ///User images
                                                  images: images
                                                      .map((e) => CachedNetworkImage(
                                                            imageUrl: Utils.version200(e),
                                                            imageBuilder: (context, imageProvider) => Container(
                                                              //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                              height: SizeConfig.safeBlockVertical * 55,
                                                              width: double.infinity,
                                                              decoration: BoxDecoration(
                                                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                                  image: DecorationImage(
                                                                image: imageProvider,
                                                                fit: BoxFit.cover,
                                                              )),
                                                            ),
                                                            placeholder: (context, url) => Utils.imageShimmer(double.infinity, SizeConfig.safeBlockVertical * 55),
                                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                                          ))
                                                      .toList(),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                    height: SizeConfig.safeBlockVertical * 55,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                        image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    )),
                                                  ),
                                                  placeholder: (context, url) => Utils.imageShimmer(double.infinity, SizeConfig.safeBlockVertical * 55),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                )),

                                      ///Title
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 3),
                                              child: Text(
                                                AppLocalizations.of(context).enterSelfDetails,
                                                maxLines: 4,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1.5),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      ///Booking Code & Email & Name & Surname & Check In & Check Out & Number Of Guests
                                      Container(
                                        height: SizeConfig.safeBlockVertical * 70,
                                        child: Column(
                                          children: [
                                            ///Email address
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    key: Key('self_email_key'),
                                                    controller: _emailToInviteController,
                                                    textAlign: TextAlign.start,
                                                    keyboardType: TextInputType.emailAddress,
                                                    textInputAction: TextInputAction.next,
                                                    autofillHints: [AutofillHints.email],
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      labelText: AppLocalizations.of(context).emailAddress,
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
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                    validator: (String value) {
                                                      if (value.isEmpty || !EmailValidator.validate(value)) {
                                                        debugPrint('UI_M_booking_creation => Email Is Empty');
                                                        return AppLocalizations.of(context).pleaseEnterAValidEmail;
                                                      }
                                                      return null;
                                                    },
                                                    onEditingComplete: () {
                                                      node.nextFocus();
                                                      //_formKey.currentState.reset();
                                                      //_formKey.
                                                    },
                                                  )),
                                            ),

                                            ///Name
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    key: Key('self_name_key'),
                                                    controller: _nameController,
                                                    textAlign: TextAlign.start,
                                                    textInputAction: TextInputAction.next,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      labelText: AppLocalizations.of(context).name,
                                                      //hintText: "email *",
                                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                                      labelStyle: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Color(0xff666666),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        debugPrint('UI_M_booking_creation => Name Is Empty');
                                                        return AppLocalizations.of(context).pleaseEnterAValidName;
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            ),

                                            ///Surname
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    key: Key('self_surname_key'),
                                                    controller: _surnameController,
                                                    textAlign: TextAlign.start,
                                                    textInputAction: TextInputAction.done,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      labelText: AppLocalizations.of(context).surname,
                                                      //hintText: "email *",
                                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                                      labelStyle: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Color(0xff666666),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                    validator: (String value) {
                                                      if (value.isEmpty) {
                                                        debugPrint('UI_M_booking_creation => Surname Is Empty');
                                                        return AppLocalizations.of(context).pleaseEnterAValidSurname;
                                                      }
                                                      return null;
                                                    },
                                                  )),
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
                                                          child: GestureDetector(
                                                            key: Key('self_check_in_key'),
                                                        onTap: () async {
                                                          await _selectDate(context, checkIn, checkOut);
                                                        },
                                                        child: TextFormField(
                                                          //enabled: false,
                                                          readOnly: true,
                                                          controller: _checkInController,
                                                          textAlign: TextAlign.start,
                                                          keyboardType: TextInputType.datetime,
                                                          decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: BuytimeTheme.DividerGrey,
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              labelText: AppLocalizations.of(context).checkIn,
                                                              //hintText: "email *",
                                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                                              labelStyle: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: Color(0xff666666),
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                              suffixIcon: Icon(Icons.calendar_today)),
                                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                          onTap: () async {
                                                            node.unfocus();
                                                            await _selectDate(context, checkIn, checkOut);
                                                          },
                                                          validator: (String value) {
                                                            if (value.isEmpty) {
                                                              debugPrint('UI_M_booking_creation => Check In Is Empty');
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
                                                            key: Key('self_check_out_key'),
                                                        onTap: () async {
                                                          await _selectDate(context, checkIn, checkOut);
                                                        },
                                                        child: TextFormField(
                                                          //enabled: false,
                                                          readOnly: true,
                                                          controller: _checkOutController,
                                                          textAlign: TextAlign.start,
                                                          keyboardType: TextInputType.datetime,
                                                          decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: BuytimeTheme.DividerGrey,
                                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                              labelText: AppLocalizations.of(context).checkOut,
                                                              //hintText: "email *",
                                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                                              labelStyle: TextStyle(
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: Color(0xff666666),
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                              suffixIcon: Icon(Icons.calendar_today)),
                                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                          onTap: () async {
                                                            node.unfocus();
                                                            await _selectDate(context, checkIn, checkOut);
                                                          },
                                                          validator: (String value) {
                                                            debugPrint('${checkIn.compareTo(checkOut)}');
                                                            if (value.isEmpty || checkIn.compareTo(checkOut) > 0) {
                                                              debugPrint('UI_M_booking_creation => Check Out Is Empty');
                                                              return AppLocalizations.of(context).pleaseEnterAValidDateInterval;
                                                            }
                                                            return null;
                                                          },
                                                        ),
                                                      ))
                                                    ],
                                                  )),
                                            ),

                                            ///Number of guests
                                            Expanded(
                                              child: Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                                  child: TextFormField(
                                                    key: Key('self_guests_key'),
                                                    controller: _numberOfGuestsController,
                                                    textAlign: TextAlign.start,
                                                    textInputAction: TextInputAction.done,
                                                    decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: BuytimeTheme.DividerGrey,
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                      labelText: AppLocalizations.of(context).numberOfGuest,
                                                      //hintText: "email *",
                                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                                      labelStyle: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: Color(0xff666666),
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w600, fontSize: 16),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),

                                      ///Create Invite
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 180,

                                              ///media.width * .5
                                              height: 44,
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 4),
                                              child: MaterialButton(
                                                key: Key('create_self_invite_key'),
                                                elevation: 0,
                                                hoverElevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                                onPressed: () {

                                                  if (_formKey.currentState.validate()) {
                                                    setState(() {
                                                      bookingRequest = 'send';
                                                    });

                                                    bookingState.business_id = StoreProvider.of<AppState>(context).state.business.id_firestore;
                                                    bookingState.business_name = StoreProvider.of<AppState>(context).state.business.name;
                                                    bookingState.guest_number_booked_for = _numberOfGuestsController.text.isNotEmpty ? int.parse(_numberOfGuestsController.text) : 1;

                                                    UserSnippet currentUser = UserSnippet(name: _nameController.text, surname: _surnameController.text, email: _emailToInviteController.text);

                                                    bookingState.user.add(currentUser);

                                                    bookingState.wide = StoreProvider.of<AppState>(context).state.business.wide;

                                                    bookingState.start_date = checkIn;
                                                    bookingState.end_date = checkOut;

                                                    debugPrint('UI_M_BookingCreation => Start date: ${bookingState.start_date}');
                                                    debugPrint('UI_M_BookingCreation => End date: ${bookingState.end_date}');

                                                    bookingState.status = Utils.enumToString(BookingStatus.opened);

                                                    bookingState.userEmail.add(_emailToInviteController.text);

                                                    StoreProvider.of<AppState>(context).dispatch(CreateSelfBookingRequest(bookingState, StoreProvider.of<AppState>(context).state.business.id_firestore));

                                                    // Timer(Duration(seconds: 1), () {
                                                    //   setState(() {
                                                    //     bookingRequest = '';
                                                    //   });
                                                    // });
                                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails(bookingState: bookingState)));

                                                  }
                                                },
                                                textColor: BuytimeTheme.TextWhite,
                                                color: BuytimeTheme.BackgroundCerulean,
                                                padding: EdgeInsets.all(media.width * 0.03),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: new BorderRadius.circular(5),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).send.toUpperCase(),
                                                      style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, color: BuytimeTheme.TextDark, letterSpacing: 1.25),
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            ///Ripple Effect
                            bookingRequest.isNotEmpty
                                ? Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          height: SizeConfig.safeBlockVertical * 126,
                                          decoration: BoxDecoration(
                                            color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 26),
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
                                          )),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
        ));
  }
}
