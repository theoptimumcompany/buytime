import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderTotal extends StatelessWidget {
  const OrderTotal({
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
      height: SizeConfig.safeBlockVertical * 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Total Price Text
          Text(
            /*AppLocalizations.of(context).total*/ 'Total price',
            style: TextStyle(
              fontFamily: BuytimeTheme.FontFamily,
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              color: BuytimeTheme.TextGrey
            ),
          ),
          ///Total Value
          Container(
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
            child: Text(
              '€ ${orderState.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: BuytimeTheme.FontFamily,
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.safeBlockHorizontal * 7,
              ),
            ),
          ),
          ///Tax
          Container(
            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
            child: Text(
              AppLocalizations.of(context).tax + (orderState.total != null ? (orderState.total * 0.25).toStringAsFixed(2) : "0"),
              style: TextStyle(
                fontFamily: BuytimeTheme.FontFamily,
                fontWeight: FontWeight.w400,
                fontSize: media.height * 0.020,
                  color: BuytimeTheme.TextGrey
              ),
            ),
          ),
        ],
      ),
    );
  }
}