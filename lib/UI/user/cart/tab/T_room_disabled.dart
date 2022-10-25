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

import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/cart/widget/W_credit_card.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/UI/user/service/UI_U_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RoomDisabled extends StatefulWidget {

  RoomDisabled() : super();

  @override
  State<StatefulWidget> createState() => RoomDisabledState();
}

class RoomDisabledState extends State<RoomDisabled> {




  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 5),
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 10),
              margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 10),
              child: Text(
                AppLocalizations.of(context).paymentMethodNotAvailable,
                textAlign: TextAlign.start,
                style: TextStyle(
                  letterSpacing: 0.25,
                  fontFamily: BuytimeTheme.FontFamily,
                  color: BuytimeTheme.TextMedium,
                  fontSize: 14,
                  ///SizeConfig.safeBlockHorizontal * 3.5
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  String asteriskChars(String bookingCode, int asterisksToShowInFront) {
    String result = bookingCode;
    if ( bookingCode!= null && (bookingCode.length - asterisksToShowInFront) > 1) {
      result = '';
      int lastCharsToTake = bookingCode.length - asterisksToShowInFront;
      String charsToShow = bookingCode.substring(lastCharsToTake, bookingCode.length);
      for (int i = 0; i < asterisksToShowInFront; i++) {
        result = result + '*';
      }
      result = result + charsToShow;
    }
    return result;

  }
}
