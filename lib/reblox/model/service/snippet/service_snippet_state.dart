import 'package:json_annotation/json_annotation.dart';
part 'service_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSnippet {
  String id;
  String name;
  int timesSold;
  String image1;
  String visibility;


  ServiceSnippet({
    this.id,
    this.name,
    this.timesSold,
    this.image1,
    this.visibility,
  });

  ServiceSnippet.fromState(ServiceSnippet serviceSnippet) {
    this.id = serviceSnippet.id;
    this.name = serviceSnippet.name;
    this.timesSold = serviceSnippet.timesSold;
    this.image1 = serviceSnippet.image1;
    this.visibility = serviceSnippet.visibility;
  }

  ServiceSnippet copyWith({
    String id,
    String name,
    int timesSold,
    int image1,
    int visibility,
  }) {
    return ServiceSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      timesSold: timesSold ?? this.timesSold,
      image1: image1 ?? this.image1,
      visibility: visibility ?? this.visibility,
    );
  }

  ServiceSnippet toEmpty() {
    return ServiceSnippet(
      id: '',
      name: '',
      timesSold: 0,
      image1: '',
      visibility: '',
    );
  }

  factory ServiceSnippet.fromJson(Map<String, dynamic> json) => _$ServiceSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceSnippetToJson(this);
}
