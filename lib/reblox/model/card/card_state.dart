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

import 'dart:convert';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_annotation/json_annotation.dart';
part 'card_state.g.dart';

@JsonSerializable(explicitToJson: true)
class CardState {

  ///Storage
  final storage = new FlutterSecureStorage();

  String cardId;
  String cardOwner;
  StripeState stripeState;
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
    this.stripeState,
    this.selected
  });

  CardState toEmpty() {
    return CardState(
      cardId: "",
      cardOwner: "",
      stripeState: StripeState(),
      selected: false,
    );
  }


  CardState.fromState(CardState state) {
    this.cardId = state.cardId;
    this.cardOwner = state.cardOwner;
    this.stripeState = state.stripeState;
    this.selected = state.selected;
  }

  companyStateFieldUpdate(
    String cardId,
    String cardOwner,
    StripeState stripeState,
    bool selected,
  ) {
    CardState(
      cardId: cardId ?? this.cardId,
      cardOwner: cardOwner ?? this.cardOwner,
      stripeState: stripeState ?? this.stripeState,
      selected: selected ?? this.selected,
    );
  }

  CardState copyWith({
    String cardId,
    String cardOwner,
    StripeState stripeState,
    bool selected,
  }) {
    return CardState(
      cardId: cardId ?? this.cardId,
      cardOwner: cardOwner ?? this.cardOwner,
      stripeState: stripeState ?? this.stripeState,
      selected: selected ?? this.selected,
    );
  }

  factory CardState.fromJson(Map<String, dynamic> json) => _$CardStateFromJson(json);
  Map<String, dynamic> toJson() => _$CardStateToJson(this);


  writeToStorage(List<CardState> state) async{

    //List<CardState> list = await readFromStorage();
    String append = '';
    state.forEach((element) {
      String read = jsonEncode(element.toJson());
      debugPrint('card_state => JSON: $read');
      append = append.isNotEmpty ? append + '|' + read : read;
    });

    debugPrint('card_state => CCS: $append');
    await storage.write(key: 'ccs', value: append);
  }

  Future<List<CardState>> readFromStorage() async{
    List<CardState> list = [];
    String tmpString = await storage.read(key: 'ccs') ?? '';
    debugPrint('card_state => CARDS: $tmpString');

    if(tmpString.isNotEmpty){
      List<String> cards = tmpString.trim().split('|');
      cards.forEach((element) {
        Map<String, dynamic> map = jsonDecode(element);
        debugPrint('card_state => SECRET TOKEN: ${map['secretToken']}');
        if(element.isNotEmpty){
          CardState state = CardState.fromJson(map);
          list.add(state);
        }
      });
    }

    return list;
  }

}
