import 'dart:math';

import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_business_details.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

class ExternalBusinessListItem extends StatefulWidget {

  ExternalBusinessState externalBusinessState;
  //bool tourist;
  bool fromMyList;
  int count;
  ExternalBusinessListItem(this.externalBusinessState, this.fromMyList, this.count);

  @override
  _ExternalBusinessListItemState createState() => _ExternalBusinessListItemState();
}

class _ExternalBusinessListItemState extends State<ExternalBusinessListItem> {

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

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
              onTap: () async {
                Navigator.push(context, EnterExitRoute(enterPage: ExternalBusinessDetails(widget.externalBusinessState, widget.fromMyList, false), exitPage: ExternalServiceList(), from: true));
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ///Service Image
                        CachedNetworkImage(
                          imageUrl: widget.externalBusinessState.profile != null && widget.externalBusinessState.profile.isNotEmpty ? widget.externalBusinessState.profile : 'https://firebasestorage.googleapis.com/v0/b/${Environment().config.fireStorageServiceStorageBucket}/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
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
                        ///Service Name & Description
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Service Name
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 50,
                                  child: Text(
                                    widget.externalBusinessState.name ?? '..............',
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
                              ///Count
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                  width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                  height: 40, ///SizeConfig.safeBlockVertical * 10
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    '${widget.count} ${AppLocalizations.of(context).services}',
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
                        ),
                      ],
                    ),
                    /*Icon(
                      Icons.arrow_forward_ios,
                      color: BuytimeTheme.SymbolLightGrey,
                    )*/
                  ],
                ),
              ),
            )
        )
    );
  }
}

