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
      debugPrint('stripe_payment_service_epic => LAST4: ${element.stripeCard.last4}');
      map.putIfAbsent(element.stripeCard.last4, () => cardState);
    });
    map.forEach((key, value) {
      cardList.add(value);
    });
  }
  return cardList;
}

Future <List<CardState>> stripeCardListMaker(dynamic event, List<StripeState> stripeStateList, List<CardState> cardList, StripeCardResponse stripeCardResponse) async {
  debugPrint("STRIPE_PAYMENT_SERVICE_EPIC - StripePaymentCardListRequest => USER ID: ${event.firebaseUserId}");
  String userId = event.firebaseUserId;
  QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/card/").limit(10).get();
  QuerySnapshot snapshotToken = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "/token/").limit(10).get();
  bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;
  bool snapshotTokenAvailable = snapshotToken != null && snapshotToken.docs != null && snapshotToken.docs.isNotEmpty;
  if (snapshotTokenAvailable && snapshotCardAvailable) {
    debugPrint('stripe_payment_service_epic => CARD LENGTH: ${snapshotCard.docs.length} TOKEN LENGTH: ${snapshotCard.docs.length}');
    snapshotCard.docs.forEach((element) {
      debugPrint('stripe_payment_service_epic => CARD ID: ${element.id}');
    });
    int counter = 0;
    snapshotToken.docs.forEach((element) {
      var tokenData = element.data();
      if (snapshotCard?.docs != null && snapshotCard.docs.length > counter) {
        var cardFirestoreId = snapshotCard?.docs[counter]?.id;
        stripeStateList.add(StripeState(
            stripeCard: StripeCardResponse(
              firestore_id: cardFirestoreId,
              last4: tokenData['card']['last4'],
              expYear: tokenData['card']['exp_year'],
              expMonth: tokenData['card']['exp_month'],
              brand: tokenData['card']['brand'],
            )));
      }
      counter++;
    });
    return stripeStateToCardState(stripeStateList);
  }
  statisticsComputation();
}
