import 'dart:async';

import 'package:Buytime/UI/user/booking/UI_U_booking_page.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/booking_card_widget.dart';
import 'package:Buytime/services/business_service_epic.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RMyBookings extends StatefulWidget {

  static String route = 'myBookings';
  bool fromLanding = false;
  RMyBookings({Key key, this.fromLanding}) : super(key: key);
  @override
  _RMyBookingsState createState() => _RMyBookingsState();
}

class _RMyBookingsState extends State<RMyBookings> {
  

  bool showList = false;
  Timer timer;
  bool clicked = false;
  @override
  void initState() {
    super.initState();
    /*cards.add(BookingCardWidget('Hotel Hermitage', '22 August - 29 August 2020', 'assets/img/hermitage.png', null));
    cards.add(BookingCardWidget('Ice Resort', '12 July - 19 July 2019', 'assets/img/iceresort.png', null));

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        showList = !showList;
      });
    });*/
  }


  @override
  void dispose() {
    //timer.cancel();
    super.dispose();
  }

  List<BookingState> bookings;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bookingStream = FirebaseFirestore.instance
        .collection("booking")
        .where("userEmail", arrayContains: StoreProvider.of<AppState>(context).state.user.email)
        .snapshots(includeMetadataChanges: true);
    return StreamBuilder<QuerySnapshot>(
        stream: _bookingStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> bookingSnapshot) {
          if(bookingSnapshot.hasError || bookingSnapshot.connectionState == ConnectionState.waiting){
            return Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                height: double.infinity,
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
                ));
          }

          bookingSnapshot.data.docs.forEach((element) {
            BookingState bookingState = BookingState.fromJson(element.data());
            bookings.add(bookingState);
          });

          debugPrint('RUI_U_MyBookings => bookings length: ${bookings.length}');
          List<BookingState> tmpOpened = [];
          List<BookingState> tmpClosed = [];

          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);

          bookings.forEach((element) {
            DateTime endTime = element.end_date;
            endTime = new DateTime(endTime.year, endTime.month, endTime.day, 0, 0, 0, 0, 0);
            if(endTime.isBefore(currentTime) && element.status != 'closed'){
              debugPrint('RUI_U_MyBookings => ${element.end_date}');
              element.status = Utils.enumToString(BookingStatus.closed);
              StoreProvider.of<AppState>(context).dispatch(UpdateBooking(element));
            }
            if(element.status == 'opened'){
              tmpOpened.add(element);
            }
            if(element.status == 'closed'){
              tmpClosed.add(element);
            }
          });

          tmpOpened.sort((a,b) => a.start_date.isBefore(b.start_date) ? -1 : a.start_date.isAtSameMomentAs(b.start_date) ? 0 : 1);
          tmpClosed.sort((a,b) => a.start_date.isBefore(b.start_date) ? -1 : a.start_date.isAtSameMomentAs(b.start_date) ? 0 : 1);
          bookings.clear();
          bookings.addAll(tmpOpened);
          bookings.addAll(tmpClosed);
          if(bookings.isNotEmpty)
            showList = true;
          else
            showList = false;
          return Stack(children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: Scaffold(
                  appBar: BuytimeAppbar(
                    width: SizeConfig.screenWidth,
                    background: BuytimeTheme.BackgroundCerulean,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                            onPressed: () {
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                              if(widget.fromLanding == null)
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                              else
                                Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                      ///Title
                      Utils.barTitle(AppLocalizations.of(context).myBookings),
                      SizedBox(
                        width: 50.0,
                      )
                    ],
                  ),
                  /*AppBar(
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
                //Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
              },
            ),
          ),*/
                  floatingActionButton: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: FloatingActionButton(
                      backgroundColor: BuytimeTheme.Secondary,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => InviteGuestForm(id: '', fromLanding: true,)),);
                      },
                      child: Icon(
                          Icons.add
                      ),
                    ),
                  ),
                  body: SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///Bookings Text
                          /*Expanded(
                    flex: 2,
                    child: Container(
                      color: BuytimeTheme.BackgroundCerulean,
                      //height: SizeConfig.safeBlockVertical * 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 25.0),
                            child: Text(
                              AppLocalizations.of(context).myBookings,
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 26 ///SizeConfig.safeBlockHorizontal * 7
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),*/
                          Expanded(
                            flex: 18,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///Card list
                                Expanded(
                                    flex: 7,
                                    child: showList ?
                                    Container(
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 4),
                                      alignment: Alignment.topCenter,
                                      child: MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child: CustomScrollView(
                                            shrinkWrap: true,
                                            slivers: [
                                              SliverList(
                                                delegate: SliverChildBuilderDelegate(
                                                      (context, index){
                                                    BookingState booking = bookings.elementAt(index);
                                                    return Container(
                                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8, bottom: SizeConfig.safeBlockVertical * 3),
                                                      child: BookingCardWidget(
                                                          bookingState: booking,
                                                          call: (value){
                                                            setState(() {
                                                              clicked = value;
                                                            });
                                                          }
                                                      ),
                                                    );
                                                  },
                                                  childCount: bookings.length,
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ) :
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 197, ///SizeConfig.safeBlockVertical * 28
                                          width: 310, ///SizeConfig.safeBlockHorizontal * 80
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              image: DecorationImage(
                                                image: AssetImage('assets/img/nobookings.png'),
                                                fit: BoxFit.cover,
                                              )
                                          ),
                                        ),
                                        ///Description
                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8, top: SizeConfig.safeBlockVertical * 8),
                                              child: Text(
                                                AppLocalizations.of(context).yourBookingWill,
                                                style: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextBlack,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              )
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                ///Contact
                                Container(
                                  color: Colors.white,
                                  height: 64,
                                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async{
                                        String url = BuytimeConfig.ArunasNumber.trim();
                                        debugPrint('Restaurant phonenumber: ' + url);
                                        if (await canLaunch('tel:$url')) {
                                          await launch('tel:$url');
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: CustomBottomButtonWidget(
                                          Container(
                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                            child: Text(
                                              AppLocalizations.of(context).contactUs,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: Colors.black.withOpacity(.7),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                          AppLocalizations.of(context).haveAnyQuestion,
                                          Container(
                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                            child: Icon(
                                              Icons.call,
                                              color: BuytimeTheme.SymbolLightGrey,
                                            ),
                                          )
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ///Ripple Effect
            clicked ? Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                    height: double.infinity,
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
                    )),
              ),
            )
                : Container(),
          ]);
        }
    );
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    this.closedBuilder,
    this.transitionType,
    this.onClosed,
    this.index,
    this.bookingState
  });

  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;
  final ClosedCallback<bool> onClosed;
  final int index;
  final BookingState bookingState;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return null;
      },
      onClosed: onClosed,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      tappable: false,
      closedBuilder: closedBuilder,
      transitionDuration: Duration(milliseconds: 800),
    );
  }
}