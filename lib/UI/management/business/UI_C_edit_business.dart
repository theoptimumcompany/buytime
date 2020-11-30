import 'dart:io';

import 'package:BuyTime/UI/management/business/UI_M_business.dart';
import 'package:BuyTime/UI/management/old_design/UI_M_Tabs.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'UI_C_business_list.dart';
import '../../../reusable/form/optimum_chip.dart';
import '../../../reusable/form/optimum_form_field.dart';
import 'package:BuyTime/reusable/form/optimum_form_multi_photo.dart' if (dart.library.html) 'package:BuyTime/reusable/form/optimum_form_multi_photo_web.dart';

class UI_EditBusiness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_EditBusinessState();
}

class UI_EditBusinessState extends State<UI_EditBusiness> {
  BuildContext context;
  int _index = 0;
  int currentStep = 0;
  bool complete = false;
  int steps = 3;
  final GlobalKey<FormState> _formKeyEdit = GlobalKey<FormState>();
  bool _autoValidate = false;

  next() {
    currentStep + 1 != steps ? goTo(currentStep + 1) : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  void initState() {
    super.initState();
  }

  bool _validateInputs() {
    if (_formKeyEdit.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKeyEdit.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void uploadFirestore(snapshot) {
    upload(File(snapshot.profile), 'profile', snapshot.id_firestore);
    upload(File(snapshot.logo), 'logo', snapshot.id_firestore);
    upload(File(snapshot.thumbnail), 'thumbnail', snapshot.id_firestore);
    for (int i = 0; i < snapshot.gallery.lenght; i++) {
      upload(File(snapshot.gallery[i]), 'gallery', snapshot.id_firestore);
    }
  }

  Future<void> upload(File file, String label, String id_firestore) async {
    StorageReference storageReference;

    storageReference = FirebaseStorage.instance.ref().child("Business/" + id_firestore + "/" + label + "/");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }

  // Single Global Key Form Fields
  final GlobalKey<FormState> _formKeyNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonSurnameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonEmailFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmailFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyVatFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetNumberFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyZipFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyMunicipalityFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStateFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNationFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCoordinateFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDescriptionFieldEdit = GlobalKey<FormState>();

  List<ObjectState> reportList = [ObjectState(name: "Hotel"),ObjectState(name:"Spa"),ObjectState(name: "Restaurant")];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    this.context = context;
    return Column(children: <Widget>[
      Form(
        key: _formKeyEdit,
        autovalidate: _autoValidate,
        child: Expanded(
          child: StoreConnector<AppState, BusinessState>(
              converter: (store) => store.state.business,
              onInit: (store) => {
              },
              builder: (context, snapshot) {
                String businessName = snapshot.name != null ? snapshot.name : "";
                print("BusinessName : " + businessName);
                return Stepper(
                  steps: [
                    Step(
                      title: Text('Definition'),
                      isActive: currentStep == 0 ? true : false,
                      state: currentStep == 0 ? StepState.editing : StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Text("Published"),
                              Switch(value: !snapshot.draft, onChanged: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessDraft(!value));
                              })
                            ],
                          ),
                          OptimumFormField(
                            field: "businessName",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Company Name'),
                            globalFieldKey: _formKeyNameFieldEdit,
                            typeOfValidate: "name",
                            initialFieldValue: snapshot.name,
                            onSaveOrChangedCallback: (value) {
                              setState(() {
                                businessName = value;
                              });
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessName(value));
                            },
                          ),
                          OptimumFormField(
                            field: "responsible_person_name",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Responsible Person Name'),
                            globalFieldKey: _formKeyResponsablePersonNameFieldEdit,
                            typeOfValidate: "name",
                            initialFieldValue: snapshot.responsible_person_name,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonName(value));
                            },
                          ),
                          OptimumFormField(
                            field: "responsible_person_surname",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Responsible Person Surname'),
                            globalFieldKey: _formKeyResponsablePersonSurnameFieldEdit,
                            typeOfValidate: "name",
                            initialFieldValue: snapshot.responsible_person_surname,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonSurname(value));
                            },
                          ),
                          OptimumFormField(
                            field: "responsible_person_email",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Responsible Person Email'),
                            globalFieldKey: _formKeyResponsablePersonEmailFieldEdit,
                            typeOfValidate: "email",
                            initialFieldValue: snapshot.responsible_person_email,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonEmail(value));
                            },
                          ),
                          OptimumFormField(
                            field: "mail",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Business Email'),
                            globalFieldKey: _formKeyEmailFieldEdit,
                            typeOfValidate: "email",
                            initialFieldValue: snapshot.email,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessEmail(value));
                            },
                          ),
                          OptimumFormField(
                            field: "vat",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'VAT Number'),
                            globalFieldKey: _formKeyVatFieldEdit,
                            typeOfValidate: "number",
                            initialFieldValue: snapshot.VAT,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessVAT(value));
                            },
                          ),
                        ],
                      ),
                    ),
                    Step(
                        title: Text('Address'),
                        isActive: currentStep == 1 ? true : false,
                        state: currentStep == 1 ? StepState.editing : StepState.indexed,
                        content: Column(
                          children: <Widget>[
                            OptimumFormField(
                              field: "street",
                              textInputType: TextInputType.text,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'Street'),
                              globalFieldKey: _formKeyStreetFieldEdit,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.street,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessStreet(value));
                              },
                            ),
                            OptimumFormField(
                              field: "streetNumber",
                              textInputType: TextInputType.text,
                              minLength: 1,
                              inputDecoration: InputDecoration(labelText: 'Street Number'),
                              globalFieldKey: _formKeyStreetNumberFieldEdit,
                              typeOfValidate: "number",
                              initialFieldValue: snapshot.street_number,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessStreetNumber(value));
                              },
                            ),
                            OptimumFormField(
                              field: "zip",
                              textInputType: TextInputType.number,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'ZIP'),
                              globalFieldKey: _formKeyZipFieldEdit,
                              typeOfValidate: "number",
                              initialFieldValue: snapshot.ZIP,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessZIP(value));
                              },
                            ),
                            OptimumFormField(
                              field: "municipality",
                              textInputType: TextInputType.text,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'Municipality'),
                              globalFieldKey: _formKeyMunicipalityFieldEdit,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.municipality,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessMunicipality(value));
                              },
                            ),
                            OptimumFormField(
                              field: "state",
                              textInputType: TextInputType.text,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'State'),
                              globalFieldKey: _formKeyStateFieldEdit,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.state_province,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessStateProvince(value));
                              },
                            ),
                            OptimumFormField(
                              field: "nation",
                              textInputType: TextInputType.text,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'Nation'),
                              globalFieldKey: _formKeyNationFieldEdit,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.nation,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessNation(value));
                              },
                            ),
                            OptimumFormField(
                              field: "coordinate",
                              textInputType: TextInputType.text,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'Coordinate'),
                              globalFieldKey: _formKeyCoordinateFieldEdit,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.coordinate,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(value));
                              },
                            ),
                          ],
                        )),
                    Step(
                      title: Text('Company Information'),
                      isActive: currentStep == 2 ? true : false,
                      state: currentStep == 2 ? StepState.editing : StepState.indexed,
                      content: Column(
                        children: <Widget>[
                          OptimumFormField(
                            field: "description",
                            textInputType: TextInputType.text,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'Description'),
                            globalFieldKey: _formKeyDescriptionFieldEdit,
                            typeOfValidate: "multiline",
                            initialFieldValue: snapshot.description,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessDescription(value));
                            },
                          ),
                          //Type Of Business
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: <Widget>[
                                Text("Type of Business"),
                                OptimumChip(
                                  chipList: reportList,
                                  selectedChoices: snapshot.business_type,
                                  optimumChipListToDispatch: (List<ObjectState> selectedChoices) {
                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessType(selectedChoices));
                                  },
                                ),
                              ],
                            ),
                          ),
                          //Business Logo
                          OptimumFormMultiPhoto(
                            text: "logo",
                            remotePath: "business/" + snapshot.name + "/logo",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            image: snapshot.logo == null || snapshot.logo.isEmpty ? null : Image.network(snapshot.logo, width: media.width * 0.3),
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/logo";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload));
                            },
                          ),
                          //Business Thumbnail
                          OptimumFormMultiPhoto(
                            text: "thumbnail",
                            remotePath: "business/" + snapshot.name + "/thumbnail",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            image: snapshot.thumbnail == null || snapshot.thumbnail.isEmpty ? null : Image.network(snapshot.thumbnail, width: media.width * 0.3),
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/thumbnail";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload));
                            },
                          ),
                          //Photo Profile
                          OptimumFormMultiPhoto(
                            text: "profile",
                            remotePath: "business/" + snapshot.name + "/profile",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            image: snapshot.profile == null || snapshot.profile.isEmpty ? null : Image.network(snapshot.profile, width: media.width * 0.3),
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/profile";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload));
                            },
                          ),
                          //Business Gallery
                          OptimumFormMultiPhoto(
                            text: "gallery",
                            remotePath: "business/" + snapshot.name + "/gallery",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            image: snapshot.gallery == null || snapshot.gallery.length == 0 || snapshot.gallery.isEmpty ? null :Image.network(snapshot.gallery[0], width: media.width * 0.3),
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/gallery";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  type: StepperType.vertical,
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                  controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) => StoreConnector<AppState, BusinessState>(
                    converter: (store) => store.state.business,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          currentStep == 0
                              ? Container()
                              : RaisedButton(
                                  onPressed: onStepCancel,
                                  child: const Text('Back!'),
                                ),
                          currentStep != 2
                              ? RaisedButton(
                                  onPressed: () {
                                    print("salesman board: Upload to DB");
                                    onStepContinue();
                                  },
                                  child: const Text('Next'),
                                )
                              : RaisedButton(
                                  onPressed: () {
                                    if (_validateInputs() == false) {
                                      print("buytime_salesman_edit: validate problems");
                                      return;
                                    }

                                    print("salesman board: Upload to DB");
                                    //uploadFirestore(snapshot);
                                    StoreProvider.of<AppState>(context).dispatch(new UpdateBusiness(snapshot));

                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => UI_M_Business()),
                                    );
                                  },
                                  child: const Text('Edit Business!'),
                                ),
                        ],
                      );
                    },
                  ),
                );
              }),
        ),
      ),
    ]);
  }
}
