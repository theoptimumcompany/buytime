import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service/card_list_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

// ignore: must_be_immutable
class CreditCardListElement extends StatefulWidget {

  CardState cardState;
  CreditCardListElement(this.cardState);

  @override
  _CreditCardListElementState createState() => _CreditCardListElementState();
}

class _CreditCardListElementState extends State<CreditCardListElement> {

  String bookingStatus = '';
  bool selected = false;
  bool askedForCancelation = false;
  String card = '';
  List<String> cc = ['v','mc'];

  String ownerCard ='';
  String cardName = '';
  String cardEndWith = '';
  String firestoreCardId = '';

  @override
  void initState() {
    super.initState();
    askedForCancelation = false;
    card = widget.cardState.stripeState.stripeCard.brand.toLowerCase().substring(0,1) == 'v' ? 'v' : 'mc';
    //card = 'v';
    ownerCard = widget.cardState.cardOwner ?? '';
    cardName = widget.cardState.stripeState.stripeCard.brand;
    cardEndWith = widget.cardState.stripeState.stripeCard.last4;
    firestoreCardId = widget.cardState.stripeState.stripeCard.firestore_id;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: SizeConfig.safeBlockVertical * 10,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///Delete
          Container(
            //alignment: Alignment.centerRight,
              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: (){
                      if (!askedForCancelation) {
                        askedForCancelation = true;
                        debugPrint("W_credit_card => Asked cancelation of credit card");
                        StoreProvider.of<AppState>(context).dispatch(DeletingStripePaymentMethodOR());
                        StoreProvider.of<AppState>(context).dispatch(CreateDisposePaymentMethodIntent(firestoreCardId, StoreProvider.of<AppState>(context).state.user.uid));
                        //StoreProvider.of<AppState>(context).dispatch(AddCardToList(tmpList));
                      }

                    },
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Container(
                      // /padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Icon(
                            BuytimeIcons.remove,
                            color: BuytimeTheme.AccentRed,
                            size: 22,
                          ),
                        ],
                      ),
                    )
                ),
              )
          ),
          ///Card Image
          Container(
            height: 30,
            width: 50,
            margin: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2.5),
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
            flex: 3,
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
                            '$cardName'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: BuytimeTheme.FontFamily,
                                fontWeight: FontWeight.w400,
                                color: BuytimeTheme.TextGrey
                            ),
                          ),
                          ///Ending **** ....
                          Text(
                            AppLocalizations.of(context).endingCard + cardEndWith,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: BuytimeTheme.FontFamily,
                                fontWeight: FontWeight.w400,
                                color: BuytimeTheme.TextGrey
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Select
                    Container(
                        //alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5, left: SizeConfig.safeBlockHorizontal * 2),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: (){
                                List<CardState> tmpList = StoreProvider.of<AppState>(context).state.cardListState.cardList;
                                tmpList.forEach((element) {
                                  if(element.stripeState.stripeCard.last4 == widget.cardState.stripeState.stripeCard.last4){
                                    element.selected = !element.selected;
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      !widget.cardState.selected ? Icons.add : MaterialDesignIcons.done,
                                      color: !widget.cardState.selected ? BuytimeTheme.TextGrey : BuytimeTheme.ActionButton,
                                    ),
                                    Text(
                                      !widget.cardState.selected ? AppLocalizations.of(context).select : AppLocalizations.of(context).selected,
                                      style: TextStyle(
                                          letterSpacing: 0.2,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: !widget.cardState.selected ? BuytimeTheme.TextGrey : BuytimeTheme.ActionButton,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}

