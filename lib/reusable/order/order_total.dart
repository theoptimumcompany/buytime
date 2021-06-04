import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class OrderTotal extends StatelessWidget {
   OrderTotal({
    @required this.orderState,
    Key key,
    @required this.media,
  }) : super(key: key);

  final Size media;
  final OrderState orderState;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Container(
      width: media.width,
      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3, right: SizeConfig.safeBlockHorizontal * 3),
      height: SizeConfig.safeBlockVertical * 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Total Price Text
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).total,
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: 16, ///SizeConfig.safeBlockHorizontal * 4
                    color: BuytimeTheme.TextMedium,
                    letterSpacing: 0.25
                ),
              ),
            ),
          ),
          ///Total Value
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
              child: Text(
                '${AppLocalizations.of(context).euroSpace} ${orderState.total.toStringAsFixed(2)}',
                style: TextStyle(
                    fontFamily: BuytimeTheme.FontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 24, ///SizeConfig.safeBlockHorizontal * 7,
                    color: BuytimeTheme.TextBlack
                ),
              ),
            )
          ),
          ///Tax
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
                child: Text(
                  //AppLocalizations.of(context).tax + (orderState.total != null ? (orderState.total * 0.25).toStringAsFixed(2) : "0"),
                  AppLocalizations.of(context).tax + (orderState.total != null ?
                  (orderState.total *
                      (StoreProvider.of<AppState>(context).state.serviceState.vat != null && StoreProvider.of<AppState>(context).state.serviceState.vat != 0 ?
                      StoreProvider.of<AppState>(context).state.serviceState.vat/100 : 0.22)).toStringAsFixed(2) : "0"),
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 16, ///SizeConfig.safeBlockHorizontal * 4
                      color: BuytimeTheme.TextMedium,
                      letterSpacing: 0.25
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}