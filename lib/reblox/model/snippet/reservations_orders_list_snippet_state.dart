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

import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservations_orders_list_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ReservationsOrdersListSnippetState {
  OrderState order;
  @JsonKey(defaultValue: '')
  String orderId;

  ReservationsOrdersListSnippetState({
    this.order,
    this.orderId,
  });

  ReservationsOrdersListSnippetState.fromState(ReservationsOrdersListSnippetState reservationsOrdersListSnippetState) {
    this.order = reservationsOrdersListSnippetState.order;
    this.orderId = reservationsOrdersListSnippetState.orderId;
  }

  ReservationsOrdersListSnippetState copyWith({
    OrderState order,
    String orderId,
  }) {
    return ReservationsOrdersListSnippetState(
      order: order ?? this.order,
      orderId: orderId ?? this.orderId,
    );
  }

  factory ReservationsOrdersListSnippetState.fromJson(Map<String, dynamic> json) => _$ReservationsOrdersListSnippetStateFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationsOrdersListSnippetStateToJson(this);

  ReservationsOrdersListSnippetState toEmpty() {
    return ReservationsOrdersListSnippetState(
      order: OrderState().toEmpty(),
      orderId: '',
    );
  }
}
