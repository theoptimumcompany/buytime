import 'dart:async';
import 'package:Buytime/UI/user/booking/UI_U_booking_page.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';


class ConfirmBooking extends StatefulWidget {

  static String route = '/confirmBooking';
  /*BookingState state;
  ConfirmBooking(this.state);*/

  @override
  _ConfirmBookingState createState() => _ConfirmBookingState();
}

class _ConfirmBookingState extends State<ConfirmBooking> {
  TextEditingController bookingCodeController = new TextEditingController();

  BookingState bookingState;


  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => bookingState = StoreProvider.of<AppState>(context).state.booking);
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, snapshot) {

        bookingState = snapshot.booking;

        return  Scaffold(
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
            title: Text(
              AppLocalizations.of(context).confirmNewBooking,
              style: TextStyle(
                  fontFamily: BuytimeTheme.FontFamily,
                  color: BuytimeTheme.TextWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 20 ///SizeConfig.safeBlockHorizontal * 7
              ),
            ),
            centerTitle: true,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ///Confirm new booking Text
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 20,
                    color: BuytimeTheme.BackgroundCerulean,
                    //height: SizeConfig.safeBlockVertical * 15,
                    /*child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                            margin: EdgeInsets.only(left: 25.0),
                            child: Text(
                              AppLocalizations.of(context).confirmNewBooking,
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26 ///SizeConfig.safeBlockHorizontal * 7
                              ),
                            ),
                          )
                        ],
                      )*/
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
                                  image: NetworkImage(bookingState.wide ?? 'assets/img/placeholder.png'),
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
                            Column(
                              children: [
                                ///Hotel Name Text
                                Container(
                                  child: Text(
                                    bookingState.business_name ?? AppLocalizations.of(context).hotelName,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                ///Location & Country Text
                                Container(
                                  child: Text(
                                    bookingState.business_address ?? AppLocalizations.of(context).locationCountry,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                ///Guest Number
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '${bookingState.user.first.name} ${bookingState.user.first.surname.substring(0,1).toUpperCase()}. and ${bookingState.guest_number_booked_for} guests' ?? AppLocalizations.of(context).guestsNumber,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                ///Holiday Period
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Text(
                                    '${DateFormat('dd MMMM').format(bookingState.start_date)} - ${DateFormat('dd MMMM yyyy').format(bookingState.end_date)}' ?? '12 June - 18 June 2021',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                ///Confirm Booking
                                Container(
                                    width: 247, ///SizeConfig.safeBlockHorizontal * 55
                                    height: 44,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2),
                                    child: MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () {
                                        /*showDialog(
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
                                                      color: Colors.white.withOpacity(.8),
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          Container(
                                                            width: SizeConfig.safeBlockVertical * 20,
                                                            height: SizeConfig.safeBlockVertical * 20,
                                                            child: Center(
                                                              child: BCubeGridSpinner(
                                                                color: Colors.transparent,
                                                                size: SizeConfig.safeBlockVertical * 15,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                )
                                            );
                                          });*/

                                        bookingState.status = Utils.enumToString(BookingStatus.opened);
                                        StoreProvider.of<AppState>(context).dispatch(UpdateBookingOnConfirm(bookingState));
                                        //StoreProvider.of<AppState>(context).dispatch(BusinessAndNavigateOnConfirmRequest(bookingState.business_id));
                                        StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(snapshot.user.email, true));

                                        /*Timer(Duration(milliseconds: 5000), (){
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => BookingPage()),
                                        );
                                      });*/
                                      },
                                      textColor: BuytimeTheme.TextWhite,
                                      color: BuytimeTheme.ButtonMalibu,
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).confirmBooking.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.25
                                        ),
                                      ),
                                    )
                                ),
                                ///Something Isnt Right
                                Container(
                                    width: 247, ///SizeConfig.safeBlockHorizontal * 40
                                    height: 44,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * 2, right: SizeConfig.safeBlockHorizontal * 0),
                                    decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(5),
                                        border: Border.all(
                                            color: BuytimeTheme.ButtonMalibu
                                        )
                                    ),
                                    child: MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Landing()), (Route<dynamic> route) => false);
                                        //Navigator.of(context).pushNamedAndRemoveUntil(Landing.route, (Route<dynamic> route) => false);
                                      },
                                      textColor: BuytimeTheme.ButtonMalibu,
                                      color: BuytimeTheme.BackgroundWhite,
                                      //padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).somethingIsNotRight,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.25
                                        ),
                                      ),
                                    )
                                )
                              ],
                            )
                            /*Container(
                                  margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 10),
                                  alignment: Alignment.center,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: (){
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Landing()), (Route<dynamic> route) => false);
                                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BookingPage()));
                                        },
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        child: Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            AppLocalizations.of(context).somethingIsNotRight,
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.UserPrimary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        )
                                    ),
                                  )
                              ),*/
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}