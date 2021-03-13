import 'package:json_annotation/json_annotation.dart';
part 'token.g.dart';

@JsonSerializable(explicitToJson: true)
class Token {
  String id;
  String name;
  String user_uid;

  Token({
    this.id,
    this.name,
    this.user_uid,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
