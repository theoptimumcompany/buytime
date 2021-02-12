import 'dart:async';
import 'package:Buytime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
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
                              AppLocalizations.of(context).confirmNewBooking,
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
                              ///Hotel Name Text
                              Container(
                                child: Text(
                                  bookingState.business_name ?? AppLocalizations.of(context).hotelName,
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
                                  bookingState.business_address ?? AppLocalizations.of(context).locationCountry,
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
                                  '${bookingState.user.first.name} ${bookingState.user.first.surname.substring(0,1).toUpperCase()}. and ${bookingState.guest_number_booked_for} guests' ?? AppLocalizations.of(context).guestsNumber,
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
                                  '${DateFormat('dd MMMM').format(bookingState.start_date)} - ${DateFormat('dd MMMM yyyy').format(bookingState.end_date)}' ?? '12 June - 18 June 2021',
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
                                  width: SizeConfig.safeBlockHorizontal * 55,
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5, bottom: SizeConfig.safeBlockVertical * 2),
                                  child: RaisedButton(
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

                                      bookingState.status = bookingState.enumToString(BookingStatus.opened);
                                      StoreProvider.of<AppState>(context).dispatch(UpdateBooking(bookingState));

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
                                      AppLocalizations.of(context).confirmBooking,
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
                                            AppLocalizations.of(context).somethingIsNotRight,
                                            style: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.UserPrimary,
                                                fontWeight: FontWeight.bold,
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
      },
    );
  }
}