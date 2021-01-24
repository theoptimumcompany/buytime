import 'dart:io';
import 'package:BuyTime/UI/management/business/UI_M_business_list.dart';
import 'package:BuyTime/UI/management/old_design/UI_M_Tabs.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/business_state.dart';
import 'package:BuyTime/reblox/model/snippet/generic.dart';
import 'package:BuyTime/reblox/reducer/business_reducer.dart';
import 'package:BuyTime/reusable/form/optimum_form_field.dart';
import 'package:BuyTime/reusable/form/optimum_form_multi_photo.dart' if (dart.library.html) 'package:BuyTime/reusable/form/optimum_form_multi_photo_web.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../reusable/form/optimum_chip.dart';

class UI_CreateBusiness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_CreateBusinessState();
}

class UI_CreateBusinessState extends State<UI_CreateBusiness> {
  BuildContext context;
  int currentStep = 0;
  bool complete = false;
  int steps = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<GenericState> reportList = [GenericState(content: "Hotel"),GenericState(content:"Spa"),GenericState(content: "Restaurant")];

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

  void uploadFirestore(snapshot) {
    upload(File(snapshot.profile), 'profile', snapshot.id_firestore);
    upload(File(snapshot.logo), 'logo', snapshot.id_firestore);
    upload(File(snapshot.wide_card_photo), 'wide', snapshot.id_firestore);
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

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  // Single Global Key Form Fields
  final GlobalKey<FormState> _formKeyNameField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonNameField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonSurnameField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonEmailField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmailField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyVatField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetNumberField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyZipField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyMunicipalityField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStateField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNationField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCoordinateField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDescriptionField = GlobalKey<FormState>();

  bool isSelected = false;



  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Column(children: <Widget>[
      Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Expanded(
          child: StoreConnector<AppState, BusinessState>(
              converter: (store) => store.state.business,
              onInit: (store) => store.dispatch(new SetBusinessToEmpty()),
              builder: (context, snapshot) {
                String businessName = snapshot.name != null ? snapshot.name : "";
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
                            globalFieldKey: _formKeyNameField,
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
                            globalFieldKey: _formKeyResponsablePersonNameField,
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
                            globalFieldKey: _formKeyResponsablePersonSurnameField,
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
                            globalFieldKey: _formKeyResponsablePersonEmailField,
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
                            globalFieldKey: _formKeyEmailField,
                            typeOfValidate: "email",
                            initialFieldValue: snapshot.email,
                            onSaveOrChangedCallback: (value) {
                              StoreProvider.of<AppState>(context).dispatch(SetBusinessEmail(value));
                            },
                          ),
                          OptimumFormField(
                            field: "vat",
                            textInputType: TextInputType.number,
                            minLength: 3,
                            inputDecoration: InputDecoration(labelText: 'VAT Number'),
                            globalFieldKey: _formKeyVatField,
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
                              globalFieldKey: _formKeyStreetField,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.street,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessStreet(value));
                              },
                            ),
                            OptimumFormField(
                              field: "streetNumber",
                              textInputType: TextInputType.number,
                              minLength: 1,
                              inputDecoration: InputDecoration(labelText: 'Street Number'),
                              globalFieldKey: _formKeyStreetNumberField,
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
                              globalFieldKey: _formKeyZipField,
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
                              globalFieldKey: _formKeyMunicipalityField,
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
                              globalFieldKey: _formKeyStateField,
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
                              globalFieldKey: _formKeyNationField,
                              typeOfValidate: "name",
                              initialFieldValue: snapshot.nation,
                              onSaveOrChangedCallback: (value) {
                                StoreProvider.of<AppState>(context).dispatch(SetBusinessNation(value));
                              },
                            ),
                            OptimumFormField(
                              field: "coordinate",
                              textInputType: TextInputType.number,
                              minLength: 3,
                              inputDecoration: InputDecoration(labelText: 'Coordinate'),
                              globalFieldKey: _formKeyCoordinateField,
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
                            globalFieldKey: _formKeyDescriptionField,
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
                                  optimumChipListToDispatch: (List<GenericState> selectedChoices) {
                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessType(selectedChoices));
                                  },
                                ),
                              ],
                            ),
                          ),
                          //Business Logo
                          OptimumFormMultiPhoto(
                            text: "logo",
                            remotePath: "business/" + businessName + "/logo",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            onFilePicked: (fileToUpload) {
                                fileToUpload.remoteFolder = "business/" + businessName + "/logo";
                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 0));
                            },
                          ),
                          //Business Thumbnail
                          OptimumFormMultiPhoto(
                            text: "Wide",
                            remotePath: "business/" + businessName + "/wide",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/wide";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 1));
                            },
                          ),
                          //Photo Profile
                          OptimumFormMultiPhoto(
                            text: "profile",
                            remotePath: "business/" + businessName + "/profile",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/profile";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 2));
                            },
                          ),
                          //Business Gallery
                          OptimumFormMultiPhoto(
                            text: "gallery",
                            remotePath: "business/" + businessName + "/gallery",
                            maxHeight: 1000,
                            maxPhoto: 1,
                            maxWidth: 800,
                            minHeight: 200,
                            minWidth: 600,
                            onFilePicked: (fileToUpload) {
                              fileToUpload.remoteFolder = "business/" + businessName + "/gallery";
                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 3));
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
                                      print("buytime_salesman_create: validate problems");
                                      return;
                                    }

                                    print("salesman board: Upload to DB");
                                    StoreProvider.of<AppState>(context).dispatch(new CreateBusiness(snapshot));
//                                    StoreProvider.of<AppState>(context).dispatch(new UpdateBusiness(snapshot));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => UI_M_BusinessList()),
                                    );
                                  },
                                  child: const Text('Create Business!'),
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
