import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/foundation.dart';


class CardListState {
  List<CardState> cardListState;

  CardListState({
    @required this.cardListState,
  });

  CardListState.fromState(CardListState state) {
    this.cardListState = state.cardListState ;
  }

  companyStateFieldUpdate(List<CardState> cardListState) {
    CardListState(
        cardListState: cardListState ?? this.cardListState
    );
  }

  CardListState copyWith({cardListState}) {
    return CardListState(
        cardListState: cardListState ?? this.cardListState
    );
  }

  CardListState.fromJson(Map json)
      : cardListState = json['cardListState'];

  Map<String, dynamic> toJson() => {
    'cardListState': cardListState
  };

  CardListState toEmpty() {
    return CardListState(cardListState: []);
  }

}