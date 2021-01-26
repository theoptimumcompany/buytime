
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';

class BusinessListRequest {
  String _userId;
  Role _role;
  BusinessListRequest(this._userId, this._role);
  String get userId => _userId;
  Role get role => _role;
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
    print("Nel reducer business List");
    return businessListState;
  }
  return state;
}