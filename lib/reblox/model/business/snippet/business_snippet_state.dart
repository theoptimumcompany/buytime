import 'package:json_annotation/json_annotation.dart';
part 'business_snippet_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessSnippet {
  String id;
  String name;
  String thumbnail;

  BusinessSnippet({
    this.id,
    this.name,
    this.thumbnail,
  });

  BusinessSnippet.fromState(BusinessSnippet businessSnippet) {
    this.id = businessSnippet.id;
    this.name = businessSnippet.name;
    this.thumbnail = businessSnippet.thumbnail;
  }

  BusinessSnippet copyWith({
    String id,
    String name,
    String thumbnail,
  }) {
    return BusinessSnippet(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  BusinessSnippet toEmpty() {
    return BusinessSnippet(
      id: '',
      name: '',
      thumbnail: '',
    );
  }

  factory BusinessSnippet.fromJson(Map<String, dynamic> json) => _$BusinessSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessSnippetToJson(this);
}
