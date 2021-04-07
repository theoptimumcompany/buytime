

import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';

class RequestListCategory {
  String _businessId;
  RequestListCategory(this._businessId);
  String get businessId => _businessId;
}
class AllRequestListCategory {
  AllRequestListCategory();
}

class UserRequestListCategory {
  String _businessId;
  UserRequestListCategory(this._businessId);
  String get businessId => _businessId;
}

class RequestRootListCategory {
  String _businessId;
  RequestRootListCategory(this._businessId);
  String get businessId => _businessId;
}

class CategoryListReturned {
  List<CategoryState> _categoryListState;
  CategoryListReturned(this._categoryListState);
  List<CategoryState> get categoryListState => _categoryListState;

}

class SetCategoryListToEmpty {
  String _something;
  SetCategoryListToEmpty();
  String get something => _something;
}

CategoryListState categoryListReducer(CategoryListState state, action) {
  CategoryListState categoryListState = new CategoryListState.fromState(state);
  if (action is SetCategoryListToEmpty) {
    categoryListState = CategoryListState().toEmpty();
    return categoryListState;
  }
  if (action is CategoryListReturned) {
    categoryListState = CategoryListState(categoryListState: action.categoryListState).copyWith();
    return categoryListState;
  }
  return state;
}