import 'package:BuyTime/reblox/model/category/tree/category_tree_state.dart';
import 'package:BuyTime/reblox/model/snippet/generic.dart';
import 'package:BuyTime/reblox/model/snippet/parent.dart';

class CategoryTreeCreateIfNotExists {
  String _idFirestore;
  var context;

  CategoryTreeCreateIfNotExists(this._idFirestore, this.context);

  String get idFirestore => _idFirestore;
}

class CategoryTreeCreatedResponse {
  CategoryTree _categoryNode;

  CategoryTreeCreatedResponse();

  CategoryTree get categoryNode => _categoryNode;
}

class CategoryTreeRequest {
  CategoryTree _categoryNode;

  CategoryTreeRequest();

  CategoryTree get categoryNode => _categoryNode;
}

class CategoryTreeRequestResponse {
  CategoryTree _categoryNode;

  CategoryTreeRequestResponse(this._categoryNode);

  CategoryTree get categoryNode => _categoryNode;
}

class UnlistenCategoryTree {}

class UpdateCategoryTree {
  Parent _selectedParent;

  UpdateCategoryTree(this._selectedParent);

  Parent get selectedParent => _selectedParent;
}

class AddCategoryTree {
  Parent _selectedParent;

  AddCategoryTree(this._selectedParent);

  Parent get selectedParent => _selectedParent;
}

class DeleteCategoryTree {
  String _selectedNodeId;

  DeleteCategoryTree(this._selectedNodeId);

  String get selectedNodeId => _selectedNodeId;
}

class AddedCategoryTree {
  String _selectedParent;

  AddedCategoryTree(this._selectedParent);

  String get selectedParent => _selectedParent;
}

class DeletedCategoryTree {
  String _selectedParent;

  DeletedCategoryTree(this._selectedParent);

  String get selectedParent => _selectedParent;
}

class UpdatedCategoryTree {
  CategoryTree _categoryNode;

  UpdatedCategoryTree(this._categoryNode);

  CategoryTree get categoryNode => _categoryNode;
}

class CreateCategoryTree {
  String _idBusiness;

  CreateCategoryTree(this._idBusiness);

  String get idBusiness => _idBusiness;
}

class CreatedCategoryTree {
  CategoryTree _categoryNode;

  CreatedCategoryTree(this._categoryNode);

  CategoryTree get categoryNode => _categoryNode;
}

class CategoryTreeChanged {
  CategoryTree _categoryNode;

  CategoryTreeChanged(this._categoryNode);

  CategoryTree get categoryNode => _categoryNode;
}

class SetCategoryTreeName {
  String _nodeName;

  SetCategoryTreeName(this._nodeName);

  String get nodeName => _nodeName;
}

class SetCategoryTreeId {
  String _nodeId;

  SetCategoryTreeId(this._nodeId);

  String get nodeId => _nodeId;
}

class SetCategoryTreeLevel {
  int _nodeLevel;

  SetCategoryTreeLevel(this._nodeLevel);

  int get nodeLevel => _nodeLevel;
}

class SetCategoryTreeNumberOfCategories {
  int _numberOfCategories;

  SetCategoryTreeNumberOfCategories(this._numberOfCategories);

  int get numberOfCategories => _numberOfCategories;
}

class SetCategoryTreeList {
  List<dynamic> _categoryNodeList;

  SetCategoryTreeList(this._categoryNodeList);

  List<dynamic> get categoryNodeList => _categoryNodeList;
}

class SetCategoryTreeToEmpty {
  String _something;
  SetCategoryTreeToEmpty();
  String get something => _something;
}

CategoryTree categoryTreeReducer(CategoryTree state, action) {
  CategoryTree categoryNode = new CategoryTree.fromState(state);
  if (action is SetCategoryTreeToEmpty) {
    categoryNode = CategoryTree().toEmpty();
    return categoryNode;
  }
  if (action is SetCategoryTreeName) {
    categoryNode.nodeName = action.nodeName;
    return categoryNode;
  }
  if (action is SetCategoryTreeId) {
    categoryNode.nodeId = action.nodeId;
    return categoryNode;
  }
  if (action is SetCategoryTreeLevel) {
    categoryNode.nodeLevel = action.nodeLevel;
    return categoryNode;
  }
  if (action is SetCategoryTreeNumberOfCategories) {
    categoryNode.numberOfCategories = action.numberOfCategories;
    return categoryNode;
  }
  if (action is SetCategoryTreeList) {
    categoryNode.categoryNodeList = action.categoryNodeList;
    return categoryNode;
  }
  if (action is CategoryTreeChanged) {
    categoryNode = action.categoryNode.copyWith();
    return categoryNode;
  }
  if (action is CreateCategoryTree) {
    /*categoryNode = action.categoryNode.copyWith();
    return categoryNode;*/
  }
  if (action is CategoryTreeRequestResponse) {
    categoryNode = action.categoryNode;
    print(categoryNode.nodeName + " nel reducer");
    return categoryNode;
  }

  return state;
}
