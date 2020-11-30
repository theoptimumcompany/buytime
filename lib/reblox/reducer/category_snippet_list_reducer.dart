import 'package:BuyTime/reblox/model/category/category_snippet_list_state.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';

class RequestListCategorySnippet {
  String _userId;
  RequestListCategorySnippet(this._userId);
  String get userId => _userId;
}
class CategorySnippetListReturned {
  Map<String,CategorySnippet> _categorySnippetListState;
  CategorySnippetListReturned(this._categorySnippetListState);
  Map<String,CategorySnippet> get categorySnippetListState => _categorySnippetListState;
}

class SetCategorySnippetListToEmpty {
  String _something;
  SetCategorySnippetListToEmpty();
  String get something => _something;
}

CategorySnippetListState categorySnippetListReducer(CategorySnippetListState state, action) {
  CategorySnippetListState categorySnippetListState = new CategorySnippetListState.fromState(state);
  if (action is SetCategorySnippetListToEmpty) {
    categorySnippetListState = CategorySnippetListState().toEmpty();
    return categorySnippetListState;
  }
  if (action is CategorySnippetListReturned) {
    categorySnippetListState = CategorySnippetListState(categorySnippetListState: action.categorySnippetListState).copyWith();
    print("CategorySnippetList's Reducer");
    return categorySnippetListState;
  }
  return state;
}