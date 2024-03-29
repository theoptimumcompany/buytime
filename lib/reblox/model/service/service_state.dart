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

import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import '../file/optimum_file_to_upload.dart';
import 'package:json_annotation/json_annotation.dart';

import 'convention_slot_state.dart';

part 'service_state.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceState {
  String serviceId;
  String businessId;
  List<String> categoryId;
  String image1;
  String image2;
  String image3;
  String name;
  String description;
  String visibility;
  double price;
  int vat;
  int timesSold;
  List<String> tag;
  @JsonKey(defaultValue: false)
  bool switchSlots = false;
  @JsonKey(defaultValue: false)
  bool hubConvention = false;
  @JsonKey(defaultValue: false)
  bool switchAutoConfirm = false;
  @JsonKey(defaultValue: [])
  List<ServiceSlot> serviceSlot = [];
  @JsonKey(defaultValue: false)
  bool spinnerVisibility = false;
  @JsonKey(defaultValue: false)
  bool serviceCreated = false;
  @JsonKey(defaultValue: false)
  bool serviceEdited = false;
  @JsonKey(defaultValue: true)
  bool serviceCrossSell = true;
  String serviceBusinessAddress;
  String serviceBusinessCoordinates;
  String serviceAddress;
  String serviceCoordinates;
  @JsonKey(defaultValue: '')
  String originalLanguage;
  @JsonKey(defaultValue: true)
  bool paymentMethodRoom = true;
  @JsonKey(defaultValue: true)
  bool paymentMethodCard = true;
  @JsonKey(defaultValue: false)
  bool paymentMethodOnSite = false;
  @JsonKey(defaultValue: '')
  String condition;
  UserSnippet contentCreator;

  @JsonKey(defaultValue: [])
  List<ConventionSlot> conventionSlotList;

  ///Out Database
  @JsonKey(ignore: true)
  List<OptimumFileToUpload> fileToUploadList;

  ServiceState({
    this.serviceId,
    this.businessId,
    this.categoryId,
    this.name,
    this.image1,
    this.image2,
    this.image3,
    this.description,
    this.visibility,
    this.price,
    this.vat,
    this.fileToUploadList,
    this.conventionSlotList,
    this.timesSold,
    this.tag,
    this.switchSlots,
    this.hubConvention,
    this.switchAutoConfirm,
    this.serviceSlot,
    this.spinnerVisibility,
    this.serviceCreated,
    this.serviceEdited,
    this.serviceCrossSell,
    this.serviceBusinessAddress,
    this.serviceBusinessCoordinates,
    this.originalLanguage,
    this.serviceAddress,
    this.serviceCoordinates,
    this.paymentMethodRoom,
    this.paymentMethodCard,
    this.paymentMethodOnSite,
    this.condition,
    this.contentCreator,
  });

  ServiceState toEmpty() {
    return ServiceState(
      serviceId: "",
      businessId: "",
      categoryId: [],
      name: "",
      image1: "",
      image2: "",
      image3: "",
      description: "",
      visibility: 'Invisible',
      price: 0.00,
      vat: 22,
      fileToUploadList: [],
      conventionSlotList: [],
      timesSold: 0,
      tag: [],
      switchSlots: false,
      hubConvention: false,
      switchAutoConfirm: false,
      serviceSlot: [],
      spinnerVisibility: false,
      serviceCreated: false,
      serviceEdited: false,
      serviceCrossSell: false,
      serviceBusinessAddress: '',
      serviceBusinessCoordinates: '',
      originalLanguage: '',
      serviceAddress: '',
      serviceCoordinates: '',
      paymentMethodRoom: true,
      paymentMethodCard: true,
      paymentMethodOnSite: false,
      condition: '',
      contentCreator: UserSnippet().toEmpty(),
    );
  }

  ServiceState.fromState(ServiceState service) {
    this.serviceId = service.serviceId;
    this.businessId = service.businessId;
    this.categoryId = service.categoryId;
    this.name = service.name;
    this.image1 = service.image1;
    this.image2 = service.image2;
    this.image3 = service.image3;
    this.description = service.description;
    this.visibility = service.visibility;
    this.price = service.price;
    this.vat = service.vat;
    this.fileToUploadList = service.fileToUploadList;
    this.conventionSlotList = service.conventionSlotList;
    this.timesSold = service.timesSold;
    this.tag = service.tag;
    this.switchSlots = service.switchSlots;
    this.hubConvention = service.hubConvention;
    this.switchAutoConfirm = service.switchAutoConfirm;
    this.serviceSlot = service.serviceSlot;
    this.spinnerVisibility = service.spinnerVisibility;
    this.serviceCreated = service.serviceCreated;
    this.serviceEdited = service.serviceEdited;
    this.serviceCrossSell = service.serviceCrossSell;
    this.serviceBusinessAddress = service.serviceBusinessAddress;
    this.serviceBusinessCoordinates = service.serviceBusinessCoordinates;
    this.originalLanguage = service.originalLanguage;
    this.serviceAddress = service.serviceAddress;
    this.serviceCoordinates = service.serviceCoordinates;
    this.paymentMethodCard = service.paymentMethodCard;
    this.paymentMethodOnSite = service.paymentMethodOnSite;
    this.paymentMethodRoom = service.paymentMethodRoom;
    this.condition = service.condition;
    this.contentCreator = service.contentCreator;
  }

  ServiceState copyWith(
      {String serviceId,
      String businessId,
      List<String> categoryId,
      String name,
      String image1,
      String image2,
      String image3,
      String description,
      String visibility,
      double price,
      int vat,
      List<OptimumFileToUpload> fileToUploadList,
      List<ConventionSlot> conventionSlotList,
      int timesSold,
      List<String> tag,
      bool switchSlots,
      bool hubConvention,
      bool switchAutoConfirm,
      List<ServiceSlot> serviceSlot,
      bool spinnerVisibility,
      bool serviceCreated,
      bool serviceEdited,
      bool serviceCrossSell,
      String serviceBusinessAddress,
      String serviceBusinessCoordinates,
      String originalLanguage,
      String serviceAddress,
      String serviceCoordinates,
      bool paymentMethodRoom,
      bool paymentMethodCard,
      bool paymentMethodOnSite,
      String condition,
      UserSnippet contentCreator}) {
    return ServiceState(
      serviceId: serviceId ?? this.serviceId,
      businessId: businessId ?? this.businessId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      image1: image1 ?? this.image1,
      image2: image2 ?? this.image2,
      image3: image3 ?? this.image3,
      description: description ?? this.description,
      visibility: visibility ?? this.visibility,
      price: price ?? this.price,
      vat: vat ?? this.vat,
      fileToUploadList: fileToUploadList ?? this.fileToUploadList,
      conventionSlotList: conventionSlotList ?? this.conventionSlotList,
      timesSold: timesSold ?? this.timesSold,
      tag: tag ?? this.tag,
      switchSlots: switchSlots ?? this.switchSlots,
      hubConvention: hubConvention ?? this.hubConvention,
      switchAutoConfirm: switchAutoConfirm ?? this.switchAutoConfirm,
      serviceSlot: serviceSlot ?? this.serviceSlot,
      spinnerVisibility: spinnerVisibility ?? this.spinnerVisibility,
      serviceCreated: serviceCreated ?? this.serviceCreated,
      serviceEdited: serviceEdited ?? this.serviceEdited,
      serviceCrossSell: serviceCrossSell ?? this.serviceCrossSell,
      serviceBusinessAddress: serviceBusinessAddress ?? this.serviceBusinessAddress,
      serviceBusinessCoordinates: serviceBusinessCoordinates ?? this.serviceBusinessCoordinates,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      serviceAddress: serviceAddress ?? this.serviceAddress,
      serviceCoordinates: serviceCoordinates ?? this.serviceCoordinates,
      paymentMethodRoom: paymentMethodRoom ?? this.paymentMethodRoom,
      paymentMethodCard: paymentMethodCard ?? this.paymentMethodCard,
      paymentMethodOnSite: paymentMethodOnSite ?? this.paymentMethodOnSite,
      condition: condition ?? this.condition,
      contentCreator: contentCreator ?? this.contentCreator,
    );
  }

  factory ServiceState.fromJson(Map<String, dynamic> json) => _$ServiceStateFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceStateToJson(this);
}
