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