import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';



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
  String _businessId;
  CreateService(this._serviceState, this._businessId);
  ServiceState get serviceState => _serviceState;
  String get businessId => _businessId;
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

class SetServiceThumbnail {
  String _thumbnail;
  SetServiceThumbnail(this._thumbnail);
  String get thumbnail => _thumbnail;
}

class SetServiceImage {
  String _image;
  SetServiceImage(this._image);
  String get image => _image;
}

class SetServiceDescription {
  String _description;
  SetServiceDescription(this._description);
  String get description => _description;
}

class SetServiceAvailability {
  bool _availability;
  SetServiceAvailability(this._availability);
  bool get availability => _availability;
}

class SetServiceAction {
  List<GenericState> _actionList;
  SetServiceAction(this._actionList);
  List<GenericState> get actionList => _actionList;
}

class SetServiceCategory {
  List<GenericState> _categoryList;
  SetServiceCategory(this._categoryList);
  List<GenericState> get categoryList => _categoryList;
}

class SetServicePipeline {
  List<GenericState> _pipelineList;
  SetServicePipeline(this._pipelineList);
  List<GenericState> get pipelineList => _pipelineList;
}

class SetServiceExternalCategory {
  List<GenericState> _externalCategoryList;
  SetServiceExternalCategory(this._externalCategoryList);
  List<GenericState> get externalCategoryList => _externalCategoryList;
}

class SetServicePosition {
  List<GenericState> _positionList;
  SetServicePosition(this._positionList);
  List<GenericState> get positionList => _positionList;
}

class SetServiceVisibility {
  String _visibility;
  SetServiceVisibility(this._visibility);
  String get visibility => _visibility;
}

class SetServiceConstraint {
  List<GenericState> _constraintList;
  SetServiceConstraint(this._constraintList);
  List<GenericState> get constraintList => _constraintList;
}

class SetServiceTag {
  List<GenericState> _tagList;
  SetServiceTag(this._tagList);
  List<GenericState> get tagList => _tagList;
}

class SetServicePrice {
  double _price;
  SetServicePrice(this._price);
  double get price => _price;
}

class SetServiceWritePermission {
  List<GenericState> _write_permission;
  SetServiceWritePermission(this._write_permission);
  List<GenericState> get write_permission => _write_permission;
}

ServiceState serviceReducer(ServiceState state, action) {
  ServiceState serviceState = new ServiceState.fromState(state);
  if (action is SetServiceId) {
    serviceState.id = action.id;
    return serviceState;
  }
  if (action is SetServiceName) {
    serviceState.name = action.name;
    return serviceState;
  }
  if (action is SetServiceThumbnail) {
    serviceState.thumbnail = action.thumbnail;
    return serviceState;
  }
  if (action is SetServiceImage) {
    serviceState.image = action.image;
    return serviceState;
  }
  if (action is SetServiceDescription) {
    serviceState.description = action.description;
    return serviceState;
  }
  if (action is SetServiceAvailability) {
    serviceState.availability = action.availability;
    return serviceState;
  }
  if (action is SetServiceAction) {
    serviceState.actionList = action.actionList;
    return serviceState;
  }
  if (action is SetServiceCategory) {
    serviceState.categoryList = action.categoryList;
    return serviceState;
  }
  if (action is SetServiceExternalCategory) {
    serviceState.externalCategoryList = action.externalCategoryList;
    return serviceState;
  }
  if (action is SetServicePipeline) {
    serviceState.pipelineList = action.pipelineList;
    return serviceState;
  }
  if (action is SetServicePosition) {
    serviceState.positionList = action.positionList;
    return serviceState;
  }
  if (action is SetServiceVisibility) {
    serviceState.visibility = action.visibility;
    return serviceState;
  }
  if (action is SetServiceConstraint) {
    serviceState.constraintList = action.constraintList;
    return serviceState;
  }
  if (action is SetServiceTag) {
    serviceState.tagList = action.tagList;
    return serviceState;
  }
  if (action is SetServicePrice) {
    serviceState.price = action.price;
    return serviceState;
  }
  if (action is SetServiceWritePermission) {
    serviceState.write_permission = action.write_permission;
    return serviceState;
  }
  if (action is ServiceChanged) {
    serviceState = action.serviceState.copyWith();
    return serviceState;
  }
  if (action is CreateService) {
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
      print("business_reducer: fileuploadlist != null");
      serviceState.fileToUploadList
      = []
        ..addAll(state.fileToUploadList)
        ..add(action.fileToUpload);
    } else {
      print("business_reducer: fileuploadlist == null");
      serviceState.fileToUploadList
      = []
        ..add(action.fileToUpload);
    }
    print("business_reducer: fileToUploadList(0) is now: " + serviceState.fileToUploadList.elementAt(0).remoteName);
    return serviceState;
  }
  return state;
}
