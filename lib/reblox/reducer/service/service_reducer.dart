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

import 'package:Buytime/UI/management/service_internal/class/service_slot_classes.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/convention_slot_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/service_slot_time_state.dart';
import 'package:Buytime/reblox/model/slot/slot_list_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:flutter/material.dart';

class UpdateSlotSnippet {
  String _serviceId;
  SlotListSnippetState _slotSnippet;

  UpdateSlotSnippet(this._serviceId, this._slotSnippet);

  SlotListSnippetState get slotSnippet => _slotSnippet;
  String get serviceId => _serviceId;
}


class AddFileToUploadInService {
  OptimumFileToUpload _fileToUpload;

  AddFileToUploadInService(this._fileToUpload);

  OptimumFileToUpload get fileToUpload => _fileToUpload;
}

class ServiceRequest {
  ServiceState _serviceState;

  ServiceRequest(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class SetServiceServiceCrossSell {
  bool _serviceCrossSell;

  SetServiceServiceCrossSell(this._serviceCrossSell);

  bool get serviceCrossSell => _serviceCrossSell;
}

class SetServiceHubConvention {
  bool _serviceHubConvention;

  SetServiceHubConvention(this._serviceHubConvention);

  bool get serviceHubConvention => _serviceHubConvention;
}

class ServiceRequestByID {
  String _serviceId;

  ServiceRequestByID(this._serviceId);

  String get serviceId => _serviceId;
}

class ServiceRequestByIDResponse {
  ServiceState _serviceState;

  ServiceRequestByIDResponse(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class SetService {
  ServiceState _serviceState;

  SetService(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class SetCreatedService {
  bool _value;
  SetCreatedService(this._value);
  bool get value => _value;
}

class SetEditedService {
  bool _value;
  SetEditedService(this._value);
  bool get value => _value;
}

class SetServiceToEmpty {
  ServiceState _serviceState;

  SetServiceToEmpty();

  ServiceState get serviceState => _serviceState;
}

class ServiceRequestResponse {
  ServiceState _serviceState;

  ServiceRequestResponse(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class UpdateService {
  ServiceState _serviceState;

  UpdateService(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class UpdatedService {
  ServiceState _serviceState;

  UpdatedService(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class DeleteService {
  String _serviceId;

  DeleteService(this._serviceId);

  String get serviceId => _serviceId;
}

class DeletedService {
  ServiceState _serviceState;

  DeletedService();

  ServiceState get serviceState => _serviceState;
}

class CreateService {
  ServiceState _serviceState;

  CreateService(this._serviceState);

  ServiceState get serviceState => _serviceState;
}
class DuplicateService {
  String _serviceId;
  DuplicateService(this._serviceId);
  String get serviceId => _serviceId;
}
class DuplicatedService {}
class CreatedService {
  ServiceState _serviceState;

  CreatedService(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class CreatedServiceFromStore {
  ServiceState serviceState;

  CreatedServiceFromStore();
}

class ServiceChanged {
  ServiceState _serviceState;

  ServiceChanged(this._serviceState);

  ServiceState get serviceState => _serviceState;
}

class SetServiceId {
  String _id;

  SetServiceId(this._id);

  String get id => _id;
}

class SetServiceName {
  String _name;

  SetServiceName(this._name);

  String get name => _name;
}

class SetServiceOriginalLanguage {
  String _originalLanguage;

  SetServiceOriginalLanguage(this._originalLanguage);

  String get originalLanguage => _originalLanguage;
}

class SetServiceImage1 {
  String _image;

  SetServiceImage1(this._image);

  String get image => _image;
}

class SetServiceImage2 {
  String _image;

  SetServiceImage2(this._image);

  String get image => _image;
}

class SetServiceImage3 {
  String _image;

  SetServiceImage3(this._image);

  String get image => _image;
}

class SetServiceDescription {
  String _description;

  SetServiceDescription(this._description);

  String get description => _description;
}
class SetServiceCondition {
  String _condition;

  SetServiceCondition(this._condition);

  String get condition => _condition;
}
class SetServiceAddress {
  String _address;

  SetServiceAddress(this._address);

  String get address => _address;
}
class SetServiceBusinessAddress {
  String _address;

  SetServiceBusinessAddress(this._address);

  String get address => _address;
}

class SetServiceCoordinates {
  String _coordinates;

  SetServiceCoordinates(this._coordinates);

  String get coordinates => _coordinates;
}
class SetServiceBusinessCoordinates {
  String _coordinates;

  SetServiceBusinessCoordinates(this._coordinates);

  String get coordinates => _coordinates;
}

class SetServiceVisibility {
  String _visibility;

  SetServiceVisibility(this._visibility);

  String get visibility => _visibility;
}

class SetServicePrice {
  double _price;

  SetServicePrice(this._price);

  double get price => _price;
}

class SetServicePaymentMethodCard {
  bool _value;
  SetServicePaymentMethodCard(this._value);
  bool get value => _value;
}

class SetServicePaymentMethodOnSite {
  bool _value;
  SetServicePaymentMethodOnSite(this._value);
  bool get value => _value;
}

class SetServicePaymentMethodRoom {
  bool _value;
  SetServicePaymentMethodRoom(this._value);
  bool get value => _value;
}

class SetServiceVAT {
  int _vat;

  SetServiceVAT(this._vat);

  int get vat => _vat;
}

class SetServiceSelectedCategories {
  List<Parent> _selectedCategories;

  SetServiceSelectedCategories(this._selectedCategories);

  List<Parent> get selectedCategories => _selectedCategories;
}

class SetServiceConventionSlotList {
  List<ConventionSlot> _conventionSlotList;

  SetServiceConventionSlotList(this._conventionSlotList);

  List<ConventionSlot> get conventionSlotList => _conventionSlotList;
}

class SetServiceSwitchSlots {
  bool _enabled;

  SetServiceSwitchSlots(this._enabled);

  bool get enabled => _enabled;
}

class SetServiceSwitchAutoConfirm {
  bool _enabled;

  SetServiceSwitchAutoConfirm(this._enabled);

  bool get enabled => _enabled;
}

class AddServiceSlot {
  ServiceSlot _serviceSlot;
  AddServiceSlot(this._serviceSlot);
  ServiceSlot get serviceSlot => _serviceSlot;
}

class UpdateServiceSlot {
  ServiceSlot _serviceSlot;
  int _index;
  UpdateServiceSlot(this._serviceSlot, this._index);
  ServiceSlot get serviceSlot => _serviceSlot;
  int get index => _index;
}

class DeleteServiceSlot {
  int _index;
  DeleteServiceSlot(this._index);
  int get index => _index;
}

class DeleteConventionSlot {
  int _index;
  DeleteConventionSlot(this._index);
  int get index => _index;
}



ServiceState serviceReducer(ServiceState state, action) {
  ServiceState serviceState = ServiceState.fromState(state);
  if (action is SetCreatedService) {
    serviceState.serviceCreated = action.value;
    return serviceState;
  }
  if (action is SetEditedService) {
    serviceState.serviceEdited = action.value;
    return serviceState;
  }
  if (action is SetServiceId) {
    serviceState.serviceId = action.id;
    return serviceState;
  }
  if (action is SetServiceName) {
    serviceState.name = action.name;
    debugPrint('service_reducer => state value: ${serviceState.name} | action value: ${action.name}');
    return serviceState;
  }
  if (action is SetServiceOriginalLanguage) {
    serviceState.originalLanguage = action.originalLanguage;
    //debugPrint('service_reducer => state value: ${serviceState.name} | action value: ${action.name}');
    return serviceState;
  }
  if (action is SetServiceImage1) {
    serviceState.image1 = action.image;
    return serviceState;
  }
  if (action is SetServiceImage2) {
    serviceState.image2 = action.image;
    return serviceState;
  }
  if (action is SetServiceImage3) {
    serviceState.image3 = action.image;
    return serviceState;
  }
  if (action is SetServiceServiceCrossSell) {
    serviceState.serviceCrossSell = action.serviceCrossSell;
    return serviceState;
  }
  if (action is SetServiceHubConvention) {
    serviceState.hubConvention = action.serviceHubConvention;
    return serviceState;
  }

  if (action is SetServiceDescription) {
    serviceState.description = action.description;
    return serviceState;
  }
  if (action is SetServiceCondition) {
    serviceState.condition = action.condition;
    return serviceState;
  }
  if (action is SetServiceAddress) {
    serviceState.serviceAddress = action.address;
    return serviceState;
  }
  if (action is SetServiceBusinessAddress) {
    serviceState.serviceBusinessAddress = action.address;
    return serviceState;
  }
  if (action is SetServiceCoordinates) {
    serviceState.serviceCoordinates = action.coordinates;
    return serviceState;
  }
  if (action is SetServiceBusinessCoordinates) {
    serviceState.serviceBusinessCoordinates = action.coordinates;
    return serviceState;
  }
  if (action is SetServiceVisibility) {
    serviceState.visibility = action.visibility;
    return serviceState;
  }
  if (action is SetServicePrice) {
    serviceState.price = action.price;
    return serviceState;
  }
  if (action is SetServicePaymentMethodCard) {
    serviceState.paymentMethodCard = action.value;
    return serviceState;
  }
  if (action is SetServicePaymentMethodRoom) {
    serviceState.paymentMethodRoom = action.value;
    return serviceState;
  }
  if (action is SetServicePaymentMethodOnSite) {
    serviceState.paymentMethodOnSite = action.value;
    return serviceState;
  }
  if (action is SetServiceVAT) {
    serviceState.vat = action.vat;
    return serviceState;
  }
  if (action is SetServiceSwitchSlots) {
    serviceState.switchSlots = action.enabled;
    return serviceState;
  }
  if (action is SetServiceSwitchAutoConfirm) {
    serviceState.switchAutoConfirm = action.enabled;
    return serviceState;
  }
  if (action is AddServiceSlot) {
    ServiceSlot serviceSlot = action.serviceSlot.copyWith();
    serviceState.serviceSlot.add(serviceSlot);
    return serviceState;
  }
  if (action is UpdateServiceSlot) {
    serviceState.serviceSlot[action.index] = action.serviceSlot;
    return serviceState;
  }
  if (action is DeleteServiceSlot) {
    serviceState.serviceSlot.removeAt(action.index);
    return serviceState;
  }

  if (action is SetServiceSelectedCategories) {
    List<String> selCat = [];

    action.selectedCategories.forEach((element) {
      if (!selCat.contains(element.id)) {
        selCat.add(element.id);
      }
      // if (!selRootCat.contains(element.parentRootId)) {
      //   selRootCat.add(element.parentRootId);
      // }
    });
    serviceState.categoryId = selCat;
  //  serviceState.categoryRootId = selRootCat;
    return serviceState;
  }
  if (action is ServiceChanged) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is SetServiceConventionSlotList) {
    serviceState.conventionSlotList = action.conventionSlotList;
    return serviceState;
  }
  if (action is DeleteConventionSlot) {
    serviceState.conventionSlotList.removeAt(action.index);
    return serviceState;
  }
  if (action is CreatedService) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is UpdatedService) {
    if (action.serviceState != null) {
      serviceState = action.serviceState.copyWith();
    }
    return serviceState;
  }
  if (action is ServiceRequestResponse) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is ServiceRequestByIDResponse) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is SetServiceToEmpty) {
    serviceState = ServiceState().toEmpty();
    return serviceState;
  }
  if (action is SetService) {
    print("business_reducer: set service");
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is AddFileToUploadInService) {
    print("business_reducer: addFileInService. service: " + state.name);
    if (state.fileToUploadList != null) {
      print("service_reducer: fileuploadlist != null");
      serviceState.fileToUploadList = []
        ..addAll(state.fileToUploadList)
        ..add(action.fileToUpload);
    } else {
      print("service_reducer: fileuploadlist == null");
      serviceState.fileToUploadList = []..add(action.fileToUpload);
    }
    print("service_reducer: fileToUploadList(0) is now: " + serviceState.fileToUploadList
        .elementAt(0)
        .remoteName);
    return serviceState;
  }
  return state;
}
