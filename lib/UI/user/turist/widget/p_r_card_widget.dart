import 'package:Buytime/UI/user/category/UI_U_FilterByCategory.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
      imageUrl: widget.serviceState.image1 != null && widget.serviceState.image1.isNotEmpty ? widget.serviceState.image1:  'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
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
