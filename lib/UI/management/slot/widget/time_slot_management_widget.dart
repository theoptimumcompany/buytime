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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef onQuantityChangeCallback = void Function(int value);

class TimeSlotManagementWidget extends StatefulWidget {
  SquareSlotState squareSlot;
  onQuantityChangeCallback onChange;
  bool load;
  int first;
  int second;
  ServiceSlot serviceSlot;
  TimeSlotManagementWidget(this.squareSlot, this.onChange, this.load, this.first, this.second, this.serviceSlot);

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
    load = false;
    debugPrint('time_slot_management_widget => FIRST: ${widget.first} - SECOND: ${widget.second}');
  }

  bool load;

  @override
  Widget build(BuildContext context) {
    free = widget.squareSlot.free;
    debugPrint('time_slot_management_widget => FREE: ${widget.squareSlot.free} - bool: ${widget.load}');
    DateTime tmp = DateFormat('dd/MM/yyyy').parse(widget.squareSlot.date);
    Map<DateTime, List<SquareSlotState>> tmpMap = Map();
    //tmp = DateTime(tmp.year, tmp.month, 1, 0,0,0,0,0);
    if(widget.serviceSlot.day != 0){
      if(widget.serviceSlot.day > 1){
        duration = '${widget.serviceSlot.day} ${AppLocalizations.of(context).days}';
      }else{
        duration = '${widget.serviceSlot.day} ${AppLocalizations.of(context).day}';
      }
    }else{
      int tmpMin = widget.serviceSlot.hour * 60 + widget.serviceSlot.minute;
      if(tmpMin > 90)
        duration = '${widget.serviceSlot.hour} h ${tmp.minute} ${AppLocalizations.of(context).min}';
      else
        duration = '$tmpMin ${AppLocalizations.of(context).min}';
    }
    return !widget.load ? Container(
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
              /* Container(
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
               ),*/
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
                         key: Key('remove_${widget.first}_${widget.second}_key'),
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                         onTap: (){
                           int minus = free;
                            if(minus > 0)
                              setState(() {
                                widget.load = true;
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
                         key: Key('add_${widget.first}_${widget.second}_key'),
                         borderRadius: BorderRadius.all(Radius.circular(12)),
                         onTap: (){
                           int sum = free;
                           if(sum < widget.squareSlot.max)
                             setState(() {
                               widget.load = true;
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
    ) : Utils.imageShimmer(100, 100);
  }
}

