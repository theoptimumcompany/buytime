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
import 'package:Buytime/UI/management/invite/widget/w_booking_list_item.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            DateFormat('MMM yyyy',Localizations.localeOf(context).languageCode).format(widget.bookingList.first.start_date).toUpperCase(),
            style: TextStyle(
                fontFamily: BuytimeTheme.FontFamily,
                color: BuytimeTheme.ManagerPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              letterSpacing: 1.5
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
                //debugPrint('w_ booking_month_list => bookings booking status: ${booking.user.first.surname} ${booking.status}');
                return BookingListItem(booking);
              },
              childCount: widget.bookingList.length,
            ),
          ),
        ]) : Container(
          height: SizeConfig.safeBlockVertical * 8,
          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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

