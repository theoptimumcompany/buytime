import 'package:Buytime/UI/management/service/class/service_slot_classes.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/service_time_slot_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:flutter/material.dart';

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

class SetService {
  ServiceState _serviceState;

  SetService(this._serviceState);

  ServiceState get serviceState => _serviceState;
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

class SetServiceSelectedCategories {
  List<Parent> _selectedCategories;

  SetServiceSelectedCategories(this._selectedCategories);

  List<Parent> get selectedCategories => _selectedCategories;
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

class SetServiceSlot {
  ServiceSlot _tab;

  SetServiceSlot(this._tab);

  ServiceSlot get tab => _tab;
}


class SetServiceSlotDaysInterval {
  List<EveryDay> _daysInterval;

  SetServiceSlotDaysInterval(this._daysInterval);

  List<EveryDay> get daysInterval => _daysInterval;
}

class SetServiceSlotNumberOfInterval {
  int _numberOfInterval;
  SetServiceSlotNumberOfInterval(this._numberOfInterval);
  int get numberOfInterval => _numberOfInterval;
}

class SetServiceSlotSwitchWeek {
  List<bool>  _switchWeek;
  SetServiceSlotSwitchWeek(this._switchWeek);
  List<bool> get switchWeek => _switchWeek;

}

class SetServiceSlotStartTime {
  List<String> _time;
  SetServiceSlotStartTime(this._time);
  List<String>  get time => _time;
}

class SetServiceSlotStopTime {
  List<String> _time;
  SetServiceSlotStopTime(this._time);
  List<String>  get time => _time;
}


class SetServiceSlotCheckIn {
  String _date;
  SetServiceSlotCheckIn(this._date);
  String get date => _date;
}


class SetServiceSlotCheckOut{
  String _date;
  SetServiceSlotCheckOut(this._date);
  String get date => _date;
}

class SetServiceSlotHour {
  int _hour;
  SetServiceSlotHour(this._hour);
  int get hour => _hour;
}

class SetServiceSlotMinute {
  int _minute;
  SetServiceSlotMinute(this._minute);
  int get minute => _minute;
}

class SetServiceSlotLimitBooking {
  int _limit;
  SetServiceSlotLimitBooking(this._limit);
  int get limit => _limit;
}

class SetServiceSlotPrice {
  double _price;
  SetServiceSlotPrice(this._price);
  double get price => _price;
}

class SetServiceSlotNumber {
  int _number;
  SetServiceSlotNumber(this._number);
  int get number => _number;
}


ServiceState serviceReducer(ServiceState state, action) {
  ServiceState serviceState = ServiceState.fromState(state);
  if (action is SetServiceId) {
    serviceState.serviceId = action.id;
    return serviceState;
  }
  if (action is SetServiceName) {
    serviceState.name = action.name;
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
  if (action is SetServiceDescription) {
    serviceState.description = action.description;
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
  if (action is SetServiceSwitchSlots) {
    serviceState.switchSlots = action.enabled;
    return serviceState;
  }
  if (action is SetServiceSwitchAutoConfirm) {
    serviceState.switchAutoConfirm = action.enabled;
    return serviceState;
  }
  if (action is SetServiceSlot) {
    serviceState.serviceSlot = action.tab.copyWith();
    return serviceState;
  }
  if (action is SetServiceSlotDaysInterval) {
    serviceState.serviceSlot.daysInterval = action.daysInterval;
    return serviceState;
  }
  if (action is SetServiceSlotNumberOfInterval) {
    serviceState.serviceSlot.numberOfInterval = action.numberOfInterval;
    return serviceState;
  }
  if (action is SetServiceSlotSwitchWeek) {
    serviceState.serviceSlot.switchWeek = action.switchWeek;
    return serviceState;
  }
  if (action is SetServiceSlotCheckIn) {
    serviceState.serviceSlot.checkIn = action.date;
    return serviceState;
  }
  if (action is SetServiceSlotCheckOut) {
    serviceState.serviceSlot.checkOut = action.date;
    return serviceState;
  }
  if (action is SetServiceSlotStartTime) {
    serviceState.serviceSlot.startTime = action.time;
    return serviceState;
  }
  if (action is SetServiceSlotStopTime) {
    serviceState.serviceSlot.stopTime = action.time;
    return serviceState;
  }
  if (action is SetServiceSlotHour) {
    serviceState.serviceSlot.hour = action.hour;
    return serviceState;
  }
  if (action is SetServiceSlotMinute) {
    serviceState.serviceSlot.minute = action.minute;
    return serviceState;
  }
  if (action is SetServiceSlotLimitBooking) {
    serviceState.serviceSlot.limitBooking = action.limit;
    return serviceState;
  }
  if (action is SetServiceSlotPrice) {
    serviceState.serviceSlot.price = action.price;
    return serviceState;
  }
  if (action is SetServiceSlotNumber) {
    serviceState.numberOfServiceSlot = action.number;
    return serviceState;
  }
  if (action is SetServiceSelectedCategories) {
    List<String> selCat = [];
    List<String> selRootCat = [];
    action.selectedCategories.forEach((element) {
      if (!selCat.contains(element.id)) {
        selCat.add(element.id);
      }
      if (!selRootCat.contains(element.parentRootId)) {
        selRootCat.add(element.parentRootId);
      }
    });
    serviceState.categoryId = selCat;
    serviceState.categoryRootId = selRootCat;
    return serviceState;
  }
  if (action is ServiceChanged) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is CreatedService) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is ServiceRequestResponse) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is SetServiceToEmpty) {
    serviceState = ServiceState().toEmpty();
    return serviceState;
  }
  if (action is SetService) {
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
