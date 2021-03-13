import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'card_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory CardListState.fromJson(Map<String, dynamic> json) => _$CardListStateFromJson(json);
  Map<String, dynamic> toJson() => _$CardListStateToJson(this);

  CardListState toEmpty() {
    return CardListState(cardListState: []);
  }

}