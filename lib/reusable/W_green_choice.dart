import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class W_GreenChoice extends StatefulWidget {
  @override
  _W_GreenChoiceState createState() => _W_GreenChoiceState();
}

class _W_GreenChoiceState extends State<W_GreenChoice> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        width: 130,

        ///SizeConfig.safeBlockHorizontal * 40
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: BuytimeTheme.GreenChoice,
        ),
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage('assets/img/ecoWhite.png')),
              Text(
                AppLocalizations.of(context).greenChoice.toUpperCase(),
                style: TextStyle(color: BuytimeTheme.TextWhite, fontSize: 12, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, letterSpacing: 1.25),
              ),
            ],
          ),
        ));
  }
}
