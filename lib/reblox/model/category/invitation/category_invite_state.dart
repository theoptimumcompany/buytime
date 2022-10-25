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

part 'category_invite_state.g.dart';


@JsonSerializable(explicitToJson: true)
class CategoryInviteState {
  String id;
  String id_business;
  String id_category;
  String mail;
  String link;
  String role;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime timestamp;

  CategoryInviteState({
    this.id,
    this.id_business,
    this.id_category,
    this.mail,
    this.link,
    this.role,
    this.timestamp,
  });

  CategoryInviteState toEmpty() {
    return CategoryInviteState(
      id: "",
      id_business: "",
      id_category: "",
      mail: "",
      link: "",
      role: "",
      timestamp: DateTime.now(),
    );
  }

  CategoryInviteState.fromState(CategoryInviteState categoryInvite) {
    this.id = categoryInvite.id;
    this.id_business = categoryInvite.id_business;
    this.id_category = categoryInvite.id_category;
    this.mail = categoryInvite.mail;
    this.link = categoryInvite.link;
    this.role = categoryInvite.role;
    this.timestamp = categoryInvite.timestamp;
  }

  categoryStateFieldUpdate(
      String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp) {
    CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState copyWith(
      {String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp}) {
    return CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory CategoryInviteState.fromJson(Map<String, dynamic> json) => _$CategoryInviteStateFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryInviteStateToJson(this);
}
