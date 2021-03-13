import 'package:json_annotation/json_annotation.dart';
part 'parent.g.dart';

@JsonSerializable(explicitToJson: true)
class Parent {
  String id;
  int level;
  String name;
  String parentRootId;

  Parent({
    this.id = "",
    this.level = 0,
    this.name = "",
    this.parentRootId = "",
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
}
