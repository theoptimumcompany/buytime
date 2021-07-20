import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
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

typedef onQuantityChangeCallback = void Function(int value);

class TimeSlotManagementWidget extends StatefulWidget {
  SquareSlotState squareSlot;
  onQuantityChangeCallback onChange;
  TimeSlotManagementWidget(this.squareSlot, this.onChange);

  @override
  _TimeSlotManagementWidgetState createState() => _TimeSlotManagementWidgetState();
}

class _TimeSlotManagementWidgetState extends State<TimeSlotManagementWidget> {

  String bookingStatus = '';
  bool closed = false;

  String duration = '';

  int free = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    free = widget.squareSlot.free;
    debugPrint('FREE: ${widget.squareSlot.free}');
    DateTime tmp = DateFormat('dd/MM/yyyy').parse(widget.squareSlot.date);
    Map<DateTime, List<SquareSlotState>> tmpMap = Map();
    //tmp = DateTime(tmp.year, tmp.month, 1, 0,0,0,0,0);
    if(tmp.day != 0){
      if(tmp.day > 1){
        duration = '${tmp.day} ${AppLocalizations.of(context).days}';
      }else{
        duration = '${tmp.day} ${AppLocalizations.of(context).day}';
      }
    }else{
      int tmpMin = tmp.hour * 60 + tmp.minute;
      if(tmpMin > 90)
        duration = '${tmp.hour} h ${tmp.minute} ${AppLocalizations.of(context).min}';
      else
        duration = '$tmpMin ${AppLocalizations.of(context).min}';
    }
    return Container(
      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                 margin: EdgeInsets.only(top: 0),
                 //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     '${widget.squareSlot.on}',
                     style: TextStyle(
                       //letterSpacing: 1.25,
                         fontFamily: BuytimeTheme.FontFamily,
                         color: BuytimeTheme.TextBlack,
                         fontWeight: FontWeight.bold,
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
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   ///Remove
                   Container(
                     height: 24,
                     width: 24,
                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color:  BuytimeTheme.ManagerPrimary.withOpacity(.1)),
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                         onTap: (){
                           int minus = free;
                            if(minus > 0)
                              setState(() {
                                widget.squareSlot.free = minus--;
                                free = minus--;
                                widget.onChange(free);
                              });
                         },
                         child: Container(
                           height: 24,
                           width: 24,
                           child: Icon(
                             Icons.remove,
                             color: BuytimeTheme.ManagerPrimary,
                           ),
                         ),
                       ),
                     ),
                   ),

                   ///Quantity
                   Container(
                     margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                     child: Text(
                       '${free}',
                       style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 16, fontWeight: FontWeight.w500),
                     ),
                   ),

                   ///Add
                   Container(
                     height: 24,
                     width: 24,
                     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color:  BuytimeTheme.ManagerPrimary.withOpacity(.1)),
                     child: Material(
                       color: Colors.transparent,
                       child: InkWell(
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                         onTap: (){
                           int sum = free;
                           if(sum < widget.squareSlot.max)
                             setState(() {
                               widget.squareSlot.free = sum++;
                               free = sum++;
                               widget.onChange(free);
                             });
                         },
                         child: Container(
                           height: 24,
                           width: 24,
                           child: Icon(
                             Icons.add,
                             color:  BuytimeTheme.ManagerPrimary,
                           ),
                         ),
                       ),
                     ),
                   )
                 ],
               )
             ],
           ),
         ),
        ],
      ),
    );
  }
}

