import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'order_entry.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderEntry {
  int number;
  String name;
  String description;
  double price;
  String thumbnail;
  String id;
  String id_business;
  String id_owner;
  ///Reserve
  String time;
  String minutes;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime date;

  OrderEntry({
    this.number = 0,
    this.name,
    this.description,
    this.price,
    this.thumbnail,
    this.id,
    this.id_business,
    this.id_owner,
    this.time,
    this.minutes,
    this.date,
  });

  factory OrderEntry.fromJson(Map<String, dynamic> json) => _$OrderEntryFromJson(json);
  Map<String, dynamic> toJson() => _$OrderEntryToJson(this);
}
