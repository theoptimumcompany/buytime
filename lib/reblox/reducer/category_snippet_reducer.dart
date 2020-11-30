import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';

class CategorySnippetCreateIfNotExists {
  String _idFirestore;
  var context;

  CategorySnippetCreateIfNotExists(this._idFirestore, this.context);

  String get idFirestore => _idFirestore;
}

class CategorySnippetCreatedResponse {
  CategorySnippet _categoryNode;

  CategorySnippetCreatedResponse();

  CategorySnippet get categoryNode => _categoryNode;
}

class CategorySnippetRequest {
  CategorySnippet _categoryNode;

  CategorySnippetRequest();

  CategorySnippet get categoryNode => _categoryNode;
}

class CategorySnippetRequestResponse {
  CategorySnippet _categoryNode;

  CategorySnippetRequestResponse(this._categoryNode);

  CategorySnippet get categoryNode => _categoryNode;
}

class UnlistenCategorySnippet {}

class UpdateCategorySnippet {
  ObjectState _selectedParent;

  UpdateCategorySnippet(this._selectedParent);

  ObjectState get selectedParent => _selectedParent;
}

class AddCategorySnippet {
  ObjectState _selectedParent;

  AddCategorySnippet(this._selectedParent);

  ObjectState get selectedParent => _selectedParent;
}

class DeleteCategorySnippet {
  String _selectedNodeId;

  DeleteCategorySnippet(this._selectedNodeId);

  String get selectedNodeId => _selectedNodeId;
}

class AddedCategorySnippet {
  String _selectedParent;

  AddedCategorySnippet(this._selectedParent);

  String get selectedParent => _selectedParent;
}

class DeletedCategorySnippet {
  String _selectedParent;

  DeletedCategorySnippet(this._selectedParent);

  String get selectedParent => _selectedParent;
}

class UpdatedCategorySnippet {
  CategorySnippet _categoryNode;

  UpdatedCategorySnippet(this._categoryNode);

  CategorySnippet get categoryNode => _categoryNode;
}

class CreateCategorySnippet {
  String _idBusiness;

  CreateCategorySnippet(this._idBusiness);

  String get idBusiness => _idBusiness;
}

class CreatedCategorySnippet {
  CategorySnippet _categoryNode;

  CreatedCategorySnippet(this._categoryNode);

  CategorySnippet get categoryNode => _categoryNode;
}

class CategorySnippetChanged {
  CategorySnippet _categoryNode;

  CategorySnippetChanged(this._categoryNode);

  CategorySnippet get categoryNode => _categoryNode;
}

class SetCategorySnippetName {
  String _nodeName;

  SetCategorySnippetName(this._nodeName);

  String get nodeName => _nodeName;
}

class SetCategorySnippetId {
  String _nodeId;

  SetCategorySnippetId(this._nodeId);

  String get nodeId => _nodeId;
}

class SetCategorySnippetLevel {
  int _nodeLevel;

  SetCategorySnippetLevel(this._nodeLevel);

  int get nodeLevel => _nodeLevel;
}

class SetCategorySnippetNumberOfCategories {
  int _numberOfCategories;

  SetCategorySnippetNumberOfCategories(this._numberOfCategories);

  int get numberOfCategories => _numberOfCategories;
}

class SetCategorySnippetList {
  List<dynamic> _categoryNodeList;

  SetCategorySnippetList(this._categoryNodeList);

  List<dynamic> get categoryNodeList => _categoryNodeList;
}

class SetCategorySnippetToEmpty {
  String _something;
  SetCategorySnippetToEmpty();
  String get something => _something;
}

CategorySnippet categorySnippetReducer(CategorySnippet state, action) {
  CategorySnippet categoryNode = new CategorySnippet.fromState(state);
  if (action is SetCategorySnippetToEmpty) {
    categoryNode = CategorySnippet().toEmpty();
    return categoryNode;
  }
  if (action is SetCategorySnippetName) {
    categoryNode.nodeName = action.nodeName;
    return categoryNode;
  }
  if (action is SetCategorySnippetId) {
    categoryNode.nodeId = action.nodeId;
    return categoryNode;
  }
  if (action is SetCategorySnippetLevel) {
    categoryNode.nodeLevel = action.nodeLevel;
    return categoryNode;
  }
  if (action is SetCategorySnippetNumberOfCategories) {
    categoryNode.numberOfCategories = action.numberOfCategories;
    return categoryNode;
  }
  if (action is SetCategorySnippetList) {
    categoryNode.categoryNodeList = action.categoryNodeList;
    return categoryNode;
  }
  if (action is CategorySnippetChanged) {
    categoryNode = action.categoryNode.copyWith();
    return categoryNode;
  }
  if (action is CreateCategorySnippet) {
    /*categoryNode = action.categoryNode.copyWith();
    return categoryNode;*/
  }
  if (action is CategorySnippetRequestResponse) {
    categoryNode = action.categoryNode;
    print(categoryNode.nodeName + " nel reducer");
    return categoryNode;
  }

  return state;
}
