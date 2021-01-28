import 'package:BuyTime/UI/management/invite/UI_M_BookingCreation.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/booking/booking_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/reducer/category_list_reducer.dart';
import 'package:BuyTime/reusable/custom_bottom_button_widget.dart';
import 'package:BuyTime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// ignore: must_be_immutable
class BookingList extends StatefulWidget {
  static String route = '/bookingList';

  List<BookingState> bookingList;

  BookingList({Key key, this.bookingList}) : super(key: key);

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  List<BookingState> bookingList = new List();

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
                "Guests",
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
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 2),
                  child: Text(
                    'ACTIVE BOOKINGS',
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                ///Booking list & NPas bookings
                Expanded(
                  child: Stack(
                    children: [
                      bookingList.length > 0
                          ?
                      ///Booking list
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.blueGrey.withOpacity(0.1),
                            margin: EdgeInsets.only(bottom: 60.0),
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: CustomScrollView(shrinkWrap: true, slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                    BookingState booking = bookingList.elementAt(index);
                                    return Container(
                                      color: BuytimeTheme.BackgroundCerulean,
                                    );
                                  },
                                  childCount: bookingList.length,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ) : Container(
                        height: SizeConfig.screenHeight * 0.1,
                        child: Center(
                          child: Text(
                            "No active Booking found!",
                            style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                          ),
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
                                      backgroundColor: BuytimeTheme.TextMedium,
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
                      ///Past Bookings
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

                                  },
                                  child: CustomBottomButtonWidget(
                                      Text(
                                        'View closed bookings',
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: Color(0xffba68c8),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16
                                        ),
                                      ),
                                      '',
                                      Icon(
                                        Icons.business_center,
                                        color: Color(0xffba68c8),
                                      ))),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                ///Invite user

              ],
            ),
          ),
        ),
      ),
    );
  }
}
