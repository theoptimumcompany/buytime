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
      date = DateFormat('MMM dd').format(widget.orderState.date).toUpperCase();
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
      imageUrl: widget.orderState.itemList.first.thumbnail != null && widget.orderState.itemList.first.thumbnail.isNotEmpty ? widget.orderState.itemList.first.thumbnail : 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Service name
                  Container(
                    //width: 200,
                    height: 100 / 3,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)), color: Colors.black.withOpacity(.2)),
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
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              currentDate == date
                                  ? AppLocalizations.of(context).todayLower + ', ${widget.orderState.itemList.first.time}'
                                  : nextDate == date
                                      ? AppLocalizations.of(context).tomorrowLower + ', ${widget.orderState.itemList.first.time}'
                                      : '${DateFormat('dd EEE', Localizations.localeOf(context).languageCode).format(widget.orderState.date)},  ${widget.orderState.itemList.first.time}',
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
      placeholder: (context, url) => Container(
        // width: 200, ///SizeConfig.safeBlockVertical * widget.width
        height: 100,

        ///SizeConfig.safeBlockVertical * widget.width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
