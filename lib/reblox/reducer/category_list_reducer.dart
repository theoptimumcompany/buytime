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



import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';

class RequestListCategory {
  String _businessId;
  RequestListCategory(this._businessId);
  String get businessId => _businessId;
}
class AllRequestListCategory {
  String _empty;
  AllRequestListCategory(this._empty);
  String get empty => _empty;
}

class UserRequestListCategory {
  String _businessId;
  UserRequestListCategory(this._businessId);
  String get businessId => _businessId;
}

class UserRequestListByIdsCategory {
  List<String> _categoryIds;
  UserRequestListByIdsCategory(this._categoryIds);
  List<String> get categoryIds => _categoryIds;
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