import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/reducer/stripe_list_payment_reducer.dart';
import 'package:Buytime/services/statistic/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<CardState> stripeStateToCardState( List<StripeState> stripeListState) {
  List<CardState> cardList = [];
  Map<String, CardState> map = Map();
  if (stripeListState != null) {
    stripeListState.forEach((element) {
      CardState cardState = CardState().toEmpty();
      cardState.stripeState = element;
      debugPrint('util - stripeStateToCardState => LAST4: ${element.stripeCard.last4}');
      map.putIfAbsent(element.stripeCard.last4, () => cardState);
    });
    map.forEach((key, value) {
      cardList.add(value);
    });
  }
  return cardList;
}

Future <List<CardState>> stripeCardListMaker(dynamic event, List<StripeState> stripeStateList, List<CardState> cardList, StripeCardResponse stripeCardResponse) async {
  debugPrint("util - stripeCardListMaker => StripePaymentCardListRequest => USER ID: ${event.firebaseUserId}");
  String userId = event.firebaseUserId;
  QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/card/").limit(10).get();
  QuerySnapshot snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/token/").limit(10).get();
  bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;
  bool snapshotTokenAvailable = snapshotToken != null && snapshotToken.docs != null && snapshotToken.docs.isNotEmpty;
  if (snapshotTokenAvailable && snapshotCardAvailable) {
    debugPrint('util - stripeCardListMaker => CARD LENGTH: ${snapshotCard.docs.length} TOKEN LENGTH: ${snapshotCard.docs.length}');
    snapshotCard.docs.forEach((element) {
      debugPrint('util - stripeCardListMaker => CARD ID: ${element.id}');
    });
    int counter = 0;
    snapshotToken.docs.forEach((elementToken) {
      var tokenData = elementToken.data();
      if (snapshotCard?.docs != null && snapshotCard.docs.length > counter) {
        snapshotCard.docs.forEach((elementCard) {
          var cardData = elementCard.data();
          if ( cardData['payment_method'] == tokenData['id']) {
            stripeStateList.add(StripeState(
                stripeCard: StripeCardResponse(
                  firestore_id: elementCard.id,
                  last4: tokenData['card']['last4'],
                  expYear: tokenData['card']['exp_year'],
                  expMonth: tokenData['card']['exp_month'],
                  brand: tokenData['card']['brand'],
                  paymentMethodId: tokenData['id']
                )));
          }
        });
      }
      counter++;
    });
    return stripeStateToCardState(stripeStateList);
  }
  statisticsComputation();
}
