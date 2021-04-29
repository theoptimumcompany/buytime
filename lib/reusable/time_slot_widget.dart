import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class TimeSlotWidget extends StatefulWidget {
  dynamic serviceSlot;
  dynamic index;
  bool selected;
  TimeSlotWidget(this.serviceSlot, this.index, this.selected);

  @override
  _TimeSlotWidgetState createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {

  String bookingStatus = '';
  bool closed = false;

  String duration = '';

  @override
  void initState() {
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    if(widget.serviceSlot.day != 0){
      if(widget.serviceSlot.day > 1){
        duration = '${widget.serviceSlot.day} ${AppLocalizations.of(context).days}';
      }else{
        duration = '${widget.serviceSlot.day} ${AppLocalizations.of(context).day}';
      }
    }else{
      int tmpMin = widget.serviceSlot.hour * 60 + widget.serviceSlot.minute;
      if(tmpMin > 90)
        duration = '${widget.serviceSlot.hour} h ${widget.serviceSlot.minute} ${AppLocalizations.of(context).min}';
      else
        duration = '$tmpMin ${AppLocalizations.of(context).min}';
    }
    return Container(
      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           height: 78,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               ///Time
               Container(
                 width: 100,
                 margin: EdgeInsets.only(top: 15),
                 //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     widget.index == 0 ? '${widget.serviceSlot.startTime.first}' : '${widget.serviceSlot.startTime.elementAt(widget.index)}',
                     style: TextStyle(
                       //letterSpacing: 1.25,
                         fontFamily: BuytimeTheme.FontFamily,
                         color: BuytimeTheme.TextBlack,
                         fontWeight: FontWeight.w400,
                         fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                     ),
                   ),
                 ),
               ),
               ///Duration
               Container(
                 width: 100,
                 //margin: EdgeInsets.only(top: 5),
                 //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     '$duration',
                     style: TextStyle(
                       //letterSpacing: 1.25,
                         fontFamily: BuytimeTheme.FontFamily,
                         color: BuytimeTheme.TextBlack,
                         fontWeight: FontWeight.w400,
                         fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                     ),
                   ),
                 ),
               ),
               ///Price
               Container(
                 width: 100,
                 //margin: EdgeInsets.only(top: 5),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     '${AppLocalizations.of(context).currency} ' + widget.serviceSlot.price.toStringAsFixed(2),
                     style: TextStyle(
                       //letterSpacing: 1.25,
                         fontFamily: BuytimeTheme.FontFamily,
                         color:  BuytimeTheme.TextBlack,
                         fontWeight: FontWeight.w400,
                         fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
          widget.selected ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 0, right: .5),
                child: Icon(
                  Icons.check_circle,
                  color: BuytimeTheme.UserPrimary.withOpacity(.5),
                  size: 20,
                ),
              )
            ],
          ) : Container()
        ],
      ),
    );
  }
}

