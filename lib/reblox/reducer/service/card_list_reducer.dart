import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';


class AddCardToList{
  List<CardState> _cardList;
  AddCardToList(this._cardList);
  List<CardState> get cardList => _cardList;
}

class DeleteStripePaymentMethodLocally{
  String _paymentMethodId;
  DeleteStripePaymentMethodLocally(this._paymentMethodId);
  String get paymentMethodId => _paymentMethodId;
}

CardListState cardListReducer(CardListState state, action) {
  CardListState cardListState = new CardListState.fromState(state);

  if (action is AddCardToList) {
    cardListState.cardList = action.cardList;
    if (cardListState != null && cardListState.cardList != null) {
      debugPrint('card_list_reducer: LENGTH: ${cardListState.cardList.length}');
    }
    return cardListState;
  }
  if (action is DeleteStripePaymentMethodLocally) {
    if (cardListState.cardList != null) {
      for (int i = 0; i < cardListState.cardList.length; i++) {
        if (cardListState.cardList[i].cardId == action.paymentMethodId){
          cardListState.cardList.removeAt(i);
          debugPrint('card_list_reducer: removed locally: ${action.paymentMethodId}');
        }
      }
    }
    if (cardListState != null && cardListState.cardList != null) {
    }
    return cardListState;
  }

  return state;
}
