import 'package:json_annotation/json_annotation.dart';
part 'device.g.dart';

@JsonSerializable(explicitToJson: true)
class Device {
  String id;
  String name;
  String user_uid;

  Device({
    this.id,
    this.name,
    this.user_uid,
  });

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
