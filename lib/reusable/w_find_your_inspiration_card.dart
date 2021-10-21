import 'package:Buytime/UI/user/category/UI_U_filter_by_category.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FindYourInspirationCardWidget extends StatefulWidget {

  double width;
  double heigth;
  CategoryState categoryState;
  List<String> categoryListIds;
  bool fromBookingPage;
  bool tourist;
  int first;
  int second;
  bool fromSubCategory;
  FindYourInspirationCardWidget(this.width, this.heigth,this.categoryState, this.fromBookingPage, this.tourist, this.categoryListIds, this.first, this.second, this.fromSubCategory);

  @override
  _FindYourInspirationCardWidgetState createState() => _FindYourInspirationCardWidgetState();
}

class _FindYourInspirationCardWidgetState extends State<FindYourInspirationCardWidget> {

  @override
  void initState() {
    super.initState();
    //debugPrint('w_find_your_inspiration_Card => ${widget.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {

    return  CachedNetworkImage(
      imageUrl: Utils.version200(widget.categoryState.categoryImage),
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
        //width: double.infinity,
        //height: double.infinity,
        width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
        height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
        decoration: BoxDecoration(
            color: BuytimeTheme.BackgroundWhite,
            //borderRadius: BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            )
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: Key('category_${widget.first}_${widget.second}_key'),
            splashColor: Colors.black.withOpacity(.3),
            onTap: (){
              widget.fromBookingPage || widget.fromSubCategory ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true, categoryState: widget.categoryState, tourist: widget.tourist, categoryListIds: widget.categoryListIds,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,categoryState: widget.categoryState, tourist: widget.tourist, categoryListIds: widget.categoryListIds,)));
            },
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: SizeConfig.safeBlockVertical * widget.width,
              height: SizeConfig.safeBlockVertical * widget.heigth,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.all(Radius.circular(5)),
                  //color: Colors.black.withOpacity(.2)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: widget.width,
                    height: widget.heigth/3,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                        color: Colors.black.withOpacity(.2)
                    ),
                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                    child: Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.categoryState.name,
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              color: BuytimeTheme.TextWhite,
                              fontWeight: FontWeight.w400,
                              fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
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
      placeholder: (context, url) => Utils.imageShimmer(widget.width, widget.heigth),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

