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

import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'order_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderEntry {
  int number;
  String name;
  String description;
  double price;
  String thumbnail;
  String id; //TODO: Change name into id_service
  String id_business;
  String id_owner;
  String id_category;
  ///Reserve
  String time;  ///time NULL -> No Reservable
  String minutes;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date;
  @JsonKey(defaultValue: false)
  bool switchAutoConfirm = false;
  @JsonKey(defaultValue: '')
  String idSquareSlot;
  int orderCapacity;

  @JsonKey(defaultValue: 22)
  int vat;

  OrderEntry({
    this.number = 0,
    this.name,
    this.description,
    this.price,
    this.thumbnail,
    this.id,
    this.id_business,
    this.id_owner,
    this.id_category,
    this.time,
    this.minutes,
    this.date,
    this.switchAutoConfirm,
    this.idSquareSlot,
    this.orderCapacity,
    this.vat,
  });

  factory OrderEntry.fromJson(Map<String, dynamic> json) => _$OrderEntryFromJson(json);
  Map<String, dynamic> toJson() => _$OrderEntryToJson(this);
}
