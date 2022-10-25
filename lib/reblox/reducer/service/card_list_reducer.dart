/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
