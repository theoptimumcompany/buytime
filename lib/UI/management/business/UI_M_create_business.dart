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
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';
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
  int steps = 4;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  List<String> tag = [];

  // TODO insert the real dynamic content
  List<GenericState> reportList = [GenericState(name: "Hotel"), GenericState(name: "Spa"), GenericState(name: "Restaurant")];

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
  final GlobalKey<FormState> _formKeySalesmanNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySalesmanPhonenumberFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyConciergePhonenumberFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyEmailField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyVatField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStreetNumberField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyZipField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyMunicipalityField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStateField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyNationField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCoordinateField = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCoordinateFieldEdit = GlobalKey<FormState>();

  //final GlobalKey<FormState> _formKeyDescriptionField = GlobalKey<FormState>();

  bool isSelected = false;

  ///Controllers
  ///Definition
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _responsiblePersonNameController = TextEditingController();
  TextEditingController _responsiblePersonSurnameController = TextEditingController();
  TextEditingController _responsiblePersonEmailController = TextEditingController();
  TextEditingController _salesmanNameController = TextEditingController();
  TextEditingController _salesmanPhonenumberController = TextEditingController();
  TextEditingController _conciergePhonenumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _vatController = TextEditingController();
  TextEditingController _tagController = TextEditingController();

  ///Address
  TextEditingController _addressController = TextEditingController();

  ///Address Details
  TextEditingController _streetController = TextEditingController();
  TextEditingController _streetNumberController = TextEditingController();

  // TextEditingController _zipController = TextEditingController();
  // TextEditingController _municipalityController = TextEditingController();
  // TextEditingController _stateController = TextEditingController();
  // TextEditingController _nationController = TextEditingController();

  TextEditingController _addressOptionalController = TextEditingController();
  TextEditingController _zipPostalController = TextEditingController();
  TextEditingController _cityTownController = TextEditingController();
  TextEditingController _stateTerritoryProvinceController = TextEditingController();
  TextEditingController _countryController = TextEditingController();

  TextEditingController _coordinateController = TextEditingController();

  ///Company Information
  TextEditingController _areaController = TextEditingController();

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

  List<String> hubType = [];
  List<String> notHubType = [];
  List<String> businessType = [];

  bool isHub = false;
  bool required = false;

  bool validate(BusinessState business) {
    if (business.name != null &&
        business.name.isNotEmpty &&
        business.responsible_person_name != null &&
        business.responsible_person_name.isNotEmpty &&
        business.responsible_person_surname != null &&
        business.responsible_person_surname.isNotEmpty &&
        business.phoneSalesman != null &&
        business.phoneSalesman.isNotEmpty &&
        business.phoneConcierge != null &&
        business.phoneConcierge.isNotEmpty &&
        business.email != null &&
        business.email.isNotEmpty &&
        business.VAT != null &&
        business.VAT.isNotEmpty &&
        business.business_type != null &&
        business.business_type.isNotEmpty &&
        business.businessAddress != null &&
        business.businessAddress.isNotEmpty &&
        business.coordinate != null &&
        business.coordinate.isNotEmpty &&
        business.area != null &&
        business.area.isNotEmpty &&
        business.logo != null &&
        business.logo.isNotEmpty &&
        business.wide != null &&
        business.wide.isNotEmpty &&
        business.profile != null &&
        business.profile.isNotEmpty &&
        business.gallery != null &&
        business.gallery.isNotEmpty) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
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
                    data: ThemeData(primaryColor: BuytimeTheme.ManagerPrimary, accentColor: BuytimeTheme.Secondary),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Flexible(
                                  child: StoreConnector<AppState, BusinessState>(
                                      converter: (store) => store.state.business,
                                      onInit: (store) {
                                        store.dispatch(new SetBusinessToEmpty());
                                        //store.state.business.business_type = [GenericState(name: 'Bar')];
                                        hubType = ['Hotel', 'Eco', 'Service Center', 'Center(Membership)'];

                                        //hubType.sort((a,b) => a.name.compareTo(b.name));
                                        notHubType = [
                                          'Bar',
                                          'Bike Renting',
                                          'Museum',
                                          'Diving and Sailing Center',
                                          'Motor Rental',
                                          'Tour Operator',
                                          'Wellness',
                                        ];
                                      },
                                      builder: (context, snapshot) {
                                        String businessName = snapshot.name != null ? snapshot.name : "";
                                        tag = snapshot.tag;
                                        if (snapshot.area.isEmpty) snapshot.area = ['Reception'];
                                        if (snapshot.hub != null && snapshot.business_type != null) {
                                          if (snapshot.business_type.isNotEmpty) businessType = snapshot.business_type;
                                          if (isHub != snapshot.hub) {
                                            snapshot.business_type.clear();
                                            businessType = [];
                                            //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([]));
                                            if (snapshot.hub) {
                                              debugPrint('UI_M_create_business => NOW IS HUB');
                                              //snapshot.business_type = [GenericState(name: 'Hotel')];
                                              businessType = ['Hotel'];
                                              //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([GenericState(name: 'Hotel')]));
                                            } else {
                                              debugPrint('UI_M_create_business => NOW IS NOT A HUB');
                                              //snapshot.business_type = [GenericState(name: 'Bar')];
                                              businessType = ['Bar'];
                                              //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([GenericState(name: 'Bar')]));
                                            }
                                            isHub = snapshot.hub;
                                          }
                                          debugPrint('UI_M_create_business => BUSINESS TYPE LENGTH: ${snapshot.business_type.length}');
                                          snapshot.business_type.forEach((element) {
                                            debugPrint('UI_M_create_business => BUSINESS TYPE: ${element}');
                                          });
                                        }
                                        return Column(
                                          children: [
                                            /*Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "* = " + AppLocalizations.of(context).required,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.AccentRed
                                                        ),
                                                      ),
                                                    ),*/
                                            Stepper(
                                              steps: [
                                                ///Definition
                                                Step(
                                                  title: Text(
                                                    AppLocalizations.of(context).definition,
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600),
                                                  ),
                                                  isActive: currentStep == 0 ? true : false,
                                                  state: currentStep == 0 ? StepState.editing : StepState.indexed,
                                                  content: Column(
                                                    children: <Widget>[
                                                      ///Publish
                                                      Row(
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(context).publish,
                                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600),
                                                          ),
                                                          Switch(
                                                              activeColor: BuytimeTheme.ManagerPrimary,
                                                              value: !snapshot.draft,
                                                              onChanged: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessDraft(!value));
                                                              })
                                                        ],
                                                      ),

                                                      ///Business Name
                                                      OptimumFormField(
                                                        required: required,
                                                        controller: _businessNameController,
                                                        field: "businessName",
                                                        textInputType: TextInputType.text,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).companyName,
                                                        globalFieldKey: _formKeyNameField,
                                                        typeOfValidate: "name",
                                                        validateEmail: true,
                                                        //initialFieldValue: snapshot.name,
                                                        onSaveOrChangedCallback: (value) {
                                                          setState(() {
                                                            businessName = value;
                                                          });
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessName(value));
                                                        },
                                                      ),

                                                      ///Responsible Name
                                                      OptimumFormField(
                                                        required: required,
                                                        controller: _responsiblePersonNameController,
                                                        field: "responsible_person_name",
                                                        textInputType: TextInputType.text,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).responsibleName,
                                                        globalFieldKey: _formKeyResponsablePersonNameField,
                                                        validateEmail: true,
                                                        typeOfValidate: "name",
                                                        // initialFieldValue: snapshot.responsible_person_name,
                                                        onSaveOrChangedCallback: (value) {
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonName(value));
                                                        },
                                                      ),

                                                      ///Responsible Surname
                                                      OptimumFormField(
                                                        required: required,
                                                        controller: _responsiblePersonSurnameController,
                                                        field: "responsible_person_surname",
                                                        textInputType: TextInputType.text,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).responsibleSurname,
                                                        globalFieldKey: _formKeyResponsablePersonSurnameField,
                                                        validateEmail: true,
                                                        typeOfValidate: "name",
                                                        //initialFieldValue: snapshot.responsible_person_surname,
                                                        onSaveOrChangedCallback: (value) {
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonSurname(value));
                                                        },
                                                      ),

                                                      ///Responsible Email
                                                      OptimumFormField(
                                                        controller: _responsiblePersonEmailController,
                                                        field: "responsible_person_email",
                                                        textInputType: TextInputType.text,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).responsibleEmail,
                                                        globalFieldKey: _formKeyResponsablePersonEmailField,
                                                        typeOfValidate: "email",
                                                        //initialFieldValue: snapshot.responsible_person_email,
                                                        onSaveOrChangedCallback: (value) {
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonEmail(value));
                                                        },
                                                      ),

                                                      ///Salesman Name
                                                      Container(
                                                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                                                          child: Form(
                                                            key: _formKeySalesmanNameFieldEdit,
                                                            child: TextFormField(
                                                              //enabled: false,
                                                              //focusNode: focusNode,
                                                              //initialValue: widget.initialFieldValue,
                                                              controller: _salesmanNameController,
                                                              onChanged: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessSalesmanName(value));
                                                              },
                                                              keyboardType: TextInputType.text,
                                                              validator: (String value) {
                                                                if (true && value.isNotEmpty) {
                                                                  return "test " + AppLocalizations.of(context).required;
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                                                              decoration: InputDecoration(
                                                                labelText: AppLocalizations.of(context).salesmanName,
                                                                errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                              ),
                                                              onSaved: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessSalesmanName(value));
                                                              },
                                                            ),
                                                          )),

                                                      ///Salesman Phone Number
                                                      Container(
                                                          margin: EdgeInsets.only(bottom: 10, top: SizeConfig.safeBlockVertical * 0),
                                                          child: Form(
                                                            key: _formKeySalesmanPhonenumberFieldEdit,
                                                            child: TextFormField(
                                                              //maxLength: 10,
                                                              //enabled: false,
                                                              //focusNode: focusNode,
                                                              //initialValue: widget.initialFieldValue,
                                                              controller: _salesmanPhonenumberController,
                                                              onChanged: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessSalesmanPhonenumber(value));
                                                              },
                                                              keyboardType: TextInputType.number,
                                                              textInputAction: TextInputAction.done,
                                                              validator: (String value) {
                                                                if (true && value.isNotEmpty) {
                                                                  return "test " + AppLocalizations.of(context).required;
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                                                              decoration: InputDecoration(
                                                                //counter: Container(),
                                                                helperText: required && _salesmanPhonenumberController.text.isEmpty ? '~ ${AppLocalizations.of(context).required}' : null,
                                                                helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                labelText: AppLocalizations.of(context).salesmanPhonenumber,
                                                                errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                              ),
                                                              onSaved: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessSalesmanPhonenumber(value));
                                                              },
                                                            ),
                                                          )),

                                                      ///Concierge Phone Number
                                                      Container(
                                                          margin: EdgeInsets.only(bottom: 15, top: SizeConfig.safeBlockVertical * 0),
                                                          child: Form(
                                                            key: _formKeyConciergePhonenumberFieldEdit,
                                                            child: TextFormField(
                                                              //maxLength: 10,
                                                              //enabled: false,
                                                              //focusNode: focusNode,
                                                              //initialValue: widget.initialFieldValue,
                                                              controller: _conciergePhonenumberController,
                                                              onChanged: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessConciergePhonenumber(value));
                                                              },
                                                              keyboardType: TextInputType.number,
                                                              validator: (String value) {
                                                                if (true && value.isNotEmpty) {
                                                                  return "test " + AppLocalizations.of(context).required;
                                                                }
                                                                return null;
                                                              },
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                                                              decoration: InputDecoration(
                                                                helperText: required && _conciergePhonenumberController.text.isEmpty ? '~ ${AppLocalizations.of(context).required}' : null,
                                                                helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                labelText: AppLocalizations.of(context).conciergePhonenumber,
                                                                errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                              ),
                                                              onSaved: (value) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessConciergePhonenumber(value));
                                                              },
                                                            ),
                                                          )),

                                                      ///Email
                                                      OptimumFormField(
                                                        required: required,
                                                        controller: _emailController,
                                                        field: "mail",
                                                        textInputType: TextInputType.text,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).businessEmail,
                                                        globalFieldKey: _formKeyEmailField,
                                                        validateEmail: true,
                                                        typeOfValidate: "email",
                                                        //initialFieldValue: snapshot.email,
                                                        onSaveOrChangedCallback: (value) {
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessEmail(value));
                                                        },
                                                      ),

                                                      ///Vat
                                                      OptimumFormField(
                                                        required: required,
                                                        controller: _vatController,
                                                        field: "vat",
                                                        textInputType: TextInputType.number,
                                                        minLength: 3,
                                                        label: AppLocalizations.of(context).vatNumber,
                                                        globalFieldKey: _formKeyVatField,
                                                        validateEmail: true,
                                                        typeOfValidate: "number",
                                                        //initialFieldValue: snapshot.VAT,
                                                        onSaveOrChangedCallback: (value) {
                                                          StoreProvider.of<AppState>(context).dispatch(SetBusinessVAT(value));
                                                        },
                                                      ),

                                                      ///Type Of Business
                                                      /*Padding(
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
                                                            ),*/
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'HUB',
                                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, color: BuytimeTheme.TextGrey, fontSize: 16),
                                                          ),
                                                          Switch(
                                                              activeColor: BuytimeTheme.ManagerPrimary,
                                                              value: snapshot.hub,
                                                              onChanged: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                                                  ? (value) {
                                                                      debugPrint('UI_M-create_business => HUB: $value');
                                                                      setState(() {
                                                                        //isHub = value;
                                                                      });
                                                                      StoreProvider.of<AppState>(context).dispatch(SetHub(value));
                                                                      //snapshot.hub = value;
                                                                    }
                                                                  : (value) {}),
                                                        ],
                                                      ),

                                                      ///Business Type
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                          Row(
                                                            children: [
                                                              Text(
                                                                AppLocalizations.of(context).businessType,
                                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 14, fontWeight: FontWeight.w600),
                                                              ),
                                                              required && snapshot.business_type.isEmpty
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(left: 5),
                                                                      child: Text(
                                                                        '~ ' + AppLocalizations.of(context).required,
                                                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                          snapshot.hub
                                                              ? OptimumChip(
                                                                  chipList: hubType,
                                                                  selectedChoices: businessType,
                                                                  optimumChipListToDispatch: (List<String> selectedChoices) {
                                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessType(selectedChoices));
                                                                  },
                                                                )
                                                              : OptimumChip(
                                                                  chipList: notHubType,
                                                                  selectedChoices: businessType,
                                                                  optimumChipListToDispatch: (List<String> selectedChoices) {
                                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessType(selectedChoices));
                                                                  },
                                                                ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ///Address
                                                Step(
                                                    title: Text(
                                                      AppLocalizations.of(context).address,
                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600),
                                                    ),
                                                    isActive: currentStep == 1 ? true : false,
                                                    state: currentStep == 1 ? StepState.editing : StepState.indexed,
                                                    content: Column(
                                                      children: <Widget>[
                                                        ///Address
                                                        Container(
                                                          margin: EdgeInsets.only(top: 2.0, bottom: 5.0),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Flexible(
                                                                child: Container(
                                                                    width: media.width * 0.9,
                                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                                    //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                                                    child: TextFormField(
                                                                      enabled: false,
                                                                      readOnly: true,
                                                                      keyboardType: TextInputType.multiline,
                                                                      maxLines: null,
                                                                      controller: _addressController,
                                                                      //initialValue: _serviceAddress,
                                                                      onChanged: (value) {
                                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessAddress(_addressController.text));
                                                                      },
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey),
                                                                      decoration: InputDecoration(
                                                                        labelText: AppLocalizations.of(context).businessAddress,
                                                                        helperText: required && _addressController.text.isEmpty ? '~ ' + AppLocalizations.of(context).required : null,
                                                                        helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                        //hintText: AppLocalizations.of(context).addressOptional,
                                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                      ),
                                                                    )),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: 25.0),
                                                                child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.add_location_rounded,
                                                                    color: BuytimeTheme.ManagerPrimary,
                                                                  ),
                                                                  onPressed: () {
                                                                    Utils.googleSearch(context, (place) {
                                                                      //_serviceAddress = store.state.business.street + ', ' + store.state.business.street_number + ', ' + store.state.business.ZIP + ', ' + store.state.business.state_province;
                                                                      ///Address
                                                                      _addressController.text = place[0];
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessAddress(_addressController.text));

                                                                      ///Address Details
                                                                      _coordinateController.text = '${place[1]}, ${place[2]}';
                                                                      _streetController.clear();
                                                                      _streetNumberController.clear();
                                                                      _zipPostalController.clear();
                                                                      _cityTownController.clear();
                                                                      _stateTerritoryProvinceController.clear();
                                                                      _countryController.clear();
                                                                      place[3].forEach((element) {
                                                                        if (element[0].contains('route') || element[0].contains('natural_feature') || element[0].contains('establishment')) _streetController.text = element[1];
                                                                        if (element[0].contains('street_number')) _streetNumberController.text = element[1];
                                                                        if (element[0].contains('postal_code')) _zipPostalController.text = element[1];
                                                                        if (element[0].contains('administrative_area_level_2') || element[0].contains('administrative_area_level_3')) _cityTownController.text = element[2];
                                                                        if (element[0].contains('administrative_area_level_1')) _stateTerritoryProvinceController.text = element[1];
                                                                        if (element[0].contains('country')) _countryController.text = element[2];
                                                                      });
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessStreet(_streetController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessStreetNumber(_streetNumberController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessZipPostal(_zipPostalController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessCityTown(_cityTownController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessStateTerritoryProvince(_stateTerritoryProvinceController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessCountry(_countryController.text));
                                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(_coordinateController.text));
                                                                    });
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),

                                                        ///Coordinate
                                                        Container(
                                                            margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, top: SizeConfig.safeBlockVertical * 1),
                                                            child: Form(
                                                              key: _formKeyCoordinateFieldEdit,
                                                              child: TextFormField(
                                                                enabled: false,
                                                                //focusNode: focusNode,
                                                                //initialValue: widget.initialFieldValue,
                                                                controller: _coordinateController,
                                                                onChanged: (value) {
                                                                  StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(value));
                                                                },
                                                                keyboardType: TextInputType.text,
                                                                validator: (String value) {
                                                                  if (true && value.isNotEmpty) {
                                                                    return "test " + AppLocalizations.of(context).required;
                                                                  }
                                                                  return null;
                                                                },
                                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey),
                                                                decoration: InputDecoration(
                                                                  helperText: required && _coordinateController.text.isEmpty ? '~ ' + AppLocalizations.of(context).required : null,
                                                                  helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                  labelText: AppLocalizations.of(context).coordinate,
                                                                  errorStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                ),
                                                                onSaved: (value) {
                                                                  StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(value));
                                                                },
                                                              ),
                                                            )),
                                                      ],
                                                    )),

                                                ///Address Details
                                                Step(
                                                    title: Text(
                                                      AppLocalizations.of(context).invoiceDetails,
                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600),
                                                    ),
                                                    isActive: currentStep == 2 ? true : false,
                                                    state: currentStep == 2 ? StepState.editing : StepState.indexed,
                                                    content: Column(
                                                      children: <Widget>[
                                                        ///Street
                                                        OptimumFormField(
                                                          controller: _streetController,
                                                          field: "street",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          label: AppLocalizations.of(context).street,
                                                          globalFieldKey: _formKeyStreetField,
                                                          validateEmail: true,
                                                          typeOfValidate: "name",
                                                          //initialFieldValue: snapshot.street,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessStreet(value));
                                                          },
                                                        ),

                                                        ///Street numnber
                                                        OptimumFormField(
                                                          controller: _streetNumberController,
                                                          field: "streetNumber",
                                                          textInputType: TextInputType.number,
                                                          minLength: 1,
                                                          label: AppLocalizations.of(context).streetNumber,
                                                          globalFieldKey: _formKeyStreetNumberField,
                                                          validateEmail: true,
                                                          typeOfValidate: "number",
                                                          //initialFieldValue: snapshot.street_number,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessStreetNumber(value));
                                                          },
                                                        ),

                                                        ///Zip
                                                        OptimumFormField(
                                                          controller: _zipPostalController,
                                                          field: "zipPostal",
                                                          textInputType: TextInputType.number,
                                                          minLength: 3,
                                                          label: AppLocalizations.of(context).zip,
                                                          globalFieldKey: _formKeyZipField,
                                                          typeOfValidate: "number",
                                                          //initialFieldValue: snapshot.ZIP,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessZipPostal(value));
                                                          },
                                                        ),

                                                        ///Municipality
                                                        OptimumFormField(
                                                          controller: _cityTownController,
                                                          field: "cityTown",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          label: AppLocalizations.of(context).cityTown,
                                                          globalFieldKey: _formKeyMunicipalityField,
                                                          typeOfValidate: "name",
                                                          //initialFieldValue: snapshot.municipality,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessCityTown(value));
                                                          },
                                                        ),

                                                        ///State
                                                        OptimumFormField(
                                                          controller: _stateTerritoryProvinceController,
                                                          field: "stateTerritoryProvince",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          label: AppLocalizations.of(context).stateTerritoryProvince,
                                                          globalFieldKey: _formKeyStateField,
                                                          typeOfValidate: "name",
                                                          //initialFieldValue: snapshot.state_province,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessStateTerritoryProvince(value));
                                                          },
                                                        ),

                                                        ///Nation
                                                        OptimumFormField(
                                                          controller: _countryController,
                                                          field: "country",
                                                          textInputType: TextInputType.text,
                                                          minLength: 3,
                                                          label: AppLocalizations.of(context).country,
                                                          globalFieldKey: _formKeyNationField,
                                                          typeOfValidate: "name",
                                                          //initialFieldValue: snapshot.nation,
                                                          onSaveOrChangedCallback: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessCountry(value));
                                                          },
                                                        ),
                                                      ],
                                                    )),

                                                ///Company Information
                                                Step(
                                                  title: Text(
                                                    AppLocalizations.of(context).companyInformation,
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600),
                                                  ),
                                                  isActive: currentStep == 3 ? true : false,
                                                  state: currentStep == 3 ? StepState.editing : StepState.indexed,
                                                  content: Column(
                                                    children: <Widget>[
                                                      ///Description
                                                      /*OptimumFormField(
                                                                  field: "description",
                                                                  textInputType: TextInputType.text,
                                                                  minLength: 3,
                                                                  label: AppLocalizations.of(context).description + " *",
                                                                  globalFieldKey: _formKeyDescriptionField,
                                                                  validateEmail: true,
                                                                  typeOfValidate: "multiline",
                                                                  initialFieldValue: snapshot.description,
                                                                  onSaveOrChangedCallback: (value) {
                                                                    StoreProvider.of<AppState>(context).dispatch(SetBusinessDescription(value));
                                                                  },
                                                                ),*/

                                                      ///Tags
                                                      Container(
                                                        // height: media.height * 0.266,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                        decoration: BoxDecoration(),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                                                          child: Column(
                                                            children: [
                                                              ///Tag text
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 5.0, bottom: 10),
                                                                      child: Text(
                                                                        AppLocalizations.of(context).tag,
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                          color: BuytimeTheme.TextBlack,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w600,
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
                                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        labelText: AppLocalizations.of(context).addNewTag,
                                                                        //hintText: "email *",
                                                                        //hintStyle: TextStyle(color: Color(0xff666666)),
                                                                        labelStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Color(0xff666666), fontWeight: FontWeight.w400, fontSize: 16),
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
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if (_tagController.text.isNotEmpty) {
                                                                            snapshot.tag.add(_tagController.text);
                                                                            _tagController.clear();
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              /*Container(
                                                                  width: double.infinity,
                                                                  child: Row(
                                                                    children: listOfTagChips(tag),
                                                                  ),
                                                                ),*/
                                                              (snapshot.tag != null && snapshot.tag.length > 0)
                                                                  ? Container(
                                                                      margin: EdgeInsets.only(top: 10),
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
                                                                                  backgroundColor: BuytimeTheme.BackgroundLightGrey,
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

                                                      ///Business Area
                                                      Container(
                                                        // height: media.height * 0.266,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                                        decoration: BoxDecoration(),
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              ///Area text
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 0.0, bottom: 20),
                                                                      child: Text(
                                                                        AppLocalizations.of(context).serviceArea,
                                                                        textAlign: TextAlign.start,
                                                                        style: TextStyle(
                                                                          color: BuytimeTheme.TextBlack,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),

                                                              ///Add Area field & Add Area Button
                                                              Row(
                                                                children: [
                                                                  ///Add Tag field
                                                                  Container(
                                                                    //margin: EdgeInsets.only(top: 10.0),
                                                                    height: SizeConfig.safeBlockHorizontal * 10,
                                                                    width: SizeConfig.safeBlockHorizontal * 60,
                                                                    child: TextFormField(
                                                                      controller: _areaController,
                                                                      textAlign: TextAlign.start,
                                                                      decoration: InputDecoration(
                                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                        labelText: AppLocalizations.of(context).addNewArea,
                                                                        //hintText: "email *",
                                                                        //hintStyle: TextStyle(color: Color(0xff666666)),
                                                                        labelStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Color(0xff666666), fontWeight: FontWeight.w400, fontSize: 16),
                                                                      ),
                                                                      style: TextStyle(
                                                                        fontFamily: BuytimeTheme.FontFamily,
                                                                        color: Color(0xff666666),
                                                                        fontWeight: FontWeight.w800,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  ///Add Area button
                                                                  Container(
                                                                    child: IconButton(
                                                                      icon: Icon(
                                                                        Icons.add_circle_rounded,
                                                                        size: 24,
                                                                        color: BuytimeTheme.TextGrey,
                                                                      ),
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          if (_areaController.text.isNotEmpty) {
                                                                            if (snapshot.area == null) snapshot.area = [];

                                                                            snapshot.area.add(_areaController.text);
                                                                            _areaController.clear();
                                                                          }
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              /*Container(
                                                                  width: double.infinity,
                                                                  child: Row(
                                                                    children: listOfTagChips(tag),
                                                                  ),
                                                                ),*/
                                                              (snapshot.area != null && snapshot.area.length > 0)
                                                                  ? Wrap(
                                                                      spacing: 0,
                                                                      children: snapshot.area
                                                                          .map((e) => Container(
                                                                                margin: EdgeInsets.only(right: 5.0),
                                                                                child: InputChip(
                                                                                  backgroundColor: BuytimeTheme.BackgroundLightGrey,
                                                                                  selected: false,
                                                                                  label: Text(
                                                                                    e,
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
                                                                                  onDeleted: e == 'Reception' && snapshot.area.length == 1
                                                                                      ? null
                                                                                      : () {
                                                                                          setState(() {
                                                                                            snapshot.area.remove(e);
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
                                                                              ))
                                                                          .toList(),
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        ),
                                                      ),

                                                      ///Business Logo
                                                      Container(
                                                        margin: EdgeInsets.only(top: 15, bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '1. ${AppLocalizations.of(context).logo}',
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                            required && snapshot.logo.isEmpty
                                                                ? Container(
                                                                    margin: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '~ ' + AppLocalizations.of(context).required,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      OptimumFormMultiPhoto(
                                                        isWide: false,
                                                        text: '',
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

                                                      ///Photo Profile
                                                      Container(
                                                        margin: EdgeInsets.only(top: 15, bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '2. ${AppLocalizations.of(context).profile}',
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                            required && snapshot.profile.isEmpty
                                                                ? Container(
                                                                    margin: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '~ ' + AppLocalizations.of(context).required,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      OptimumFormMultiPhoto(
                                                        isWide: false,
                                                        text: '',
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

                                                      ///Business Gallery
                                                      Container(
                                                        margin: EdgeInsets.only(top: 15, bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '3.${AppLocalizations.of(context).gallery}',
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                            required && (snapshot.gallery != null && snapshot.gallery.first.isEmpty)
                                                                ? Container(
                                                                    margin: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '~ ' + AppLocalizations.of(context).required,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      OptimumFormMultiPhoto(
                                                        isWide: false,
                                                        text: '',
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

                                                      ///Business Wide
                                                      Container(
                                                        margin: EdgeInsets.only(top: 15, bottom: 5),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '4.${AppLocalizations.of(context).wide}',
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                            required && snapshot.wide.isEmpty
                                                                ? Container(
                                                                    margin: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '~ ' + AppLocalizations.of(context).required,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                      OptimumFormMultiPhoto(
                                                        isWide: true,
                                                        text: '',
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
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      /*currentStep == 0
                                                                ? Container()
                                                                : MaterialButton(
                                                              color: BuytimeTheme.ManagerPrimary,
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              onPressed: onStepCancel,
                                                              child: Text(AppLocalizations.of(context).back,
                                                                  style: TextStyle(
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.TextWhite
                                                                  )),
                                                            ),*/
                                                      currentStep != 3
                                                          ? Container(
                                                              height: 44,
                                                              width: 208,
                                                              margin: EdgeInsets.only(top: 10),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                              child: MaterialButton(
                                                                color: BuytimeTheme.ManagerPrimary,
                                                                elevation: 0,
                                                                hoverElevation: 0,
                                                                focusElevation: 0,
                                                                highlightElevation: 0,
                                                                onPressed: () {
                                                                  print("salesman board: Upload to DB");
                                                                  onStepContinue();
                                                                },
                                                                padding: EdgeInsets.all(0),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: new BorderRadius.circular(5),
                                                                ),
                                                                child: Text(AppLocalizations.of(context).next, style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontSize: 18)),
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 44,
                                                              width: 208,
                                                              margin: EdgeInsets.only(top: 10),
                                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                                                              child: MaterialButton(
                                                                color: BuytimeTheme.ManagerPrimary,
                                                                elevation: 0,
                                                                hoverElevation: 0,
                                                                focusElevation: 0,
                                                                highlightElevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: new BorderRadius.circular(5),
                                                                ),
                                                                onPressed: () {
                                                                  /*setState(() {
                                                                    required = validate(snapshot);
                                                                  });
                                                                  if (required) {
                                                                    final snackBar = SnackBar(content: Text(AppLocalizations.of(context).pleaseFillAllFields));
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                    print("buytime_salesman_create: validate problems");
                                                                    return;
                                                                  }*/
                                                                  setState(() {
                                                                    bookingRequest = 'send';
                                                                  });
                                                                  print("salesman board: Upload to DB");
                                                                  StoreProvider.of<AppState>(context).dispatch(CreateBusiness(snapshot));
                                                                },
                                                                child: Text(AppLocalizations.of(context).createBusiness, style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontSize: 18)),
                                                              ),
                                                            ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
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
                )),
          )),

          ///Ripple Effect
          bookingRequest.isNotEmpty
              ? Positioned.fill(
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
                                width: SizeConfig.safeBlockVertical * 20,
                                height: SizeConfig.safeBlockVertical * 20,
                                child: Center(
                                  child: SpinKitRipple(
                                    color: Colors.white,
                                    size: SizeConfig.safeBlockVertical * 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
