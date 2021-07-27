import 'dart:io';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../reusable/form/optimum_chip.dart';
import '../../../reusable/form/optimum_form_field.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';

class UI_M_EditBusiness extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_EditBusinessState();
}

class UI_M_EditBusinessState extends State<UI_M_EditBusiness> {
  BuildContext context;
  int _index = 0;
  int currentStep = 0;
  bool complete = false;
  int steps = 4;
  List<String> europeanCountries = ['Austria', 'Italy', 'Belgium', 'Latvia', 'Bulgaria', 'Lithuania', 'Croatia', 'Luxembourg', 'Cyprus', 'Malta', 'Czechia', 'Netherlands', 'Denmark', 'Poland', 'Estonia', 'Portugal', 'Finland', 'Romania', 'France', 'Slovakia', 'Germany', 'Slovenia', 'Greece', 'Spain', 'Hungary', 'Sweden', 'Ireland'];
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
        business.zipPostal != null &&
        business.zipPostal.isNotEmpty &&
        /*business.municipality != null &&
        business.municipality.isNotEmpty &&*/
        business.cityTown != null &&
        business.cityTown.isNotEmpty &&
        business.stateTerritoryProvince != null &&
        business.stateTerritoryProvince.isNotEmpty &&
        business.country != null &&
        business.country.isNotEmpty &&
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

  /// Single Global Key Form Fields
  final GlobalKey<FormState> _formKeyNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonSurnameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyResponsablePersonEmailFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySalesmanNameFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySalesmanPhonenumberFieldEdit = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyConciergePhonenumberFieldEdit = GlobalKey<FormState>();
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
  // TextEditingController _streetController = TextEditingController();
  // TextEditingController _streetNumberController = TextEditingController();
  // TextEditingController _zipController = TextEditingController();
  // TextEditingController _municipalityController = TextEditingController();
  // TextEditingController _stateController = TextEditingController();
  // TextEditingController _nationController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _streetNumberController = TextEditingController();

  TextEditingController _addressOptionalController = TextEditingController();
  TextEditingController _zipPostalController = TextEditingController();
  TextEditingController _cityTownController = TextEditingController();
  TextEditingController _stateTerritoryProvinceController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _coordinateController = TextEditingController();

  ///Company Information
  TextEditingController _areaController = TextEditingController();

  String bookingRequest = '';
  List<String> hubType = [];
  List<String> notHubType = [];
  String businessType = '';

