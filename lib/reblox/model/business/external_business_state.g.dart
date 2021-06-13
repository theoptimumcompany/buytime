// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_business_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalBusinessState _$ExternalBusinessStateFromJson(
    Map<String, dynamic> json) {
  return ExternalBusinessState(
    name: json['name'] as String ?? '',
    responsible_person_name: json['responsible_person_name'] as String,
    responsible_person_surname: json['responsible_person_surname'] as String,
    responsible_person_email: json['responsible_person_email'] as String,
    phone_number: json['phone_number'] as String,
    email: json['email'] as String,
    VAT: json['VAT'] as String,
    street: json['street'] as String,
    municipality: json['municipality'] as String,
    street_number: json['street_number'] as String,
    ZIP: json['ZIP'] as String,
    salesmanName: json['salesmanName'] as String,
    phoneSalesman: json['phoneSalesman'] as String,
    phoneConcierge: json['phoneConcierge'] as String,
    state_province: json['state_province'] as String,
    nation: json['nation'] as String,
    country: json['country'] as String ?? '',
    address: json['address'] as String ?? '',
    addressOptional: json['addressOptional'] as String ?? '',
    cityTown: json['cityTown'] as String ?? '',
    stateTerritoryProvince: json['stateTerritoryProvince'] as String ?? '',
    zipPostal: json['zipPostal'] as String ?? '',
    coordinate: json['coordinate'] as String,
    profile: json['profile'] as String,
    gallery: (json['gallery'] as List)?.map((e) => e as String)?.toList(),
    hasAccess: (json['hasAccess'] as List)?.map((e) => e as String)?.toList(),
    wide: json['wide'] as String,
    logo: json['logo'] as String,
    draft: json['draft'] as bool,
    business_type:
        (json['business_type'] as List)?.map((e) => e as String)?.toList(),
    description: json['description'] as String,
    id_firestore: json['id_firestore'] as String,
    salesman: json['salesman'] == null
        ? null
        : GenericState.fromJson(json['salesman'] as Map<String, dynamic>),
    salesmanId: json['salesmanId'] as String,
    stripeCustomerId: json['stripeCustomerId'] as String,
    owner: json['owner'] == null
        ? null
        : GenericState.fromJson(json['owner'] as Map<String, dynamic>),
    ownerId: json['ownerId'] as String,
    tag: (json['tag'] as List)?.map((e) => e as String)?.toList(),
    area: (json['area'] as List)?.map((e) => e as String)?.toList(),
    hub: json['hub'] as bool ?? false,
    businessAddress: json['businessAddress'] as String,
  );
}

Map<String, dynamic> _$ExternalBusinessStateToJson(
        ExternalBusinessState instance) =>
    <String, dynamic>{
      'name': instance.name,
      'responsible_person_name': instance.responsible_person_name,
      'responsible_person_surname': instance.responsible_person_surname,
      'responsible_person_email': instance.responsible_person_email,
      'phone_number': instance.phone_number,
      'email': instance.email,
      'VAT': instance.VAT,
      'street': instance.street,
      'municipality': instance.municipality,
      'street_number': instance.street_number,
      'ZIP': instance.ZIP,
      'salesmanName': instance.salesmanName,
      'phoneSalesman': instance.phoneSalesman,
      'phoneConcierge': instance.phoneConcierge,
      'state_province': instance.state_province,
      'nation': instance.nation,
      'country': instance.country,
      'address': instance.address,
      'addressOptional': instance.addressOptional,
      'cityTown': instance.cityTown,
      'stateTerritoryProvince': instance.stateTerritoryProvince,
      'zipPostal': instance.zipPostal,
      'coordinate': instance.coordinate,
      'profile': instance.profile,
      'gallery': instance.gallery,
      'hasAccess': instance.hasAccess,
      'wide': instance.wide,
      'logo': instance.logo,
      'business_type': instance.business_type,
      'description': instance.description,
      'id_firestore': instance.id_firestore,
      'salesman': instance.salesman?.toJson(),
      'salesmanId': instance.salesmanId,
      'stripeCustomerId': instance.stripeCustomerId,
      'owner': instance.owner?.toJson(),
      'ownerId': instance.ownerId,
      'draft': instance.draft,
      'tag': instance.tag,
      'area': instance.area,
      'hub': instance.hub,
      'businessAddress': instance.businessAddress,
    };
