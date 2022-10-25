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

import 'package:json_annotation/json_annotation.dart';
part 'business_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessSnippetState {
  String businessId;
  String businessName;
  String businessImage;
  int serviceTakenNumber;
  int serviceGivenNumber;

  BusinessSnippetState({
    this.businessId,
    this.businessName,
    this.businessImage,
    this.serviceTakenNumber,
    this.serviceGivenNumber,
  });

  BusinessSnippetState.fromState(BusinessSnippetState businessSnippet) {
    this.businessId = businessSnippet.businessId;
    this.businessName = businessSnippet.businessName;
    this.businessImage = businessSnippet.businessImage;
    this.serviceTakenNumber = businessSnippet.serviceTakenNumber;
    this.serviceGivenNumber = businessSnippet.serviceGivenNumber;
  }

  BusinessSnippetState copyWith({
    String businessId,
    String businessName,
    String businessImage,
    int serviceTakenNumber,
    int serviceGivenNumber,
  }) {
    return BusinessSnippetState(
      businessId: businessId ?? this.businessId,
      businessName: businessName ?? this.businessName,
      businessImage: businessImage ?? this.businessImage,
      serviceTakenNumber: serviceTakenNumber ?? this.serviceTakenNumber,
      serviceGivenNumber: serviceGivenNumber ?? this.serviceGivenNumber,
    );
  }

  BusinessSnippetState toEmpty() {
    return BusinessSnippetState(
      businessId: '',
      businessName: '',
      businessImage: '',
      serviceTakenNumber: 0,
      serviceGivenNumber: 0,
    );
  }

  factory BusinessSnippetState.fromJson(Map<String, dynamic> json) => _$BusinessSnippetStateFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessSnippetStateToJson(this);
}
