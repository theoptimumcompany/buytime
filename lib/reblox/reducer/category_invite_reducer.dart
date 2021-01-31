import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';


class CategoryInviteRequest {
  String _id;
  CategoryInviteRequest(this._id);
  String get id => _id;
}

class CategoryInviteRequestResponse {
  CategoryInviteState _categoryInviteState;

  CategoryInviteRequestResponse(this._categoryInviteState);

  CategoryInviteState get categoryInviteState => _categoryInviteState;
}

class UnlistenCategoryInvite {}

class SetCategoryInviteToEmpty {
  CategoryInviteState _categoryInviteState;

  SetCategoryInviteToEmpty();

  CategoryInviteState get categoryInviteState => _categoryInviteState;
}


class CreateCategoryInvite {
  CategoryInviteState _categoryInviteState;

  CreateCategoryInvite(this._categoryInviteState);

  CategoryInviteState get categoryInviteState => _categoryInviteState;
}

class CreatedCategoryInvite {
  CategoryInviteState _categoryInviteState;

  CreatedCategoryInvite(this._categoryInviteState);

  CategoryInviteState get categoryInviteState => _categoryInviteState;
}

class DeleteCategoryInvite {
  String _id;

  DeleteCategoryInvite(this._id);

  String get id => _id;
}

class DeletedCategoryInvite {
  String _id;

  DeletedCategoryInvite(this._id);

  String get id => _id;
}



class SetCategoryInviteMail {
  String _mail;

  SetCategoryInviteMail(this._mail);

  String get mail => _mail;
}

CategoryInviteState categoryInviteReducer(CategoryInviteState state, action) {
  CategoryInviteState categoryInviteState = new CategoryInviteState.fromState(state);
  if (action is SetCategoryInviteMail) {
    categoryInviteState.mail = action.mail;
    return categoryInviteState;
  }

  if (action is CreateCategoryInvite) {
    categoryInviteState = action.categoryInviteState.copyWith();
    return categoryInviteState;
  }
  if (action is CreatedCategoryInvite) {
    categoryInviteState = action.categoryInviteState.copyWith();
    return categoryInviteState;
  }
  if (action is CategoryInviteRequestResponse) {
    categoryInviteState = action.categoryInviteState;
    return categoryInviteState;
  }
  if (action is SetCategoryInviteToEmpty) {
    categoryInviteState = CategoryInviteState().toEmpty();
    return categoryInviteState;
  }
  return state;
}
