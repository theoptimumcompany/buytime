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

class UnlistenCategory {}

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

class SetServiceSwitchMultiPrice {
  bool _enabled;

  SetServiceSwitchMultiPrice(this._enabled);

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


class SetServiceSlotIncrementDaysInterval {
  SetServiceSlotIncrementDaysInterval();
}

class SetServiceSlotDaysInterval {
  List<ListEveryDay> _daysInterval;

  SetServiceSlotDaysInterval(this._daysInterval);

  List<ListEveryDay> get daysInterval => _daysInterval;
}

class SetServiceSlotIncrementNumberOfAvailableInterval {
  SetServiceSlotIncrementNumberOfAvailableInterval();
}

class SetServiceSlotNumberOfInterval {
  List<int> _numberOfInterval;

  SetServiceSlotNumberOfInterval(this._numberOfInterval);

  List<int> get numberOfInterval => _numberOfInterval;
}

class SetServiceSlotIncrementSwitchWeek {
  SetServiceSlotIncrementSwitchWeek();
}

class SetServiceSlotSwitchWeek {
  List<ListWeek>  _switchWeek;
  SetServiceSlotSwitchWeek(this._switchWeek);
  List<ListWeek> get switchWeek => _switchWeek;

}

class SetServiceSlotSwitchDay {
  List<ListEveryDay> _everyDay;
  SetServiceSlotSwitchDay(this._everyDay);
  List<ListEveryDay> get everyDay => _everyDay;

}

class SetServiceSlotIncrementStartController {
  SetServiceSlotIncrementStartController();
}

class SetServiceSlotStartController {
  List<ListTextEditingController> _controller;
  SetServiceSlotStartController(this._controller);
  List<ListTextEditingController>  get controller => _controller;
}

class SetServiceSlotIncrementStopController {
  SetServiceSlotIncrementStopController();
}

class SetServiceSlotStopController {
  List<ListTextEditingController> _controller;
  SetServiceSlotStopController(this._controller);
  List<ListTextEditingController>  get controller => _controller;
}

class SetServiceSlotIncrementStartTime {
  SetServiceSlotIncrementStartTime();
}
class SetServiceSlotStartTime {
  List<EveryTime> _time;
  SetServiceSlotStartTime(this._time);
  List<EveryTime>  get time => _time;
}

class SetServiceSlotIncrementStopTime {
  SetServiceSlotIncrementStopTime();
}

class SetServiceSlotStopTime {
  List<EveryTime> _time;
  SetServiceSlotStopTime(this._time);
  List<EveryTime>  get time => _time;
}

class SetServiceSlotIncrementCheckInController {
  SetServiceSlotIncrementCheckInController();
}

class SetServiceSlotCheckInController {
  String _text;
  int _index;
  SetServiceSlotCheckInController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotIncrementCheckOutController {
  SetServiceSlotIncrementCheckOutController();
}

class SetServiceSlotCheckOutController {
  String _text;
  int _index;
  SetServiceSlotCheckOutController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotIncrementCheckIn {
  SetServiceSlotIncrementCheckIn();
}

class SetServiceSlotCheckIn {
  DateTime _date;
  int _index;
  SetServiceSlotCheckIn(this._date, this._index);
  DateTime get date => _date;
  int get index => _index;
}

class SetServiceSlotIncrementCheckOut {
  SetServiceSlotIncrementCheckOut();
}

class SetServiceSlotCheckOut{
  DateTime _date;
  int _index;
  SetServiceSlotCheckOut(this._date, this._index);
  DateTime get date => _date;
  int get index => _index;
}

class SetServiceSlotIncrementHourController {
  SetServiceSlotIncrementHourController();
}

class SetServiceSlotHourController {
  String _text;
  int _index;
  SetServiceSlotHourController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotIncrementMinuteController {
  SetServiceSlotIncrementMinuteController();
}

class SetServiceSlotMinuteController {
  String _text;
  int _index;
  SetServiceSlotMinuteController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotIncrementLimitBookingController {
  SetServiceSlotIncrementLimitBookingController();
}

class SetServiceSlotLimitBookingController {
  String _text;
  int _index;
  SetServiceSlotLimitBookingController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotIncrementPriceController {
  SetServiceSlotIncrementPriceController();
}

class SetServiceSlotPriceController {
  String _text;
  int _index;
  SetServiceSlotPriceController(this._text, this._index);
  String get text => _text;
  int get index => _index;
}

class SetServiceSlotFormSlotTimeKey {
  List<GlobalKey<FormState>> _global;
  SetServiceSlotFormSlotTimeKey(this._global);
  List<GlobalKey<FormState>> get global => _global;
}

class SetServiceSlotFormSlotLengthKey {
  List<GlobalKey<FormState>> _global;
  SetServiceSlotFormSlotLengthKey(this._global);
  List<GlobalKey<FormState>> get global => _global;
}

class SetServiceSlotFormSlotPriceKey {
  List<GlobalKey<FormState>> _global;
  SetServiceSlotFormSlotPriceKey(this._global);
  List<GlobalKey<FormState>> get global => _global;
}

class SetServiceSlotActualIndex {
  int _index;
  SetServiceSlotActualIndex(this._index);
  int get index => _index;
}

class SetServiceSlotNumber {
  int _index;
  SetServiceSlotNumber(this._index);
  int get index => _index;
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
  if (action is SetServiceSwitchMultiPrice) {
    serviceState.switchMultiPrice = action.enabled;
    return serviceState;
  }
  if (action is SetServiceSlot) {
    serviceState.serviceSlot = action.tab.copyWith();
    return serviceState;
  }
  if (action is SetServiceSlotIncrementDaysInterval) {
    serviceState.serviceSlot.daysInterval.add(ListEveryDay().toEmpty());
    return serviceState;
  }
  if (action is SetServiceSlotDaysInterval) {
    serviceState.serviceSlot.daysInterval = action.daysInterval;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementNumberOfAvailableInterval) {
    serviceState.serviceSlot.numberOfInterval.add(1);
    return serviceState;
  }
  if (action is SetServiceSlotNumberOfInterval) {
    serviceState.serviceSlot.numberOfInterval = action.numberOfInterval;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementSwitchWeek) {
    serviceState.serviceSlot.switchWeek.add(ListWeek().toEmpty());
    return serviceState;
  }
  if (action is SetServiceSlotSwitchWeek) {
    serviceState.serviceSlot.switchWeek = action.switchWeek;
    return serviceState;
  }
  if (action is SetServiceSlotSwitchDay) {
    serviceState.serviceSlot.daysInterval = action.everyDay;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementCheckInController) {
    serviceState.serviceSlot.checkInController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotCheckInController) {
    serviceState.serviceSlot.checkInController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementCheckOutController) {
    serviceState.serviceSlot.checkOutController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotCheckOutController) {
    serviceState.serviceSlot.checkOutController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementStartController) {
    ListTextEditingController list = ListTextEditingController().toEmpty();
    serviceState.serviceSlot.startController.add(list);
    return serviceState;
  }
  if (action is SetServiceSlotStartController) {
    serviceState.serviceSlot.startController = action.controller;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementStopController) {
    ListTextEditingController list = ListTextEditingController().toEmpty();
    serviceState.serviceSlot.stopController.add(list);
    return serviceState;
  }
  if (action is SetServiceSlotStopController) {
    serviceState.serviceSlot.stopController = action.controller;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementStartTime) {
    serviceState.serviceSlot.startTime.add(EveryTime().toEmpty());
    return serviceState;
  }
  if (action is SetServiceSlotStartTime) {
    serviceState.serviceSlot.startTime = action.time;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementStopTime) {
    serviceState.serviceSlot.stopTime.add(EveryTime().toEmpty());
    return serviceState;
  }
  if (action is SetServiceSlotStopTime) {
    serviceState.serviceSlot.stopTime = action.time;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementCheckIn) {
    serviceState.serviceSlot.checkIn.add(DateTime.now());
    return serviceState;
  }
  if (action is SetServiceSlotCheckIn) {
    serviceState.serviceSlot.checkIn[action.index] = action.date;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementCheckOut) {
    serviceState.serviceSlot.checkOut.add(DateTime.now());
    return serviceState;
  }
  if (action is SetServiceSlotCheckOut) {
    serviceState.serviceSlot.checkOut[action.index] = action.date;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementHourController) {
    serviceState.serviceSlot.hourController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotHourController) {
    serviceState.serviceSlot.hourController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementMinuteController) {
    serviceState.serviceSlot.minuteController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotMinuteController) {
    serviceState.serviceSlot.minuteController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementLimitBookingController) {
    serviceState.serviceSlot.limitBookingController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotLimitBookingController) {
    serviceState.serviceSlot.limitBookingController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotIncrementPriceController) {
    serviceState.serviceSlot.priceController.add(TextEditingController());
    return serviceState;
  }
  if (action is SetServiceSlotPriceController) {
    serviceState.serviceSlot.priceController[action.index].text = action.text;
    return serviceState;
  }
  if (action is SetServiceSlotFormSlotTimeKey) {
    serviceState.serviceSlot.formSlotTimeKey = action.global;
    return serviceState;
  }
  if (action is SetServiceSlotFormSlotLengthKey) {
    serviceState.serviceSlot.formSlotLengthKey = action.global;
    return serviceState;
  }
  if (action is SetServiceSlotFormSlotPriceKey) {
    serviceState.serviceSlot.formSlotPriceKey = action.global;
    return serviceState;
  }
  if (action is SetServiceSlotActualIndex) {
    serviceState.serviceSlot.actualSlotIndex = action.index;
    return serviceState;
  }
  if (action is SetServiceSlotNumber) {
    serviceState.serviceSlot.numberOfSlot = action.index;
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
