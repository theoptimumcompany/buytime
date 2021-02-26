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

  List<String> tmpList = ['ciao', 'come'];
  List<Widget> creditCards = [];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Flexible(
      child: Container(
        color: BuytimeTheme.BackgroundWhite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              //height: SizeConfig.safeBlockVertical * 30,
              flex: 1,
              child: CustomScrollView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        //MenuItemModel menuItem = menuItems.elementAt(index);
                        return creditCards.elementAt(index);
                      },
                        childCount: creditCards.length,
                      ),
                    ),
                  ]),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UI_U_StripePayment()),
                            );
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                          },
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Add a Card',//AppLocalizations.of(context).somethingIsNotRight,
                              style: TextStyle(
                                  letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  color: BuytimeTheme.UserPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: SizeConfig.safeBlockHorizontal * 4
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
