import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';

class CategoryRequest {
  String _id;

  CategoryRequest(this._id);

  String get id => _id;
}
class SetCategoryToEmpty {
  CategoryState _categoryState;
  SetCategoryToEmpty();
  CategoryState get categoryState => _categoryState;
}


class CategoryRequestResponse {
  CategoryState _categoryState;

  CategoryRequestResponse(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class UnlistenCategory {}

class UpdateCategory {
  CategoryState _categoryState;

  UpdateCategory(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class UpdatedCategory {
  CategoryState _categoryState;

  UpdatedCategory(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class CreateCategory {
  CategoryState _categoryState;

  CreateCategory(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class CreatedCategory {
  CategoryState _categoryState;

  CreatedCategory(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class DeleteCategory {
  String _idCategory;

  DeleteCategory(this._idCategory);

  String get idCategory => _idCategory;
}

class DeletedCategory {
  String _idCategory;

  DeletedCategory(this._idCategory);

  String get idCategory => _idCategory;
}

class CreatedCategoryFromStore {
  CategoryState categoryState;

  CreatedCategoryFromStore();
}

class CategoryChanged {
  CategoryState _categoryState;

  CategoryChanged(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class SetCategoryName {
  String _name;

  SetCategoryName(this._name);

  String get name => _name;
}

class SetCategoryId {
  String _id;

  SetCategoryId(this._id);

  String get id => _id;
}

class SetCategoryLevel {
  int _level;

  SetCategoryLevel(this._level);

  int get level => _level;
}

class SetCategoryChildren {
  int _children;

  SetCategoryChildren(this._children);

  int get children => _children;
}

class SetCategoryParent {
  ObjectState _parent;

  SetCategoryParent(this._parent);

  ObjectState get parent => _parent;
}

class AddCategoryManager {
  ObjectState _manager;

  AddCategoryManager(this._manager);

  ObjectState get manager => _manager;
}

class SetCategoryBusinessId {
  String _businessId;

  SetCategoryBusinessId(this._businessId);

  String get businessId => _businessId;
}

class AddCategoryNotificationTo {
  List<ObjectState> _notificationTo;

  AddCategoryNotificationTo(this._notificationTo);

  List<ObjectState> get notificationTo => _notificationTo;
}

CategoryState categoryReducer(CategoryState state, action) {
  CategoryState categoryState = new CategoryState.fromState(state);
  if (action is SetCategoryName) {
    categoryState.name = action.name;
    return categoryState;
  }
  if (action is SetCategoryId) {
    categoryState.id = action.id;
    return categoryState;
  }
  if (action is SetCategoryLevel) {
    categoryState.level = action.level;
    return categoryState;
  }
  if (action is SetCategoryChildren) {
    categoryState.children = action.children;
    return categoryState;
  }
  if (action is SetCategoryParent) {
    categoryState.parent = action.parent;
    return categoryState;
  }
  if (action is AddCategoryManager) {
    categoryState.manager.add(action.manager);
    return categoryState;
  }
  if (action is SetCategoryBusinessId) {
    categoryState.businessId = action.businessId;
    print(categoryState.businessId);
    return categoryState;
  }
  if (action is AddCategoryNotificationTo) {
    categoryState.notificationTo = action.notificationTo;
    return categoryState;
  }
  if (action is CategoryChanged) {
    categoryState = action.categoryState.copyWith();
    return categoryState;
  }
  if (action is CreateCategory) {
    categoryState = action.categoryState.copyWith();
    return categoryState;
  }
  if (action is CreatedCategory) {
    categoryState = action.categoryState.copyWith();
    return categoryState;
  }
  if (action is CategoryRequestResponse) {
    categoryState = action.categoryState;
    print("Nel reducer CategoryState");
    return categoryState;
  }
  if (action is SetCategoryToEmpty) {
    categoryState = CategoryState().toEmpty();
    return categoryState;
  }

  return state;
}
