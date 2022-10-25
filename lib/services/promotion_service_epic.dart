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

import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class PromotionListRequestService implements EpicClass<AppState> {
  PromotionState promotionState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("promotion_service_epic => PromotionListRequestService => PromotionList Service CAUGHT ACTION");
    List<PromotionState> promotionStateList = [];
    return actions.whereType<PromotionListRequest>().asyncMap((event) async {
      promotionStateList.clear();

      if (store.state.promotionState.timesUsed == 0) {

        var promotionListQuery = await FirebaseFirestore.instance.collection('promotion').get();

        for(int i = 0; i <  promotionListQuery.docs.length; i++){
          promotionState = PromotionState.fromJson(promotionListQuery.docs[i].data());
          debugPrint('promotion_service_epic => PROMOTION STATE TIMESUSED BEFORE: ${promotionState.timesUsed}');
          promotionState.timesUsed = 0;
          if (store.state.user.uid != null && store.state.user.uid.isNotEmpty) {
            var promotionCounterCollection= await FirebaseFirestore.instance.collection('user').doc(store.state.user.uid).collection('promotionUsage').limit(1).get();
            if (promotionCounterCollection.docs.length > 0) {
              var promotionCounterRef = await FirebaseFirestore.instance.collection('user').doc(store.state.user.uid).collection('promotionUsage').doc('off').get();
              if (promotionCounterRef.exists) {
                var promotionCounterData = promotionCounterRef.data();
                if (promotionCounterData['CxrTzUICSR30XvCBJDpQ'] != null) {
                  promotionState.timesUsed += promotionCounterData['CxrTzUICSR30XvCBJDpQ'];
                }
              }
            }
          }
          if (promotionState.limit > 0) {
            promotionStateList.add(promotionState);
          }
        }
        if (promotionState != null) {
          debugPrint('promotion_service_epic => PROMOTION STATE TIMESUSED AFTER: ${promotionState.timesUsed}');
        }
        if (promotionStateList.isEmpty) promotionStateList.add(PromotionState());
      }

    }).expand((element) => [
          SetPromotion(promotionStateList.isNotEmpty ? promotionStateList.first : []),
          PromotionListReturned(promotionStateList),
        ]);
  }
}

class PromotionRequestService implements EpicClass<AppState> {
  PromotionState promotionState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("promotion_service_epic => PromotionRequestService => Promotion Service CAUGHT ACTION");
    return actions.whereType<PromotionRequest>().asyncMap((event) async {

      var promotionSnapshot = await FirebaseFirestore.instance.collection('promotion').get();

      if (promotionSnapshot.docs.isEmpty) {
        promotionState = PromotionState().toEmpty();
      } else {
        promotionSnapshot.docs.forEach((element) {
          promotionState = PromotionState.fromJson(element.data());
        });
      }

    }).expand((element) => [
          PromotionRequestResponse(promotionState),
        ]);
  }
}
