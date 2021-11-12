import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:Buytime/reblox/model/app_state.dart';

class NewDiscount extends StatefulWidget {
  ServiceState serviceState;
  String businessId;
  bool isPromo;
  bool isFirst;
  NewDiscount(this.serviceState, this.businessId, this.isPromo, this.isFirst);
  @override
  _NewDiscountState createState() => _NewDiscountState();
}

class _NewDiscountState extends State<NewDiscount> {
  @override
  Widget build(BuildContext context) {
    String discount = '';
    if(widget.isPromo){
      discount = StoreProvider.of<AppState>(context).state.promotionState.discount.toString();
      if (StoreProvider.of<AppState>(context).state.promotionState.discountType == "percentageAmount") {
        discount += "%";
      } else if (StoreProvider.of<AppState>(context).state.promotionState.discountType == "fixedAmount") {
        discount += "€";
      }
    }else{
      ConventionHelper conventionHelper = ConventionHelper();
      discount = '${conventionHelper.getConventionDiscount(widget.serviceState, widget.businessId)}%';
    }


    return Container(
      height: 34,
      width: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: BuytimeTheme.SymbolMalibu,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(7),
            bottomLeft: Radius.circular(7) ,
          )
      ),
      child: Text(
        '$discount\nOFF',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: BuytimeTheme.FontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: BuytimeTheme.TextWhite
        ),
      ),
    );
  }
}
