import 'package:Buytime/UI/user/category/UI_U_FilterByCategory.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FindYourInspirationCardWidget extends StatefulWidget {

  double width;
  double heigth;
  String imageUrl;
  String categoryName;
  bool fromBookingPage;
  FindYourInspirationCardWidget(this.width, this.heigth, this.imageUrl,this.categoryName, this.fromBookingPage);

  @override
  _FindYourInspirationCardWidgetState createState() => _FindYourInspirationCardWidgetState();
}

class _FindYourInspirationCardWidgetState extends State<FindYourInspirationCardWidget> {

  @override
  void initState() {
    super.initState();
    //debugPrint('${widget.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {

    return  CachedNetworkImage(
      imageUrl: widget.imageUrl.isNotEmpty ? widget.imageUrl:  'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
        //width: double.infinity,
        //height: double.infinity,
        width: SizeConfig.safeBlockVertical * widget.width,
        height: SizeConfig.safeBlockVertical * widget.heigth,
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
              widget.fromBookingPage ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,)));
            },
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: SizeConfig.safeBlockVertical * widget.width,
              height: SizeConfig.safeBlockVertical * widget.heigth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  //color: Colors.black.withOpacity(.2)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: SizeConfig.safeBlockVertical * widget.width,
                    height: SizeConfig.safeBlockVertical * widget.heigth/3,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                        color: Colors.black.withOpacity(.2)
                    ),
                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                    child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.categoryName,
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: BuytimeTheme.TextWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.safeBlockHorizontal * 4
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

