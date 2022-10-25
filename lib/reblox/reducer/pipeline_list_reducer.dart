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

import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';

class RequestListPipeline {
  Pipeline _pipeline;
  RequestListPipeline();
  Pipeline get pipeline => _pipeline;
}
class PipelineListReturned {
  List<Pipeline> _pipelineList;
  PipelineListReturned(this._pipelineList);
  List<Pipeline> get pipelineList => _pipelineList;
}

class SetPipelineListToEmpty {
  String _something;
  SetPipelineListToEmpty();
  String get something => _something;
}

PipelineList pipelineListReducer(PipelineList state, action) {
  PipelineList pipelineList = new PipelineList.fromState(state);
  if (action is SetPipelineListToEmpty) {
    pipelineList = PipelineList().toEmpty();
    return pipelineList;
  }
  if (action is PipelineListReturned) {
    pipelineList = PipelineList(pipelineList: action.pipelineList).copyWith();
    return pipelineList;
  }
  return state;
}