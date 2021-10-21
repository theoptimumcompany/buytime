import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/material.dart';

class AddCard{
  CardState _cardState;

  AddCard(this._cardState);

  CardState get cardState => _cardState;
}

CardState cardReducer(CardState state, action) {
  CardState cardState = new CardState.fromState(state);
  
  if (action is AddCard) {
    cardState = action.cardState.copyWith();
    debugPrint('card_reducer => ${cardState.cardOwner}');
    return cardState;
  }
  
  return state;
}
