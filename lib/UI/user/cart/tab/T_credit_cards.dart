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

import 'package:Buytime/UI/user/cart/UI_U_add_card.dart';
import 'package:Buytime/UI/user/cart/widget/W_credit_card.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CreditCards extends StatelessWidget {
  final String title = 'Cart';
  bool tourist;
  bool reserve;
  CreditCards({Key key, this.reserve, this.tourist}) : super(key: key);
  List<Widget> cardWidgetList = [];

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.safeBlockHorizontal * 5),
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StoreConnector<AppState, CardListState>(
                converter: (store) => store.state.cardListState,
                distinct: true,
                rebuildOnChange: true,
                onInit: (store) {
                  /// check if the stripe customer have been created for this user:
                  store?.dispatch(CheckStripeCustomer(true));
                  store?.dispatch(AddingStripePaymentMethodResetOR());
                  initializeCardList(store.state.cardListState);
                  debugPrint('T_credit_cards => ON INIT');
                },
                onWillChange: (oldStore, newStore){
                  initializeCardList(newStore);
                },
                builder: (context, snapshot) {
                  initializeCardList(snapshot);
                  return Flexible(
                    flex: 1,
                    child: cardWidgetList.length > 0 ? ListView(
                      children: cardWidgetList,
                    ) : Container()
                  );
                }
            ),
            ///Add Card
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StoreConnector<AppState, CardListState>(
                    converter: (store) => store.state.cardListState,
                    distinct: true,
                    rebuildOnChange: true,
                    builder: (context, snapshot) {
                    return
                      snapshot.cardList == null || (snapshot.cardList != null && snapshot.cardList.length == 0) ?
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () async {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => UI_U_AddCard()));
                              },
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  AppLocalizations.of(context).addCard,
                                  style: TextStyle(
                                      letterSpacing: 1.25,
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color:  tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16
                                  ),
                                ),
                              )
                          ),
                        )
                    ) :
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(AppLocalizations.of(context).info,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                // letterSpacing: 1.25,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color:  BuytimeTheme.TextGrey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            child: Text(AppLocalizations.of(context).atTheMomentWeOnlySupportOneCreditCard,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  // letterSpacing: 1.25,
                                fontStyle: FontStyle.italic,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color:  BuytimeTheme.TextGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 10.0),
                            child: Text(AppLocalizations.of(context).selectACardToPay,
                              softWrap: true,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                // letterSpacing: 1.25,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color:  BuytimeTheme.TextGrey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void initializeCardList(CardListState newStore) {
    if (newStore.cardList != null) {
      for(int i = 0; i < newStore.cardList.length; i++) {
        cardWidgetList.add(CreditCardListElement(newStore.cardList[i]));
        print("T_credit_cards => N:${newStore.cardList?.length} - ADD CARD FirebaseId: ${newStore.cardList[i].stripeState.stripeCard.firestore_id}");
      }
    }
  }
}
