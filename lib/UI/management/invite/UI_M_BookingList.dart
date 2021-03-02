import 'package:Buytime/UI/management/invite/UI_M_CheckedOutBookingList.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import 'UI_M_BookingCreation.dart';

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

  Map<String, List<BookingState>> bookingsMap = new Map();
  List<List<BookingState>> bookingsList = [];

  Map<String, List<BookingState>> checkedOutBookingsMap = new Map();
  List<List<BookingState>> checkedOutBookingsList = [];

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
        debugPrint('UI_M_BookingList => BOOKING LENGTH: ${bookings.length}');
        bookings.forEach((element) {
          if(element.end_date.isBefore(DateTime.now()) && element.status != 'closed'){
            debugPrint('UI_M_BookingList => ${element.end_date}');
            element.status = element.enumToString(BookingStatus.closed);
            StoreProvider.of<AppState>(context).dispatch(UpdateBooking(element));
          }
        });
      },
      builder: (context, snapshot) {
        //bookingList.clear();
        bookingsMap.clear();
        bookingsList.clear();
        checkedOutBookingsMap.clear();
        checkedOutBookingsList.clear();

        debugPrint('UI_M_BookingList: snapshot: ${snapshot.bookingList.bookingListState.length}');
        bookingList.addAll(snapshot.bookingList.bookingListState);

        bookingList.sort((a,b) => DateFormat('MM').format(a.start_date).compareTo(DateFormat('MM').format(b.start_date)));
        //DateFormat('dd/MM').format(widget.booking.start_date)
        bookingList.forEach((element) {
          debugPrint('UI_M_BookingList: snapshot booking status: ${element.user.first.surname} ${element.status}');
          if(element.status != 'closed'){
            bookingsMap.putIfAbsent(DateFormat('MMM yyyy').format(element.start_date), () => []);
            bookingsMap[DateFormat('MMM yyyy').format(element.start_date)].add(element);
          }else{
            checkedOutBookingsMap.putIfAbsent(DateFormat('MMM yyyy').format(element.start_date), () => []);
            checkedOutBookingsMap[DateFormat('MMM yyyy').format(element.start_date)].add(element);
          }

        });

        bookingsMap.forEach((key, value) {
          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          value.sort((a,b) => DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));
          //value.sort((a,b) => DateFormat('dd').format(a.end_date).compareTo(DateFormat('dd').format(b.end_date)));
          bookingsList.add(value);
        });

        checkedOutBookingsMap.forEach((key, value) {
          /*value.forEach((element) {
            debugPrint('UI_M_BookingList: value booking status: ${element.user.first.surname} ${element.status}');
          });*/
          value.sort((a,b) => DateFormat('dd').format(a.start_date).compareTo(DateFormat('dd').format(b.start_date)));
          checkedOutBookingsList.add(value);
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
                            bookingsList.length > 0 ?
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
                                        List<BookingState> bookings = bookingsList.elementAt(index);
                                        bookings.forEach((element) {
                                          debugPrint('UI_M_BookingList: bookings booking status: ${element.user.first.surname} ${element.status}');
                                        });
                                        return BookingMonthList(bookings);
                                      },
                                        childCount: bookingsList.length,
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckedOutBookingList(checkedOutBookingsList: checkedOutBookingsList)));
                                        },
                                        child: CustomBottomButtonWidget(
                                            Text(
                                              AppLocalizations.of(context).viewCheckedOutBookings,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextBlack,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                              ),
                                            ),
                                            '',
                                            Icon(
                                              Icons.business_center,
                                              color: BuytimeTheme.SymbolBlack,
                                            ))),
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
