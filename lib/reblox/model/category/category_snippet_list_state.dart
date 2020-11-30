import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:flutter/foundation.dart';

class CategorySnippetListState {
  Map<String,CategorySnippet> categorySnippetListState;

  CategorySnippetListState({
    @required this.categorySnippetListState,
  });

  CategorySnippetListState.fromState(CategorySnippetListState state) {
    this.categorySnippetListState = state.categorySnippetListState ;
  }

  CategorySnippetListState copyWith({categorySnippetListState}) {
    return CategorySnippetListState(
        categorySnippetListState: categorySnippetListState ?? this.categorySnippetListState
    );
  }

  CategorySnippetListState.fromJson(Map json)
      : categorySnippetListState = json['categorySnippetListState'];

  Map<String, dynamic> toJson() => {
    'categorySnippetListState': categorySnippetListState
  };

  CategorySnippetListState toEmpty() {
    return CategorySnippetListState(categorySnippetListState: Map<String, CategorySnippet>());
  }

}