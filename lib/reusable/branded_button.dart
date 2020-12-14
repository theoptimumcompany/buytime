
import 'dart:io';

import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/utils/size_config.dart';
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
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0),
            child: RaisedButton(
              color: BuytimeTheme.BackgroundWhite,
              onPressed: buttonText.toString().contains('Apple') && Platform.isAndroid ? null : () =>  this.callbackAction(),
              highlightElevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5),
              ),
              disabledColor: Colors.white.withOpacity(.3),
              child: Container(
                width: 240,
                height: 45,
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
                              fontSize: 18,
                              color: Color(0xff666666),
                              fontWeight: FontWeight.bold,
                              fontFamily: BuytimeTheme.FontFamily
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      );
  }

}
