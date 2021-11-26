import 'package:Buytime/UI/management/activity/RUI_M_activity_management_item_details.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class ManagerNotificationListItem extends StatefulWidget {

  NotificationState notificationState;
  ServiceState serviceState;
  ManagerNotificationListItem(this.notificationState, this.serviceState);

  @override
  _ManagerNotificationListItemState createState() => _ManagerNotificationListItemState();
}

class _ManagerNotificationListItemState extends State<ManagerNotificationListItem> {

  String days = '';
  String hours = '';
  String minutes = '';
  String seconds = '';

  bool can = false;

  List<String> notificationBodyList = [];
  String customNotificationTime = '';
  DateTime notificationTime = DateTime.now();
  @override
  void initState() {
    super.initState();

    if(widget.notificationState.timestamp != null)
      notificationTime = DateTime.fromMillisecondsSinceEpoch(widget.notificationState.timestamp);
    debugPrint('manager_notification_list_item => NOTIFICATION TIME: $notificationTime');

    DateTime currentTime = DateTime.now();
    Duration tmpDuration;
    if(currentTime.isAfter(notificationTime))
      tmpDuration = currentTime.difference(notificationTime);
    else
      tmpDuration = notificationTime.difference(currentTime);

    if(tmpDuration.inDays != 0){
      days = tmpDuration.inDays.toString();
    }else if(tmpDuration.inHours != 0){
      //debugPrint('manager_notification_list_item => HOURS: ${tmpDuration.inHours}');
      hours = tmpDuration.inHours.toString();
    }else if(tmpDuration.inMinutes != 0){
      //debugPrint('manager_notification_list_item => MINUTES: ${tmpDuration.inMinutes}');
      minutes = tmpDuration.inMinutes.toString();
    }else{
      //debugPrint('manager_notification_list_item => SECONDS: ${tmpDuration.inSeconds}');
      seconds = tmpDuration.inSeconds.toString();
    }

    notificationBodyList =  widget.notificationState.body.split('|');
    if(notificationBodyList.isNotEmpty && notificationBodyList.length == 4)
      can = true;
  }

  String notificationBodyBuilder(bool can, List<String> notificationBodyList, String customNotificationTime, BuildContext context) {
    if (can) {
      if (notificationBodyList[3] == 'orderPaid') {
        return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenPaid}, € ${notificationBodyList[2]}';
      } else if (notificationBodyList[3] == 'paymentError') {
        return '${AppLocalizations.of(context).thePaymentFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenRefusedMethod}';
      } else if (notificationBodyList[3] == 'acceptedBuyer') {
        return '${notificationBodyList[0]}  ${AppLocalizations.of(context).on} $customNotificationTime';
      } else if (notificationBodyList[3] == 'declinedBuyer') {
        return '${AppLocalizations.of(context).unfortunatelyYourBooking} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasNotBeenAccepted}';
      } else if (notificationBodyList[3] == 'canceledBuyer') {
        return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCanceledFor} ${notificationBodyList[4]} ${AppLocalizations.of(context).aRefundFor} €${notificationBodyList[2]} ${AppLocalizations.of(context).hasBeenInitiated}';
      } else if (notificationBodyList[3] == 'canceledBusiness') {
        return '${AppLocalizations.of(context).orderFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCanceledRefundFor} €${notificationBodyList[2]} ${AppLocalizations.of(context).hasBeenPaid}';
      } else if (notificationBodyList[3] == 'createdAutoAcceptedBusiness') {
        return '${AppLocalizations.of(context).aNewOrder} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).hasBeenCreated}';
      } else if (notificationBodyList[3] == 'actionRequiredBusiness') {
        return '${AppLocalizations.of(context).aNewRequestFor} ${notificationBodyList[0]} ${AppLocalizations.of(context).on} $customNotificationTime ${AppLocalizations.of(context).needsConfirmation} ';
      }
    }
    return widget.notificationState.body;
  }


  @override
  Widget build(BuildContext context) {
    customNotificationTime = DateFormat('E, dd/M/yyyy, HH:mm', Localizations.localeOf(context).languageCode).format(notificationTime);
    //debugPrint('manager_notification_list_item => image: ${widget.serviceState.image1}');
    return Container(
      //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        //padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
        decoration: BoxDecoration(
          color: widget.notificationState.opened ? BuytimeTheme.BackgroundWhite : BuytimeTheme.UserPrimary.withOpacity(0.05),
          //borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              //borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () {
                if(widget.notificationState.data != null &&
                    widget.notificationState.data.state != null &&
                    widget.notificationState.data.state.serviceId != null &&
                    widget.notificationState.data.state.orderId != null
                ){
                  widget.notificationState.opened = true;
                  StoreProvider.of<AppState>(context).dispatch(UpdateNotification(widget.notificationState));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RActivityManagementItemDetails(orderId: widget.notificationState.data.state.orderId,)));
                  //StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigate(widget.notificationState.data.state));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => RUI_U_OrderDetail()));
                }
              },
              child: Container(
                height:  widget.notificationState.title.split(' ').last.toLowerCase() == 'canceled' && widget.serviceState.switchSlots ? 122 : 110,  ///SizeConfig.safeBlockVertical * 15
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
                          ///Notification Status icon
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
                          ///Notification Status & Description
                          Expanded(
                            flex: 10,
                            child: Container(
                              //width: SizeConfig.safeBlockHorizontal * 76,
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
                              child:  Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Notification Status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Notification status
                                      Flexible(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0),
                                          child:  Text(
                                              widget.notificationState.serviceName != null && widget.notificationState.serviceName.isNotEmpty ?
                                            '${Utils.retriveField(Localizations.localeOf(context).languageCode,  widget.notificationState.serviceName)} ${widget.notificationState.title.split(' ').last}' :
                                              '*** ${widget.notificationState.title.split(' ').last}',
                                            maxLines: 3,
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
                                                color: BuytimeTheme.TextBlack,
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
                                        notificationBodyBuilder(can, notificationBodyList, customNotificationTime, context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
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
                                      if(widget.notificationState.notificationId != null && widget.notificationState.notificationId.isNotEmpty && widget.notificationState.data.state.serviceId.isNotEmpty){
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
              )
            )
        )
    );
  }
}


