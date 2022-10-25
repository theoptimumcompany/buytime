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

import 'package:json_annotation/json_annotation.dart';
part 'pipeline.g.dart';

@JsonSerializable(explicitToJson: true)
class Pipeline {
  String name;
  String description;

  Pipeline({
    this.name,
    this.description,
  });

  Pipeline.fromState(Pipeline pipeline) {
    this.name = pipeline.name;
    this.description = pipeline.description;
  }

  Pipeline copyWith({String name, String description}) {
    return Pipeline(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory Pipeline.fromJson(Map<String, dynamic> json) => _$PipelineFromJson(json);
  Map<String, dynamic> toJson() => _$PipelineToJson(this);

  Pipeline toEmpty() {
    return Pipeline(
      name: "",
      description: "",
    );
  }
}
