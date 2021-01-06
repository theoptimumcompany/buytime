import 'package:BuyTime/UI/user/landing/invite_guest_form.dart';
import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class LandingCardWidget extends StatefulWidget {

  String topString;
  String bottomString;
  String imagePath;
  VoidCallback callback;
  LandingCardWidget(this.topString, this.bottomString, this.imagePath, this.callback);

  @override
  _LandingCardWidgetState createState() => _LandingCardWidgetState();
}

class _LandingCardWidgetState extends State<LandingCardWidget> {
  @override
  Widget build(BuildContext context) {


    return Container(
      height: SizeConfig.safeBlockVertical * 25,
      width: SizeConfig.safeBlockHorizontal * 50,
      //margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
      decoration: BoxDecoration(
        color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage(widget.imagePath),
            fit: BoxFit.cover,
          )
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.black.withOpacity(.3),
          onTap: widget.callback,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            height: SizeConfig.safeBlockVertical * 25,
            width: SizeConfig.safeBlockHorizontal * 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black.withOpacity(.2)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.topString,
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.safeBlockHorizontal * 4
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 1),
                  child:  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.bottomString,
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.safeBlockHorizontal * 4
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

