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

import 'package:Buytime/reblox/model/stripe/stripe_card_response.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stripe_state.g.dart';

enum PaymentType {
  card,
  native,
  room,
  applePay,
  googlePay,
  onSite,
  noPaymentMethod,
  paypal
}


@JsonSerializable(explicitToJson: true)
class StripeState {
  List<Map<String, dynamic>> paymentMethodList;
  var date;
  var position;
  double total = 0.0;
  StripeCardResponse stripeCard;
  String URL = "";
  String error = "";
  @JsonKey(ignore: true)
  bool stripeCustomerCreated = false;
  @JsonKey(ignore: true)
  String chosenPaymentMethod = Utils.enumToString(PaymentType.noPaymentMethod);


  StripeState({
    this.paymentMethodList,
    this.position,
    this.date,
    this.total,
    this.stripeCard,
    this.URL,
    this.error,
    this.chosenPaymentMethod = "noPaymentMethod",
    this.stripeCustomerCreated = false,
  });

  StripeState.fromState(StripeState state) {
    this.paymentMethodList = state.paymentMethodList;
    this.date = state.date;
    this.position = state.position;
    this.total = state.total;
    this.stripeCard = state.stripeCard;
    this.URL = state.URL;
    this.error = state.error;
    this.chosenPaymentMethod = state.chosenPaymentMethod;
    this.stripeCustomerCreated = state.stripeCustomerCreated;
  }

  StripeState copyWith({
    List<Map<String, dynamic>> paymentMethodList,
    var date,
    var position,
    double total,
    StripeCardResponse stripeCard,
    String URL,
    String error,
    String chosenPaymentMethod,
    String stripeCustomerCreated,
  }) {
    return StripeState(
      paymentMethodList: paymentMethodList ?? this.paymentMethodList,
      date: date ?? this.date,
      position: position ?? this.position,
      total: total ?? this.total,
      stripeCard: stripeCard ?? this.stripeCard,
      URL: URL ?? this.URL,
      error: error ?? this.error,
      chosenPaymentMethod: chosenPaymentMethod ?? this.chosenPaymentMethod,
      stripeCustomerCreated: stripeCustomerCreated ?? this.stripeCustomerCreated,
    );
  }

  StripeState toEmpty() {
    return StripeState(
      position: "",
      date: "",
      paymentMethodList: null,
      total: 0.0,
      stripeCard: StripeCardResponse(),
      URL: "",
      error: "",
      chosenPaymentMethod: "noPaymentMethod",
      stripeCustomerCreated: false,
    );
  }

  factory StripeState.fromJson(Map<String, dynamic> json) => _$StripeStateFromJson(json);
  Map<String, dynamic> toJson() => _$StripeStateToJson(this);
}