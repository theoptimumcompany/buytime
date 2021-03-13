import 'package:json_annotation/json_annotation.dart';
part 'business_type.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessType {
  String id;
  String name;

  BusinessType({
    this.id,
    this.name,
  });

  factory BusinessType.fromJson(Map<String, dynamic> json) => _$BusinessTypeFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessTypeToJson(this);
}
