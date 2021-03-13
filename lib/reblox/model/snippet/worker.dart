import 'package:json_annotation/json_annotation.dart';
part 'worker.g.dart';

@JsonSerializable(explicitToJson: true)
class Worker {
  String id;
  String mail;
  String name;
  String surname;

  Worker({
    this.id,
    this.mail,
    this.name,
    this.surname,
  });

  factory Worker.fromJson(Map<String, dynamic> json) => _$WorkerFromJson(json);
  Map<String, dynamic> toJson() => _$WorkerToJson(this);
}
