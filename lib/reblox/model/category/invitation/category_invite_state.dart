import 'package:Buytime/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'category_invite_state.g.dart';


@JsonSerializable(explicitToJson: true)
class CategoryInviteState {
  String id;
  String id_business;
  String id_category;
  String mail;
  String link;
  String role;
  @JsonKey(fromJson: Utils.getDate, toJson: Utils.setDate)
  DateTime timestamp;

  CategoryInviteState({
    this.id,
    this.id_business,
    this.id_category,
    this.mail,
    this.link,
    this.role,
    this.timestamp,
  });

  CategoryInviteState toEmpty() {
    return CategoryInviteState(
      id: "",
      id_business: "",
      id_category: "",
      mail: "",
      link: "",
      role: "",
      timestamp: DateTime.now(),
    );
  }

  CategoryInviteState.fromState(CategoryInviteState categoryInvite) {
    this.id = categoryInvite.id;
    this.id_business = categoryInvite.id_business;
    this.id_category = categoryInvite.id_category;
    this.mail = categoryInvite.mail;
    this.link = categoryInvite.link;
    this.role = categoryInvite.role;
    this.timestamp = categoryInvite.timestamp;
  }

  categoryStateFieldUpdate(
      String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp) {
    CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  CategoryInviteState copyWith(
      {String id, String id_business, String id_category, String mail, String link, String role, DateTime timestamp}) {
    return CategoryInviteState(
      id: id ?? this.id,
      id_business: id_business ?? this.id_business,
      id_category: id_category ?? this.id_category,
      mail: mail ?? this.mail,
      link: link ?? this.link,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory CategoryInviteState.fromJson(Map<String, dynamic> json) => _$CategoryInviteStateFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryInviteStateToJson(this);
}
