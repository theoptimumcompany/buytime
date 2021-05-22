import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';

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

class BusinessServiceListAndNavigateRequest {
  String _businessStateId;

  BusinessServiceListAndNavigateRequest(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class BusinessRequestAndNavigate {
  String _businessStateId;

  BusinessRequestAndNavigate(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class BusinessAndNavigateOnConfirmRequest {
  String _businessStateId;

  BusinessAndNavigateOnConfirmRequest(this._businessStateId);

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
  ImageState state;
  int index;

  AddFileToUploadInBusiness(this._fileToUpload, this.state, this.index);

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

class SetBusinessAddress {
  String _address;

  SetBusinessAddress(this._address);

  String get address => _address;
}

class AddBusinessArea {
  String _area;

  AddBusinessArea(this._area);

  String get area => _area;
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

class SetBusinessZipPostal {
  String _zipPostal;
  SetBusinessZipPostal(this._zipPostal);
  String get zipPostal => _zipPostal;
}
class SetBusinessCityTown {
  String _cityTown;
  SetBusinessCityTown(this._cityTown);
  String get cityTown => _cityTown;
}
class SetBusinessStateTerritoryProvince {
  String _stateTerritoryProvince;
  SetBusinessStateTerritoryProvince(this._stateTerritoryProvince);
  String get stateTerritoryProvince => _stateTerritoryProvince;
}
class SetBusinessAddressOptional {
  String _addressOptional;
  SetBusinessAddressOptional(this._addressOptional);
  String get addressOptional => _addressOptional;
}
class SetBusinessCountry {
  String _country;
  SetBusinessCountry(this._country);
  String get country => _country;
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

class SetHub {
  bool _hub;

  SetHub(this._hub);

  bool get hub => _hub;
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

class SetBusinessWide {
  String _wide;

  SetBusinessWide(this._wide);

  String get wide => _wide;
}

class SetBusinessLogo {
  String _logo;

  SetBusinessLogo(this._logo);

  String get logo => _logo;
}

class SetBusinessType {
  List<GenericState> _business_type;

  SetBusinessType(this._business_type);

  List<GenericState> get business_type => _business_type;
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
  GenericState _salesman;

  SetBusinessSalesman(this._salesman);

  GenericState get salesman => _salesman;
}

class SetBusinessOwner {
  GenericState _owner;

  SetBusinessOwner(this._owner);

  GenericState get owner => _owner;
}

BusinessState businessReducer(BusinessState state, action) {
  BusinessState businessState = new BusinessState.fromState(state);
  if (action is SetBusinessName) {
    businessState.name = action.name;
    return businessState;
  }
  if (action is SetBusinessAddress) {
    businessState.businessAddress = action.address;
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
  if (action is SetBusinessStateTerritoryProvince) {
    businessState.stateTerritoryProvince = action.stateTerritoryProvince;
    return businessState;
  }
  if (action is SetBusinessZipPostal) {
    businessState.zipPostal = action.zipPostal;
    return businessState;
  }
  if (action is SetBusinessCityTown) {
    businessState.cityTown = action.cityTown;
    return businessState;
  }
  if (action is SetBusinessCountry) {
    businessState.country = action.country;
    return businessState;
  }
  if (action is SetBusinessAddressOptional) {
    businessState.addressOptional = action.addressOptional;
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
  if (action is SetBusinessWide) {
    businessState.wide = action.wide;
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
  if (action is SetHub) {
    businessState.hub = action.hub;
    return businessState;
  }
  if (action is BusinessRequestResponse) {
    businessState = action.businessState.copyWith(); // TODO check validity of the copyWith
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
  if (action is AddBusinessArea) {
    businessState.area.add(action.area);
    return businessState;
  }
  if (action is SetBusinessOwner) {
    businessState.owner = action.owner;
    return businessState;
  }
  if (action is AddFileToUploadInBusiness) {
    print("business_reducer: addFileInbusiness. business: " + state.name);

    businessState.fileToUploadList = [];

    if (state.fileToUploadList != null) {
      print("business_reducer: fileuploadlist != null");

      businessState.fileToUploadList
        ..addAll(state.fileToUploadList);

    }

    replaceIfExists(businessState.fileToUploadList, action.fileToUpload);

    businessState.fileToUploadList.forEach((element) {
      if(element.remoteName != null)
        print("business_reducer: " + element.remoteName);
    });
    return businessState;
  }
  return state;
}

void replaceIfExists(List<OptimumFileToUpload> fileToUploadList, OptimumFileToUpload myFile){
  bool replaced = false;
  if(fileToUploadList.isNotEmpty){
    fileToUploadList.forEach((element) {
      if(element.remoteFolder == myFile.remoteFolder){
        element = myFile;
        replaced = true;
      }
    });
  }else{

  }

  if(!replaced){
    fileToUploadList.add(myFile);
  }
}
