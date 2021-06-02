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

  bool tourist;
  bool reserve;
  String bookingCode = '???';
  Room({Key key, this.reserve, this.tourist, this.bookingCode}) : super(key: key);

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
  }

  List<String> tmpList = [];
  List<Widget> creditCards = [];

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
                    ///Booking Code Text
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                      child: Text(
                        AppLocalizations.of(context).bookingCode,
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

                    ///Booking Code Value
                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                      child: Text(
                        asteriskChars(widget.bookingCode, 3),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextBlack,
                          fontSize: 16,

                          ///SizeConfig.safeBlockHorizontal * 3.5
                          fontWeight: FontWeight.w600,
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
                        AppLocalizations.of(context).nameColon,
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

                    ///Name Value
                    Container(
                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                      child: Text(
                        fullName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          letterSpacing: 0.5,
                          fontFamily: BuytimeTheme.FontFamily,
                          color: BuytimeTheme.TextBlack,
                          fontSize: 16,

                          ///SizeConfig.safeBlockHorizontal * 3.5
                          fontWeight: FontWeight.w600,
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
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      AppLocalizations.of(context).pleaseChargeAmountToMyBill,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        letterSpacing: 0.5,
                        fontFamily: BuytimeTheme.FontFamily,
                        color: widget.tourist != null && widget.tourist  ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                        fontSize: 16,

                        ///SizeConfig.safeBlockHorizontal * 3.5
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
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
