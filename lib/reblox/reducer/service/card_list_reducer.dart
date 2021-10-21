import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';


class AddCardToList{
  List<CardState> _cardList;
  AddCardToList(this._cardList);
  List<CardState> get cardList => _cardList;
}

class DeleteStripePaymentMethodLocally{
  String _firestoreCardId;
  DeleteStripePaymentMethodLocally(this._firestoreCardId);
  String get firestoreCardId => _firestoreCardId;
}

CardListState cardListReducer(CardListState state, action) {
  CardListState cardListState = new CardListState.fromState(state);

  if (action is AddCardToList) {
    cardListState.cardList = action.cardList;
    if (cardListState != null && cardListState.cardList != null) {
      cardListState.cardList.forEach((element) {
        debugPrint('card_list_reducer => added locally: ${element.stripeState.stripeCard.firestore_id}');
      });
    }
    return cardListState;
  }
  if (action is DeleteStripePaymentMethodLocally) {
    CardListState cardListStateTemp;
    if (cardListState.cardList != null) {
      for (int i = 0; i < cardListState.cardList.length; i++) {
        if (cardListState.cardList[i].stripeState.stripeCard.firestore_id == action.firestoreCardId){
          cardListState.cardList.removeAt(i);
          debugPrint('card_list_reducer => removed locally: ${action.firestoreCardId}');
        }
      }
    }
    if (cardListState != null && cardListState.cardList != null) {
      cardListStateTemp = cardListState;
    }
    cardListState.toEmpty();
    return cardListStateTemp;
  }

  return state;
}
