/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/UI/management/invite/UI_M_booking_details.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:Buytime/reusable/material_design_icons.dart';

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
    debugPrint('booking_list_item: booking status: ${booking.user.first.surname} ${booking.status}');
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ),
                            ///Date
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                              child: Text(
                                '${DateFormat('dd/MM',Localizations.localeOf(context).languageCode).format(widget.booking.start_date.toUtc())} - ${DateFormat('dd/MM').format(widget.booking.end_date.toUtc())}',
                                style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            )
                          ],
                        ),
                        ///Share icon
                        widget.booking.status != 'closed' ?
                        Container(
                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Check Mark
                              Container(
                                margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2),
                                child: Icon(
                                  widget.booking.status == 'created' ? Icons.bookmark_border : widget.booking.status == 'opened' ? MaterialDesignIcons.done_all : MaterialDesignIcons.done,
                                  color: BuytimeTheme.ActionButton,
                                  size: 18,
                                ),
                              ),
                              ///Status
                              Container(
                                child: Text(
                                  '${widget.booking.status.substring(0,1).toUpperCase()}${widget.booking.status.substring(1, widget.booking.status.length)}',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) :
                        Container(),
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

