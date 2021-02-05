import 'package:Buytime/UI/management/invite/UI_M_BookingDetails.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reusable/booking_list_item.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class BookingMonthList extends StatefulWidget {

  List<BookingState> bookingList;
  //VoidCallback callback;
  BookingMonthList(this.bookingList);

  @override
  _BookingMonthListState createState() => _BookingMonthListState();
}

class _BookingMonthListState extends State<BookingMonthList> {


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///Month
        Container(
          margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5, top: SizeConfig.blockSizeVertical * 2, bottom: SizeConfig.blockSizeVertical * 2),
          child: Text(
            DateFormat('MMM yyyy').format(widget.bookingList.first.start_date).toUpperCase(),
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
        ///Bookings List
        widget.bookingList.isNotEmpty ? CustomScrollView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                //MenuItemModel menuItem = menuItems.elementAt(index);
                BookingState booking = widget.bookingList.elementAt(index);
                return BookingListItem(booking);
              },
              childCount: widget.bookingList.length,
            ),
          ),
        ]) : Container(
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
      ],
    );
  }
}

