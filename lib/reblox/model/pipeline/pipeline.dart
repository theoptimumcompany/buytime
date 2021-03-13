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
