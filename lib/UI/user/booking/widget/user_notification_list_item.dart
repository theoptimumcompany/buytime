import 'package:Buytime/UI/user/booking/UI_U_OrderDetails.dart';
import 'package:Buytime/reblox/model/notification/notification_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_ServiceDetails.dart';

class UserNotificationListItem extends StatefulWidget {

  NotificationState notificationState;
  UserNotificationListItem(this.notificationState);

  @override
  _UserNotificationListItemState createState() => _UserNotificationListItemState();
}

class _UserNotificationListItemState extends State<UserNotificationListItem> {
  @override
  Widget build(BuildContext context) {

    //debugPrint('image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () async {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderState: widget.orderState)));
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Icon & Notification info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///Service Image
                              widget.notificationState.serviceState == 'canceled' ?
                              Icon(
                                  BuytimeIcons.remove
                              ) : Icon(
                                  BuytimeIcons.accepted_clock
                              ),
                              ///Service Name & Description
                              Container(
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
                                child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ///Order Status
                                    Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          widget.notificationState.serviceName + ' ' + widget.notificationState.serviceState,
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
                                    ///Description
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                        width: SizeConfig.safeBlockHorizontal * 50,
                                        child: Text(
                                          'Description',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                              )
                            ],
                          ),
                          ///Time
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '? ....',
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
                    ),
                    widget.notificationState.serviceState == 'canceled' ?
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


