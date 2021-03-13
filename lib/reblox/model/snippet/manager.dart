import 'package:json_annotation/json_annotation.dart';
part 'manager.g.dart';

@JsonSerializable(explicitToJson: true)
class Manager {
  String id;
  String mail;
  String name;
  String surname;

  Manager({
    this.id,
    this.mail,
    this.name,
    this.surname,
  });

  factory Manager.fromJson(Map<String, dynamic> json) => _$ManagerFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerToJson(this);
}
