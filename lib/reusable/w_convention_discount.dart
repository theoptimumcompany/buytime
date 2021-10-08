import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/services/convention/convention_helper.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:Buytime/reblox/model/app_state.dart';

class W_ConventionDiscount extends StatefulWidget {
  bool onlyIcon;
  ServiceState serviceState;
  String businessId;
  W_ConventionDiscount(this.serviceState, this.businessId, this.onlyIcon);
  @override
  _W_ConventionDiscountState createState() => _W_ConventionDiscountState();
}

class _W_ConventionDiscountState extends State<W_ConventionDiscount> {
  @override
  Widget build(BuildContext context) {

    ConventionHelper conventionHelper = ConventionHelper();
    return Container(
        height: 20,
        //width: 130,
        ///SizeConfig.safeBlockHorizontal * 40
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: BuytimeTheme.AccentRed,
        ),
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Icon(MaterialDesignIcons.local_activity,size: 14,color: BuytimeTheme.SymbolWhite),
              Text(
                '${conventionHelper.getConventionDiscount(widget.serviceState, widget.businessId)}%',
                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 13),
              ),
              !widget.onlyIcon ?
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  AppLocalizations.of(context).promo.toUpperCase(),
                  style: TextStyle(color: BuytimeTheme.TextWhite, fontSize: 12, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.bold, letterSpacing: 1.25),
                ),
              ) : Container(),
            ],
          ),
        ));
  }
}
