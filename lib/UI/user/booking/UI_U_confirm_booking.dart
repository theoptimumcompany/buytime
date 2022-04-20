import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  ///Storage
  // final storage = new FlutterSecureStorage();

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
            backgroundColor: Colors.white,
            brightness: Brightness.dark,
            elevation: 1,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.help_outline,
                  color: Colors.black,
                ),
                onPressed: (){

                },
              ),
            ],
            title: Text(
              AppLocalizations.of(context).confirmNewBooking,
              style: TextStyle(
                  fontFamily: BuytimeTheme.FontFamily,
                  color: BuytimeTheme.TextBlack,
                  fontWeight: FontWeight.w500,
                  fontSize: 16 ///SizeConfig.safeBlockHorizontal * 7
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
              onPressed: () async{
                //await storage.delete(key: 'bookingCode').whenComplete(() => {
                Navigator.of(context).pushNamed(AppRoutes.inviteGuestForm);
                //});
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
                    color: Colors.white,
                    //height: SizeConfig.safeBlockVertical * 15,
                    /*child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
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
                                    '${DateFormat('dd MMMM',Localizations.localeOf(context).languageCode).format(bookingState.start_date)} - ${DateFormat('dd MMMM yyyy').format(bookingState.end_date)}' ?? '12 June - 18 June 2021',
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
                                      onPressed: () async {
                                        bookingState.status = Utils.enumToString(BookingStatus.opened);
                                        StoreProvider.of<AppState>(context).dispatch(UpdateBookingOnConfirm(bookingState));
                                        //StoreProvider.of<AppState>(context).dispatch(BusinessAndNavigateOnConfirmRequest(bookingState.business_id));
                                        //StoreProvider.of<AppState>(context).dispatch(UserBookingListRequest(snapshot.user.email, true));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => RServiceExplorer()),
                                        );
                                        /*Timer(Duration(milliseconds: 5000), (){
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => BookingPage()),
                                        );
                                      });*/
                                      },
                                      textColor: BuytimeTheme.TextWhite,
                                      color: BuytimeTheme.ActionBlackPurple,
                                      //padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).confirmBooking,
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
                                        borderRadius: new BorderRadius.circular(20),
                                        border: Border.all(
                                            color: BuytimeTheme.ActionBlackPurple
                                        )
                                    ),
                                    child: MaterialButton(
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: () async {
                                       // await storage.delete(key: 'bookingCode');
                                       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => RServiceExplorer()), (Route<dynamic> route) => false);
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RServiceExplorer()));
                                      },
                                      textColor: BuytimeTheme.ActionBlackPurple,
                                      color: BuytimeTheme.BackgroundWhite,
                                      //padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(20),
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