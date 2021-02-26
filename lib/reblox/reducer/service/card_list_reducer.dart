import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_list_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';


class AddCardToList{
  List<CardState> _cardListState;

  AddCardToList(this._cardListState);

  List<CardState> get cardListState => _cardListState;
}


CardListState cardListReducer(CardListState state, action) {
  CardListState cardListState = new CardListState.fromState(state);

  if (action is AddCardToList) {
    cardListState = CardListState(cardListState: action.cardListState).copyWith();
    debugPrint('card_list_reducer: LENGTH: ${cardListState.cardListState.length}');
    return cardListState;
  }

  return state;
}
