import 'package:Buytime/UI/user/category/UI_U_filter_by_category.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class PRCardWidget extends StatefulWidget {

  double width;
  double heigth;
  ServiceState serviceState;
  bool fromBookingPage;
  bool isBlack;
  PRCardWidget(this.width, this.heigth,this.serviceState, this.fromBookingPage, this.isBlack);

  @override
  _PRCardWidgetState createState() => _PRCardWidgetState();
}

class _PRCardWidgetState extends State<PRCardWidget> {

  @override
  void initState() {
    super.initState();
    //debugPrint('${widget.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {

    return  CachedNetworkImage(
      imageUrl: Utils.version200(widget.serviceState.image1),
      imageBuilder: (context, imageProvider) =>
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
              //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
              //width: double.infinity,
              //height: double.infinity,
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
              width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
              height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
              decoration: BoxDecoration(
                  color: BuytimeTheme.BackgroundWhite,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Colors.black.withOpacity(.3),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetails(serviceState: widget.serviceState, tourist: true,)));
                    /*widget.fromBookingPage ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true, categoryState: widget.categoryState,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,categoryState: widget.categoryState,)));*/
                  },
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      //color: Colors.black.withOpacity(.2)
                    ),
                  ),
                ),
              ),
            ),
              Container(
                width: 180,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: widget.isBlack ?  BuytimeTheme.TextBlack : BuytimeTheme.TextWhite, fontWeight: FontWeight.w400, fontSize: 14
                      ///SizeConfig.safeBlockHorizontal * 4
                    ),
                  ),
                ),
              )
            ],
          ),
      placeholder: (context, url) => Column(
        children: [
          Container(
          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
          child: Utils.imageShimmer(widget.width, widget.heigth),
          ),
          Container(
            width: 180,
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
            child: Utils.textShimmer(150, 10),
          )
        ],
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

