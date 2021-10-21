import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_list_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/UI/management/invite/widget/w_booking_list_item.dart';
import 'package:Buytime/UI/management/invite/widget/w_booking_month_list.dart';
import 'package:Buytime/reusable/w_custom_bottom_button.dart';
import 'package:Buytime/reusable/menu/w_manager_drawer.dart';
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
class CheckedOutBookingList extends StatefulWidget {
  static String route = '/checkedOutBookingList';

  List<List<BookingState>> checkedOutBookingsList;

  CheckedOutBookingList({Key key, this.checkedOutBookingsList}) : super(key: key);

  @override
  _CheckedOutBookingListState createState() => _CheckedOutBookingListState();
}

class _CheckedOutBookingListState extends State<CheckedOutBookingList> {

  List<List<BookingState>> closedBookingsList = [];

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
          title: Utils.barTitle(AppLocalizations.of(context).checkedOutBookings),
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
        //drawer: UI_M_BusinessListDrawer(),
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
                        widget.checkedOutBookingsList.length > 0 ?
                        ///Booking list
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              //color: Colors.blueGrey.withOpacity(0.1),
                              //margin: EdgeInsets.only(bottom: 60.0),
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: CustomScrollView(shrinkWrap: true, slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate((context, index) {
                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                    List<BookingState> bookings = widget.checkedOutBookingsList.elementAt(index);
                                    /*bookings.forEach((element) {
                                      debugPrint('UI_M_checked_out_booking_list => bookings booking status: ${element.user.first.surname} ${element.status}');
                                    });*/
                                    return BookingMonthList(bookings);
                                  },
                                    childCount: widget.checkedOutBookingsList.length,
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
                                    AppLocalizations.of(context).noHistoryFound,
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
  }
}
