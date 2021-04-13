import 'package:json_annotation/json_annotation.dart';
part 'token.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenB {
  String id;
  String name;
  String user_uid;

  TokenB({
    this.id,
    this.name,
    this.user_uid,
  });

  factory TokenB.fromJson(Map<String, dynamic> json) => _$TokenBFromJson(json);
  Map<String, dynamic> toJson() => _$TokenBToJson(this);
}
