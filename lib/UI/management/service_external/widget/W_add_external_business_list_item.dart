import 'dart:math';

import 'package:Buytime/UI/management/service_external/UI_M_add_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_business_details.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';

class AddExternalBusinessListItem extends StatefulWidget {

  ExternalBusinessState externalBusinessState;
  BusinessState businessState;
  //bool tourist;
  bool fromMy;
  AddExternalBusinessListItem(this.externalBusinessState, this.businessState, this.fromMy);

  @override
  _AddExternalBusinessListItemState createState() => _AddExternalBusinessListItemState();
}

class _AddExternalBusinessListItemState extends State<AddExternalBusinessListItem> {

  double calculateDistance(){
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
   if(widget.businessState.coordinate != null && widget.businessState.coordinate.isNotEmpty){
     List<String> latLng1 = widget.businessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
     debugPrint('W_add_external_business_list_item => ${widget.businessState.name} | Cordinates 1: $latLng1');
     if(latLng1.length == 2){
       lat1 = double.parse(latLng1[0]);
       lon1 = double.parse(latLng1[1]);
     }
   }
    if(widget.externalBusinessState.coordinate != null && widget.externalBusinessState.coordinate.isNotEmpty){
      List<String> latLng2 = widget.externalBusinessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('W_add_external_business_list_item => ${widget.externalBusinessState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    double tmp = (12742 * asin(sqrt(a)));
    debugPrint('W_add_external_business_list_item => Distance: $tmp');

    return  tmp;
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('W_add_external_business_list_item => coordinates: ${calculateDistance()}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () async {
                Navigator.push(context, EnterExitRoute(enterPage: ExternalBusinessDetails(widget.externalBusinessState, widget.fromMy, false), exitPage: AddExternalServiceList(false), from: true));
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
                          imageUrl: Utils.version200(widget.externalBusinessState.logo),
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
                        ///Service Name & Description
                        Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
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
                              ///Description
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                  width: 180, ///SizeConfig.safeBlockHorizontal * 50
                                  height: 40, ///SizeConfig.safeBlockVertical * 10
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                      calculateDistance().toString().split('.').first.startsWith('0') ? calculateDistance().toString().split('.').last.substring(0,3) + ' m' : calculateDistance().toStringAsFixed(1) + ' Km',
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

