import 'dart:core';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// ignore: must_be_immutable
class BookingDetails extends StatefulWidget {
  static String route = '/bookingDetails';

  BookingState bookingState;
  bool view;
  BookingDetails({Key key, this.bookingState, this.view}) : super(key: key);

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
  bool view;

  @override
  void initState() {
    super.initState();

    bookingState = widget.bookingState;
    view = widget.view ?? false;
    /*bookingState = widget.bookingState;

    fullName = '${bookingState.user.first.name} ${bookingState.user.first.surname}';
    email = bookingState.user.first.email;
    _checkInController.text = DateFormat('dd/MM/yyyy').format(bookingState.start_date);
    _checkOutController.text = DateFormat('dd/MM/yyyy').format(bookingState.end_date);
    _numberOfGuestsController.text = bookingState.guest_number_booked_for.toString() ?? '';*/
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://buytime.page.link/booking/?booking=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print("Link dinamico creato " + dynamicUrl.toString());
    return dynamicUrl;
  }

  String link = '';
  Future readDynamicLink(String id) async{
    if(link.isEmpty){
      Uri tmp = await createDynamicLink(id);
      setState(() {
        link = '$tmp';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {
        if(bookingState == null)
          bookingState = snapshot.booking;

        _checkInController.text = DateFormat('dd/MM/yyyy').format(bookingState.start_date);
        _checkOutController.text = DateFormat('dd/MM/yyyy').format(bookingState.end_date);

        _numberOfGuestsController.text = bookingState.guest_number_booked_for.toString();

        readDynamicLink(bookingState.booking_code);

        debugPrint('UI_M_BookingDetails => BOOKING CODE: ${bookingState.booking_code}');

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
                    AppLocalizations.of(context).guestDetails,
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
            //drawer: !view ? UI_M_BusinessListDrawer() : null,
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 2.5
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
                                            ///Full Name Text
                                            Container(
                                              child: Text(
                                                'Full Name',
                                                style: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextMedium,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18
                                                ),
                                              ),
                                            ),
                                            ///Full Name
                                           Flexible(child:  Container(
                                             margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                             child: FittedBox(
                                               fit: BoxFit.scaleDown,
                                               child: Text(
                                                 '${bookingState.user.first.name} ${bookingState.user.first.surname}',
                                                 style: TextStyle(
                                                     fontFamily: BuytimeTheme.FontFamily,
                                                     color: BuytimeTheme.TextDark,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 18
                                                 ),
                                               ),
                                             ),
                                           ))
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
                                            ///Email Text
                                            Container(
                                              child: Text(
                                                'Email',
                                                style: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextMedium,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18
                                                ),
                                              ),
                                            ),
                                            ///Email
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    bookingState.user.first.email ?? 'sample@gmail.com',
                                                    style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextDark,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18
                                                    ),
                                                  ),
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
                                                        isDense: true,
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
                                                          isDense: true,
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
                                              isDense: true,
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
                              ///Qr Code
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  //crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 0),
                                      //color: Colors.black,
                                      child: QrImage(
                                        //size: SizeConfig.safeBlockHorizontal * 50,
                                        data: '$link',
                                        version: QrVersions.auto,
                                        padding: EdgeInsets.all(0),
                                        gapless: false,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ///Send invitation
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: media.width * .5,
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical * 2.5),
                                        alignment: Alignment.bottomCenter,
                                        child: RaisedButton(
                                          onPressed: () async{
                                            if(view){
                                              Clipboard.setData(ClipboardData(text: link));
                                            }else{
                                              final RenderBox box = context.findRenderObject();
                                              //Uri link = await createDynamicLink(bookingState.booking_code);
                                              bookingState.status = bookingState.enumToString(BookingStatus.sent);
                                              StoreProvider.of<AppState>(context).dispatch(UpdateBooking(bookingState)); //TODO: Create the booking status update epic

                                              Share.share('check out Buytime App at $link', subject: 'Take your Time!', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                              /*Share.share('Share', subject:
                                            Platform.isAndroid ?
                                            'https://play.google.com/store/apps/details?id=com.theoptimumcompany.buytime' :
                                            'Test'
                                                , sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);*/
                                            }
                                          },
                                          textColor: BuytimeTheme.TextDark,
                                          color: BuytimeTheme.Secondary,
                                          padding: EdgeInsets.all(media.width * 0.03),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            !view ? "SEND INVITE" : 'COPY LINK',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                                color: BuytimeTheme.TextDark,
                                                letterSpacing: 2
                                            ),
                                          ),
                                        )
                                    )
                                  ],
                                ),
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
