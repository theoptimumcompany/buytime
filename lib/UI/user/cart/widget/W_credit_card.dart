import 'dart:math';

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

class CreditCard extends StatefulWidget {

  CardState cardState;
  CreditCard(this.cardState);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  String bookingStatus = '';
  bool selected = false;
  String card = '';
  List<String> cc = ['v','mc'];

  String ownerCard ='';
  String cardName = '';
  String cardEndWith = '';

  @override
  void initState() {
    super.initState();
    card = widget.cardState.cardResponse.brand.toLowerCase().substring(0,1) == 'v' ? 'v' : 'mc';
    ownerCard = widget.cardState.cardOwner ?? '';
    cardName = widget.cardState.cardResponse.brand;
    cardEndWith = widget.cardState.cardResponse.last4;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: SizeConfig.safeBlockVertical * 10,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///Card Image
          Container(
            height: SizeConfig.safeBlockVertical * 8,
            width: SizeConfig.safeBlockHorizontal * 18,
            margin: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 5),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/img/cc/$card.png'
                    )
                )
            ),
          ),
          ///Card Name & Ending **** .... & Select
          Expanded(
              child: Container(
                //width: SizeConfig.safeBlockHorizontal * 50,
                //color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ///Card Name & Ending **** ....
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///Card Name
                          Text(
                            '$cardName',//AppLocalizations.of(context).logBack, ///TODO Make it Global
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontFamily: BuytimeTheme.FontFamily,
                                fontWeight: FontWeight.w500,
                                color: BuytimeTheme.TextGrey
                            ),
                          ),
                          ///Ending **** ....
                          Text(
                            'ending **** $cardEndWith',//AppLocalizations.of(context).logBack, ///TODO Make it Global
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 4,
                                fontFamily: BuytimeTheme.FontFamily,
                                fontWeight: FontWeight.w500,
                                color: BuytimeTheme.TextGrey
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Select
                    Container(
                        //alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: (){
                                /*setState(() {
                                  //tmpList.add('scemo');
                                  // creditCards.add(CreditCard());
                                  selected = !selected;
                                });*/
                                List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardListState;
                                tmpList.forEach((element) {
                                  if(element.cardResponse.secretToken == widget.cardState.cardResponse.secretToken){
                                    element.selected = true;
                                  }else{
                                    element.selected = false;
                                  }
                                });
                                StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                              },
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      !widget.cardState.selected ? Icons.add : MaterialDesignIcons.done,
                                      color: !widget.cardState.selected ? BuytimeTheme.TextGrey : BuytimeTheme.ActionButton,
                                    ),
                                    Text(
                                      !widget.cardState.selected ? 'select' : 'selected',//AppLocalizations.of(context).somethingIsNotRight,
                                      style: TextStyle(
                                          letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: !widget.cardState.selected ? BuytimeTheme.TextGrey : BuytimeTheme.ActionButton,
                                          fontWeight: FontWeight.w600,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        )
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}

