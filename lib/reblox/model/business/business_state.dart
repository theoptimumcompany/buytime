import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../file/optimum_file_to_upload.dart';
part 'business_state.g.dart';

@JsonSerializable(explicitToJson: true)
class BusinessState {
  String name;
  String responsible_person_name;
  String responsible_person_surname;
  String responsible_person_email;
  String phone_number;
  String email;
  String VAT;
  String street;
  String municipality;
  String street_number;
  String ZIP;
  String state_province;
  String nation;
  String coordinate;
  String profile;
  List<String> gallery;
  List<String> hasAccess;
  String wide;
  String logo;
  List<GenericState> business_type;
  String description;
  String id_firestore;
  GenericState salesman;
  String salesmanId;
  @JsonKey(defaultValue: '')
  String stripeCustomerId;
  GenericState owner;
  String ownerId;
  bool draft;
  @JsonKey(ignore: true)
  List<OptimumFileToUpload> fileToUploadList;
  List<String> tag;
  @JsonKey(defaultValue: [''])
  List<String> area;
  @JsonKey(defaultValue: false)
  bool hub;
  String businessAddress;

  BusinessState({
    @required this.name,
    @required this.responsible_person_name,
    @required this.responsible_person_surname,
    @required this.responsible_person_email,
    @required this.phone_number,
    @required this.email,
    @required this.VAT,
    @required this.street,
    @required this.municipality,
    @required this.street_number,
    @required this.ZIP,
    @required this.state_province,
    @required this.nation,
    @required this.coordinate,
    @required this.profile,
    @required this.gallery,
    this.hasAccess,
    @required this.wide,
    @required this.logo,
    @required this.draft,
    @required this.business_type,
    @required this.description,
    @required this.id_firestore,
    this.salesman,
    this.salesmanId,
    this.stripeCustomerId,
    this.owner,
    this.ownerId,
    this.fileToUploadList,
    this.tag,
    this.area,
    this.hub,
    this.businessAddress
  });

  BusinessState toEmpty() {
    return BusinessState(
      name: "",
      responsible_person_name: "",
      responsible_person_surname: "",
      responsible_person_email: "",
      phone_number: '',
      email: "",
      VAT: "",
      street: "",
      street_number: "",
      ZIP: "",
      state_province: "",
      nation: "",
      coordinate: "",
      municipality: "",
      profile: "",
      gallery: [""],
      hasAccess: [""],
      wide: "",
      logo: "",
      draft: true,
      business_type: [],
      description: "",
      id_firestore: "",
      salesman: GenericState(),
      salesmanId: "",
        stripeCustomerId: "",
      owner: GenericState(),
      ownerId: "",
      fileToUploadList: null,
      tag: [],
      area: [],
      hub: false,
        businessAddress: ''
    );
  }

  BusinessState.fromState(BusinessState state) {
    this.name = state.name;
    this.responsible_person_name = state.responsible_person_name;
    this.responsible_person_surname = state.responsible_person_surname;
    this.responsible_person_email = state.responsible_person_email;
    this.phone_number = state.phone_number;
    this.email = state.email;
    this.VAT = state.VAT;
    this.street = state.street;
    this.municipality = state.municipality;
    this.street_number = state.street_number;
    this.ZIP = state.ZIP;
    this.state_province = state.state_province;
    this.nation = state.nation;
    this.coordinate = state.coordinate;
    this.profile = state.profile;
    this.gallery = state.gallery;
    this.hasAccess = state.hasAccess;
    this.wide = state.wide;
    this.logo = state.logo;
    this.business_type = state.business_type;
    this.description = state.description;
    this.id_firestore = state.id_firestore;
    this.salesman = state.salesman;
    this.salesmanId = state.salesmanId;
    this.stripeCustomerId = state.stripeCustomerId;
    this.owner = state.owner;
    this.ownerId = state.ownerId;
    this.draft = state.draft;
    this.fileToUploadList = state.fileToUploadList;
    this.tag = state.tag;
    this.area = state.area;
    this.hub = state.hub;
    this.businessAddress = state.businessAddress;
  }

  BusinessState.fromExternalState(ExternalBusinessState state) {
    this.name = state.name;
    this.responsible_person_name = state.responsible_person_name;
    this.responsible_person_surname = state.responsible_person_surname;
    this.responsible_person_email = state.responsible_person_email;
    this.phone_number = state.phone_number;
    this.email = state.email;
    this.VAT = state.VAT;
    this.street = state.street;
    this.municipality = state.municipality;
    this.street_number = state.street_number;
    this.ZIP = state.ZIP;
    this.state_province = state.state_province;
    this.nation = state.nation;
    this.coordinate = state.coordinate;
    this.profile = state.profile;
    this.gallery = state.gallery;
    this.hasAccess = state.hasAccess;
    this.wide = state.wide;
    this.logo = state.logo;
    this.business_type = state.business_type;
    this.description = state.description;
    this.id_firestore = state.id_firestore;
    this.salesman = state.salesman;
    this.salesmanId = state.salesmanId;
    this.stripeCustomerId = state.stripeCustomerId;
    this.owner = state.owner;
    this.ownerId = state.ownerId;
    this.draft = state.draft;
    this.fileToUploadList = state.fileToUploadList;
    this.tag = state.tag;
    this.area = state.area;
    this.hub = state.hub;
    this.businessAddress = state.businessAddress;
  }

  BusinessState copyWith({
    String name,
    String responsible_person_name,
    String responsible_person_surname,
    String responsible_person_email,
    String phone_number,
    String email,
    String VAT,
    String street,
    String municipality,
    String street_number,
    String ZIP,
    String state_province,
    String nation,
    String coordinate,
    String profile,
    List<String> gallery,
    List<String> hasAccess,
    String wide,
    String logo,
    List<GenericState> business_type,
    String description,
    String id_firestore,
    GenericState salesaman,
    String salesmanId,
    String stripeCustomerId,
    GenericState owner,
    String ownerId,
    bool draft,
    List<OptimumFileToUpload> fileToUploadList,
    List<String> tag,
    List<String> area,
    bool hub,
    String businessAddress
  }) {
    return BusinessState(
      name: name ?? this.name,
      responsible_person_name: responsible_person_name ?? this.responsible_person_name,
      responsible_person_surname: responsible_person_surname ?? this.responsible_person_surname,
      responsible_person_email: responsible_person_email ?? this.responsible_person_email,
      phone_number: phone_number ?? this.phone_number,
      email: email ?? this.email,
      VAT: VAT ?? this.VAT,
      street: street ?? this.street,
      municipality: municipality ?? this.municipality,
      street_number: street_number ?? this.street_number,
      ZIP: ZIP ?? this.ZIP,
      state_province: state_province ?? this.state_province,
      nation: nation ?? this.nation,
      coordinate: coordinate ?? this.coordinate,
      profile: profile ?? this.profile,
      gallery: gallery ?? this.gallery,
      hasAccess: hasAccess ?? this.hasAccess,
      wide: wide ?? this.wide,
      logo: logo ?? this.logo,
      business_type: business_type ?? this.business_type,
      description: description ?? this.description,
      id_firestore: id_firestore ?? this.id_firestore,
      salesman: salesman ?? this.salesman,
      salesmanId: salesmanId ?? this.salesmanId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      draft: draft ?? this.draft,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
      tag: tag ?? this.tag,
      area: area ?? this.area,
      hub: hub ?? this.hub,
      businessAddress: businessAddress ?? this.businessAddress,
    );
  }

  factory BusinessState.fromJson(Map<String, dynamic> json) => _$BusinessStateFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessStateToJson(this);

}
