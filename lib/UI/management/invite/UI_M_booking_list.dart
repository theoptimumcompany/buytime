import 'package:Buytime/UI/management/invite/UI_M_checked_out_booking_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reusable/booking_list_item.dart';
import 'package:Buytime/reusable/booking_month_list.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/services/booking_service_epic.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import 'UI_M_booking_creation.dart';

// ignore: must_be_immutable
class BookingList extends StatefulWidget {
  static String route = '/bookingList';

  List<BookingState> bookingList;

  BookingList({Key key, this.bookingList}) : super(key: key);

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {

  List<BookingState> bookingList = [];

  Map<String, List<BookingState>> bookingMap = new Map();
  List<List<BookingState>> activeBookingList = [];

  Map<String, List<BookingState>> checkedOutBookingMap = new Map();
  List<List<BookingState>> checkedOutBookingList = [];

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        print("Oninitbookinglist");
        List<BookingState> bookings = store.state.bookingList.bookingListState;
        //debugPrint('UI_M_BookingList => BOOKING LENGTH: ${bookings.length}');

        DateTime currentTime = DateTime.now();
        currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
        //debugPrint('UI_M_BookingList => ${currentTime}');
        bookings.forEach((element) {
          DateTime endTime = element.end_date;
          endTime = new DateTime(endTime.year, endTime.month, endTime.day, 0, 0, 0, 0, 0);
          if(endTime.isBefore(currentTime) && element.status != 'closed'){
            //debugPrint('UI_M_BookingList => ${element.end_date}');
            element.status = Utils.enumToString(BookingStatus.closed);
            StoreProvider.of<AppState>(context).dispatch(UpdateBooking(element));
          }
        });
      },
      builder: (context, snapshot) {
        //bookingList.clear();
        bookingMap.clear();
        activeBookingList.clear();
        checkedOutBookingMap.clear();
        checkedOutBookingList.clear();

        //debugPrint('UI_M_BookingList: snapshot: ${snapshot.bookingList.bookingListState.length}');
        bookingList = snapshot.bookingList.bookingListState;

        bookingList.sort((a,b) => DateFormat('MM',Localizations.localeOf(context).languageCode).format(a.start_date).compareTo(DateFormat('MM').format(b.start_date)));
        //DateFormat('dd/MM').format(widget.booking.start_date)
        bookingList.forEach((element) {
          //debugPrint('UI_M_BookingList: snapshot booking Date Time: ${element.start_date} - ${element.end_date} | ${element.start_date.isUtc} - ${element.end_date.isUtc} | ${element.start_date.timeZoneName} - ${element.end_date.timeZoneName} | ${element.start_date.timeZoneOffset} - ${element.end_date.timeZoneOffset}');
          //debugPrint('UI_M_BookingList: snapshot booking status: ${element.user.first.surname} ${element.status}');
          if(element.status != 'closed'){
            bookingMap.putIfAbsent(DateFormat('MMM yyyy',Localizations.localeOf(context).languageCode).format(element.start_date), () => []);
            bookingMap[DateFormat('MMM yyyy',Localizations.localeOf(context).languageCode).format(element.start_date)].add(element);
          }else{
            checkedOutBookingMap.putIfAbsent(DateFormat('MMM yyyy',Localizations.localeOf(context).languageCode).format(element.start_date), () => []);
            checkedOutBookingMap[DateFormat('MMM yyyy',Localizations.localeOf(context).languageCode).format(element.start_date)].add(element);
          }

        });

        bookingMap.forEach((key, value) {
          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          value.sort((a,b) => DateFormat('dd',Localizations.localeOf(context).languageCode).format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));
          //value.sort((a,b) => DateFormat('dd').format(a.end_date).compareTo(DateFormat('dd').format(b.end_date)));
          activeBookingList.add(value);
        });

        checkedOutBookingMap.forEach((key, value) {
          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          value.sort((a,b) => DateFormat('dd',Localizations.localeOf(context).languageCode).format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));
          checkedOutBookingList.add(value);
        });

        //debugPrint('UI_M_BookingList: bookingsList: ${bookingsList.length}');

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
                    AppLocalizations.of(context).guests,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: BuytimeTheme.TextWhite,
                      fontSize: media.height * 0.025,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            drawer: UI_M_BusinessListDrawer(),
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Booking list & NPas bookings
                      Expanded(
                        child: Stack(
                          children: [
                            activeBookingList.length > 0 ?
                            ///Booking list
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  //color: Colors.blueGrey.withOpacity(0.1),
                                  margin: EdgeInsets.only(bottom: 60.0),
                                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: CustomScrollView(shrinkWrap: true, slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate((context, index) {
                                        //MenuItemModel menuItem = menuItems.elementAt(index);
                                        List<BookingState> bookings = activeBookingList.elementAt(index);
                                        bookings.forEach((element) {
                                          //debugPrint('UI_M_BookingList: bookings booking status: ${element.user.first.surname} ${element.status}');
                                        });
                                        return BookingMonthList(bookings);
                                      },
                                        childCount: activeBookingList.length,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ) :
                                ///No Bookings
                            Container(
                              height: SizeConfig.safeBlockVertical * 8,
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                              decoration: BoxDecoration(
                                color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                  alignment: Alignment.centerLeft,
                                  child:  Text(
                                    AppLocalizations.of(context).noActiveBookingFound,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    ),
                                  ),
                                )
                              ),
                            ),
                            ///Add Booking
                            Positioned.fill(
                              bottom: 80,
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                      margin: EdgeInsets.only( right: SizeConfig.safeBlockHorizontal * 4),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FloatingActionButton(
                                            backgroundColor: BuytimeTheme.Secondary,
                                            onPressed: () async {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookingCreation()));
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(500.0)),
                                            child: Icon(
                                              Icons.add,
                                              size: 30,
                                              color: BuytimeTheme.TextDark,
                                            ),
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ),
                            ///Checked out bookings
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.white,
                                  height: 60,
                                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () async {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckedOutBookingList(checkedOutBookingsList: checkedOutBookingList)));
                                        },
                                        child: CustomBottomButtonWidget(
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                              child: Text(
                                                AppLocalizations.of(context).viewCheckedOutBookings,
                                                style: TextStyle(
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextBlack,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16
                                                ),
                                              ),
                                            ),
                                            '',
                                            Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                              child: Icon(
                                                Icons.business_center,
                                                color: BuytimeTheme.SymbolBlack,
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
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
