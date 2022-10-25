/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
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
    double vat = 0.0;
    orderState.itemList.forEach((element) {
      vat += (element.price - Utils.checkPromoDiscount('general_1', context).discount) * (element.vat / 100);
    });
    return Container(
      width: media.width,
      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3, right: SizeConfig.safeBlockHorizontal * 3),
      height: SizeConfig.safeBlockVertical * 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Promo Text
                Utils.checkPromoDiscount('general_1', context).promotionId != 'empty'
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${AppLocalizations.of(context).promo} :',
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w500, fontSize: 14, color: BuytimeTheme.TextMedium, letterSpacing: 0.25),
                          ),
                        ),
                      )
                    : Container(),

                ///Promo Value
                Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
                      child: Text(
                        '- ${AppLocalizations.of(context).euroSpace} ${orderState.totalPromoDiscount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,

                            ///SizeConfig.safeBlockHorizontal * 7,
                            color: BuytimeTheme.TextBlack),
                      ),
                    )),

                ///Empty Space
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
                    child: Text(
                      '',
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,

                          ///SizeConfig.safeBlockHorizontal * 4
                          color: BuytimeTheme.TextMedium,
                          letterSpacing: 0.25),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
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
                        fontSize: 16,

                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.TextMedium,
                        letterSpacing: 0.25),
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
                      !orderState.carbonCompensation ? '${AppLocalizations.of(context).euroSpace} ${orderState.total.toStringAsFixed(2)}' : '${AppLocalizations.of(context).euroSpace} ${totalECO.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontFamily: BuytimeTheme.FontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,

                          ///SizeConfig.safeBlockHorizontal * 7,
                          color: BuytimeTheme.TextBlack),
                    ),
                  )),

              ///Tax
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
                  child: Text(
                    AppLocalizations.of(context).vat + ' € ' + vat.toStringAsFixed(2),
                    /*AppLocalizations.of(context).vat + (orderState.total != null ?
                      (orderState.total *
                          (StoreProvider.of<AppState>(context).state.serviceState.vat != null && StoreProvider.of<AppState>(context).state.serviceState.vat != 0 ?
                          StoreProvider.of<AppState>(context).state.serviceState.vat/100 : 0.22)).toStringAsFixed(2) : "0"),*/
                    style: TextStyle(
                        fontFamily: BuytimeTheme.FontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,

                        ///SizeConfig.safeBlockHorizontal * 4
                        color: BuytimeTheme.TextMedium,
                        letterSpacing: 0.25),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
