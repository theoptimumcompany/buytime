import 'dart:io';
import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/reusable/form/optimum_form_field.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart' if (dart.library.html) 'package:Buytime/reusable/form/optimum_form_multi_photo_web.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../../reusable/form/optimum_chip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_M_CreateBusiness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_CreateBusinessState();
}

class UI_M_CreateBusinessState extends State<UI_M_CreateBusiness> {
  BuildContext context;
  int currentStep = 0;
  bool complete = false;
  int steps = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<String> tag = [];

  // TODO insert the real dynamic content
  List<GenericState> reportList = [GenericState(name: "Hotel"),GenericState(name:"Spa"),GenericState(name: "Restaurant")];

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
    upload(File(snapshot.wide), 'wide', snapshot.id_firestore);
    for (int i = 0; i < snapshot.gallery.lenght; i++) {
      upload(File(snapshot.gallery[i]), 'gallery', snapshot.id_firestore);
    }
  }

  Future<void> upload(File file, String label, String id_firestore) async {
    Reference storageReference;

    storageReference = FirebaseStorage.instance.ref().child("Business/" + id_firestore + "/" + label + "/");
    final UploadTask uploadTask = storageReference.putFile(file);
    final TaskSnapshot downloadUrl = (await uploadTask); // TODO check for radioactivity
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

  TextEditingController _tagController = TextEditingController();

  List<Widget> listOfTagChips(List<String> tags) {
    List<Widget> listOfWidget = new List();
    tags.forEach((element) {
      listOfWidget.add(InputChip(
        selected: false,
        label: Text(
          element,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));
    });

    return listOfWidget;
  }
  String bookingRequest = '';
  @override
  Widget build(BuildContext context) {
    this.context = context;
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Stack(
        children: [
          ///Create Business
          Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: WillPopScope(
                    onWillPop: () async {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                      //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_BusinessList(), exitPage: UI_M_CreateBusiness(), from: false));
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
                                    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_BusinessList()));
                                    Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_BusinessList(), exitPage: UI_M_CreateBusiness(), from: false));
                                  }),
                            ],
                          ),
                          ///Title
                          Utils.barTitle(AppLocalizations.of(context).businessCreation),
                          SizedBox(
                            width: 56.0,
                          )
                        ],
                      ),
                      body: Theme(
                        data: ThemeData(
                            primaryColor: BuytimeTheme.ManagerPrimary,
                            accentColor: BuytimeTheme.Secondary
                        ),
                        child: SafeArea(
                          child: Center(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Form(
                                          key: _formKey,
                                          autovalidate: _autoValidate,
                                          child: Flexible(
                                            child: StoreConnector<AppState, BusinessState>(
                                                converter: (store) => store.state.business,
                                                onInit: (store) => store.dispatch(new SetBusinessToEmpty()),
                                                builder: (context, snapshot) {
                                                  String businessName = snapshot.name != null ? snapshot.name : "";
                                                  tag = snapshot.tag;
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
                                                              label: AppLocalizations.of(context).companyName,
                                                              globalFieldKey: _formKeyNameField,
                                                              typeOfValidate: "name",
                                                              validateEmail: true,
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
                                                              label: AppLocalizations.of(context).responsibleName,
                                                              globalFieldKey: _formKeyResponsablePersonNameField,
                                                              validateEmail: true,
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
                                                              label: AppLocalizations.of(context).responsibleSurname,
                                                              globalFieldKey: _formKeyResponsablePersonSurnameField,
                                                              validateEmail: true,
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
                                                              label: AppLocalizations.of(context).responsibleEmail,
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
                                                              label: AppLocalizations.of(context).businessEmail,
                                                              globalFieldKey: _formKeyEmailField,
                                                              validateEmail: true,
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
                                                              label:  AppLocalizations.of(context).vatNumber,
                                                              globalFieldKey: _formKeyVatField,
                                                              validateEmail: true,
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
                                                                                  '${AppLocalizations.of(context).tag}',
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
                                                                                  labelText: '${AppLocalizations.of(context).addNewTag}',
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
                                                                label: AppLocalizations.of(context).street,
                                                                globalFieldKey: _formKeyStreetField,
                                                                validateEmail: true,
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
                                                                label: AppLocalizations.of(context).streetNumber,
                                                                globalFieldKey: _formKeyStreetNumberField,
                                                                validateEmail: true,
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
                                                                label: AppLocalizations.of(context).zip,
                                                                globalFieldKey: _formKeyZipField,
                                                                validateEmail: true,
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
                                                                label: AppLocalizations.of(context).municipality,
                                                                globalFieldKey: _formKeyMunicipalityField,
                                                                validateEmail: true,
                                                                typeOfValidate: "name",
                                                                initialFieldValue: snapshot.municipality,
                                                                onSaveOrChangedCallback: (value) {
                                                                  StoreProvider.of<AppState>(context).dispatch(SetBusinessMunicipality(value));
                                                                },
                                                              ),
                                                              OptimumFormField(
                                                                field: "state",
                                                                textInputType: TextInputType.text,
                                                                minLength: 2,
                                                                label: AppLocalizations.of(context).state,
                                                                globalFieldKey: _formKeyStateField,
                                                                validateEmail: true,
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
                                                                label: AppLocalizations.of(context).nation,
                                                                globalFieldKey: _formKeyNationField,
                                                                validateEmail: true,
                                                                typeOfValidate: "name",
                                                                initialFieldValue: snapshot.nation,
                                                                onSaveOrChangedCallback: (value) {
                                                                  StoreProvider.of<AppState>(context).dispatch(SetBusinessNation(value));
                                                                },
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                                child: OptimumFormField(
                                                                  field: "coordinate",
                                                                  textInputType: TextInputType.number,
                                                                  minLength: 3,
                                                                  label: AppLocalizations.of(context).coordinate,
                                                                  globalFieldKey: _formKeyCoordinateField,
                                                                  validateEmail: true,
                                                                  typeOfValidate: "name",
                                                                  initialFieldValue: snapshot.coordinate,
                                                                  onSaveOrChangedCallback: (value) {
                                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(value));
                                                                  },
                                                                ),
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
                                                              label: AppLocalizations.of(context).description,
                                                              globalFieldKey: _formKeyDescriptionField,
                                                              validateEmail: true,
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
                                                              remotePath: "business/" + businessName + "/logo",
                                                              maxHeight: 1000,
                                                              maxPhoto: 1,
                                                              maxWidth: 800,
                                                              minHeight: 200,
                                                              minWidth: 600,
                                                              roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                              cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                              onFilePicked: (fileToUpload) {
                                                                fileToUpload.remoteFolder = "business/" + businessName + "/logo";
                                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 0));
                                                              },
                                                            ),
                                                            //Business Wide
                                                            OptimumFormMultiPhoto(
                                                              text: AppLocalizations.of(context).wide,
                                                              remotePath: "business/" + businessName + "/wide",
                                                              maxHeight: 1000,
                                                              maxPhoto: 1,
                                                              maxWidth: 800,
                                                              minHeight: 200,
                                                              minWidth: 600,
                                                              roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                              cropAspectRatioPreset: CropAspectRatioPreset.ratio16x9,
                                                              onFilePicked: (fileToUpload) {
                                                                fileToUpload.remoteFolder = "business/" + businessName + "/wide";
                                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 1));
                                                              },
                                                            ),
                                                            //Photo Profile
                                                            OptimumFormMultiPhoto(
                                                              text: AppLocalizations.of(context).profile,
                                                              remotePath: "business/" + businessName + "/profile",
                                                              maxHeight: 1000,
                                                              maxPhoto: 1,
                                                              maxWidth: 800,
                                                              minHeight: 200,
                                                              minWidth: 600,
                                                              roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                              cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                              onFilePicked: (fileToUpload) {
                                                                fileToUpload.remoteFolder = "business/" + businessName + "/profile";
                                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 2));
                                                              },
                                                            ),
                                                            //Business Gallery
                                                            OptimumFormMultiPhoto(
                                                              text: AppLocalizations.of(context).gallery,
                                                              remotePath: "business/" + businessName + "/gallery",
                                                              maxHeight: 1000,
                                                              maxPhoto: 1,
                                                              maxWidth: 800,
                                                              minHeight: 200,
                                                              minWidth: 600,
                                                              roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                              cropAspectRatioPreset: CropAspectRatioPreset.square,
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
                                                              color: BuytimeTheme.ManagerPrimary,
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              onPressed: onStepCancel,
                                                              child: Text(
                                                                AppLocalizations.of(context).back,
                                                                style: TextStyle(
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: BuytimeTheme.TextWhite
                                                                ),),
                                                            ),
                                                            currentStep != 2
                                                                ? MaterialButton(
                                                              color: BuytimeTheme.ManagerPrimary,
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              onPressed: () {
                                                                print("salesman board: Upload to DB");
                                                                onStepContinue();
                                                              },
                                                              child: Text(AppLocalizations.of(context).next,
                                                                  style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.TextWhite
                                                                  )),
                                                            )
                                                                : MaterialButton(
                                                              color: BuytimeTheme.ManagerPrimary,
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              onPressed: () {
                                                                if (
                                                                    _validateInputs() == false ||
                                                                    StoreProvider.of<AppState>(context).state.business.fileToUploadList == null ||
                                                                    StoreProvider.of<AppState>(context).state.business.fileToUploadList.length < 4
                                                                ) {
                                                                  final snackBar = SnackBar(content: Text(AppLocalizations.of(context).pleaseFillAllFields));
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                  print("buytime_salesman_create: validate problems");
                                                                  return;
                                                                }
                                                                setState(() {
                                                                  bookingRequest = 'send';
                                                                });
                                                                print("salesman board: Upload to DB");
                                                                StoreProvider.of<AppState>(context).dispatch(CreateBusiness(snapshot));
                                                              },
                                                              child: Text(AppLocalizations.of(context).createBusiness,
                                                                  style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.TextWhite
                                                                  )),
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
      ),
    );
  }
}
