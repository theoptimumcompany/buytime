
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:flutter/cupertino.dart';

class BusinessListRequest {
  String _userId;
  Role _role;
  int _limit;
  BusinessListRequest(this._userId, this._role, this._limit);
  String get userId => _userId;
  Role get role => _role;
  int get limit => _limit;
}

class BusinessServiceSnippetListRequest {
  String _businessId;
  BusinessServiceSnippetListRequest(this._businessId);
  String get businessId => _businessId;
}

class BusinessServiceSnippetListReturned {
  List<ServiceSnippetState> _businessServiceSnippetList;
  BusinessServiceSnippetListReturned(this._businessServiceSnippetList);
  List<ServiceSnippetState> get businessServiceSnippetList => _businessServiceSnippetList;
}



class BusinessListReturned {
  List<BusinessState> _businessListState;
  BusinessListReturned(this._businessListState);
  List<BusinessState> get businessListState => _businessListState;
}

class SetBusinessListToEmpty {
  String _something;
  SetBusinessListToEmpty();
  String get something => _something;
}

BusinessListState businessListReducer(BusinessListState state, action) {
  BusinessListState businessListState = new BusinessListState.fromState(state);
  if (action is SetBusinessListToEmpty) {
    businessListState = BusinessListState().toEmpty();
    return businessListState;
  }
  if (action is BusinessListReturned) {
    businessListState = BusinessListState(businessListState: action.businessListState).copyWith();
    debugPrint("business_list_reducer => Nel reducer business List");
    return businessListState;
  }
  return state;
}