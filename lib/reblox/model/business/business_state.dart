import 'package:BuyTime/reusable/snippet/generic.dart';
import 'package:BuyTime/utils/theme/buytime_config.dart';
import 'package:flutter/foundation.dart';

import '../file/optimum_file_to_upload.dart';

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
  String wide_card_photo;
  String logo;
  List<GenericState> business_type;
  String description;
  String id_firestore;
  GenericState salesman;
  String salesmanId;
  GenericState owner;
  String ownerId;
  bool draft;
  List<OptimumFileToUpload> fileToUploadList;

  List<dynamic> convertToJson(List<GenericState> objectStateList) {
    List<dynamic> list = List<dynamic>();
    objectStateList.forEach((element) {
      list.add(element.toJson());
    });
    return list;
  }

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
    @required this.wide_card_photo,
    @required this.logo,
    @required this.draft,
    @required this.business_type,
    @required this.description,
    @required this.id_firestore,
    this.salesman,
    this.salesmanId,
    this.owner,
    this.ownerId,
    this.fileToUploadList,
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
      wide_card_photo: "",
      logo: "",
      draft: true,
      business_type: [],
      description: "",
      id_firestore: "",
      salesman: GenericState(),
      salesmanId: "",
      owner: GenericState(),
      ownerId: "",
      fileToUploadList: null,
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
    this.wide_card_photo = state.wide_card_photo;
    this.logo = state.logo;
    this.business_type = state.business_type;
    this.description = state.description;
    this.id_firestore = state.id_firestore;
    this.salesman = state.salesman;
    this.salesmanId = state.salesmanId;
    this.owner = state.owner;
    this.ownerId = state.ownerId;
    this.draft = state.draft;
    this.fileToUploadList = state.fileToUploadList;
  }

  companyStateFieldUpdate(
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
    String wide_card_photo,
    String logo,
    List<GenericState> business_type,
    String description,
    String id_firestore,
    GenericState salesman,
    String salesmanId,
    GenericState owner,
    String ownerId,
    bool draft,
    List<OptimumFileToUpload> fileToUploadList,
  ) {
    BusinessState(
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
      wide_card_photo: wide_card_photo ?? this.wide_card_photo,
      logo: logo ?? this.logo,
      business_type: business_type ?? this.business_type,
      description: description ?? this.description,
      id_firestore: id_firestore ?? this.id_firestore,
      salesman: salesman ?? this.salesman,
      salesmanId: salesmanId ?? this.salesmanId,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      draft: draft ?? this.draft,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
    );
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
    String wide_card_photo,
    String logo,
    List<GenericState> business_type,
    String description,
    String id_firestore,
    GenericState salesaman,
    String salesmanId,
    GenericState owner,
    String ownerId,
    bool draft,
    List<OptimumFileToUpload> fileToUploadList,
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
      wide_card_photo: wide_card_photo ?? this.wide_card_photo,
      logo: logo ?? this.logo,
      business_type: business_type ?? this.business_type,
      description: description ?? this.description,
      id_firestore: id_firestore ?? this.id_firestore,
      salesman: salesman ?? this.salesman,
      salesmanId: salesmanId ?? this.salesmanId,
      owner: owner ?? this.owner,
      ownerId: ownerId ?? this.ownerId,
      draft: draft ?? this.draft,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
    );
  }

  BusinessState.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        responsible_person_name = json['responsible_person_name'],
        responsible_person_surname = json['responsible_person_surname'],
        responsible_person_email = json['responsible_person_email'],
        phone_number = json['phone_number'] ?? BuytimeConfig.FlaviosNumber,
        email = json['email'],
        VAT = json['VAT'],
        street = json['street'],
        municipality = json['municipality'],
        street_number = json['street_number'],
        ZIP = json['ZIP'],
        state_province = json['state_province'],
        nation = json['nation'],
        coordinate = json['coordinate'],
        profile = json['profile'],
        gallery = List<String>.from(json['gallery']),
        wide_card_photo = json['wide_card_photo'],
        logo = json['logo'],
        business_type = List<GenericState>.from(json["business_type"].map((item) {
          return new GenericState(
            name: item["name"] != null ? item["name"] : "",
            id: item["id"] != null ? item["id"] : "",
            // name: item["name"],
            // id: item["id"],
          );
        })),
        description = json['description'],
        id_firestore = json['id_firestore'],
        salesman = GenericState.fromJson(json["salesman"]) ?? GenericState.fromJson(json["salesman"]),
        salesmanId = json['salesmanId'],
        draft = json['draft'],
        owner = GenericState.fromJson(json["owner"]),
        ownerId = json['ownerId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'responsible_person_name': responsible_person_name,
        'responsible_person_surname': responsible_person_surname,
        'responsible_person_email': responsible_person_email,
        'phone_number': phone_number,
        'email': email,
        'VAT': VAT,
        'street': street,
        'municipality': municipality,
        'street_number': street_number,
        'ZIP': ZIP,
        'state_province': state_province,
        'nation': nation,
        'coordinate': coordinate,
        'profile': profile,
        'gallery': gallery,
        'wide_card_photo': wide_card_photo,
        'logo': logo,
        'business_type': convertToJson(business_type),
        'description': description,
        'id_firestore': id_firestore,
        'salesman': salesman.toJson(),
        'salesmanId': salesmanId,
        'owner': owner.toJson(),
        'ownerId': ownerId,
        'draft': draft,
      };
}
