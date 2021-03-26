import 'dart:io';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../reusable/form/optimum_chip.dart';
import '../../../reusable/form/optimum_form_field.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart' if (dart.library.html) 'package:Buytime/reusable/form/optimum_form_multi_photo_web.dart';

class UI_M_EditBusiness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_EditBusinessState();
}

class UI_M_EditBusinessState extends State<UI_M_EditBusiness> {
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
      return AppLocalizations.of(context).nameMin;
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return AppLocalizations.of(context).enterValidEmail;
    else
      return null;
  }

  void uploadFirestore(snapshot) {
    upload(File(snapshot.profile), 'profile', snapshot.id_firestore);
    upload(File(snapshot.logo), 'logo', snapshot.id_firestore);
    upload(File(snapshot.wide), 'wide', snapshot.id_firestore);
    for (int i = 0; i < snapshot.gallery.lenght; i++) {
      upload(File(snapshot.gallery[i]), 'gallery', snapshot.id_firestore);
    }
  }

  Future<void> upload(File file, String label, String id_firestore) async {
    Reference storageReference;

    storageReference = FirebaseStorage.instance.ref().child("Business/" + id_firestore + "/" + label + "/");
    final UploadTask uploadTask = storageReference.putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask);
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

  List<GenericState> reportList = [GenericState(name: "Hotel"),GenericState(name:"Spa"),GenericState(name: "Restaurant")];
  TextEditingController _tagController = TextEditingController();

  String bookingRequest = '';

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    this.context = context;

    return Stack(
      children: [
        ///Edit Business
        Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: WillPopScope(
                  onWillPop: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()));
                    //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: UI_M_EditBusiness(), from: false));
                    return false;
                  },
                  child: Scaffold(
                    //resizeToAvoidBottomInset: false,
                    appBar: BuytimeAppbar(
                      width: media.width,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.chevron_left, color: BuytimeTheme.TextWhite),
                              onPressed: () {
                                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
                                Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: UI_M_EditBusiness(), from: false));
                              },
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  AppLocalizations.of(context).businessEdit,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                                    color: BuytimeTheme.TextWhite,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 50.0,
                        )
                      ],
                    ),
                    body: SafeArea(
                      child: Center(
                        child:SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Form(
                                      key: _formKeyEdit,
                                      autovalidate: _autoValidate,
                                      child: Flexible(
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
                                                    title: Text(AppLocalizations.of(context).definition),
                                                    isActive: currentStep == 0 ? true : false,
                                                    state: currentStep == 0 ? StepState.editing : StepState.indexed,
                                                    content: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(AppLocalizations.of(context).published),
                                                            Switch(value: !snapshot.draft, onChanged: (value) {
                                                              StoreProvider.of<AppState>(context).dispatch(SetBusinessDraft(!value));
                                                            })
                                                          ],
                                                        ),
                                                        OptimumFormField(
                                                          field: "businessName",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).companyName),
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
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).responsibleName),
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
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).responsibleSurname),
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
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).responsibleEmail),
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
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).businessEmail),
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
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).vatNumber),
                                                          globalFieldKey: _formKeyVatFieldEdit,
                                                          typeOfValidate: "number",
                                                          initialFieldValue: snapshot.VAT,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessVAT(value));
                                                          },
                                                        ),
                                                        ///Tags
                                                        Container(
                                                          // height: media.height * 0.266,
                                                          width: double.infinity,
                                                          decoration: BoxDecoration(
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    ///Tag text
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 5.0),
                                                                            child: Text(
                                                                              'Tag',
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(
                                                                                color: BuytimeTheme.TextGrey,
                                                                                fontSize: media.height * 0.023,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    ///Add Tag field & Add Tag Button
                                                                    Row(
                                                                      children: [
                                                                        ///Add Tag field
                                                                        Container(
                                                                          //margin: EdgeInsets.only(top: 10.0),
                                                                          height: SizeConfig.safeBlockHorizontal * 10,
                                                                          width: SizeConfig.safeBlockHorizontal * 30,
                                                                          child: TextFormField(
                                                                            controller: _tagController,
                                                                            textAlign: TextAlign.start,
                                                                            decoration: InputDecoration(
                                                                              enabledBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: Color(0xff666666)),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                              ),
                                                                              errorBorder: OutlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.redAccent),
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                                              ),
                                                                              labelText: 'Add new tag',
                                                                              //hintText: "email *",
                                                                              //hintStyle: TextStyle(color: Color(0xff666666)),
                                                                              labelStyle: TextStyle(
                                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                                color: Color(0xff666666),
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                            style: TextStyle(
                                                                              fontFamily: BuytimeTheme.FontFamily,
                                                                              color: Color(0xff666666),
                                                                              fontWeight: FontWeight.w800,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ///Add tag button
                                                                        Container(
                                                                          child: IconButton(
                                                                            icon: Icon(
                                                                              Icons.add_circle_rounded,
                                                                              size: 24,
                                                                              color: BuytimeTheme.TextGrey,
                                                                            ),
                                                                            onPressed: (){
                                                                              setState(() {
                                                                                if(_tagController.text.isNotEmpty) {
                                                                                  snapshot.tag.add(_tagController.text);
                                                                                  _tagController.clear();
                                                                                }
                                                                              });

                                                                            },
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                /*Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: listOfTagChips(tag),
                                    ),
                                  ),*/
                                                                (snapshot.tag.length > 0 && snapshot.tag != null)
                                                                    ? Container(
                                                                  height: media.height * 0.05,
                                                                  child: ListView.builder(
                                                                    scrollDirection: Axis.horizontal,
                                                                    itemCount: snapshot.tag.length,
                                                                    itemBuilder: (context, i) {
                                                                      return Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(left: 5.0),
                                                                            child: InputChip(
                                                                              selected: false,
                                                                              label: Text(
                                                                                snapshot.tag[i],
                                                                                style: TextStyle(
                                                                                  fontSize: 13.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                              //avatar: FlutterLogo(),
                                                                              onPressed: () {
                                                                                print('Manager is pressed');

                                                                                ///Vedere che fare quando si pigia il chip
                                                                                setState(() {
                                                                                  //_selected = !_selected;
                                                                                });
                                                                              },
                                                                              onDeleted: () {
                                                                                setState(() {
                                                                                  snapshot.tag.remove(snapshot.tag[i]);
                                                                                });
                                                                                /* Manager managerToDelete = Manager(id: "", name: "", surname: "", mail: managerList[i].mail);
                                                print("Mail di invito Manager da eliminare : " + managerList[i].mail);
                                                CategoryInviteState categoryInviteState = CategoryInviteState().toEmpty();
                                                categoryInviteState.role = "Manager";
                                                categoryInviteState.id_category = snapshot.category.id;
                                                categoryInviteState.mail = managerList[i].mail;
                                                StoreProvider.of<AppState>(context).dispatch(DeleteCategoryInvite(categoryInviteState));
                                                StoreProvider.of<AppState>(context).dispatch(new DeleteCategoryManager(managerToDelete));
                                                print('Manager is deleted');*/
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                )
                                                                    : Container()
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Step(
                                                      title: Text(AppLocalizations.of(context).address),
                                                      isActive: currentStep == 1 ? true : false,
                                                      state: currentStep == 1 ? StepState.editing : StepState.indexed,
                                                      content: Column(
                                                        children: <Widget>[
                                                          OptimumFormField(
                                                            field: "street",
                                                            textInputType: TextInputType.text,
                                                            minLength: 3,
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).street),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).streetNumber),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).zip),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).municipality),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).state),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).nation),
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
                                                            inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).coordinate),
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
                                                    title: Text(AppLocalizations.of(context).companyInformation),
                                                    isActive: currentStep == 2 ? true : false,
                                                    state: currentStep == 2 ? StepState.editing : StepState.indexed,
                                                    content: Column(
                                                      children: <Widget>[
                                                        OptimumFormField(
                                                          field: "description",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          inputDecoration: InputDecoration(labelText: AppLocalizations.of(context).description),
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
                                                              Text(AppLocalizations.of(context).typeOfBusiness),
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
                                                          text: AppLocalizations.of(context).logo,
                                                          remotePath: "business/" + snapshot.name + "/logo",
                                                          maxHeight: 1000,
                                                          maxPhoto: 1,
                                                          maxWidth: 800,
                                                          minHeight: 200,
                                                          minWidth: 500,
                                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                          image: snapshot.logo == null || snapshot.logo.isEmpty ? null : Image.network(snapshot.logo, width: media.width * 0.3),
                                                          onFilePicked: (fileToUpload) {
                                                            fileToUpload.remoteFolder = "business/" + businessName + "/logo";
                                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 0));
                                                          },
                                                        ),
                                                        //Business Thumbnail
                                                        OptimumFormMultiPhoto(
                                                          text: AppLocalizations.of(context).wide,
                                                          remotePath: "business/" + snapshot.name + "/wide",
                                                          maxHeight: 1000,
                                                          maxPhoto: 1,
                                                          maxWidth: 800,
                                                          minHeight: 200,
                                                          minWidth: 600,
                                                          cropAspectRatioPreset: CropAspectRatioPreset.ratio16x9,
                                                          image: snapshot.wide == null || snapshot.wide.isEmpty ? null : Image.network(snapshot.wide, width: media.width * 0.3),
                                                          onFilePicked: (fileToUpload) {
                                                            fileToUpload.remoteFolder = "business/" + businessName + "/wide";
                                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 1));
                                                          },
                                                        ),
                                                        //Photo Profile
                                                        OptimumFormMultiPhoto(
                                                          text: AppLocalizations.of(context).profile,
                                                          remotePath: "business/" + snapshot.name + "/profile",
                                                          maxHeight: 1000,
                                                          maxPhoto: 1,
                                                          maxWidth: 800,
                                                          minHeight: 200,
                                                          minWidth: 600,
                                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                          image: snapshot.profile == null || snapshot.profile.isEmpty ? null : Image.network(snapshot.profile, width: media.width * 0.3),
                                                          onFilePicked: (fileToUpload) {
                                                            fileToUpload.remoteFolder = "business/" + businessName + "/profile";
                                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 2));
                                                          },
                                                        ),
                                                        //Business Gallery
                                                        OptimumFormMultiPhoto(
                                                          text: AppLocalizations.of(context).gallery,
                                                          remotePath: "business/" + snapshot.name + "/gallery",
                                                          maxHeight: 1000,
                                                          maxPhoto: 1,
                                                          maxWidth: 800,
                                                          minHeight: 200,
                                                          minWidth: 600,
                                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                          image: snapshot.gallery == null || snapshot.gallery.length == 0 || snapshot.gallery.isEmpty ? null :Image.network(snapshot.gallery[0], width: media.width * 0.3),
                                                          onFilePicked: (fileToUpload) {
                                                            fileToUpload.remoteFolder = "business/" + businessName + "/gallery";
                                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 3));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                physics: ClampingScrollPhysics(),
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
                                                            : MaterialButton(
                                                          elevation: 0,
                                                          hoverElevation: 0,
                                                          focusElevation: 0,
                                                          highlightElevation: 0,
                                                          onPressed: onStepCancel,
                                                          child: Text(AppLocalizations.of(context).back),
                                                        ),
                                                        currentStep != 2
                                                            ? MaterialButton(
                                                          elevation: 0,
                                                          hoverElevation: 0,
                                                          focusElevation: 0,
                                                          highlightElevation: 0,
                                                          onPressed: () {
                                                            print("salesman board: Upload to DB");
                                                            onStepContinue();
                                                          },
                                                          child: Text(AppLocalizations.of(context).next),
                                                        )
                                                            : MaterialButton(
                                                          elevation: 0,
                                                          hoverElevation: 0,
                                                          focusElevation: 0,
                                                          highlightElevation: 0,
                                                          onPressed: () {
                                                            if (_validateInputs() == false) {
                                                              print("buytime_salesman_edit: validate problems");
                                                              return;
                                                            }

                                                            setState(() {
                                                              bookingRequest = 'send';
                                                            });

                                                            print("salesman board: Upload to DB");
                                                            //uploadFirestore(snapshot);
                                                            StoreProvider.of<AppState>(context).dispatch(new UpdateBusiness(snapshot));

                                                            /*Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => UI_M_Business()),
                                        );*/
                                                          },
                                                          child: Text(AppLocalizations.of(context).editBusiness),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ),
            )
        ),
        ///Ripple Effect
        bookingRequest.isNotEmpty ? Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                height: SizeConfig.safeBlockVertical * 100,
                decoration: BoxDecoration(
                  color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: SpinKitRipple(
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
        ) : Container()
      ],
    );
  }
}
