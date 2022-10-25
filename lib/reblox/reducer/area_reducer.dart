/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/area/area_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reusable/form/w_optimum_form_multi_photo.dart';

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
