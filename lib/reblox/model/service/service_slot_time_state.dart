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
import 'package:json_annotation/json_annotation.dart';
part 'service_slot_time_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSlot {
  ///Time Slot Inner Interval vars
  int numberOfInterval = 1;
  List<bool> switchWeek = [];
  List<EveryDay> daysInterval = [];
  @JsonKey(defaultValue: [true])
  List<bool> intervalVisibility = [true];

  ///Time vars
  List<String> startTime = [];
  List<String> stopTime = [];

  ///Calendar vars
  String checkIn = '';
  String checkOut = '';

  ///Length vars
  @JsonKey(defaultValue: 0)
  int hour = 0;
  @JsonKey(defaultValue: 0)
  int minute = 0;
  @JsonKey(defaultValue: 0)
  int day = 0;
  @JsonKey(defaultValue: 1)
  int maxQuantity = 1;
  @JsonKey(defaultValue: 1)
  int limitBooking = 1;
  @JsonKey(defaultValue: false)
  bool noLimitBooking = false;

  ///Price vars
  @JsonKey(defaultValue: 0.0)
  double price = 0.0;


  ServiceSlot({
    this.numberOfInterval,
    this.switchWeek,
    this.daysInterval,
    this.startTime,
    this.stopTime,
    this.checkIn,
    this.checkOut,
    this.hour,
    this.minute,
    this.limitBooking,
    this.noLimitBooking,
    this.price,
    this.maxQuantity,
    this.intervalVisibility,
    this.day,
  });

  ServiceSlot copyWith({
    int numberOfInterval,
    List<bool> switchWeek,
    List<EveryDay> daysInterval,
    List<String> startTime,
    List<String> stopTime,
    String checkIn,
    String checkOut,
    int hour,
    int minute,
    int limitBooking,
    bool noLimitBooking,
    double price,
    int maxQuantity,
    List<bool> intervalVisibility,
    int day,
  }) {
    return ServiceSlot(
      numberOfInterval: numberOfInterval ?? this.numberOfInterval,
      switchWeek: switchWeek ?? this.switchWeek,
      daysInterval: daysInterval ?? this.daysInterval,
      startTime: startTime ?? this.startTime,
      stopTime: stopTime ?? this.stopTime,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      limitBooking: limitBooking ?? this.limitBooking,
      noLimitBooking: noLimitBooking ?? this.noLimitBooking,
      price: price ?? this.price,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      intervalVisibility: intervalVisibility ?? this.intervalVisibility,
      day: day ?? this.day,
    );
  }

  ServiceSlot toEmpty() {
    return ServiceSlot(
      numberOfInterval: 1,
      switchWeek: [true],
      daysInterval: [EveryDay().toEmpty()],
      startTime: [],
      stopTime: [],
      checkIn: '',
      checkOut: '',
      hour: 0,
      minute: 0,
      limitBooking: 1,
      noLimitBooking: false,
      price: 0.0,
      maxQuantity: 1,
      intervalVisibility: [true],
      day: 0,
    );
  }

  ServiceSlot.fromState(ServiceSlot serviceSlot) {
    this.numberOfInterval = serviceSlot.numberOfInterval;
    this.switchWeek = serviceSlot.switchWeek;
    this.daysInterval = serviceSlot.daysInterval;
    this.startTime = serviceSlot.startTime;
    this.stopTime = serviceSlot.stopTime;
    this.checkIn = serviceSlot.checkIn;
    this.checkOut = serviceSlot.checkOut;
    this.hour = serviceSlot.hour;
    this.minute = serviceSlot.minute;
    this.limitBooking = serviceSlot.limitBooking;
    this.noLimitBooking = serviceSlot.noLimitBooking;
    this.price = serviceSlot.price;
    this.maxQuantity = serviceSlot.maxQuantity;
    this.intervalVisibility = serviceSlot.intervalVisibility;
    this.day = serviceSlot.day;
  }


  factory ServiceSlot.fromJson(Map<String, dynamic> json) => _$ServiceSlotFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceSlotToJson(this);
}
