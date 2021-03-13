import 'package:json_annotation/json_annotation.dart';
part 'generic.g.dart';

@JsonSerializable(explicitToJson: true)
class GenericState {
  String content;
  String id;

  GenericState({
    this.content = "",
    this.id = "",
  });

  factory GenericState.fromJson(Map<String, dynamic> json) => _$GenericStateFromJson(json);
  Map<String, dynamic> toJson() => _$GenericStateToJson(this);
}
