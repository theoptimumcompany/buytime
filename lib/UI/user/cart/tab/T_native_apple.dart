import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NativeApple extends StatefulWidget {
  bool tourist = false;
  NativeApple({Key key, this.tourist = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NativeAppleState();
}

class NativeAppleState extends State<NativeApple> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  ///Pay with Apple Pay
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            AppLocalizations.of(context).payWithApplePay,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontFamily: BuytimeTheme.FontFamily,
                              color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
