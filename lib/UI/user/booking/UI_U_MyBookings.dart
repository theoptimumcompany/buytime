import 'dart:async';

import 'package:Buytime/UI/user/booking/UI_U_BookingPage.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/booking_card_widget.dart';
import 'package:Buytime/services/business_service_epic.dart';
import 'package:Buytime/utils/b_cube_grid_spinner.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBookings extends StatefulWidget {

  static String route = 'myBookings';
  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  

  bool showList = false;
  Timer timer;
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

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        debugPrint('UI_U_MyBookings => onInit');
        bookings = store.state.bookingList.bookingListState;
        List<BookingState> tmpOpened = [];
        List<BookingState> tmpClosed = [];
        bookings.forEach((element) {
          if(element.end_date.isBefore(DateTime.now()) && element.status != 'closed'){
            debugPrint('UI_U_MyBookings => ${element.end_date}');
            element.status = element.enumToString(BookingStatus.closed);
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
      },
      builder: (context, snapshot) {
        //bookings = snapshot.bookingList.bookingListState;

        if(bookings.isNotEmpty)
          showList = true;
        else
          showList = false;
        
        return  Scaffold(
          appBar: AppBar(
            backgroundColor: BuytimeTheme.BackgroundCerulean,
            brightness: Brightness.dark,
            elevation: 0,
            /*actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: (){

            },
          ),
        ],*/
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
                  ///Bookings Text
                  Expanded(
                    flex: 3,
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
                        ///Card list
                        Expanded(
                            flex: 7,
                            child: showList ?
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 0),
                              alignment: Alignment.centerLeft,
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
                                              child: BookingCardWidget(booking),
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
                                  height: SizeConfig.safeBlockVertical * 28,
                                  width: SizeConfig.safeBlockHorizontal * 80,
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
                                      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 8, right: SizeConfig.safeBlockHorizontal * 8, top: SizeConfig.safeBlockVertical * 5),
                                      child: Text(
                                        AppLocalizations.of(context).yourBookingWill,
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18//SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            )
                        ),
                        ///Contact
                        Expanded(
                            flex: 1,
                            child: Container(
                              color: Colors.white,
                              height: 60,
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async{
                                    String url = BuytimeConfig.FlaviosNumber.trim();
                                    debugPrint('Restaurant phonenumber: ' + url);
                                    if (await canLaunch('tel:$url')) {
                                      await launch('tel:$url');
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: CustomBottomButtonWidget(
                                      Text(
                                        AppLocalizations.of(context).contactUs,
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Colors.black.withOpacity(.7),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16
                                        ),
                                      ),
                                      AppLocalizations.of(context).haveAnyQuestion,
                                      Icon(
                                        Icons.call,
                                        color: BuytimeTheme.SymbolLightGrey,
                                      )
                                  ),
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
          ),
        );
      },
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