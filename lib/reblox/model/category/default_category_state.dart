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

import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_category_state.g.dart';

@JsonSerializable(explicitToJson: true)
class DefaultCategoryState {
  List<String> businessType;
  CategoryState category;

  DefaultCategoryState({
    this.businessType,
    this.category,
  });

  DefaultCategoryState toEmpty() {
    return DefaultCategoryState(
      businessType: [],
      category: CategoryState().toEmpty(),
    );
  }

  DefaultCategoryState.fromState(DefaultCategoryState category) {
    this.businessType = category.businessType;
    this.category = category.category;
  }

  DefaultCategoryState copyWith({
    List<String> businessType,
    CategoryState category,
  }) {
    return DefaultCategoryState(
      businessType: businessType ?? this.businessType,
      category: category ?? this.category,
    );
  }

  factory DefaultCategoryState.fromJson(Map<String, dynamic> json) => _$DefaultCategoryStateFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultCategoryStateToJson(this);
}
