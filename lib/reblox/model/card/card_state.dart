import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';

class CardState {
  String cardId;
  String cardOwner;
  StripeCardResponse cardResponse;
  bool selected;

  List<dynamic> convertToJson(List<UserSnippet> objectStateList) {
    List<dynamic> list = [];
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

  CardState({
    this.cardId,
    this.cardOwner,
    this.cardResponse,
    this.selected
  });

  CardState toEmpty() {
    return CardState(
      cardId: "",
      cardOwner: "",
      cardResponse: StripeCardResponse(),
      selected: false,
    );
  }


  CardState.fromState(CardState state) {
    this.cardId = state.cardId;
    this.cardOwner = state.cardOwner;
    this.cardResponse = state.cardResponse;
    this.selected = state.selected;
  }

  companyStateFieldUpdate(
    String cardId,
    String cardOwner,
    StripeCardResponse cardResponse,
    bool selected,
  ) {
    CardState(
      cardId: cardId ?? this.cardId,
      cardOwner: cardOwner ?? this.cardOwner,
      cardResponse: cardResponse ?? this.cardResponse,
      selected: selected ?? this.selected,
    );
  }

  CardState copyWith({
    String cardId,
    String cardOwner,
    StripeCardResponse cardResponse,
    bool selected,
  }) {
    return CardState(
      cardId: cardId ?? this.cardId,
      cardOwner: cardOwner ?? this.cardOwner,
      cardResponse: cardResponse ?? this.cardResponse,
      selected: selected ?? this.selected,
    );
  }

  CardState.fromJson(Map<String, dynamic> json)
      : cardId = json['cardId'],
        cardOwner = json['cardOwner'],
        cardResponse = json['cardResponse'],
        selected = json['selected'];

  Map<String, dynamic> toJson() => {
        'cardId': cardId,
        'cardOwner': cardOwner,
        'cardResponse': cardResponse,
        'selected': selected,
      };
}
