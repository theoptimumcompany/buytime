import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:flutter/foundation.dart';

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

  CategoryListState.fromJson(Map json)
      : categoryListState = json['categoryListState'];

  Map<String, dynamic> toJson() => {
    'categoryListState': categoryListState
  };

  CategoryListState toEmpty() {
    return CategoryListState(categoryListState: List<CategoryState>());
  }

}