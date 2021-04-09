import 'package:Buytime/UI/user/booking/UI_U_OrderDetails.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_ServiceDetails.dart';

class UserServiceListItem extends StatefulWidget {

  OrderState orderState;
  UserServiceListItem(this.orderState);

  @override
  _UserServiceListItemState createState() => _UserServiceListItemState();
}

class _UserServiceListItemState extends State<UserServiceListItem> {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetails(orderState: widget.orderState)));
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  children: [
                    ///Service Image
                    CachedNetworkImage(
                      imageUrl: widget.orderState.business.thumbnail != null && widget.orderState.business.thumbnail.isNotEmpty ? widget.orderState.business.thumbnail : 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                      imageBuilder: (context, imageProvider) => Container(
                        //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                        height: 91,
                        width: 91,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover,)),
                      ),
                      placeholder: (context, url) => Container(
                        height: 91,
                        width: 91,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //padding: EdgeInsets.only(top: 80, bottom: 80, left: 50, right: 50),
                              child: CircularProgressIndicator(
                                //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                              ),
                            )
                          ],
                        ),
                      ),
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
                                    color: widget.orderState.progress == 'canceled' ? BuytimeTheme.AccentRed : widget.orderState.progress == 'pending' || widget.orderState.progress == 'unpaid' ? BuytimeTheme.Secondary : BuytimeTheme.ActionButton,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                ),
                              ),
                            ),
                          ),
                          ///Order Name
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: Text(
                                widget.orderState.itemList[0].name ?? '',
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
                                DateFormat('dd MMM yyyy').format(widget.orderState.itemList[0].date) ?? '',
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
                                AppLocalizations.of(context).euroSpace + widget.orderState.itemList[0].price.toStringAsFixed(2) ?? '',
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
