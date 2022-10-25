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

import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/W_green_choice.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

import 'W_promo_discount.dart';

class BookingListServiceListItem extends StatefulWidget {
  ServiceState serviceState;
  bool tourist;

  BookingListServiceListItem(this.serviceState, this.tourist);

  @override
  _BookingListServiceListItemState createState() => _BookingListServiceListItemState();
}

class _BookingListServiceListItemState extends State<BookingListServiceListItem> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ServiceDetails(
                            serviceState: widget.serviceState,
                            tourist: widget.tourist,
                          )),
                );
              },
              child: Container(
                height: 100,

                ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  children: [
                    ///Service Image
                    CachedNetworkImage(
                      imageUrl: Utils.version200(widget.serviceState.image1),
                      imageBuilder: (context, imageProvider) => Container(
                        //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                        height: 91,
                        width: 91,
                        decoration: BoxDecoration(
                            //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
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
                      //width: SizeConfig.safeBlockHorizontal * 60,
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Service Name
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              width: SizeConfig.safeBlockHorizontal * 55,
                              child: Text(
                                widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16

                                    /// SizeConfig.safeBlockHorizontal * 4
                                    ),
                              ),
                            ),
                          ),

                          ///Description
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: SizeConfig.safeBlockHorizontal * 55,
                              ///SizeConfig.safeBlockHorizontal * 50
                              height: 40,

                              ///SizeConfig.safeBlockVertical * 10
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                              child: Text(
                                widget.serviceState.description != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.description) : '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w400, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                              ),
                            ),
                          ),

                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Row(
                                children: [
                                  ///ECO label
                                  widget.serviceState.tag.contains('ECO')
                                      ? FittedBox(
                                    fit: BoxFit.contain,
                                    child: W_GreenChoice(true),
                                  )
                                      : Container(),
                                  ///Promo Discount label
                                  Utils.checkPromoDiscount('general_1', context).promotionId != 'empty'
                                      ? Container(
                                    margin: EdgeInsets.only(left: 5),
                                        child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: W_PromoDiscount(true),
                                  ),
                                      ): Container(),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
