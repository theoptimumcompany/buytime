import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';

class SetArea {
  AreaState _areaState;
  SetArea(this._areaState);
  AreaState get areaState => _areaState;
}

AreaState areaReducer(AreaState state, action) {
  AreaState areaState = state == null ? AreaState().toEmpty() : AreaState.fromState(state);
  if (action is SetArea) {
    areaState = action.areaState;
    return areaState;
  }


  return state;
}
