/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../file/optimum_file_to_upload.dart';

part 'external_business_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ExternalBusinessState {
  @JsonKey(defaultValue: '')
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
  String salesmanName;
  String phoneSalesman;
  String phoneConcierge;
  String state_province;
  String nation;
  @JsonKey(defaultValue: '')
  String country;
  @JsonKey(defaultValue: '')
  String address;
  @JsonKey(defaultValue: '')
  String addressOptional;
  @JsonKey(defaultValue: '')
  String cityTown;
  @JsonKey(defaultValue: '')
  String stateTerritoryProvince;
  @JsonKey(defaultValue: '')
  String zipPostal;
  String coordinate;
  String profile;
  List<String> gallery;
  List<String> hasAccess;
  String wide;
  String logo;
  String business_type;
  String description;
  String id_firestore;
  GenericState salesman;
  String salesmanId;
  String stripeCustomerId;
  GenericState owner;
  String ownerId;
  bool draft;
  @JsonKey(ignore: true)
  List<OptimumFileToUpload> fileToUploadList;
  List<String> tag;
  List<String> area;
  @JsonKey(defaultValue: false)
  bool hub;
  String businessAddress;
  UserSnippet contentCreator;

  ExternalBusinessState(
      {@required this.name,
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
      @required this.salesmanName,
      @required this.phoneSalesman,
      @required this.phoneConcierge,
      @required this.state_province,
      @required this.nation,
      @required this.country,
      @required this.address,
      @required this.addressOptional,
      @required this.cityTown,
      @required this.stateTerritoryProvince,
      @required this.zipPostal,
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
      this.businessAddress,
      this.contentCreator});

  ExternalBusinessState toEmpty() {
    return ExternalBusinessState(
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
        salesmanName: "",
        phoneSalesman: "",
        phoneConcierge: "",
        state_province: "",
        nation: "",
        country: "",
        address: "",
        addressOptional: "",
        cityTown: "",
        stateTerritoryProvince: "",
        zipPostal: "",
        coordinate: "",
        municipality: "",
        profile: "",
        gallery: [""],
        hasAccess: [""],
        wide: "",
        logo: "",
        draft: true,
        business_type: '',
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
        businessAddress: '',
        contentCreator: UserSnippet().toEmpty());
  }

  ExternalBusinessState.fromState(ExternalBusinessState state) {
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
    this.salesmanName = state.salesmanName;
    this.phoneSalesman = state.phoneSalesman;
    this.phoneConcierge = state.phoneConcierge;
    this.state_province = state.state_province;
    this.nation = state.nation;
    this.country = state.country;
    this.address = state.address;
    this.addressOptional = state.addressOptional;
    this.cityTown = state.cityTown;
    this.stateTerritoryProvince = state.stateTerritoryProvince;
    this.zipPostal = state.zipPostal;
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
    this.contentCreator = state.contentCreator;
  }

  ExternalBusinessState copyWith(
      {String name,
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
      String salesmanName,
      String phoneSalesman,
      String phoneConcierge,
      String state_province,
      String nation,
      String country,
      String address,
      String addressOptional,
      String cityTown,
      String stateTerritoryProvince,
      String zipPostal,
      String coordinate,
      String profile,
      List<String> gallery,
      List<String> hasAccess,
      String wide,
      String logo,
      String business_type,
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
      String businessAddress,
      UserSnippet contentCreator}) {
    return ExternalBusinessState(
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
      salesmanName: salesmanName ?? this.salesmanName,
      phoneSalesman: phoneSalesman ?? this.phoneSalesman,
      phoneConcierge: phoneConcierge ?? this.phoneConcierge,
      state_province: state_province ?? this.state_province,
      nation: nation ?? this.nation,
      country: country ?? this.country,
      address: address ?? this.address,
      addressOptional: addressOptional ?? this.addressOptional,
      cityTown: cityTown ?? this.cityTown,
      stateTerritoryProvince: stateTerritoryProvince ?? this.stateTerritoryProvince,
      zipPostal: zipPostal ?? this.zipPostal,
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
      contentCreator: contentCreator ?? this.contentCreator,
    );
  }

  factory ExternalBusinessState.fromJson(Map<String, dynamic> json) => _$ExternalBusinessStateFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalBusinessStateToJson(this);
}
