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

class Room extends StatefulWidget {
  final String title = 'Cart';

  @override
  State<StatefulWidget> createState() => RoomState();
}

class RoomState extends State<Room> {
  String fullName = '';
  String room = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fullName = StoreProvider.of<AppState>(context).state.user.name + StoreProvider.of<AppState>(context).state.user.surname);
    room = '???';
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
              child: Column(
                children: [
                  ///Room Number
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                    height: SizeConfig.safeBlockVertical * 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Room Number Text
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                            child: Text(
                              'Room Number:', ///TODO Make it Global
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextGrey,
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ///Room Number Value
                          Container(
                            margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                            child: Text(
                              room, ///TODO Make it Global
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextDark,
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                    color: BuytimeTheme.BackgroundLightGrey,
                    height: SizeConfig.safeBlockVertical * .2,
                  ),
                  ///User Name
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                    height: SizeConfig.safeBlockVertical * 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Name Text
                          Container(
                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                            child: Text(
                              'Name:', ///TODO Make it Global
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextGrey,
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ///Name Value
                          Container(
                            margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                            child: Text(
                              fullName, ///TODO Make it Global
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: BuytimeTheme.FontFamily,
                                color: BuytimeTheme.TextDark,
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10, right: SizeConfig.safeBlockHorizontal * 10),
                    color: BuytimeTheme.BackgroundLightGrey,
                    height: SizeConfig.safeBlockVertical * .2,
                  ),
                  ///Please ...
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Please charge this amount to my hotel bill.',//AppLocalizations.of(context).somethingIsNotRight,
                          style: TextStyle(
                              letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                              fontFamily: BuytimeTheme.FontFamily,
                              color: BuytimeTheme.UserPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.safeBlockHorizontal * 4
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
