import 'package:Buytime/reblox/model/pipeline/pipeline.dart';

class PipelineCreatedResponse {
  Pipeline _pipeline;

  PipelineCreatedResponse();

  Pipeline get pipeline => _pipeline;
}

class PipelineRequest {
  Pipeline _pipeline;

  PipelineRequest();

  Pipeline get pipeline => _pipeline;
}

class PipelineRequestResponse {
  Pipeline _pipeline;

  PipelineRequestResponse(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class UnlistenPipeline {}

class UpdatePipeline {
  Pipeline _pipeline;

  UpdatePipeline(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class UpdatedPipeline {
  Pipeline _pipeline;

  UpdatedPipeline(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class CreatePipeline {
  Pipeline _pipeline;

  CreatePipeline(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class CreatedPipeline {
  Pipeline _pipeline;

  CreatedPipeline(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class PipelineChanged {
  Pipeline _pipeline;

  PipelineChanged(this._pipeline);

  Pipeline get pipeline => _pipeline;
}

class SetPipelineName {
  String _name;

  SetPipelineName(this._name);

  String get name => _name;
}

class SetPipelineDescription {
  String _description;

  SetPipelineDescription(this._description);

  String get description => _description;
}

class SetPipelineToEmpty {
  String _something;
  SetPipelineToEmpty();
  String get something => _something;
}

Pipeline pipelineReducer(Pipeline state, action) {
  Pipeline pipeline = new Pipeline.fromState(state);
  if (action is SetPipelineToEmpty) {
    pipeline = Pipeline().toEmpty();
    return pipeline;
  }
  if (action is SetPipelineName) {
    pipeline.name = action.name;
    return pipeline;
  }
  if (action is SetPipelineDescription) {
    pipeline.description = action.description;
    return pipeline;
  }
  if (action is PipelineChanged) {
    pipeline = action.pipeline.copyWith();
    return pipeline;
  }
  if (action is CreatePipeline) {
    /*categoryNode = action.categoryNode.copyWith();
    return categoryNode;*/
  }
  if (action is PipelineRequestResponse) {
    pipeline = action.pipeline.copyWith();
    return pipeline;
  }
  return state;
}
