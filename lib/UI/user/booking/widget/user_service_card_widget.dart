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

import 'package:Buytime/UI/user/booking/UI_U_order_details.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/notification_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../UI_U_order_details.dart';

class UserServiceCardWidget extends StatefulWidget {
  OrderState orderState;
  bool tourist;
  ServiceState serviceState;

  UserServiceCardWidget(this.orderState, this.tourist, this.serviceState);

  @override
  _UserServiceCardWidgetState createState() => _UserServiceCardWidgetState();
}

class _UserServiceCardWidgetState extends State<UserServiceCardWidget> {
  String date = '';
  String currentDate = '';
  String nextDate = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      date = DateFormat('MMM dd').format(widget.orderState.itemList.first.date).toUpperCase();
      currentDate = DateFormat('MMM dd').format(DateTime.now()).toUpperCase();
      nextDate = DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase();
    });
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: Utils.version200(widget.orderState.itemList.first.thumbnail),
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.all(SizeConfig.safeBlockVertical * .25),
        //width: double.infinity,
        //height: double.infinity,
        //width: 200, ///SizeConfig.safeBlockVertical * widget.width
        height: 100,

        ///SizeConfig.safeBlockVertical * widget.width
        decoration: BoxDecoration(
            color: BuytimeTheme.BackgroundWhite,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            )),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.black.withOpacity(.3),
            onTap: () {
              StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.forEach((element) {
                if (element.notificationId != null && element.notificationId.isNotEmpty && widget.orderState.orderId.isNotEmpty && widget.orderState.orderId == element.data.state.orderId) {
                  element.opened = true;
                  StoreProvider.of<AppState>(context).dispatch(UpdateNotification(element));
                }
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetails(
                            orderState: widget.orderState,
                            tourist: widget.tourist,
                            serviceState: widget.serviceState,
                          )));
              //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderState: widget.orderState)));
              /* widget.fromBookingPage ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true, categoryState: widget.categoryState,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,categoryState: widget.categoryState,)));*/
            },
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              //width: 200,
              height: 100,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(5)),
                  //color: Colors.black.withOpacity(.2)
                  ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Order status label
                  /*Container(
                    margin: EdgeInsets.only(right: 5, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                            color: Utils.colorOrderStatusUser(context, widget.orderState.progress),
                          border: Border.all(color: Colors.white, width: .5),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      )],
                    ),
                  ),*/
                  ///Service name
                  Container(
                    //width: 200,
                    height: 100 / 3,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)), color: Colors.black.withOpacity(.2)),
                    //decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)), color: Utils.colorOrderStatus(context, widget.orderState.progress).withOpacity(.2)),
                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              Utils.retriveField(Localizations.localeOf(context).languageCode, widget.orderState.itemList[0].name),
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 14
                                  ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                            ),
                          ),
                        ),
                        widget.orderState.itemList.first.time != null ?
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              DateFormat('MMM dd').format(DateTime.now()).toUpperCase() == DateFormat('MMM dd').format(widget.orderState.itemList.first.date).toUpperCase()
                                  ? AppLocalizations.of(context).todayLower + ', ${widget.orderState.itemList.first.time}'
                                  : DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase() == DateFormat('MMM dd').format(widget.orderState.itemList.first.date).toUpperCase()
                                      ? AppLocalizations.of(context).tomorrowLower + ', ${widget.orderState.itemList.first.time}'
                                      : '${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(widget.orderState.date)},  ${widget.orderState.itemList.first.time}',
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 12

                                  ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                            ),
                          ),
                        ) : Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              DateFormat('MMM dd').format(DateTime.now()).toUpperCase() == DateFormat('MMM dd').format(widget.orderState.itemList.first.date).toUpperCase()
                                  ? AppLocalizations.of(context).todayLower + ', ${widget.orderState.total.toStringAsFixed(2)} €'
                                  : DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase() == DateFormat('MMM dd').format(widget.orderState.itemList.first.date).toUpperCase()
                                  ? AppLocalizations.of(context).tomorrowLower + ', ${widget.orderState.total.toStringAsFixed(2)} €'
                                  : '${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(widget.orderState.date)},  ${widget.orderState.total.toStringAsFixed(2)} €',
                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 12

                                ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => Utils.imageShimmer(200, 100),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
