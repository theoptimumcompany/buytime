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