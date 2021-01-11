import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/file/optimum_file_to_upload.dart';

class SetBusiness {
  BusinessState _businessState;

  SetBusiness(this._businessState);

  BusinessState get businessState => _businessState;
}

class SetBusinessToEmpty {
  BusinessState _businessState;

  SetBusinessToEmpty();

  BusinessState get businessState => _businessState;
}

class BusinessRequest {
  String _businessStateId;

  BusinessRequest(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class UnlistenBusiness {}

class UpdateBusiness {
  BusinessState _businessState;

  UpdateBusiness(this._businessState);

  BusinessState get businessState => _businessState;
}

class UploadedFilesBusinessCreate {
  BusinessState _businessState;

  UploadedFilesBusinessCreate(this._businessState);

  BusinessState get businessState => _businessState;
}

class AddFileToUploadInBusiness {
  OptimumFileToUpload _fileToUpload;

  AddFileToUploadInBusiness(this._fileToUpload);

  OptimumFileToUpload get fileToUpload => _fileToUpload;
}

class UpdatedBusiness {
  BusinessState _businessState;

  UpdatedBusiness(this._businessState);

  BusinessState get businessState => _businessState;
}

class CreateBusiness {
  BusinessState _businessState;

  CreateBusiness(this._businessState);

  BusinessState get businessState => _businessState;
}

class CreatedBusiness {
  BusinessState _businessState;

  CreatedBusiness(this._businessState);

  BusinessState get businessState => _businessState;
}

class CreatedBusinessFromStore {
  BusinessState businessState;

  CreatedBusinessFromStore();
}

class BusinessRequestResponse {
  BusinessState _businessState;

  BusinessRequestResponse(this._businessState);

  BusinessState get businessState => _businessState;
}

class SetBusinessName {
  String _name;

  SetBusinessName(this._name);

  String get name => _name;
}

class SetBusinessMunicipality {
  String _municipality;

  SetBusinessMunicipality(this._municipality);

  String get municipality => _municipality;
}

class SetBusinessResponsiblePersonName {
  String _responsible_person_name;

  SetBusinessResponsiblePersonName(this._responsible_person_name);

  String get responsible_person_name => _responsible_person_name;
}

class SetBusinessResponsiblePersonSurname {
  String _responsible_person_surname;

  SetBusinessResponsiblePersonSurname(this._responsible_person_surname);

  String get responsible_person_surname => _responsible_person_surname;
}

class SetBusinessResponsiblePersonEmail {
  String _responsible_person_email;

  SetBusinessResponsiblePersonEmail(this._responsible_person_email);

  String get responsible_person_email => _responsible_person_email;
}

class SetBusinessEmail {
  String _email;

  SetBusinessEmail(this._email);

  String get email => _email;
}

class SetBusinessVAT {
  String _VAT;

  SetBusinessVAT(this._VAT);

  String get VAT => _VAT;
}

class SetBusinessStreet {
  String _street;

  SetBusinessStreet(this._street);

  String get street => _street;
}

class SetBusinessStreetNumber {
  String _street_number;

  SetBusinessStreetNumber(this._street_number);

  String get street_number => _street_number;
}

class SetBusinessZIP {
  String _ZIP;

  SetBusinessZIP(this._ZIP);

  String get ZIP => _ZIP;
}

class SetBusinessStateProvince {
  String _state_province;

  SetBusinessStateProvince(this._state_province);

  String get state_province => _state_province;
}

class SetBusinessNation {
  String _nation;

  SetBusinessNation(this._nation);

  String get nation => _nation;
}

class SetBusinessDraft {
  bool _draft;

  SetBusinessDraft(this._draft);

  bool get draft => _draft;
}

class SetBusinessCoordinate {
  String _coordinate;

  SetBusinessCoordinate(this._coordinate);

  String get coordinate => _coordinate;
}

class SetBusinessProfile {
  String _profile;

  SetBusinessProfile(this._profile);

  String get profile => _profile;
}

class SetBusinessGallery {
  List<String> _gallery;

  SetBusinessGallery(this._gallery);

  List<String> get gallery => _gallery;
}

class SetBusinessThumbnail {
  String _thumbnail;

  SetBusinessThumbnail(this._thumbnail);

  String get thumbnail => _thumbnail;
}

class SetBusinessLogo {
  String _logo;

  SetBusinessLogo(this._logo);

  String get logo => _logo;
}

class SetBusinessType {
  List<ObjectState> _business_type;

  SetBusinessType(this._business_type);

  List<ObjectState> get business_type => _business_type;
}

class SetBusinessDescription {
  String _description;

  SetBusinessDescription(this._description);

  String get description => _description;
}

class SetBusinessIdFirestore {
  String _id_firestore;

  SetBusinessIdFirestore(this._id_firestore);

  String get id_firestore => _id_firestore;
}

class SetBusinessSalesman {
  ObjectState _salesman;

  SetBusinessSalesman(this._salesman);

  ObjectState get salesman => _salesman;
}

class SetBusinessOwner {
  ObjectState _owner;

  SetBusinessOwner(this._owner);

  ObjectState get owner => _owner;
}

BusinessState businessReducer(BusinessState state, action) {
  BusinessState businessState = new BusinessState.fromState(state);
  if (action is SetBusinessName) {
    businessState.name = action.name;
    return businessState;
  }
  if (action is SetBusinessResponsiblePersonName) {
    businessState.responsible_person_name = action.responsible_person_name;
    return businessState;
  }
  if (action is SetBusinessResponsiblePersonSurname) {
    businessState.responsible_person_surname = action.responsible_person_surname;
    return businessState;
  }
  if (action is SetBusinessResponsiblePersonEmail) {
    businessState.responsible_person_email = action.responsible_person_email;
    return businessState;
  }
  if (action is SetBusinessEmail) {
    businessState.email = action.email;
    return businessState;
  }
  if (action is SetBusinessVAT) {
    businessState.VAT = action.VAT;
    return businessState;
  }
  if (action is SetBusinessStreet) {
    businessState.street = action.street;
    return businessState;
  }
  if (action is SetBusinessStreetNumber) {
    businessState.street_number = action.street_number;
    return businessState;
  }
  if (action is SetBusinessZIP) {
    businessState.ZIP = action.ZIP;
    return businessState;
  }
  if (action is SetBusinessStateProvince) {
    businessState.state_province = action.state_province;
    return businessState;
  }
  if (action is SetBusinessNation) {
    businessState.nation = action.nation;
    return businessState;
  }
  if (action is SetBusinessMunicipality) {
    businessState.municipality = action.municipality;
    return businessState;
  }
  if (action is SetBusinessCoordinate) {
    businessState.coordinate = action.coordinate;
    return businessState;
  }
  if (action is SetBusinessProfile) {
    businessState.profile = action.profile;
    return businessState;
  }
  if (action is SetBusinessGallery) {
    businessState.gallery = action.gallery;
    return businessState;
  }
  if (action is SetBusinessThumbnail) {
    businessState.wide_card_photo = action.thumbnail;
    return businessState;
  }
  if (action is SetBusinessLogo) {
    print("business_reducer: set business logo is" + action.logo);
    businessState.logo = action.logo;
    return businessState;
  }
  if (action is SetBusinessType) {
    businessState.business_type = action.business_type;
    return businessState;
  }
  if (action is SetBusinessDescription) {
    businessState.description = action.description;
    return businessState;
  }
  if (action is SetBusinessIdFirestore) {
    businessState.id_firestore = action.id_firestore;
    return businessState;
  }
  if (action is SetBusinessDraft) {
    businessState.draft = action.draft;
    return businessState;
  }
  if (action is BusinessRequestResponse) {
    businessState = action.businessState.copyWith();
    return businessState;
  }
  if (action is SetBusiness) {
    businessState = action.businessState.copyWith();
    return businessState;
  }
  if (action is SetBusinessToEmpty) {
    businessState = BusinessState().toEmpty();
    return businessState;
  }
  if (action is SetBusinessSalesman) {
    businessState.salesman = action.salesman;
    return businessState;
  }
  if (action is SetBusinessOwner) {
    businessState.owner = action.owner;
    return businessState;
  }
  if (action is AddFileToUploadInBusiness) {
    print("business_reducer: addFileInbusiness. business: " + state.name);
    if (state.fileToUploadList != null) {
      print("business_reducer: fileuploadlist != null");
      businessState.fileToUploadList = []
        ..addAll(state.fileToUploadList)
        ..add(action.fileToUpload);
    } else {
      print("business_reducer: fileuploadlist == null");
      businessState.fileToUploadList = []..add(action.fileToUpload);
    }
    print("business_reducer: fileToUploadList(0) is now: " +
        businessState.fileToUploadList.elementAt(0).remoteName);
    return businessState;
  }
  return state;
}
