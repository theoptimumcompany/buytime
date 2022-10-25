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

import 'package:Buytime/reblox/model/card/card_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:http/http.dart' as http;
import 'package:Buytime/helper/statistic/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../environment_abstract.dart';


List<CardState> stripeStateToCardState( List<StripeState> stripeListState) {
  List<CardState> cardList = [];
  Map<String, CardState> map = Map();
  if (stripeListState != null) {
    stripeListState.forEach((element) {
      CardState cardState = CardState().toEmpty();
      cardState.stripeState = element;
      debugPrint('util - stripeStateToCardState => LAST4: ${element.stripeCard.last4}');
      map.putIfAbsent(element.stripeCard.last4, () => cardState);
    });
    map.forEach((key, value) {
      cardList.add(value);
    });
  }
  return cardList;
}

Future <List<CardState>> stripeCardListMaker(dynamic event, List<StripeState> stripeStateList, List<CardState> cardList, StripeCardResponse stripeCardResponse) async {
  debugPrint("util - stripeCardListMaker => StripePaymentCardListRequest => USER ID: ${event.firebaseUserId}");
  String userId = event.firebaseUserId;
  QuerySnapshot snapshotCard = await FirebaseFirestore.instance.collection("stripeCustomer").doc(userId).collection("card").limit(10).get();
  bool snapshotCardAvailable = snapshotCard != null && snapshotCard.docs != null && snapshotCard.docs.isNotEmpty;
  if (snapshotCardAvailable) {
    debugPrint('util - stripeCardListMaker => CARD LENGTH: ${snapshotCard.docs.length} TOKEN LENGTH: ${snapshotCard.docs.length}');
    snapshotCard.docs.forEach((element) {
      debugPrint('util - stripeCardListMaker => CARD ID: ${element.id}');
    });
    if (snapshotCard?.docs != null) {
      snapshotCard.docs.forEach((cardData) {
        stripeStateList.add(StripeState(
            stripeCard: StripeCardResponse(
                firestore_id: cardData.id,
                last4: cardData['last4'],
                expYear: cardData['expYear'],
                expMonth: cardData['expMonth'],
                brand: cardData['brand'],
                paymentMethodId: cardData['paymentMethodId'],
                country: '' // cardData.get('country') ?? ''
            )));
      });
    }
    return stripeStateToCardState(stripeStateList);
  }
  statisticsComputation();
}

Future<Map<String, dynamic>> requestPaymentSheet(String userId, double total) async {
  final url = Uri.https("${Environment().config.cloudFunctionLink}", "/stripePaymentSheet", {'userId': '$userId', 'total': total.toString()});
  final response = await http.get(url);
  print("/// " + response.body + " " + userId + " " + total.toString() + " ////");
  final Map<String, dynamic> bodyResponse = json.decode(response.body);
  if (bodyResponse['error'] != null) {
    throw Exception(bodyResponse['error']);
  }
  return bodyResponse;
}