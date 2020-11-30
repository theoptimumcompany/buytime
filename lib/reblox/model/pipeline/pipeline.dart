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

  Pipeline.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };

  Pipeline toEmpty() {
    return Pipeline(
      name: "",
      description: "",
    );
  }
}
