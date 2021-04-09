import 'dart:async';
import 'package:Buytime/UI/user/cart/UI_U_Cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/service/UI_U_ServiceReserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';


class OrderDetails extends StatefulWidget {
  final OrderState orderState;
  static String route = '/orderDetails';
  OrderDetails({@required this.orderState});

  @override
  createState() => _OrderDetailsState();

}

class _OrderDetailsState extends State<OrderDetails> with SingleTickerProviderStateMixin {

  OrderState order = OrderState().toEmpty();

  String date = '';
  String currentDate = '';
  String nextDate = '';

  @override
  void initState() {
    super.initState();
    //debugPrint('${widget.imageUrl}');
    date = DateFormat('MMM dd').format(widget.orderState.date).toUpperCase();
    currentDate = DateFormat('MMM dd').format(DateTime.now()).toUpperCase();
    nextDate = DateFormat('MMM dd').format(DateTime.now().add(Duration(days: 1))).toUpperCase();
    //currentDate == date ? AppLocalizations.of(context).today + date : index == 1 && nextDate == date ? AppLocalizations.of(context).tomorrow + date : '${DateFormat('EEEE').format(i).toUpperCase()}, $date'
  }


  @override
  void dispose() {
    super.dispose();
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
      },
      builder: (context, snapshot) {
        debugPrint('UI_U_ServiceDetails => SNAPSHOT CART COUNT: ${snapshot.order}');
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_ServiceDetails => CART COUNT: ${order.cartCounter}');
        return  GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: BuytimeAppbar(
                background: BuytimeTheme.UserPrimary,
                width: media.width,
                children: [
                  ///Back Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          tooltip: AppLocalizations.of(context).comeBack,
                          onPressed: () {
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                  ///Title
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.orderState.itemList.first.name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: BuytimeTheme.appbarTitle,
                        ),
                      ),
                    ),
                  ),
                  ///Cart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  BuytimeIcons.shopping_cart,
                                  color: BuytimeTheme.TextWhite,
                                  size: 24.0,
                                ),
                                onPressed: (){
                                  if (order.cartCounter > 0) {
                                    // dispatch the order
                                    StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                    // go to the cart page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Cart()),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                              title: new Text(AppLocalizations.of(context).warning),
                                              content: new Text(AppLocalizations.of(context).emptyCart),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  elevation: 0,
                                                  hoverElevation: 0,
                                                  focusElevation: 0,
                                                  highlightElevation: 0,
                                                  child: Text(AppLocalizations.of(context).ok),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ));
                                  }
                                },
                              ),
                            ),
                          ),
                          order.cartCounter > 0
                              ? Positioned.fill(
                                  top: 5,
                                  left: 2.5,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      '${order.cartCounter}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: SizeConfig.safeBlockHorizontal * 3,
                                        color: BuytimeTheme.TextWhite,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      //minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Image
                        CachedNetworkImage(
                          imageUrl: version1000(widget.orderState.business.thumbnail),
                          imageBuilder: (context, imageProvider) => Container(
                            //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                            //width: double.infinity,
                            //height: double.infinity,
                            //width: 200, ///SizeConfig.safeBlockVertical * widget.width
                            height: 375, ///SizeConfig.safeBlockVertical * widget.width
                            decoration: BoxDecoration(
                                color: BuytimeTheme.BackgroundWhite,
                                //borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                            child: Container(
                              //width: 375,
                              height: 375,
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
                                    height: 100/3,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                        color: Colors.black.withOpacity(.2)
                                    ),
                                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              widget.orderState.itemList[0].name,
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextWhite,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            // width: 200, ///SizeConfig.safeBlockVertical * widget.width
                            height: 100, ///SizeConfig.safeBlockVertical * widget.width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator()
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ///Address & Map
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Address text
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).address.toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                                ///Address value
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '...',
                                      style: TextStyle(
                                          letterSpacing: 0.15,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                                ///Hour text
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).hours.toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextMedium,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                                ///Open until value
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).openUntil + ' ...',
                                      style: TextStyle(
                                          letterSpacing: 0.15,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                                ///Directions
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.directions_walk,
                                        size: 14,
                                        color: BuytimeTheme.SymbolGrey,
                                      ),
                                      ///Min
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '? ' + AppLocalizations.of(context).min,
                                            style: TextStyle(
                                                letterSpacing: 0.25,
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: BuytimeTheme.TextMedium,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                      ),
                                      ///Directions
                                      Container(
                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
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
                                                    AppLocalizations.of(context).directions,
                                                    style: TextStyle(
                                                        letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.UserPrimary,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                )),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        ///Divider
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                          height: 15,
                          color: BuytimeTheme.DividerGrey,
                        ),
                        ///Order status
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.orderState.progress == 'paid' ?
                              '${AppLocalizations.of(context).accepted.toUpperCase()}' :
                              widget.orderState.progress == 'canceled' ?
                              '${AppLocalizations.of(context).canceled.toUpperCase()}' :
                              widget.orderState.progress == 'declined' ?
                              '${AppLocalizations.of(context).declined.toUpperCase()}' :
                              '${AppLocalizations.of(context).pending.toUpperCase()}',
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: widget.orderState.progress == 'canceled' ? BuytimeTheme.AccentRed : widget.orderState.progress == 'pending' ? BuytimeTheme.Secondary : BuytimeTheme.ActionButton,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Date
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              currentDate == date ? AppLocalizations.of(context).todayLower + ' ${DateFormat('dd EEE').format(widget.orderState.date)}, ${widget.orderState.itemList.first.time} h' : nextDate == date ? AppLocalizations.of(context).tomorrowLower + ' ${DateFormat('dd EEE').format(widget.orderState.date)}, ${widget.orderState.itemList.first.time} h' : '${DateFormat('dd EEE').format(widget.orderState.date)},  ${widget.orderState.itemList.first.time} h',
                              style: TextStyle(
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Conditions
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context).conditions.toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Conditions value
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '...',
                              style: TextStyle(
                                  letterSpacing: 0.15,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Payment method
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context).choosePaymentMethod.substring(7,AppLocalizations.of(context).choosePaymentMethod.length ).toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Price
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context).price.toUpperCase(),
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextMedium,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                        ///Price value
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${AppLocalizations.of(context).euroSpace}${widget.orderState.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                  letterSpacing: 0.15,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.TextBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /* )*/
            ),
          ),
        );
      },
    );
  }
}