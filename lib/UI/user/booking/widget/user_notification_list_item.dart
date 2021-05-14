import 'package:Buytime/UI/user/booking/UI_U_order_details.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

class UserNotificationListItem extends StatefulWidget {

  OrderState orderState;
  NotificationState notificationState;
  ServiceState serviceState;
  UserNotificationListItem(this.notificationState, this.orderState, this.serviceState);

  @override
  _UserNotificationListItemState createState() => _UserNotificationListItemState();
}

class _UserNotificationListItemState extends State<UserNotificationListItem> {

  String days = '';
  String hours = '';
  String minutes = '';
  String seconds = '';

  @override
  void initState() {
    super.initState();
    DateTime notificationTime = DateTime.now();
    if(widget.notificationState.timestamp != null)
      notificationTime = DateTime.fromMillisecondsSinceEpoch(widget.notificationState.timestamp);
    DateTime currentTime = DateTime.now();
    Duration tmpDuration = currentTime.difference(notificationTime);
    if(tmpDuration.inDays != 0){
      debugPrint('user_notification_list_item => DAYS: ${tmpDuration.inDays}');
      days = tmpDuration.inDays.toString();
    }else if(tmpDuration.inHours != 0){
      debugPrint('user_notification_list_item => HOURS: ${tmpDuration.inHours}');
      hours = tmpDuration.inHours.toString();
    }else if(tmpDuration.inMinutes != 0){
      debugPrint('user_notification_list_item => MINUTES: ${tmpDuration.inMinutes}');
      minutes = tmpDuration.inMinutes.toString();
    }else{
      debugPrint('user_notification_list_item => SECONDS: ${tmpDuration.inSeconds}');
      seconds = tmpDuration.inSeconds.toString();
    }
  }

  @override
  Widget build(BuildContext context) {

    //debugPrint('image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
        decoration: BoxDecoration(
            color: widget.notificationState.opened ? BuytimeTheme.BackgroundWhite : BuytimeTheme.UserPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () async {
                if(widget.notificationState.notificationId != null && widget.notificationState.notificationId.isNotEmpty && widget.orderState.orderId.isNotEmpty){
                  widget.notificationState.opened = true;
                  StoreProvider.of<AppState>(context).dispatch(UpdateNotification(widget.notificationState));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderState: widget.orderState)));
                }
              },
              child: Container(
                height:  widget.notificationState.title.split(' ').last.toLowerCase() == 'canceled' && widget.serviceState.switchSlots ?
                 122 :
                110,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: SizeConfig.screenWidth,
                      child: ///Icon & Notification info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ///Service Image
                          widget.notificationState.title.split(' ').last.toLowerCase() == 'canceled' || widget.notificationState.title.split(' ').last.toLowerCase() == 'declined' ?
                          Expanded(
                              flex: 1,
                              child: Icon(
                                  BuytimeIcons.remove
                              ) ): Expanded(
                              flex: 1,
                              child: Icon(
                                  BuytimeIcons.accepted_clock
                              )),
                          ///Service Name & Description
                          Expanded(
                            flex: 10,
                            child: Container(
                              //width: SizeConfig.safeBlockHorizontal * 76,
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Order Status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Order status
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0),
                                          child:  Text(
                                              Utils.retriveField(Localizations.localeOf(context).languageCode,  widget.serviceState.name)
                                                  + ' ' + widget.notificationState.title.split(' ').last,
                                            maxLines: 2,
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextBlack,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),
                                      ///Time
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            days.isNotEmpty && days != '1' ?
                                            '$days ${ AppLocalizations.of(context).days}' :
                                            days.isNotEmpty && days == '1' ?
                                            '$days ${ AppLocalizations.of(context).day}' :
                                            hours.isNotEmpty && hours != '1' ?
                                            '$hours ${ AppLocalizations.of(context).hours}' :
                                            hours.isNotEmpty && hours == '1' ?
                                            '$hours ${ AppLocalizations.of(context).hour}' :
                                            minutes.isNotEmpty && minutes != '1' ?
                                            '$minutes ${AppLocalizations.of(context).spaceMinutes}' :
                                            minutes.isNotEmpty && minutes == '1' ?
                                            '$minutes ${AppLocalizations.of(context).spaceMinute}' :
                                            seconds.isNotEmpty && seconds != '1' ?
                                            '$seconds ${ AppLocalizations.of(context).secs}' :
                                            '$seconds ${ AppLocalizations.of(context).sec}',
                                            style: TextStyle(
                                                letterSpacing: 1.5,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: widget.notificationState.opened ? BuytimeTheme.TextBlack : BuytimeTheme.UserPrimary,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  ///Description
                                  Flexible(
                                    child: Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                      child: Text(
                                        widget.notificationState.body,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            letterSpacing: 0.15,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16 /// SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    widget.notificationState.title.split(' ').last.toLowerCase() == 'canceled' && widget.serviceState.switchSlots ?
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1.5, bottom: SizeConfig.safeBlockVertical * .5, top: SizeConfig.safeBlockVertical * .25),
                              alignment: Alignment.center,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                    onTap: () {
                                      if(widget.notificationState.notificationId != null && widget.notificationState.notificationId.isNotEmpty && widget.serviceState.serviceId.isNotEmpty){
                                        //widget.notificationState.opened = true;
                                        //StoreProvider.of<AppState>(context).dispatch(UpdateNotification(widget.notificationState));
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: widget.serviceState, tourist: false,)));
                                      }
                                    },
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        AppLocalizations.of(context).reschedule.toUpperCase(),
                                        style:  TextStyle(
                                            letterSpacing: 1.25,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextMalibu,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14
                                          ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    )),
                              ))
                        ],
                      ),
                    ) : Container(),
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10),
                      height: SizeConfig.safeBlockVertical * .2,
                      color: BuytimeTheme.DividerGrey,
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}


