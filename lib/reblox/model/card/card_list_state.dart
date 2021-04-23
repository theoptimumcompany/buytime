import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'card_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class CardListState {
  List<CardState> cardList;

  CardListState({
    @required this.cardList,
  });

  CardListState.fromState(CardListState state) {
    this.cardList = state.cardList ;
  }

  companyStateFieldUpdate(List<CardState> cardListState) {
    CardListState(
        cardList: cardListState ?? this.cardList
    );
  }

  CardListState copyWith({cardListState}) {
    return CardListState(
        cardList: cardListState ?? this.cardList
    );
  }

  factory CardListState.fromJson(Map<String, dynamic> json) => _$CardListStateFromJson(json);
  Map<String, dynamic> toJson() => _$CardListStateToJson(this);

  CardListState toEmpty() {
    return CardListState(cardList: []);
  }

}