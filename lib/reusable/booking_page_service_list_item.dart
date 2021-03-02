import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:Buytime/UI/user/service/UI_U_ServiceDetails.dart';

class BookingListServiceListItem extends StatefulWidget {

  ServiceState serviceState;
  BookingListServiceListItem(this.serviceState);

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
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ServiceDetails(serviceState: widget.serviceState,)),
                );
              },
              child: Container(
                height: SizeConfig.safeBlockVertical * 15,
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                child: Row(
                  children: [
                    ///Service Image
                    Container(
                      height: SizeConfig.safeBlockVertical * 15,
                      width: SizeConfig.safeBlockVertical * 15,
                      //margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          image: DecorationImage(
                            image: widget.serviceState.image1.isNotEmpty ? NetworkImage(widget.serviceState.image1) : AssetImage('assets/img/image_placeholder.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),
                    ///Service Name & Description
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Service Name
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 50,
                                  child: Text(
                                    widget.serviceState.name ?? '',
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                              ),
                              ///Description
                              FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Container(
                                  width: SizeConfig.safeBlockHorizontal * 50,
                                  height: SizeConfig.safeBlockVertical * 10,
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    widget.serviceState.description ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextGrey,
                                        fontWeight: FontWeight.w500,
                                        fontSize: SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

