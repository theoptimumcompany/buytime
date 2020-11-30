
import 'package:BuyTime/UI/theme/buytime_theme.dart';
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

    return
      Center(
          child: Container(
            decoration: new BoxDecoration(
                color: BuytimeTheme.BackgroundWhite,
                borderRadius: new BorderRadius.all(
                  const Radius.circular(100),
                )
            ),
            child: OutlineButton(
              color: BuytimeTheme.BackgroundWhite,
              onPressed: () => this.callbackAction(),
              highlightElevation: 0,
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              child: Container(
                width: 240,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: AssetImage(
                          this.brandImage
                      ),
                      height: media.height * 0.04,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 10),
                      child: Text(
                        this.buttonText,
                        style: TextStyle(
                          fontSize: 18,
                          color: BuytimeTheme.UserPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
  }

}
