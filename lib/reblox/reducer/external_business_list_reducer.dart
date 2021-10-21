
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_list_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:flutter/cupertino.dart';

class ExternalBusinessListRequest {
  String _userId;
  Role _role;
  ExternalBusinessListRequest(this._userId, this._role);
  String get userId => _userId;
  Role get role => _role;
}

class ExternalBusinessListByIdsRequest {
  List<String> _businessIds;
  ExternalBusinessListByIdsRequest(this._businessIds);
  List<String> get businessIds => _businessIds;
}

class ExternalBusinessServiceSnippetListRequest {
  String _businessId;
  ExternalBusinessServiceSnippetListRequest(this._businessId);
  String get businessId => _businessId;
}

class ExternalBusinessServiceSnippetListReturned {
  List<ServiceSnippetState> _businessServiceSnippetList;
  ExternalBusinessServiceSnippetListReturned(this._businessServiceSnippetList);
  List<ServiceSnippetState> get businessServiceSnippetList => _businessServiceSnippetList;
}



class ExternalBusinessListReturned {
  List<ExternalBusinessState> _businessListState;
  ExternalBusinessListReturned(this._businessListState);
  List<ExternalBusinessState> get businessListState => _businessListState;
}

class SetExternalBusinessListToEmpty {
  String _something;
  SetExternalBusinessListToEmpty();
  String get something => _something;
}

ExternalBusinessListState externalBusinessListReducer(ExternalBusinessListState state, action) {
  ExternalBusinessListState externalBusinessListState = new ExternalBusinessListState.fromState(state);
  if (action is SetExternalBusinessListToEmpty) {
    externalBusinessListState = ExternalBusinessListState().toEmpty();
    return externalBusinessListState;
  }
  if (action is ExternalBusinessListReturned) {
    externalBusinessListState = ExternalBusinessListState(externalBusinessListState: action.businessListState).copyWith();
    debugPrint("Nel reducer business List");
    return externalBusinessListState;
  }
  return state;
}