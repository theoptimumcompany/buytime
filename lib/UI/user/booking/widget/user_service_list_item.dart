import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class UserServiceListItem extends StatefulWidget {

  OrderState orderState;
  bool tourist;
  ServiceState serviceState;
  UserServiceListItem(this.orderState, this.tourist, this.serviceState);

  @override
  _UserServiceListItemState createState() => _UserServiceListItemState();
}

class _UserServiceListItemState extends State<UserServiceListItem> {
  @override
  Widget build(BuildContext context) {

    debugPrint('${widget.serviceState.image1}');
    //debugPrint('image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () async {

                StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigatePop(widget.orderState.orderId, widget.orderState.itemList.first.id));
                //Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderState: widget.orderState, tourist: widget.tourist, serviceState: widget.serviceState,)));
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  children: [
                    ///Service Image
                    CachedNetworkImage(
                      imageUrl:
                        widget.orderState.itemList.length  == 1 ?
                        Utils.version200(widget.serviceState.image1) :
                          (
                          widget.orderState.itemList.length > 1 ?
                          Utils.version200(widget.orderState.business.thumbnail) :
                          'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c'
                        ),
                      imageBuilder: (context, imageProvider) => Container(
                        //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                        height: 91,
                        width: 91,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover,)),
                      ),
                      placeholder: (context, url) => Utils.imageShimmer(91, 91),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    /*Container(
                      height: 91, ///SizeConfig.safeBlockVertical * 15
                      width: 91, ///SizeConfig.safeBlockVertical * 15
                      //margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          image: DecorationImage(
                            image: widget.serviceState.image1.isNotEmpty ? NetworkImage(widget.serviceState.image1) : AssetImage('assets/img/image_placeholder.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),*/
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
                               Utils.translateOrderStatusUser(context, widget.orderState.progress).toUpperCase(),
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: Utils.colorOrderStatusUser(context, widget.orderState.progress),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            ),
                          ),
                          ///Order Name
                          widget.orderState.itemList.length > 1 ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: Text(
                                AppLocalizations.of(context).multipleOrders,
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
                          ) : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: Text(
                                widget.orderState.itemList[0].name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.orderState.itemList[0].name) : '',
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
                          ),
                          ///Order Date
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: 180, ///SizeConfig.safeBlockHorizontal * 50
                              //height: 40, ///SizeConfig.safeBlockVertical * 10
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                              child: Text(
                                DateFormat('dd MMM yyyy - HH:mm',Localizations.localeOf(context).languageCode).format(widget.orderState.itemList[0].date) ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    letterSpacing: 0.25,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            ),
                          ),
                          ///Price
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: 180, ///SizeConfig.safeBlockHorizontal * 50
                              //height: 20, ///SizeConfig.safeBlockVertical * 10
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                              child: Text(
                                AppLocalizations.of(context).euroSpace + widget.orderState.total.toStringAsFixed(2) ?? '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    letterSpacing: 0.25,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextGrey,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}

