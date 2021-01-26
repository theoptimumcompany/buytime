import 'package:Buytime/reblox/model/pipeline/pipeline.dart';
import 'package:flutter/foundation.dart';

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

  PipelineList.fromJson(Map json) : pipelineList = json['pipelineList'];

  Map<String, dynamic> toJson() => {'pipelineList': pipelineList};

  PipelineList toEmpty() {
    return PipelineList(pipelineList: List<Pipeline>());
  }
}
