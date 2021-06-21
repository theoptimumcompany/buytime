import 'package:json_annotation/json_annotation.dart';
part 'parent.g.dart';

@JsonSerializable(explicitToJson: true)
class Parent {
  String id;
  int level;
  String name;

  Parent({
    this.id = "",
    this.level = 0,
    this.name = "",
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
}
