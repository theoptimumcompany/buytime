import 'package:Buytime/UI/user/landing/invite_guest_form.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
      height: 168, ///SizeConfig.safeBlockVertical * 25
      width: 188, ///SizeConfig.safeBlockHorizontal * 50
      //margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
      decoration: BoxDecoration(
        color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(5)),
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
          child: Container(
            height: SizeConfig.safeBlockVertical * 25,
            width: SizeConfig.safeBlockHorizontal * 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                //color: Colors.black.withOpacity(.1),
              gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    BuytimeTheme.BackgroundBlack.withOpacity(0.5),
                  ],
                  begin : Alignment.topCenter,
                  end : Alignment.bottomCenter,
                  stops: [0.0, 5.0],
                  //tileMode: TileMode.
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Top text
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * .5),
                  child: Text(
                    widget.topString,
                    style: TextStyle(
                        letterSpacing: -.1,
                        fontFamily: BuytimeTheme.FontFamily,
                        color: BuytimeTheme.TextWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                    ),
                  ),
                ),
                ///Bottom text
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 1.5),
                  child:  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.bottomString,
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          color:  BuytimeTheme.TextWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
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

