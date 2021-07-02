import 'package:Buytime/UI/user/category/UI_U_filter_by_category.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PRCardWidget extends StatefulWidget {

  double width;
  double heigth;
  ServiceState serviceState;
  bool fromBookingPage;
  PRCardWidget(this.width, this.heigth,this.serviceState, this.fromBookingPage);

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
          Container(
            //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
            //width: double.infinity,
            //height: double.infinity,
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
                  width: SizeConfig.safeBlockVertical * widget.width,
                  height: SizeConfig.safeBlockVertical * widget.heigth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(.2)
                  ),
                ),
              ),
            ),
          ),
      placeholder: (context, url) => Container(
        width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
        height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