  bool isHub = false;
  bool required = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    this.context = context;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Stack(
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
                        ],
                      ),

                      ///Title
                      Utils.barTitle(AppLocalizations.of(context).businessEdit),
                      SizedBox(
                        width: 50.0,
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
                                key: _formKeyEdit,
                                autovalidate: _autoValidate,
                                child: Flexible(
                                  child: StoreConnector<AppState, BusinessState>(
                                      converter: (store) => store.state.business,
                                      onInit: (store) {
                                        isHub = store.state.business.hub;
                                        hubType = ['Hotel', 'ECO', 'Center(Membership)'];

                                        //hubType.sort((a,b) => a.name.compareTo(b.name));
                                        notHubType = ['Bar', 'Bike Renting', 'Museum', 'Diving and Sailing Center', 'Motor Rental', 'Tour Operator', 'Wellness', 'Service Center'];
                                        //notHubType.sort((a,b) => a.name.compareTo(b.name));
                                        ///Definition
                                        _businessNameController.text = store.state.business.name;
                                        _responsiblePersonNameController.text = store.state.business.responsible_person_name;
                                        _responsiblePersonSurnameController.text = store.state.business.responsible_person_surname;
                                        _responsiblePersonEmailController.text = store.state.business.email;
                                        _salesmanNameController.text = store.state.business.salesmanName;
                                        _salesmanPhonenumberController.text = store.state.business.phoneSalesman;
                                        _conciergePhonenumberController.text = store.state.business.phoneConcierge;
                                        _emailController.text = store.state.business.responsible_person_email;
                                        _vatController.text = store.state.business.VAT;

                                        ///Address
                                        _addressController.text = store.state.business.businessAddress;
                                        _addressOptionalController.text = store.state.business.addressOptional;

                                        ///Address Details
                                        _streetController.text = store.state.business.street;
                                        _streetNumberController.text = store.state.business.street_number;
                                        _zipPostalController.text = store.state.business.zipPostal;
                                        _cityTownController.text = store.state.business.cityTown;
                                        _stateTerritoryProvinceController.text = store.state.business.stateTerritoryProvince;
                                        _countryController.text = store.state.business.country;
                                        _coordinateController.text = store.state.business.coordinate;
                                      },
                                      builder: (context, snapshot) {
                                        String businessName = snapshot.name != null ? snapshot.name : "";
                                        print("BusinessName : " + businessName);
                                        if (snapshot.area != null && snapshot.area.isEmpty) snapshot.area = ['Reception'];
                                        //else
                                        //snapshot.area = ['Reception'];

                                        if (snapshot.hub != null && snapshot.business_type != null) {
                                          if (snapshot.business_type.isNotEmpty)
                                            businessType = snapshot.business_type;
                                          else
                                            debugPrint('UI_M_create_business => HAS BUSINESSS TYPE');
                                          debugPrint('UI_M_create_business => BEFORE BUSINESS TYPE LENGTH: ${snapshot.business_type.length}');

                                          if (isHub != snapshot.hub) {
                                            snapshot.business_type = '';
                                            businessType = '';
                                            //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([]));
                                            if (snapshot.hub) {
                                              debugPrint('UI_M_create_business => NOW IS HUB');
                                              //snapshot.business_type = [GenericState(name: 'Hotel')];
                                              businessType = 'Hotel';
                                              //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([GenericState(name: 'Hotel')]));
                                            } else {
                                              debugPrint('UI_M_create_business => NOW IS NOT A HUB');
                                              //snapshot.business_type = [GenericState(name: 'Bar')];
                                              businessType = 'Bar';
                                              //StoreProvider.of<AppState>(context).dispatch(SetBusinessType([GenericState(name: 'Bar')]));
                                            }
                                            isHub = snapshot.hub;
                                          }
                                          debugPrint('UI_M_create_business => AFTER BUSINESS TYPE LENGTH: ${snapshot.business_type.length}');
                                        }
                                        return Stepper(
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
                                                    globalFieldKey: _formKeyNameFieldEdit,
                                                    typeOfValidate: "name",
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
                                                    globalFieldKey: _formKeyResponsablePersonNameFieldEdit,
                                                    typeOfValidate: "name",
                                                    //initialFieldValue: snapshot.responsible_person_name,
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
                                                    globalFieldKey: _formKeyResponsablePersonSurnameFieldEdit,
                                                    typeOfValidate: "name",
                                                    //initialFieldValue: snapshot.responsible_person_surname,
                                                    onSaveOrChangedCallback: (value) {
                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonSurname(value));
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
                                                          // maxLength: 10,
                                                          //enabled: false,
                                                          //focusNode: focusNode,
                                                          //initialValue: widget.initialFieldValue,
                                                          controller: _salesmanPhonenumberController,
                                                          onChanged: (value) {
                                                            StoreProvider.of<AppState>(context).dispatch(SetBusinessSalesmanPhonenumber(value));
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
                                                            helperText: required && _salesmanPhonenumberController.text.isEmpty ? '~ ${AppLocalizations.of(context).required}' : null,
                                                            helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                            //counter: Container(),
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
                                                            //counter: Container(),
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

                                                  ///Responsible Email
                                                  OptimumFormField(
                                                    controller: _responsiblePersonEmailController,
                                                    field: "responsible_person_email",
                                                    textInputType: TextInputType.emailAddress,
                                                    minLength: 3,
                                                    label: AppLocalizations.of(context).responsibleEmail,
                                                    globalFieldKey: _formKeyResponsablePersonEmailFieldEdit,
                                                    typeOfValidate: "email",
                                                    //initialFieldValue: snapshot.responsible_person_email,
                                                    onSaveOrChangedCallback: (value) {
                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessResponsiblePersonEmail(value));
                                                    },
                                                  ),

                                                  ///Email
                                                  OptimumFormField(
                                                    required: required,
                                                    controller: _emailController,
                                                    field: "mail",
                                                    textInputType: TextInputType.emailAddress,
                                                    minLength: 3,
                                                    label: AppLocalizations.of(context).businessEmail,
                                                    globalFieldKey: _formKeyEmailFieldEdit,
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
                                                    textInputType: TextInputType.text,
                                                    minLength: 3,
                                                    label: AppLocalizations.of(context).vatNumber,
                                                    globalFieldKey: _formKeyVatFieldEdit,
                                                    typeOfValidate: "number",
                                                    //initialFieldValue: snapshot.VAT,
                                                    onSaveOrChangedCallback: (value) {
                                                      StoreProvider.of<AppState>(context).dispatch(SetBusinessVAT(value));
                                                    },
                                                  ),

                                                  ///Type Of Business
                                                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ?
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'HUB',
                                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w600, color: BuytimeTheme.TextGrey, fontSize: 16),
                                                      ),
                                                      snapshot.hub != null
                                                          ? Switch(
                                                              activeColor: BuytimeTheme.ManagerPrimary,
                                                              value: snapshot.hub,
                                                              onChanged: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                                                  ? (value) {
                                                                      debugPrint('UI_M-create_business => HUB: ${value}');
                                                                      StoreProvider.of<AppState>(context).dispatch(SetHub(value));
                                                                      //snapshot.hub = value;
                                                                    }
                                                                  : (value) {})
                                                          : Switch(
                                                              activeColor: BuytimeTheme.ManagerPrimary,
                                                              value: false,
                                                              onChanged: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                                                  ? (value) {
                                                                      debugPrint('UI_M-create_business => HUB: $value');
                                                                      StoreProvider.of<AppState>(context).dispatch(SetHub(value));
                                                                    }
                                                                  : (value) {}),
                                                    ],
                                                  ) : Container(),

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
                                                              ? FittedBox(
                                                                  fit: BoxFit.scaleDown,
                                                                  child: Container(
                                                                    margin: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '~ ' + AppLocalizations.of(context).required,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: BuytimeTheme.AccentRed),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                      snapshot.hub
                                                          ? OptimumChip(
                                                              chipList: hubType,
                                                              selectedChoices: businessType,
                                                              optimumChipListToDispatch: (String selectedChoices) {
                                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessType(selectedChoices));
                                                              },
                                                            )
                                                          : OptimumChip(
                                                              chipList: notHubType,
                                                              selectedChoices: businessType,
                                                              optimumChipListToDispatch: (String selectedChoices) {
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
                                                                    helperText: required && _addressController.text.isEmpty ? '~ ' + AppLocalizations.of(context).required : null,
                                                                    helperStyle: TextStyle(color: BuytimeTheme.AccentRed),
                                                                    labelText: AppLocalizations.of(context).businessAddress,
                                                                    //hintText: AppLocalizations.of(context).addressOptional,
                                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                                  ),
                                                                )),
                                                          ),
                                                          IconButton(
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

                                            ///Invoice Details
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
                                                      globalFieldKey: _formKeyStreetFieldEdit,
                                                      typeOfValidate: "name",
                                                      //initialFieldValue: snapshot.street,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessStreet(value));
                                                      },
                                                    ),

                                                    ///Street Number
                                                    OptimumFormField(
                                                      controller: _streetNumberController,
                                                      field: "streetNumber",
                                                      textInputType: TextInputType.text,
                                                      minLength: 1,
                                                      label: AppLocalizations.of(context).streetNumber,
                                                      globalFieldKey: _formKeyStreetNumberFieldEdit,
                                                      typeOfValidate: "number",
                                                      //initialFieldValue: snapshot.street_number,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessStreetNumber(value));
                                                      },
                                                    ),

                                                    ///Zip
                                                    OptimumFormField(
                                                      required: required,
                                                      controller: _zipPostalController,
                                                      field: "zipPostal",
                                                      textInputType: TextInputType.number,
                                                      minLength: 3,
                                                      label: AppLocalizations.of(context).zipPostal,
                                                      globalFieldKey: _formKeyZipFieldEdit,
                                                      typeOfValidate: "number",
                                                      //initialFieldValue: snapshot.ZIP,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessZipPostal(value));
                                                      },
                                                    ),

                                                    ///Municipality
                                                    OptimumFormField(
                                                      required: required,
                                                      controller: _cityTownController,
                                                      field: "cityTown",
                                                      textInputType: TextInputType.text,
                                                      minLength: 3,
                                                      label: AppLocalizations.of(context).cityTown,
                                                      globalFieldKey: _formKeyMunicipalityFieldEdit,
                                                      typeOfValidate: "name",
                                                      //initialFieldValue: snapshot.municipality,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessCityTown(value));
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessMunicipality(value));
                                                      },
                                                    ),

                                                    ///State
                                                    OptimumFormField(
                                                      required: required,
                                                      controller: _stateTerritoryProvinceController,
                                                      field: "stateTerritoryProvince",
                                                      textInputType: TextInputType.text,
                                                      minLength: 3,
                                                      label: AppLocalizations.of(context).stateTerritoryProvince,
                                                      globalFieldKey: _formKeyStateFieldEdit,
                                                      typeOfValidate: "name",
                                                      //initialFieldValue: snapshot.state_province,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessStateTerritoryProvince(value));
                                                      },
                                                    ),

                                                    ///Nation
                                                    OptimumFormField(
                                                      required: required,
                                                      controller: _countryController,
                                                      field: "country",
                                                      textInputType: TextInputType.text,
                                                      minLength: 3,
                                                      label: AppLocalizations.of(context).country,
                                                      globalFieldKey: _formKeyNationFieldEdit,
                                                      typeOfValidate: "name",
                                                      //initialFieldValue: snapshot.nation,
                                                      onSaveOrChangedCallback: (value) {
                                                        StoreProvider.of<AppState>(context).dispatch(SetBusinessCountry(value));
                                                      },
                                                    ),

                                                    /*Container(
                                                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                              child: OptimumFormField(
                                                                field: "coordinate",
                                                                textInputType: TextInputType.text,
                                                                minLength: 3,
                                                                label: AppLocalizations.of(context).coordinate,
                                                                globalFieldKey: _formKeyCoordinateFieldEdit,
                                                                typeOfValidate: "name",
                                                                initialFieldValue: snapshot.coordinate,
                                                                onSaveOrChangedCallback: (value) {
                                                                  StoreProvider.of<AppState>(context).dispatch(SetBusinessCoordinate(value));
                                                                },
                                                              ),
                                                            ),*/
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
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ///Description
                                                  /*OptimumFormField(
                                                              field: "description",
                                                              textInputType: TextInputType.text,
                                                              minLength: 3,
                                                              label: AppLocalizations.of(context).description,
                                                              globalFieldKey: _formKeyDescriptionFieldEdit,
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
                                                                  alignment: WrapAlignment.start,
                                                                  crossAxisAlignment: WrapCrossAlignment.start,
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
                                                    remotePath: "business/" + snapshot.name + "/logo",
                                                    maxHeight: 1000,
                                                    maxPhoto: 1,
                                                    maxWidth: 800,
                                                    minHeight: 200,
                                                    minWidth: 500,
                                                    cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                    roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                    image: snapshot.logo == null || snapshot.logo.isEmpty ? null : snapshot.logo,
                                                    //Image.network(snapshot.logo, width: media.width * 0.3),
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
                                                    remotePath: "business/" + snapshot.name + "/profile",
                                                    maxHeight: 1000,
                                                    maxPhoto: 1,
                                                    maxWidth: 800,
                                                    minHeight: 200,
                                                    minWidth: 600,
                                                    cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                    roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                    image: snapshot.profile == null || snapshot.profile.isEmpty ? null : snapshot.profile,
                                                    //Image.network(snapshot.profile, width: media.width * 0.3),
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
                                                    remotePath: "business/" + snapshot.name + "/gallery",
                                                    maxHeight: 1000,
                                                    maxPhoto: 1,
                                                    maxWidth: 800,
                                                    minHeight: 200,
                                                    minWidth: 600,
                                                    cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                    roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                    image: snapshot.gallery == null || snapshot.gallery.length == 0 || snapshot.gallery.isEmpty ? null : snapshot.gallery[0],
                                                    //Image.network(snapshot.gallery[0], width: media.width * 0.3),
                                                    onFilePicked: (fileToUpload) {
                                                      fileToUpload.remoteFolder = "business/" + businessName + "/gallery";
                                                      StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInBusiness(fileToUpload, fileToUpload.state, 3));
                                                    },
                                                  ),

                                                  ///Business Thumbnail
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
                                                    remotePath: "business/" + snapshot.name + "/wide",
                                                    maxHeight: 1000,
                                                    maxPhoto: 1,
                                                    maxWidth: 800,
                                                    minHeight: 200,
                                                    minWidth: 600,
                                                    cropAspectRatioPreset: CropAspectRatioPreset.ratio16x9,
                                                    roleAllowedArray: [Role.admin, Role.salesman, Role.owner],
                                                    image: snapshot.wide == null || snapshot.wide.isEmpty ? null : snapshot.wide,
                                                    //Image.network(snapshot.wide, width: media.width * 0.3),
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
                                                              if (_validateInputs() == false) {
                                                                print("buytime_salesman_edit: validate problems");
                                                                return;
                                                              }
                                                              /*if (_validateInputs() == false || (snapshot.wide.isNotEmpty)
                                                                    */ /*StoreProvider.of<AppState>(context).state.business.fileToUploadList == null ||
                                                                    StoreProvider.of<AppState>(context).state.business.fileToUploadList.length < 4*/ /*
                                                                ) {
                                                                  final snackBar = SnackBar(content: Text(AppLocalizations.of(context).pleaseFillAllFields));
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                  print("buytime_salesman_create: validate problems");
                                                                  return;
                                                                }*/
                                                              setState(() {
                                                                required = validate(snapshot);
                                                              });
                                                              if (required) {
                                                                final snackBar = SnackBar(content: Text(AppLocalizations.of(context).pleaseFillAllFields));
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                                                print("buytime_salesman_create: validate problems");
                                                                return;
                                                              }

                                                              setState(() {
                                                                bookingRequest = 'send';
                                                              });

                                                              /// identify the area
                                                              if (_coordinateController.text != null && _coordinateController.text.isNotEmpty) {
                                                                AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
                                                                if (areaListState != null && areaListState.areaList != null) {
                                                                  for (int ij = 0; ij < areaListState.areaList.length; ij++) {
                                                                    var distance = Utils.calculateDistanceBetweenPoints(areaListState.areaList[ij].coordinates, _coordinateController.text);
                                                                    debugPrint('UI_M_edit_business: area distance ' + distance.toString());
                                                                    if (distance != null && distance < 100) {
                                                                      setState(() {
                                                                        if (areaListState.areaList[ij].areaId.isNotEmpty && !snapshot.tag.contains(areaListState.areaList[ij].areaId)) {
                                                                          snapshot.tag.add(areaListState.areaList[ij].areaId);
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                }
                                                              }
                                                              print("salesman board: Upload to DB");
                                                              //uploadFirestore(snapshot);
                                                              StoreProvider.of<AppState>(context).dispatch(new UpdateBusiness(snapshot));

                                                              /*Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => UI_M_Business()),
                                        );*/
                                                            },
                                                            child: Text(AppLocalizations.of(context).editBusiness, style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontSize: 18)),
                                                          ),
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
