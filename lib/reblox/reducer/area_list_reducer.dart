import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/area/area_state.dart';

class SetAreaList {
  AreaListState _areaListState;
  SetAreaList(this._areaListState);
  AreaListState get areaLisState => _areaListState;
}
class AreaListRequest {}

AreaListState areaListReducer(AreaListState state, action) {
  AreaListState areaListState = new AreaListState.fromState(state);
  if (action is SetAreaList) {
    areaListState = action.areaLisState;
    return areaListState;
  }
  return state;
}
