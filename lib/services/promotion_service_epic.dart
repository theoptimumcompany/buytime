import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_list_reducer.dart';
import 'package:Buytime/reblox/reducer/promotion/promotion_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class PromotionListRequestService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("PROMOTION_SERVICE_EPIC - PromotionListRequestService => Promotion ListService CATCHED ACTION");
    List<PromotionState> promotionStateList = [];
    return actions.whereType<PromotionListRequest>().asyncMap((event) async {
      promotionStateList.clear();
      var promotionListQuery = await FirebaseFirestore.instance.collection("promotion").get();

      promotionListQuery.docs.forEach((element) {
        PromotionState promotionState = PromotionState.fromJson(element.data());
        promotionStateList.add(promotionState);
      });

      if (promotionStateList.isEmpty) promotionStateList.add(PromotionState());
    }).expand((element) => [
          PromotionListReturned(promotionStateList),
        ]);
  }
}

class PromotionRequestService implements EpicClass<AppState> {
  PromotionState promotionState;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("PROMOTION_SERVICE_EPIC - PromotionRequestService => Promotion Service CATCHED ACTION");

    return actions.whereType<PromotionRequest>().asyncMap((event) async {
      QuerySnapshot promotionSnapshot = await FirebaseFirestore.instance.collection("promotion").where('serviceId', isEqualTo: 'general_1').get();

      if (promotionSnapshot.docs.isNotEmpty)
        promotionState = PromotionState.fromJson(promotionSnapshot.docs.first.data());
      else {
        promotionState = PromotionState().toEmpty();
      }
    }).expand((element) => [
          PromotionRequestResponse(promotionState),
        ]);
  }
}
