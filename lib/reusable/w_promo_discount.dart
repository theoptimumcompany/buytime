import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:Buytime/reblox/model/app_state.dart';

class W_PromoDiscount extends StatefulWidget {
  bool onlyIcon;
  W_PromoDiscount(this.onlyIcon);
  @override
  _W_PromoDiscountState createState() => _W_PromoDiscountState();
}

class _W_PromoDiscountState extends State<W_PromoDiscount> {
  @override
  Widget build(BuildContext context) {
    String promotionText = "-" + StoreProvider.of<AppState>(context).state.promotionState.discount.toString();
    if (StoreProvider.of<AppState>(context).state.promotionState.discountType == "percentageAmount") {
      promotionText += "%";
    } else if (StoreProvider.of<AppState>(context).state.promotionState.discountType == "fixedAmount") {
      promotionText += "€";
    }

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
                promotionText,
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
