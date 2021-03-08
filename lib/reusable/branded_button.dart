
import 'dart:io';

import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandedButton extends StatelessWidget {

  VoidCallback callbackAction;
  var brandImage;
  var buttonText;

  BrandedButton(String brandImage, String buttonText, VoidCallback callbackAction) {
    this.brandImage = brandImage;
    this.buttonText = buttonText;
    this.callbackAction = callbackAction;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return
      Center(
          child: Container(
            width: 247,
            height: 50,
            //margin: EdgeInsets.only(top: SizeConfig.screenHeight < 537 ? 1.0 : 5.0, bottom: SizeConfig.screenHeight < 537 ? 1.0 : 5.0, left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0),
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom:SizeConfig.safeBlockVertical * 0, left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0),
            child: RaisedButton(
              color: BuytimeTheme.BackgroundWhite,
              onPressed: buttonText.toString().contains('Apple') && Platform.isAndroid ? null : () =>  this.callbackAction(),
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
              ),
              disabledColor: Colors.white.withOpacity(.3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ///Brand logo
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: AssetImage(
                          this.brandImage
                      ),
                      height: 26,
                    ),
                  ),
                  ///Button text
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 10),
                      child: Text(
                        this.buttonText,
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1.25,
                            color: BuytimeTheme.TextBlack,
                            fontWeight: FontWeight.w500,
                            fontFamily: BuytimeTheme.FontFamily
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
      );
  }

}
