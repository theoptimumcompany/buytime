import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/interval_slot_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';


class TimeSlotWidget extends StatelessWidget {

  String bookingStatus = '';
  bool closed = false;

  String duration = '';

  ServiceSlot serviceSlot;
  SquareSlotState squareSlot;
  int index;
  bool selected;
  bool isRestaurant;
  TimeSlotWidget(this.serviceSlot, this.squareSlot, this.index, this.selected, this.isRestaurant);


  @override
  Widget build(BuildContext context) {
    if(serviceSlot.day != 0){
      if(serviceSlot.day > 1){
        duration = '${serviceSlot.day} ${AppLocalizations.of(context).days}';
      }else{
        duration = '${serviceSlot.day} ${AppLocalizations.of(context).day}';
      }
    }else{
      int tmpMin = serviceSlot.hour * 60 + serviceSlot.minute;
      if(tmpMin > 90)
        duration = '${serviceSlot.hour} h ${serviceSlot.minute} ${AppLocalizations.of(context).min}';
      else
        duration = '$tmpMin ${AppLocalizations.of(context).min}';
    }
    return Container(
      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 2),
      child: Stack(
       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           height: !isRestaurant ? 78 : 58,
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               ///Time
               Container(
                 width: 100,
                 margin: EdgeInsets.only(top: !isRestaurant? 14 : 10),
                 //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 10),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     '${squareSlot.on}',
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
               ///Price
               !isRestaurant ? Container(
                 width: 100,
                 margin: EdgeInsets.only(bottom: 0),
                 child: FittedBox(
                   fit: BoxFit.scaleDown,
                   child: Text(
                     '${AppLocalizations.of(context).currency} ' + serviceSlot.price.toStringAsFixed(2),
                     style: TextStyle(
                       //letterSpacing: 1.25,
                         fontFamily: BuytimeTheme.FontFamily,
                         color:  BuytimeTheme.TextBlack,
                         fontWeight: FontWeight.w400,
                         fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                     ),
                   ),
                 ),
               ) : Container(),
             ],
           ),
         ),
          Positioned(
            child: Align(
              alignment: Alignment.topRight,
              child: selected ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 0, right: .5),
                    child: Icon(
                      Icons.bookmark,
                      color: BuytimeTheme.UserPrimary.withOpacity(.5),
                      size: 18,
                    ),
                  )
                ],
              ) : Container(),
            )
          )
        ],
      ),
    );
  }
}

