import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pipeline_list_state.g.dart';

@JsonSerializable(explicitToJson: true)
class PipelineList {
  List<Pipeline> pipelineList;

  PipelineList({
    @required this.pipelineList,
  });

  PipelineList.fromState(PipelineList state) {
    this.pipelineList = state.pipelineList;
  }

  companyStateFieldUpdate(List<Pipeline> pipelineList) {
    PipelineList(pipelineList: pipelineList ?? this.pipelineList);
  }

  PipelineList copyWith({pipelineList}) {
    return PipelineList(pipelineList: pipelineList ?? this.pipelineList);
  }

  factory PipelineList.fromJson(Map<String, dynamic> json) => _$PipelineListFromJson(json);
  Map<String, dynamic> toJson() => _$PipelineListToJson(this);

  PipelineList toEmpty() {
    return PipelineList(pipelineList: List<Pipeline>());
  }
}
