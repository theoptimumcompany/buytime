import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:flutter/material.dart';

class CategoryRequest {
  String _id;

  CategoryRequest(this._id);

  String get id => _id;
}

class CategoryInviteManager {
  Manager _manager;

  CategoryInviteManager(this._manager);

  Manager get manager => _manager;
}

class CategoryInviteWorker {
  Worker _worker;

  CategoryInviteWorker(this._worker);

  Worker get worker => _worker;
}

class CategoryRequestResponse {
  CategoryState _categoryState;

  CategoryRequestResponse(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class CategoryInviteManagerResponse {
  CategoryState _categoryState;

  CategoryInviteManagerResponse(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class CategoryInviteWorkerResponse {
  CategoryState _categoryState;

  CategoryInviteWorkerResponse(this._categoryState);

  CategoryState get categoryState => _categoryState;
}

class AddFileToUploadInCategory {
  OptimumFileToUpload _fileToUpload;
  ImageState state;
  int index;

  AddFileToUploadInCategory(this._fileToUpload, this.state, this.index);

  OptimumFileToUpload get fileToUpload => _fileToUpload;
}

class SetCategoryToEmpty {
  CategoryState _categoryState;

  SetCategoryToEmpty();

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

class CreateDefaultCategory {
  CategoryState _categoryState;
  String _businessId;
  CreateDefaultCategory(this._categoryState, this._businessId);

  CategoryState get categoryState => _categoryState;
  String get businessId => _businessId;
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

class SetCategoryShowcase {
  bool _showcase;

  SetCategoryShowcase(this._showcase);

  bool get showcase => _showcase;
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

class SetCategoryParent {
  Parent _parent;

  SetCategoryParent(this._parent);

  Parent get parent => _parent;
}

class SetCategoryImage {
  String _categoryImage;

  SetCategoryImage(this._categoryImage);

  String get categoryImage => _categoryImage;
}

class SetCustomTag {
  String _customTag;

  SetCustomTag(this._customTag);

  String get customTag => _customTag;
}

class DeleteCategoryManager {
  Manager _manager;

  DeleteCategoryManager(this._manager);

  Manager get manager => _manager;
}

class DeleteCategoryWorker {
  Worker _worker;

  DeleteCategoryWorker(this._worker);

  Worker get worker => _worker;
}

class SetCategoryBusinessId {
  String _businessId;

  SetCategoryBusinessId(this._businessId);

  String get businessId => _businessId;
}

CategoryState categoryReducer(CategoryState state, action) {
  CategoryState categoryState = new CategoryState.fromState(state);
  if (action is SetCategoryName) {
    categoryState.name = action.name;
    return categoryState;
  }
  if (action is SetCategoryShowcase) {
    categoryState.showcase = action.showcase;
    return categoryState;
  }
  if (action is SetCategoryId) {
    categoryState.id = action.id;
    return categoryState;
  }
  if (action is SetCategoryLevel) {
    categoryState.level = action.level;
    debugPrint("category_reducer => Setto livello categoria a " + action.level.toString());
    return categoryState;
  }
  if (action is SetCategoryParent) {
    categoryState.parent = action.parent;
    return categoryState;
  }
  if (action is SetCategoryImage) {
    categoryState.categoryImage = action.categoryImage;
    return categoryState;
  }
  if (action is SetCustomTag) {
    categoryState.customTag = action.customTag;
    return categoryState;
  }
  if (action is CategoryInviteManager) {
    categoryState.manager.add(action.manager);
    return categoryState;
  }
  if (action is DeleteCategoryManager) {
    categoryState.manager.removeWhere((element) => element.mail == action.manager.mail);
    return categoryState;
  }
  if (action is CategoryInviteWorker) {
    categoryState.worker.add(action.worker);
    return categoryState;
  }
  if (action is DeleteCategoryWorker) {
    categoryState.worker.removeWhere((element) => element.mail == action.worker.mail);
    return categoryState;
  }
  if (action is AddFileToUploadInCategory) {
    debugPrint("category_reducer => addFileInCategory. category: " + state.name);

    //categoryState.fileToUpload = null;

    if (state.fileToUpload != null) {
      debugPrint("category_reducer => fileupload != null");

      categoryState.fileToUpload = state.fileToUpload;

    }
    categoryState.fileToUpload = action.fileToUpload;
    debugPrint('category_reducer => cation remoteName: ${action.fileToUpload.remoteName}');
    replaceIfExists(categoryState.fileToUpload, action.fileToUpload);

    debugPrint('category_reducer => remoteName: ${categoryState.fileToUpload.remoteName}');
    debugPrint('category_reducer => remoteFolder: ${categoryState.fileToUpload.remoteFolder}');

    return categoryState;
  }
  if (action is SetCategoryBusinessId) {
    categoryState.businessId = action.businessId;
    debugPrint(categoryState.businessId);
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
    debugPrint('category_reducer => categoryImage: ${categoryState.categoryImage}');
    return categoryState;
  }
  if (action is CategoryRequestResponse) {
    categoryState = action.categoryState;
    return categoryState;
  }
  if (action is CategoryInviteManagerResponse) {
    categoryState = action.categoryState;
    return categoryState;
  }
  if (action is CategoryInviteWorkerResponse) {
    categoryState = action.categoryState;
    return categoryState;
  }
  if (action is SetCategoryToEmpty) {
    categoryState = CategoryState().toEmpty();
    return categoryState;
  }

  return state;
}

void replaceIfExists(OptimumFileToUpload fileToUpload, OptimumFileToUpload myFile){
  fileToUpload = myFile;
}