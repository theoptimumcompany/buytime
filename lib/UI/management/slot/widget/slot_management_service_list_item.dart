import 'package:Buytime/UI/management/slot/RUI_M_service_slot_management.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SlotManagementServiceListItem extends StatefulWidget {

  ServiceState serviceState;
  bool tourist;
  int index;
  SlotManagementServiceListItem(this.serviceState, this.tourist, this.index);

  @override
  _SlotManagementServiceListItemState createState() => _SlotManagementServiceListItemState();
}

class _SlotManagementServiceListItemState extends State<SlotManagementServiceListItem> {
  @override
  Widget build(BuildContext context) {

    //debugPrint('slot_management_service_list_item => image: ${widget.serviceState.image1}');
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('slot_management_service_${widget.index}_key'),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RServiceSlotManagement(serviceState: widget.serviceState)),
                );
              },
              child: Container(
                height: 91,  ///SizeConfig.safeBlockVertical * 15
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
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Service Name
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Container(
                              width: SizeConfig.safeBlockHorizontal * 50,
                              child: Text(
                                widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) :  '',
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
                          /*FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: 180, ///SizeConfig.safeBlockHorizontal * 50
                              height: 40, ///SizeConfig.safeBlockVertical * 10
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                              child: Text(
                                widget.serviceState.description != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.description) :  '',
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
                          ),*/
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

