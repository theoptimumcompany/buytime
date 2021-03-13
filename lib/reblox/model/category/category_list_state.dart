import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category_list_state.g.dart';


@JsonSerializable(explicitToJson: true)
class CategoryListState {
  List<CategoryState> categoryListState;

  CategoryListState({
    @required this.categoryListState,
  });

  CategoryListState.fromState(CategoryListState state) {
    this.categoryListState = state.categoryListState ;
  }

  CategoryListState copyWith({categoryListState}) {
    return CategoryListState(
      categoryListState: categoryListState ?? this.categoryListState
    );
  }

  factory CategoryListState.fromJson(Map<String, dynamic> json) => _$CategoryListStateFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryListStateToJson(this);

  CategoryListState toEmpty() {
    return CategoryListState(categoryListState: List<CategoryState>());
  }

}