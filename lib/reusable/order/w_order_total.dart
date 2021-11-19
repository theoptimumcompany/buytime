import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderTotal extends StatelessWidget {
  OrderTotal({
    @required this.orderState,
    Key key,
    @required this.media,
    @required this.promotion
  }) : super(key: key);

  bool promotion = false;
  final Size media;
  OrderState orderState;
  double totalECO = 0;
  double partialECO = 0;

  void calculateEcoTax() {
    totalECO = orderState.total;
    partialECO = (totalECO * 2.5) / 100;
    if (orderState.carbonCompensation) {
      totalECO = totalECO + partialECO;
    } else {
      totalECO = totalECO - partialECO;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    calculateEcoTax();
    // double vat = 0.0;
    // orderState.itemList.forEach((element) {
    //   if (element.vat != null && element.price != null) {
    //     debugPrint("order_total vat:" + element.vat.toString() + " number of items: " + element.number.toString() + " promo: " + orderState.totalPromoDiscount.toString() + " price: " + element.price.toString());
    //     double itemDiscount = orderState.totalPromoDiscount / element.number;
    //     vat += (element.price - itemDiscount) * element.number * (element.vat / 100);
    //   }
    // });
    return Container(
      width: media.width,
      margin: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 24),
      //height: SizeConfig.safeBlockVertical * 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Subtotal
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).subtotal,
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      ///SizeConfig.safeBlockHorizontal * 4
                      color: BuytimeTheme.TextMedium,
                      letterSpacing: 0.25),
                ),
              ),
              ///Value
              Container(
                alignment: Alignment.center,
                //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
                child: Text(
                  '${orderState.total.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}',
                  style: TextStyle(
                      fontFamily: BuytimeTheme.FontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,

                      ///SizeConfig.safeBlockHorizontal * 7,
                      color: BuytimeTheme.TextMedium),
                ),
              )
            ],
          ),
          ///VAT
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///VAT
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).justVAT.toUpperCase(),
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.TextMedium,
                        letterSpacing: 0.25),
                  ),
                ),
                ///Value
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context).included,
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,

                        ///SizeConfig.safeBlockHorizontal * 7,
                        color: BuytimeTheme.TextMedium),
                  ),
                )
              ],
            ),
          ),
          ///Promotional code
          orderState.totalPromoDiscount > 0 ?
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Promotional code
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).promotionalCode,
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.UserPrimary,
                        letterSpacing: 0.25),
                  ),
                ),
                ///Value
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '-${orderState.totalPromoDiscount.toStringAsFixed(2)}${AppLocalizations.of(context).currency}',
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,

                        ///SizeConfig.safeBlockHorizontal * 7,
                        color: BuytimeTheme.UserPrimary),
                  ),
                )
              ],
            ),
          ) : Container(),
          ///Green choice
          orderState.carbonCompensation ?
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Green choice
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).greenChoice,
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.GreenChoice,
                        letterSpacing: 0.25),
                  ),
                ),
                ///Value
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '+${partialECO.toStringAsFixed(2)}${AppLocalizations.of(context).currency}',
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,

                        ///SizeConfig.safeBlockHorizontal * 7,
                        color: BuytimeTheme.GreenChoice),
                  ),
                )
              ],
            ),
          ) : Container(),
          ///Total
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///Total
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).total,
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.TextBlack,
                        letterSpacing: 0.25),
                  ),
                ),
                ///Value
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        !orderState.carbonCompensation ?
                        '${orderState.total.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}' :
                        '${totalECO.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}',
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            decoration: orderState.totalPromoDiscount > 0 ?
                            TextDecoration.lineThrough : TextDecoration.none
                          ///SizeConfig.safeBlockHorizontal * 4
                        ),
                      ),
                      orderState.totalPromoDiscount > 0 ?
                      Text(
                        !orderState.carbonCompensation ?
                        ' ${orderState.totalPromoDiscount > orderState.total ? '1.00': (orderState.total-orderState.totalPromoDiscount).toStringAsFixed(2)}${AppLocalizations.of(context).currencySpace}':
                        ' ${orderState.totalPromoDiscount > totalECO ? '${(1+partialECO).toStringAsFixed(2)}': (totalECO-orderState.totalPromoDiscount).toStringAsFixed(2)}${AppLocalizations.of(context).currencySpace}',
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,

                            ///SizeConfig.safeBlockHorizontal * 7,
                            color: BuytimeTheme.TextBlack),
                      ) : Container(),
                    ],
                  )
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10.0),
          //   child: orderState.totalPromoDiscount != null && orderState.totalPromoDiscount > 0 ?
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     //crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       ///Promo Text
          //       Utils.checkPromoDiscountTotal('general_1', context, orderState.itemList[0].id_business).promotionId != 'empty'
          //           ? Expanded(
          //               flex: 1,
          //               child: Container(
          //                 alignment: Alignment.centerLeft,
          //                 child: Text(
          //                   '${AppLocalizations.of(context).promo} :',
          //                   style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, fontSize: 14, color: BuytimeTheme.TextMedium, letterSpacing: 0.25),
          //                 ),
          //               ),
          //             )
          //           : Container(),
          //
          //       ///Promo Value
          //       Utils.checkPromoDiscountTotal('general_1', context, orderState.itemList[0].id_business).promotionId != 'empty'
          //           ? Expanded(
          //           flex: 1,
          //           child: Container(
          //             alignment: Alignment.center,
          //             //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
          //             child: Text(
          //               '-${orderState.totalPromoDiscount.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}',
          //               style: TextStyle(
          //                   fontFamily: BuytimeTheme.FontFamily,
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 16,
          //
          //                   ///SizeConfig.safeBlockHorizontal * 7,
          //                   color: BuytimeTheme.TextBlack),
          //             ),
          //           )) : Container(),
          //
          //       ///Empty Space
          //       Expanded(
          //         flex: 1,
          //         child: Container(
          //           alignment: Alignment.centerRight,
          //           //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
          //           child: Text(
          //             '',
          //             style: TextStyle(
          //                 fontFamily: BuytimeTheme.FontFamily,
          //                 fontWeight: FontWeight.w500,
          //                 fontSize: 16,
          //
          //                 ///SizeConfig.safeBlockHorizontal * 4
          //                 color: BuytimeTheme.TextMedium,
          //                 letterSpacing: 0.25),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ) : Container(),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   //crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     ///Total Price Text
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         alignment: Alignment.centerLeft,
          //         child: Text(
          //           AppLocalizations.of(context).total,
          //           style: TextStyle(
          //               fontFamily: BuytimeTheme.FontFamily,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 16,
          //
          //               ///SizeConfig.safeBlockHorizontal * 4
          //               color: BuytimeTheme.TextMedium,
          //               letterSpacing: 0.25),
          //         ),
          //       ),
          //     ),
          //
          //     ///Total Value
          //     Expanded(
          //         flex: 1,
          //         child: Container(
          //           alignment: Alignment.center,
          //           //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
          //           child: Text(
          //             !orderState.carbonCompensation ? '${orderState.total.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}' : '${totalECO.toStringAsFixed(2)}${AppLocalizations.of(context).euroSpace}',
          //             style: TextStyle(
          //                 fontFamily: BuytimeTheme.FontFamily,
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 24,
          //
          //                 ///SizeConfig.safeBlockHorizontal * 7,
          //                 color: BuytimeTheme.TextBlack),
          //           ),
          //         )),
          //
          //     ///Tax
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         alignment: Alignment.centerRight,
          //         //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
          //         child: Text(
          //            AppLocalizations.of(context).vat + ' ' + vat.toStringAsFixed(2)+'€',
          //           /*AppLocalizations.of(context).vat + (orderState.total != null ?
          //             (orderState.total *
          //                 (StoreProvider.of<AppState>(context).state.serviceState.vat != null && StoreProvider.of<AppState>(context).state.serviceState.vat != 0 ?
          //                 StoreProvider.of<AppState>(context).state.serviceState.vat/100 : 0.22)).toStringAsFixed(2) : "0"),*/
          //           style: TextStyle(
          //               fontFamily: BuytimeTheme.FontFamily,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 16,
          //
          //               ///SizeConfig.safeBlockHorizontal * 4
          //               color: BuytimeTheme.TextMedium,
          //               letterSpacing: 0.25),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
