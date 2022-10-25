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

import 'package:Buytime/UI/management/service_internal/class/service_slot_classes.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'interval_slot_state.g.dart';

@JsonSerializable(explicitToJson: true)
class SquareSlotState {
  //@JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  //DateTime date;
  String date;
  String on;
  String off;
  String uid;
  //double price;
  int free;
  int max;
  //int parallelDelivery;
  @JsonKey(defaultValue: true)
  //bool visibility;

  SquareSlotState({
    this.date,
    this.on,
    this.off,
    this.uid,
    //this.price,
    this.free,
    this.max,
    //this.parallelDelivery,
    //this.visibility,
  });

  SquareSlotState copyWith({
    String date,
    String startTime,
    String stopTime,
    String slotId,
    //double price,
    int availablePlaces,
    int maxAvailablePlace,
    //int parallelDelivery,
    //bool visibility,
  }) {
    return SquareSlotState(
      date: date ?? this.date,
      on: startTime ?? this.on,
      off: stopTime ?? this.off,
      uid: slotId ?? this.uid,
      //price: price ?? this.price,
      free: availablePlaces ?? this.free,
      max: maxAvailablePlace ?? this.max,
      //parallelDelivery: parallelDelivery ?? this.parallelDelivery,
      //visibility: visibility ?? this.visibility,
    );
  }

  SquareSlotState toEmpty() {
    return SquareSlotState(
      date: '',
      on: '',
      off: '',
      uid: '',
      //price: 0.0,
      free: 0,
      max: 0,
      //parallelDelivery: 0,
      //visibility: true,
    );
  }

  SquareSlotState.fromState(SquareSlotState serviceSlot) {
    this.date = serviceSlot.date;
    this.on = serviceSlot.on;
    this.off = serviceSlot.off;
    this.uid = serviceSlot.uid;
    //this.price = serviceSlot.price;
    this.free = serviceSlot.free;
    this.max = serviceSlot.max;
    //this.parallelDelivery = serviceSlot.parallelDelivery;
    //this.visibility = serviceSlot.visibility;
  }


  factory SquareSlotState.fromJson(Map<String, dynamic> json) => _$SquareSlotStateFromJson(json);
  Map<String, dynamic> toJson() => _$SquareSlotStateToJson(this);
}
