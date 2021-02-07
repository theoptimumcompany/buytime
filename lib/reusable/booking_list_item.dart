import 'package:Buytime/UI/management/invite/UI_M_BookingDetails.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class BookingListItem extends StatefulWidget {

  BookingState booking;
  BookingListItem(this.booking);

  @override
  _BookingListItemState createState() => _BookingListItemState();
}

class _BookingListItemState extends State<BookingListItem> {

  BookingState booking;

  @override
  void initState() {
    super.initState();
    booking = widget.booking;
    debugPrint('booking_list_item: User: ${booking.user.first.name} ${booking.user.first.surname} ${booking.user.first.email}');
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: BuytimeTheme.BackgroundWhite,
      height: SizeConfig.safeBlockVertical * 9,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black.withOpacity(.3),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails(bookingState: booking, view: true)),);
          },
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ///Booking info
              Container(
                height: SizeConfig.safeBlockVertical * 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///Full name & check
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Full Name & Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///Full Name
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${widget.booking.user.first.name} ${widget.booking.user.first.surname}',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            ///Date
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: Text(
                                '${DateFormat('dd/MM').format(widget.booking.start_date)} - ${DateFormat('dd/MM').format(widget.booking.end_date)}',
                                style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextGrey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            )
                          ],
                        ),
                        ///Share icon
                        Container(
                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Check Mark
                              Container(
                                child: IconButton(
                                  icon: Icon(
                                    booking.status == 'created' ? Icons.bookmark_border : Icons.check,
                                    color: BuytimeTheme.ActionButton,
                                  ),
                                ),
                              ),
                              ///Status
                              Container(
                                child: Text(
                                  '${booking.status}',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                  ],
                )
              ),
              ///Divider
              Container(
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                height: 2,
                color: BuytimeTheme.DividerGrey,
              )
            ],
          ),
        ),
      ),
    );
  }


}
