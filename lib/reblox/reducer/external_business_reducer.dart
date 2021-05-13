import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/file/optimum_file_to_upload.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';

class SetExternalBusiness {
  ExternalBusinessState _businessState;

  SetExternalBusiness(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class SetExternalBusinessToEmpty {
  ExternalBusinessState _businessState;

  SetExternalBusinessToEmpty();

  ExternalBusinessState get businessState => _businessState;
}

class ExternalBusinessRequest {
  String _businessStateId;

  ExternalBusinessRequest(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class ExternalBusinessServiceListAndNavigateRequest {
  String _businessStateId;

  ExternalBusinessServiceListAndNavigateRequest(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class ExternalBusinessRequestAndNavigate {
  String _businessStateId;

  ExternalBusinessRequestAndNavigate(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class ExternalBusinessAndNavigateOnConfirmRequest {
  String _businessStateId;

  ExternalBusinessAndNavigateOnConfirmRequest(this._businessStateId);

  String get businessStateId => _businessStateId;
}

class UnlistenExternalBusiness {}

class UpdateExternalBusiness {
  ExternalBusinessState _businessState;

  UpdateExternalBusiness(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class UploadedFilesExternalBusinessCreate {
  ExternalBusinessState _businessState;

  UploadedFilesExternalBusinessCreate(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class AddFileToUploadInExternalBusiness {
  OptimumFileToUpload _fileToUpload;
  ImageState state;
  int index;

  AddFileToUploadInExternalBusiness(this._fileToUpload, this.state, this.index);

  OptimumFileToUpload get fileToUpload => _fileToUpload;
}

class UpdatedExternalBusiness {
  ExternalBusinessState _businessState;

  UpdatedExternalBusiness(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class CreateExternalBusiness {
  ExternalBusinessState _businessState;

  CreateExternalBusiness(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class CreatedExternalBusiness {
  ExternalBusinessState _businessState;

  CreatedExternalBusiness(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class CreatedExternalBusinessFromStore {
  ExternalBusinessState businessState;

  CreatedExternalBusinessFromStore();
}

class ExternalBusinessRequestResponse {
  ExternalBusinessState _businessState;

  ExternalBusinessRequestResponse(this._businessState);

  ExternalBusinessState get businessState => _businessState;
}

class SetExternalBusinessName {
  String _name;

  SetExternalBusinessName(this._name);

  String get name => _name;
}

class SetExternalBusinessAddress {
  String _address;

  SetExternalBusinessAddress(this._address);

  String get address => _address;
}

class SetExternalBusinessMunicipality {
  String _municipality;

  SetExternalBusinessMunicipality(this._municipality);

  String get municipality => _municipality;
}

class SetExternalBusinessResponsiblePersonName {
  String _responsible_person_name;

  SetExternalBusinessResponsiblePersonName(this._responsible_person_name);

  String get responsible_person_name => _responsible_person_name;
}

class SetExternalBusinessResponsiblePersonSurname {
  String _responsible_person_surname;

  SetExternalBusinessResponsiblePersonSurname(this._responsible_person_surname);

  String get responsible_person_surname => _responsible_person_surname;
}

class SetExternalBusinessResponsiblePersonEmail {
  String _responsible_person_email;

  SetExternalBusinessResponsiblePersonEmail(this._responsible_person_email);

  String get responsible_person_email => _responsible_person_email;
}

class SetExternalBusinessEmail {
  String _email;

  SetExternalBusinessEmail(this._email);

  String get email => _email;
}

class SetExternalBusinessVAT {
  String _VAT;

  SetExternalBusinessVAT(this._VAT);

  String get VAT => _VAT;
}

class SetExternalBusinessStreet {
  String _street;

  SetExternalBusinessStreet(this._street);

  String get street => _street;
}

class SetExternalBusinessStreetNumber {
  String _street_number;

  SetExternalBusinessStreetNumber(this._street_number);

  String get street_number => _street_number;
}

class SetExternalBusinessZIP {
  String _ZIP;

  SetExternalBusinessZIP(this._ZIP);

  String get ZIP => _ZIP;
}

class SetExternalBusinessStateProvince {
  String _state_province;

  SetExternalBusinessStateProvince(this._state_province);

  String get state_province => _state_province;
}

class SetExternalBusinessNation {
  String _nation;

  SetExternalBusinessNation(this._nation);

  String get nation => _nation;
}

class SetExternalBusinessDraft {
  bool _draft;

  SetExternalBusinessDraft(this._draft);

  bool get draft => _draft;
}

class SetExternalBusinessCoordinate {
  String _coordinate;

  SetExternalBusinessCoordinate(this._coordinate);

  String get coordinate => _coordinate;
}

class SetExternalBusinessProfile {
  String _profile;

  SetExternalBusinessProfile(this._profile);

  String get profile => _profile;
}

class SetExternalBusinessGallery {
  List<String> _gallery;

  SetExternalBusinessGallery(this._gallery);

  List<String> get gallery => _gallery;
}

class SetExternalBusinessWide {
  String _wide;

  SetExternalBusinessWide(this._wide);

  String get wide => _wide;
}

class SetExternalBusinessLogo {
  String _logo;

  SetExternalBusinessLogo(this._logo);

  String get logo => _logo;
}

class SetExternalBusinessType {
  List<GenericState> _business_type;

  SetExternalBusinessType(this._business_type);

  List<GenericState> get business_type => _business_type;
}

class SetExternalBusinessDescription {
  String _description;

  SetExternalBusinessDescription(this._description);

  String get description => _description;
}

class SetExternalBusinessIdFirestore {
  String _id_firestore;

  SetExternalBusinessIdFirestore(this._id_firestore);

  String get id_firestore => _id_firestore;
}

class SetExternalBusinessSalesman {
  GenericState _salesman;

  SetExternalBusinessSalesman(this._salesman);

  GenericState get salesman => _salesman;
}

class SetExternalBusinessOwner {
  GenericState _owner;

  SetExternalBusinessOwner(this._owner);

  GenericState get owner => _owner;
}

ExternalBusinessState externalBusinessReducer(ExternalBusinessState state, action) {
  ExternalBusinessState externalBusinessState = new ExternalBusinessState.fromState(state);
  if (action is SetExternalBusinessName) {
    externalBusinessState.name = action.name;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessAddress) {
    externalBusinessState.businessAddress = action.address;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessResponsiblePersonName) {
    externalBusinessState.responsible_person_name = action.responsible_person_name;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessResponsiblePersonSurname) {
    externalBusinessState.responsible_person_surname = action.responsible_person_surname;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessResponsiblePersonEmail) {
    externalBusinessState.responsible_person_email = action.responsible_person_email;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessEmail) {
    externalBusinessState.email = action.email;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessVAT) {
    externalBusinessState.VAT = action.VAT;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessStreet) {
    externalBusinessState.street = action.street;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessStreetNumber) {
    externalBusinessState.street_number = action.street_number;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessZIP) {
    externalBusinessState.ZIP = action.ZIP;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessStateProvince) {
    externalBusinessState.state_province = action.state_province;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessNation) {
    externalBusinessState.nation = action.nation;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessMunicipality) {
    externalBusinessState.municipality = action.municipality;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessCoordinate) {
    externalBusinessState.coordinate = action.coordinate;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessProfile) {
    externalBusinessState.profile = action.profile;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessGallery) {
    externalBusinessState.gallery = action.gallery;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessWide) {
    externalBusinessState.wide = action.wide;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessLogo) {
    print("business_reducer: set business logo is" + action.logo);
    externalBusinessState.logo = action.logo;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessType) {
    externalBusinessState.business_type = action.business_type;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessDescription) {
    externalBusinessState.description = action.description;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessIdFirestore) {
    externalBusinessState.id_firestore = action.id_firestore;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessDraft) {
    externalBusinessState.draft = action.draft;
    return externalBusinessState;
  }
  if (action is ExternalBusinessRequestResponse) {
    externalBusinessState = action.businessState.copyWith(); // TODO check validity of the copyWith
    return externalBusinessState;
  }
  if (action is SetExternalBusiness) {
    externalBusinessState = action.businessState.copyWith();
    return externalBusinessState;
  }
  if (action is SetExternalBusinessToEmpty) {
    externalBusinessState = ExternalBusinessState().toEmpty();
    return externalBusinessState;
  }
  if (action is SetExternalBusinessSalesman) {
    externalBusinessState.salesman = action.salesman;
    return externalBusinessState;
  }
  if (action is SetExternalBusinessOwner) {
    externalBusinessState.owner = action.owner;
    return externalBusinessState;
  }
  if (action is AddFileToUploadInExternalBusiness) {
    print("business_reducer: addFileInbusiness. business: " + state.name);

    externalBusinessState.fileToUploadList = [];

    if (state.fileToUploadList != null) {
      print("business_reducer: fileuploadlist != null");

      externalBusinessState.fileToUploadList
        ..addAll(state.fileToUploadList);

    }

    replaceIfExists(externalBusinessState.fileToUploadList, action.fileToUpload);

    externalBusinessState.fileToUploadList.forEach((element) {
      if(element.remoteName != null)
        print("business_reducer: " + element.remoteName);
    });
    return externalBusinessState;
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
