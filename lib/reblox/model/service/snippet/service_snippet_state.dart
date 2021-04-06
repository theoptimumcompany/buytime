import 'package:json_annotation/json_annotation.dart';

part 'service_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSnippet {
  @JsonKey(defaultValue: 0)
  int timesSold;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String visibility;
  @JsonKey(defaultValue: '')
  String connectedBusinessVisibility;
  @JsonKey(defaultValue: '')
  String absolutePath;
  @JsonKey(defaultValue: '')
  String internalPath;

  ServiceSnippet({
    this.timesSold,
    this.name,
    this.image,
    this.visibility,
    this.connectedBusinessVisibility,
    this.absolutePath,
    this.internalPath,
  });

  ServiceSnippet.fromState(ServiceSnippet serviceSnippet) {
    this.timesSold = serviceSnippet.timesSold;
    this.name = serviceSnippet.name;
    this.image = serviceSnippet.image;
    this.visibility = serviceSnippet.visibility;
    this.connectedBusinessVisibility = serviceSnippet.connectedBusinessVisibility;
    this.absolutePath = serviceSnippet.absolutePath;
    this.internalPath = serviceSnippet.internalPath;
  }

  ServiceSnippet copyWith({
    int timesSold,
    String name,
    String image,
    String visibility,
    String connectedBusinessVisibility,
    String absolutePath,
    String internalPath,
  }) {
    return ServiceSnippet(
      timesSold: timesSold ?? this.timesSold,
      name: name ?? this.name,
      image: image ?? this.image,
      visibility: visibility ?? this.visibility,
      connectedBusinessVisibility: connectedBusinessVisibility ?? this.connectedBusinessVisibility,
      absolutePath: absolutePath ?? this.absolutePath,
      internalPath: internalPath ?? this.internalPath,
    );
  }

  ServiceSnippet toEmpty() {
    return ServiceSnippet(
      timesSold: 0,
      name: '',
      image: '',
      visibility: '',
      connectedBusinessVisibility: '',
      absolutePath: '',
      internalPath: '',
    );
  }

  factory ServiceSnippet.fromJson(Map<String, dynamic> json) => _$ServiceSnippetFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSnippetToJson(this);
}
