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

import 'package:Buytime/environment_abstract.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_detail_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class OrderRoomServiceListItem extends StatefulWidget {

  OrderState orderState;
  bool tourist;
  OrderRoomServiceListItem(this.orderState, this.tourist);

  @override
  _OrderRoomServiceListItemState createState() => _OrderRoomServiceListItemState();
}

class _OrderRoomServiceListItemState extends State<OrderRoomServiceListItem> {
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
                debugPrint("orderId, serviceId " + widget.orderState.orderId  + " " + widget.orderState.itemList.first.id);
                StoreProvider.of<AppState>(context).dispatch(SetOrderDetailAndNavigatePop(widget.orderState.orderId, widget.orderState.itemList.first.id));
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  children: [
                    ///Service Image
                    CachedNetworkImage(
                      imageUrl: widget.orderState.itemList.length > 1 ?
                        widget.orderState.business.thumbnail != null && widget.orderState.business.thumbnail.isNotEmpty ?
                          widget.orderState.business.thumbnail :
                          'https://firebasestorage.googleapis.com/v0/b/${Environment().config.fireStorageServiceStorageBucket}/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c' :
                      widget.orderState.itemList.first.thumbnail != null && widget.orderState.itemList.first.thumbnail.isNotEmpty ?
                      widget.orderState.itemList.first.thumbnail :
                      'https://firebasestorage.googleapis.com/v0/b/${Environment().config.fireStorageServiceStorageBucket}/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
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
                                DateFormat('dd MMM yyyy',Localizations.localeOf(context).languageCode).format(widget.orderState.itemList[0].date) ?? '',
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
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: 180, ///SizeConfig.safeBlockHorizontal * 50
                              //height: 20, ///SizeConfig.safeBlockVertical * 10
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                              child: Text(
                                widget.orderState.user.email != null ? widget.orderState.user.email : 'email not found',
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

