import 'package:Buytime/UI/user/cart/UI_U_AddCard.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/cart/widget/W_credit_card.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
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

class CreditCards extends StatefulWidget {
  final String title = 'Cart';

  @override
  State<StatefulWidget> createState() => CreditCardsState();
}


class CreditCardsState extends State<CreditCards> {
  @override
  void initState() {
    super.initState();
  }

  List<String> tmpList = [];
  List<CardState> creditCards = [];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /*StoreConnector<AppState, AppState>(
                onInit: (store) => store?.dispatch(StripeCardListRequest(store?.state?.user?.uid)), // no
                converter: (store) => store.state,
                builder: (context, snapshot) {
                  StripeCardResponse cardResponse;
                  cardResponse = snapshot.stripe.stripeCard;
                  CardState card = CardState().toEmpty();
                  card.cardResponse = cardResponse;
                  debugPrint('T_credit_cards => CARD BRAND: ${card.cardResponse.brand}');
                  return Flexible(
                    //height: SizeConfig.safeBlockVertical * 30,
                    flex: 1,
                    child: CustomScrollView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              //MenuItemModel menuItem = menuItems.elementAt(index);

                              return CreditCard(card);
                            },
                              childCount: card.cardResponse.brand != null  ? 1 : 0,
                            ),
                          ),
                        ]),
                  );
                }),*/
            StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                rebuildOnChange: true,
                builder: (context, snapshot) {
                  creditCards = snapshot.cardListState != null ? snapshot.cardListState.cardListState : [];

                  print("T_credit_cards => CARD COUNT: ${snapshot.cardListState.cardListState.length}");
                  //creditCards.addAll(tmpList);
                  //store?.dispatch(AddCardToList(tmpList));
                  return Flexible(
                    //height: SizeConfig.safeBlockVertical * 30,
                    flex: 1,
                    child: CustomScrollView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((context, index) {
                              //MenuItemModel menuItem = menuItems.elementAt(index);
                              CardState card = creditCards.elementAt(index);
                              return CreditCard(card);
                            },
                              childCount: creditCards.length,
                            ),
                          ),
                        ]),
                  );
                }
            ),
            ///Add Card
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, right: SizeConfig.safeBlockHorizontal * 5),
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          onTap: (){
                            /*setState(() {
                              //tmpList.add('scemo');
                              creditCards.add(CreditCard());
                            });*/
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UI_U_AddCard()),);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_U_StripePayment()),);
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                          },
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              AppLocalizations.of(context).addCard,
                              style: TextStyle(
                                  letterSpacing: 1.25,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.UserPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16
                              ),
                            ),
                          )
                      ),
                    )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
