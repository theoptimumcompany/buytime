import 'package:BuyTime/utils/size_config.dart';
import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';

class CustomBottomButtonWidget extends StatefulWidget {

  String topString;
  String bottomString;
  Icon icon;
  CustomBottomButtonWidget(this.topString, this.bottomString, this.icon);

@override
_CustomBottomButtonWidgetState createState() => _CustomBottomButtonWidgetState();
}

class _CustomBottomButtonWidgetState extends State<CustomBottomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.topString,
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Colors.black.withOpacity(.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 18
                        ),
                      ),
                    ),
                    widget.bottomString.isNotEmpty ? Container(
                      child: Text(
                        widget.bottomString,
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            color: Colors.black.withOpacity(.7),
                            fontWeight: FontWeight.w400,
                            fontSize: 16
                        ),
                      ),
                    ) : Container()
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: widget.icon,
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}