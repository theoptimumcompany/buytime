import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_slot.dart';
import 'package:Buytime/UI/management/service_internal/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/area/area_list_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/slot_list_snippet_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/animations/translate_animation.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_EditService extends StatefulWidget {
  String serviceId;
  String serviceName;
  UI_EditService(this.serviceId, this.serviceName);
  State<StatefulWidget> createState() => UI_EditServiceState();
}

class UI_EditServiceState extends State<UI_EditService> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _keyEditServiceForm = GlobalKey<FormState>();
  String _serviceName = "";
  double _servicePrice = 0.0;
  String _serviceDescription = "";
  String _serviceAddress = "";
  String _serviceBusinessAddress = "";
  String _serviceCoordinates = "";
  String _serviceBusinessCoordinates = "";
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;
  bool errorCategoryListEmpty = false;
  bool rippleLoading = false;
  bool rippleTranslate = false;
  bool errorSwitchSlots = false;
  bool submit = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController _tagServiceController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  bool validateAndSave() {
    final FormState form = _keyEditServiceForm.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePrice(String value) {
    RegExp regex = RegExp(r'(^\d*\.?\d*)');
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateChosenCategories() {
    if (selectedCategoryList.isNotEmpty) {
      setState(() {
        errorCategoryListEmpty = false;
      });
      return true;
    } else {
      setState(() {
        errorCategoryListEmpty = true;
      });
      return false;
    }
  }

  bool validateReservableService() {
    if (submit) {
      if (StoreProvider.of<AppState>(context).state.serviceState.switchSlots && StoreProvider.of<AppState>(context).state.serviceState.serviceSlot.length == 0) {
        setState(() {
          errorSwitchSlots = true;
        });
        return false;
      } else {
        setState(() {
          errorSwitchSlots = false;
          submit = false;
        });
        return true;
      }
    }
  }

  void setCategoryList() {
    CategoryTree categoryNode = StoreProvider.of<AppState>(context).state.categoryTree;
    List<Parent> items = [];

    if (categoryNode.categoryNodeList != null) {
      if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
        List<dynamic> list = categoryNode.categoryNodeList;
        items = openTree(list, items);
      }
    }

    categoryList = items;
  }

  openTree(List<dynamic> list, List<Parent> items) {
    for (int i = 0; i < list.length; i++) {
      items.add(
        Parent(
          name: list[i]['nodeName'],
          id: list[i]['nodeId'],
          level: list[i]['level'],
          parentRootId: list[i]['categoryRootId'],
        ),
      );
      if (StoreProvider.of<AppState>(context).state.serviceState.categoryId.contains(list[i]['nodeId'])) {
        selectedCategoryList.add(
          Parent(
            name: list[i]['nodeName'],
            id: list[i]['nodeId'],
            level: list[i]['level'],
            parentRootId: list[i]['categoryRootId'],
          ),
        );
      }
      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    categoryList.forEach((item) {
      choices.add(
          Container(
            margin: EdgeInsets.only(right: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
            height: 32,
            padding: const EdgeInsets.all(0.0),
            child: ChoiceChip(
              label: Text(item.name),
              selected: selectedCategoryList.any((element) => element.id == item.id),
              selectedColor: Theme.of(context).accentColor,
              labelStyle: TextStyle(
                  color: canEditService ? selectedCategoryList.any((element) => element.id == item.id) ? BuytimeTheme.TextBlack : BuytimeTheme.TextWhite : BuytimeTheme.TextBlack),
              onSelected: canEditService ? (selected) {
                setState(() {
                  selectedCategoryList.clear();
                  selectedCategoryList.add(item);
                  validateChosenCategories();
                });

                ///Aggiorno lo store con la lista di categorie selezionate salvando id e rootId
                StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
              } : null,
            ),
          ));
    });
    return choices;
  }

  String returnTextSwitchers() {
    String text = AppLocalizations.of(context).manualServiceConfirmation;
    bool switchManual = StoreProvider.of<AppState>(context).state.serviceState.switchAutoConfirm;
    bool switchBookable = StoreProvider.of<AppState>(context).state.serviceState.switchSlots;
    if (switchManual && switchBookable) {
      text = AppLocalizations.of(context).reservableAutomaticServiceConfirmation;
      return text;
    } else if (switchManual && !switchBookable) {
      text = AppLocalizations.of(context).purchasableAutomaticServiceConfirmation;
      return text;
    } else if (!switchManual && switchBookable) {
      text = AppLocalizations.of(context).reservableManualServiceConfirmation;
      return text;
    } else if (!switchManual && !switchBookable) {
      text = AppLocalizations.of(context).purchasableManualServiceConfirmation;
      return text;
    }
    return text;
  }
  bool startRequest = false;
  bool noActivity = false;


  bool canEdit(){
    bool edit = false;
    debugPrint('UI_M_edit_service => USER ROLE: ${StoreProvider.of<AppState>(context).state.user.getRole()}');
    if(StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner){
      edit = true;
      debugPrint('UI_M_edit_service => CAN EDIT ${Utils.enumToString(StoreProvider.of<AppState>(context).state.user.getRole())}');
    }
    StoreProvider.of<AppState>(context).state.category.manager.forEach((email) {
      if(email.mail == StoreProvider.of<AppState>(context).state.user.email){
        edit = true;
        debugPrint('UI_M_edit_service => CAN EDIT MANAGER');
      }
    });

    return edit;
  }

  bool canEditService = false;

  String serviceName = '';
  String serviceDescription = '';
  String serviceAddress = '';

  bool firstTime = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      onWillPop: () async {
        ///Block iOS Back Swipe
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return false;
      },
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          onInit: (store){
            store.state.serviceState = ServiceState();
            store.dispatch(CategoryTreeRequest());
            store.dispatch(ServiceRequestByID(widget.serviceId));
            if(store.state.business.businessAddress != null && store.state.business.businessAddress.isNotEmpty)
              _serviceBusinessAddress = store.state.business.businessAddress;
            else
              _serviceBusinessAddress = store.state.business.street + ', ' + store.state.business.street_number + ', ' + store.state.business.ZIP + ', ' + store.state.business.state_province;
            _serviceBusinessCoordinates = store.state.business.coordinate;
            //addressController.text = _serviceAddress;
            startRequest = true;
          },
          //onDidChange: (store) => validateReservableService(),
          builder: (context, snapshot) {
            canEditService  = canEdit();
            List<String> flagsCharCode = [];
            List<String> languageCode = [];
            Locale myLocale = Localizations.localeOf(context);
            debugPrint('UI_M_edit_service => MY LOCALE: ${myLocale}');
            if(snapshot.serviceState.serviceId != null){
              validateReservableService(); //TODO Check
              ///Popolo le categorie
              setCategoryList();

              AppLocalizations.supportedLocales.forEach((element) {
                //debugPrint('UI_M_create_service => Locale: ${element}');
                String flag = '';
                if(element.languageCode == 'en')
                  flag = 'gb'.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
                else
                  flag = element.languageCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0).codeUnitAt(0) + 127397));
                //debugPrint('UI_M_create_service => Locale charCode: $flag');
                flagsCharCode.add(flag);
                languageCode.add(element.languageCode);
              });

              if(!firstTime){
                if(snapshot.serviceState.name.isNotEmpty && nameController.text.isEmpty){
                  serviceName = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.name);
                  debugPrint('UI_M_edit_service => Service Name: ${snapshot.serviceState.name}');
                  //nameController.clear();
                  nameController.text = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.name);
                }
                if(snapshot.serviceState.description.isNotEmpty && descriptionController.text.isEmpty){
                  serviceDescription = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.description);
                  debugPrint('UI_M_edit_service => Service Description: ${snapshot.serviceState.description}');
                  //descriptionController.clear();
                  descriptionController.text = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.description);
                }
                firstTime = true;
              }
            }
            if(snapshot.serviceState.price != null && priceController.text.isEmpty){
              _servicePrice = StoreProvider.of<AppState>(context).state.serviceState.price;
              List<String> format = [];
              format = _servicePrice.toString().split(".");
              priceController.text = format[0].toString() + "." + (int.parse(format[1]) < 10 ? format[1].toString() + "0" : format[1].toString());
            }

            if(addressController.text.isEmpty || _serviceAddress != _serviceBusinessAddress){
              if(snapshot.serviceState.serviceAddress != null && snapshot.serviceState.serviceAddress.isNotEmpty){
                _serviceAddress = snapshot.serviceState.serviceAddress;
              }else if(snapshot.serviceState.serviceBusinessAddress != null && snapshot.serviceState.serviceBusinessAddress.isNotEmpty){
                _serviceBusinessAddress = snapshot.serviceState.serviceBusinessAddress;
              }else{
                addressController.text = _serviceBusinessAddress;
              }

              if(_serviceAddress.isNotEmpty)
                addressController.text = _serviceAddress;
              else
                addressController.text = _serviceBusinessAddress;
            }

            if (_serviceCoordinates == null || _serviceCoordinates.isEmpty) {
              _serviceCoordinates = snapshot.business.coordinate;
            }


            return GestureDetector(
              onTap: (){

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Stack(children: [
                snapshot.serviceState.serviceId != null ?
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Scaffold(
                            appBar: BuytimeAppbar(
                              width: media.width,
                              children: [
                                Container(
                                    child: IconButton(
                                        icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_ServiceList()),);
                                          //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: UI_EditService(), from: false));
                                        })),
                                Flexible(
                                  child: Utils.barTitle('${AppLocalizations.of(context).editSpace} ${nameController.text}'),
                                ),
                                canEditService ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.check, color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          submit = true;
                                        });
                                        if(nameController.text.isNotEmpty)
                                          StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                        if(descriptionController.text.isNotEmpty)
                                          StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description)));
                                        if (validateReservableService() && validateChosenCategories() && validateAndSave() && validatePrice(_servicePrice.toString())) {
                                          setState(() {
                                            rippleLoading = true;
                                          });
                                          ServiceState tmpService = ServiceState.fromState(snapshot.serviceState);
                                          tmpService.name = Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name);
                                          tmpService.description = Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description);
                                          tmpService.serviceAddress = addressController.text;
                                          tmpService.serviceBusinessAddress = _serviceBusinessAddress;
                                          tmpService.serviceCoordinates = _serviceCoordinates;
                                          tmpService.serviceBusinessCoordinates = _serviceBusinessCoordinates;
                                          debugPrint('UI_M_edit_service => Service Name: ${tmpService.name}');
                                          debugPrint('UI_M_edit_service => Service Description: ${tmpService.description}');
                                          debugPrint('UI_M_create_service => Service Address: ${tmpService.serviceAddress}');
                                          debugPrint('UI_M_create_service => Service Business Address: ${tmpService.serviceBusinessAddress}');
                                          debugPrint('UI_M_create_service => Service Coordinates: ${tmpService.serviceCoordinates}');
                                          debugPrint('UI_M_create_service => Service Business Coordinates: ${tmpService.serviceBusinessCoordinates}');
                                          //debugPrint('UI_M_create_service => FILE TO UPLOAD LSIT: ${tmpService.fileToUploadList.length}');
                                          StoreProvider.of<AppState>(context).dispatch(SetServiceServiceCrossSell(snapshot.serviceState.serviceCrossSell));

                                          /// set the area of the service
                                          if (_serviceCoordinates != null && _serviceCoordinates.isNotEmpty) {
                                            AreaListState areaListState = StoreProvider.of<AppState>(context).state.areaList;
                                            if (areaListState != null && areaListState.areaList != null) {
                                              for(int ij = 0; ij < areaListState.areaList.length; ij++) {
                                                var distance = Utils.calculateDistanceBetweenPoints(areaListState.areaList[ij].coordinates, _serviceCoordinates);
                                                debugPrint('UI_M_edit_service: area distance ' + distance.toString());
                                                if (distance != null && distance < 100) {
                                                  setState(() {
                                                    if(areaListState.areaList[ij].areaId.isNotEmpty && !snapshot.serviceState.tag.contains(areaListState.areaList[ij].areaId)) {
                                                       snapshot.serviceState.tag.add(areaListState.areaList[ij].areaId);
                                                    }
                                                  });
                                                }
                                              }
                                            }
                                          }

                                          StoreProvider.of<AppState>(context).dispatch(UpdateService(tmpService));
                                        }
                                      }),
                                ) : SizedBox(
                                  width: 50.0,
                                ),
                              ],
                            ),
                            body: SafeArea(
                              child: Center(
                                child: SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(),
                                    child: Form(
                                      key: _keyEditServiceForm,
                                      child: Column(
                                        children: <Widget>[
                                          ///Image
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 25.0),
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: WidgetServicePhoto(
                                                        remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_1",
                                                        maxPhoto: 1,
                                                        image: snapshot.serviceState.image1,
                                                        cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                        onFilePicked: (fileToUpload) {
                                                          print("UI_create_service - callback upload image 1!");
                                                          StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: WidgetServicePhoto(
                                                            remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_2",
                                                            maxPhoto: 1,
                                                            cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                            image: snapshot.serviceState.image2,
                                                            onFilePicked: (fileToUpload) {
                                                              print("UI_create_service -  callback upload image 2!");
                                                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                                            },
                                                          ),
                                                        ),
                                                        WidgetServicePhoto(
                                                          remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                                          maxPhoto: 1,
                                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                          image: snapshot.serviceState.image3,
                                                          onFilePicked: (fileToUpload) {
                                                            print("UI_create_service -  callback upload image 3!");
                                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Name
                                          Container(
                                            margin: EdgeInsets.only(top: 40.0, bottom: 5.0, left: 32.0, right: 28.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    //width: SizeConfig.safeBlockHorizontal * 60,
                                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                                      child: TextFormField(
                                                        enabled: canEditService,
                                                          controller: nameController,
                                                          validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              serviceName = value;
                                                            });
                                                            //StoreProvider.of<AppState>(context).dispatch(SetServiceName(value + '-' + myLocale.languageCode));
                                                          },
                                                          /*onChanged: (value) {
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceName(value + '-' + myLocale.languageCode));
                                                  },
                                                  onSaved: (value) {
                                                    if (validateAndSave()) {
                                                      //_serviceName = value;
                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceName(value + '-' + myLocale.languageCode));
                                                    }
                                                  },*/
                                                          onEditingComplete: (){
                                                            //StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                                            currentFocus.unfocus();
                                                          },
                                                          style: TextStyle(
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: canEditService ? BuytimeTheme.TextBlack : BuytimeTheme.TextGrey
                                                          ),
                                                          decoration: InputDecoration(
                                                            labelText: AppLocalizations.of(context).name,
                                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                          ))
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.g_translate,
                                                    color: canEditService && serviceName.isNotEmpty ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextGrey,
                                                  ),
                                                  onPressed: canEditService && serviceName.isNotEmpty ? (){
                                                    setState(() {
                                                      rippleTranslate = true;
                                                    });
                                                    currentFocus.unfocus();
                                                    //StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                                    String newField = Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name);
                                                    Utils.multiLingualTranslate(
                                                        context, flagsCharCode, languageCode,
                                                        AppLocalizations.of(context).name, newField,
                                                        currentFocus, (value){
                                                          if(!value){
                                                            setState(() {
                                                              rippleTranslate = false;
                                                            });
                                                          }
                                                    });
                                                  } : null,
                                                )
                                              ],
                                            ),
                                          ),
                                          ///Description
                                          Container(
                                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 32.0, right: 28.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Container(
                                                    //width: SizeConfig.safeBlockHorizontal * 60,
                                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                                      child: TextFormField(
                                                          enabled: canEditService,
                                                          keyboardType: TextInputType.multiline,
                                                          maxLines: null,
                                                          controller: descriptionController,
                                                          validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              serviceDescription = value;
                                                            });
                                                            //StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(value + '-' + myLocale.languageCode));
                                                          },
                                                          /*onChanged: (value) {
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(value + '-' + myLocale.languageCode));
                                                  },
                                                  onSaved: (value) {
                                                    if (validateAndSave()) {
                                                      //_serviceName = value;
                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(value + '-' + myLocale.languageCode));
                                                    }
                                                  },*/style: TextStyle(
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: canEditService ? BuytimeTheme.TextBlack : BuytimeTheme.TextGrey
                                                      ),
                                                          onEditingComplete: (){
                                                            StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description)));
                                                            currentFocus.unfocus();
                                                          },
                                                          decoration: InputDecoration(
                                                            labelText: AppLocalizations.of(context).description,
                                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),

                                                          ))
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.g_translate,
                                                    color: canEditService && serviceDescription.isNotEmpty ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextGrey,
                                                  ),
                                                  onPressed: canEditService && serviceDescription.isNotEmpty ? (){
                                                    setState(() {
                                                      rippleTranslate = true;
                                                    });
                                                    currentFocus.unfocus();
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description)));
                                                    String newField = Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description);
                                                    Utils.multiLingualTranslate(
                                                        context, flagsCharCode, languageCode,
                                                        AppLocalizations.of(context).description, newField,
                                                        currentFocus, (value){
                                                      if(!value){
                                                        setState(() {
                                                          rippleTranslate = false;
                                                        });
                                                      }
                                                    });
                                                  } : null,
                                                )
                                              ],
                                            ),
                                          ),
                                          ///Prtice
                                          snapshot.serviceState.switchSlots
                                              ? Container()
                                              : Padding(
                                            padding: const EdgeInsets.only(bottom: 0.0,),
                                            child: Center(
                                              child: Container(
                                                width: media.width * 0.9,
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                                  child: TextFormField(
                                                    enabled: canEditService,
                                                    controller: priceController,
                                                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                    textInputAction: TextInputAction.done,
                                                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
                                                    onTap: (){
                                                      setState(() {
                                                        priceController.clear();
                                                      });
                                                    },
                                                    validator: (value) => value.isEmpty
                                                        ? AppLocalizations.of(context).servicePriceBlank
                                                        : validatePrice(value)
                                                        ? null
                                                        : AppLocalizations.of(context).notValidPrice,
                                                    onChanged: (value) {
                                                      if (value == "") {
                                                        setState(() {
                                                          _servicePrice = 0.0;
                                                          value = "0.0";
                                                        });
                                                      } else {
                                                        if (value.contains(".")) {
                                                          List<String> priceString = value.split(".");
                                                          if (priceString[1].length == 1) {
                                                            value += "0";
                                                          }
                                                          else if(priceString[1].length == 0){
                                                            value += "00";
                                                          }
                                                        } else {
                                                          value += ".00";
                                                        }
                                                        setState(() {
                                                          _servicePrice = double.parse(value);
                                                        });
                                                      }
                                                      StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                                    },
                                                    onFieldSubmitted: (value) {
                                                      if (value == "") {
                                                        setState(() {
                                                          _servicePrice = 0.0;
                                                          value = "0.0";
                                                          priceController.text = value;
                                                        });
                                                      } else {
                                                        if (value.contains(".")) {
                                                          List<String> priceString = value.split(".");
                                                          if (priceString[1].length == 1) {
                                                            value += "0";
                                                          }
                                                          else if(priceString[1].length == 0){
                                                            value += "00";
                                                          }
                                                        } else {
                                                          value += ".00";
                                                        }
                                                        setState(() {
                                                          _servicePrice = double.parse(value);
                                                          priceController.text = value;
                                                        });
                                                      }
                                                      StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                                    },
                                                    style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: canEditService ? BuytimeTheme.TextBlack : BuytimeTheme.TextGrey
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: AppLocalizations.of(context).price,
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Address
                                          Container(
                                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 32.0, right: 28.0),
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
                                                      controller: addressController,
                                                      //initialValue: _serviceAddress,
                                                      onChanged: (value) {
                                                        _serviceAddress = value;
                                                        StoreProvider.of<AppState>(context).dispatch(SetServiceAddress(_serviceAddress));
                                                      },
                                                      onSaved: (value) {
                                                        _serviceAddress = value;
                                                      },
                                                      style: TextStyle(
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextGrey
                                                      ),
                                                      decoration: InputDecoration(
                                                        labelText: AppLocalizations.of(context).addressOptional,
                                                        //hintText: AppLocalizations.of(context).addressOptional,
                                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                      ),
                                                    )
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.add_location_rounded,
                                                    color: canEditService ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextGrey,
                                                  ),
                                                  onPressed: canEditService ? (){
                                                    Utils.googleSearch(
                                                        context,
                                                            (place){
                                                          //_serviceAddress = store.state.business.street + ', ' + store.state.business.street_number + ', ' + store.state.business.ZIP + ', ' + store.state.business.state_province;
                                                          addressController.text = place[0];
                                                          setState(() {
                                                            _serviceCoordinates = '${place[1]}, ${place[2]}';
                                                          });
                                                          StoreProvider.of<AppState>(context).dispatch(SetServiceAddress(addressController.text));
                                                          StoreProvider.of<AppState>(context).dispatch(SetServiceCoordinates(_serviceCoordinates));
                                                        }
                                                    );
                                                  } : null,
                                                )
                                              ],
                                            ),
                                          ),
                                          ///Categproes
                                          Padding(
                                            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                    child: Text(
                                                      AppLocalizations.of(context).selectCategories,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: media.height * 0.02,
                                                        color: BuytimeTheme.TextBlack,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: media.width * 0.9,
                                                      child: Wrap(
                                                        children: _buildChoiceList(),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Error message Empty CategoryList
                                          errorCategoryListEmpty
                                              ? Padding(
                                            padding: const EdgeInsets.only(left: 30.0, bottom: 10),
                                            child: Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(context).notZeroCategory,
                                                      style: TextStyle(
                                                        fontSize: media.height * 0.018,
                                                        color: BuytimeTheme.ErrorRed,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          )
                                              : Container(),

                                          ///Divider under category selection
                                          Container(
                                            child: Divider(
                                              indent: 0.0,
                                              color: BuytimeTheme.DividerGrey,
                                              thickness: 5.0,
                                            ),
                                          ),

                                          ///Tag Block
                                          Padding(
                                            padding: const EdgeInsets.only(left: 30.0, top: 5.0, bottom: 10.0, right: 30.0),
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context).tag,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: media.height * 0.02,
                                                      color: BuytimeTheme.TextBlack,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),

                                                  ///Tags
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5.0),
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              ///Add Tag field & Add Tag Button
                                                              Container(
                                                                height: 45,
                                                                width: media.width * 0.55,
                                                                child: TextFormField(
                                                                  enabled: canEditService,
                                                                  controller: _tagServiceController,
                                                                  textAlign: TextAlign.start,
                                                                  decoration: InputDecoration(
                                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                    border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                                    labelText: AppLocalizations.of(context).addNewTag,
                                                                    labelStyle: TextStyle(
                                                                      fontSize: 14,
                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                      color: BuytimeTheme.TextGrey,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                  style: TextStyle(
                                                                    fontFamily: BuytimeTheme.FontFamily,
                                                                    color: BuytimeTheme.TextGrey,
                                                                    fontWeight: FontWeight.w800,
                                                                  ),
                                                                ),
                                                              ),

                                                              ///Add tag button
                                                              Container(
                                                                child: IconButton(
                                                                  icon: Icon(
                                                                    Icons.add_circle_rounded,
                                                                    size: 30,
                                                                    color: BuytimeTheme.TextGrey,
                                                                  ),
                                                                  onPressed:canEditService ? () {
                                                                    setState(() {
                                                                      if (_tagServiceController.text.isNotEmpty) {
                                                                        snapshot.serviceState.tag.add(_tagServiceController.text);
                                                                        _tagServiceController.clear();
                                                                      }
                                                                    });
                                                                  } : null,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          (snapshot.serviceState.tag.length > 0 && snapshot.serviceState.tag != null)
                                                              ? Align(
                                                            alignment: Alignment.topLeft,
                                                            child: Wrap(
                                                              spacing: 3.0,
                                                              runSpacing: 3.0,
                                                              children: List<Widget>.generate(snapshot.serviceState.tag.length, (int index) {
                                                                return InputChip(
                                                                  selected: false,
                                                                  label: Text(
                                                                    snapshot.serviceState.tag[index],
                                                                    style: TextStyle(
                                                                      fontSize: 13.0,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                  onDeleted: canEditService ?() {
                                                                    setState(() {
                                                                      snapshot.serviceState.tag.remove(snapshot.serviceState.tag[index]);
                                                                    });
                                                                  } : null,
                                                                );
                                                              }),
                                                            ),
                                                          )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: media.width * 0.9,
                                                      child: Wrap(
                                                        children: [Container()],
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Container(
                                              child: Divider(
                                                indent: 0.0,
                                                color: BuytimeTheme.DividerGrey,
                                                thickness: 20.0,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        returnTextSwitchers(),
                                                        textAlign: TextAlign.start,
                                                        overflow: TextOverflow.clip,
                                                        style: TextStyle(
                                                          fontSize: media.height * 0.020,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              ///Switch Auto Confirm
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Switch(
                                                          activeColor: BuytimeTheme.ManagerPrimary,
                                                          value: snapshot.serviceState.switchAutoConfirm,
                                                          onChanged: canEditService ? (value) {
                                                            setState(() {
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSwitchAutoConfirm(value));
                                                            });
                                                          } : (value) {
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(context).managerConfirmation,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.018,
                                                            color: BuytimeTheme.TextGrey,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),///Switch Cross Selling
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Switch(
                                                          activeColor: BuytimeTheme.ManagerPrimary,
                                                          value: snapshot.serviceState.serviceCrossSell,
                                                          onChanged: canEditService ? (value) {
                                                            setState(() {
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceServiceCrossSell(value));
                                                            });

                                                          } : (value) {
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(context).crossSell,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.018,
                                                            color: BuytimeTheme.TextGrey,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              ///Switch Service Bookable
                                              Padding(
                                                padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Switch(
                                                          activeColor: BuytimeTheme.ManagerPrimary,
                                                          value: snapshot.serviceState.switchSlots,
                                                          onChanged: canEditService ?  (value) {
                                                            setState(() {
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSwitchSlots(value));
                                                            });
                                                          } : (value) {
                                                          }),
                                                      Expanded(
                                                        child: Text(
                                                          AppLocalizations.of(context).serviceCanBeReserved,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.018,
                                                            color: BuytimeTheme.TextGrey,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              ///Error message Empty CategoryList
                                              errorSwitchSlots
                                                  ? Padding(
                                                padding: const EdgeInsets.only(left: 30.0, bottom: 10),
                                                child: Container(
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            AppLocalizations.of(context).notZeroServiceSlot,
                                                            style: TextStyle(
                                                              fontSize: media.height * 0.018,
                                                              color: BuytimeTheme.ErrorRed,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            overflow: TextOverflow.clip,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              )
                                                  : Container(),
                                            ],
                                          ),

                                          ///Divider under switch booking block
                                          Container(
                                            child: Divider(
                                              indent: 0.0,
                                              color: BuytimeTheme.DividerGrey,
                                              thickness: 20.0,
                                            ),
                                          ),

                                          snapshot.serviceState.switchSlots
                                              ?

                                          ///Service Resevable Slot Block
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 0.0,
                                              right: 0.0,
                                              bottom: 20.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          AppLocalizations.of(context).serviceTimeAvailability,
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: GestureDetector(
                                                            child: Icon(Icons.add, color: BuytimeTheme.SymbolGrey),
                                                            onTap: canEditService ? () {
                                                              ///Svuoto lo stato dello slot
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotToEmpty());
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => UI_M_ServiceSlot(
                                                                      createSlot: true,
                                                                      editSlot: false,
                                                                    )),
                                                              );
                                                            } : null,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                snapshot.serviceState.serviceSlot.length > 0
                                                    ? Padding(
                                                  padding: const EdgeInsets.only(left: 20.0),
                                                  child: ConstrainedBox(
                                                    constraints: BoxConstraints(),
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.serviceState.serviceSlot.length,
                                                      itemBuilder: (context, index) {
                                                        return Dismissible(
                                                          key: UniqueKey(),
                                                          direction: canEditService ? DismissDirection.endToStart : DismissDirection.none,
                                                          background: Container(
                                                            color: Colors.red,
                                                            margin: EdgeInsets.symmetric(horizontal: 0),
                                                            alignment: Alignment.centerRight,
                                                            child: Icon(
                                                              Icons.delete,
                                                              color: BuytimeTheme.SymbolWhite,
                                                            ),
                                                          ),
                                                          onDismissed: (direction) {
                                                            setState(() {
                                                              ///Deleting Slot
                                                              StoreProvider.of<AppState>(context).dispatch(DeleteServiceSlot(index));
                                                            });
                                                          },
                                                          child: GestureDetector(
                                                            onTap: canEditService ? () {
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlot(snapshot.serviceState.serviceSlot[index]));
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => UI_M_ServiceSlot(
                                                                      createSlot: false,
                                                                      editSlot: true,
                                                                      indexSlot: index,
                                                                    )),
                                                              );
                                                            } : null,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 88,
                                                                    child: ListTile(
                                                                      title: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            '${AppLocalizations.of(context).timeAvailabilitySpace} ' + (index + 1).toString(),
                                                                            style: TextStyle(
                                                                              fontSize:16,
                                                                              color: BuytimeTheme.TextBlack,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      subtitle: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.only(top: 10),
                                                                            child: Row(
                                                                              children: [
                                                                                Text(snapshot.serviceState.serviceSlot[index].checkIn + " - " + snapshot.serviceState.serviceSlot[index].checkOut,
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: BuytimeTheme.TextBlack,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                snapshot.serviceState.serviceSlot[index].price.toString().split('.')[1] == '0' ?
                                                                                snapshot.serviceState.serviceSlot[index].price.toString().split('.')[0] + ' ${AppLocalizations.of(context).spaceEuro}' :
                                                                                       snapshot.serviceState.serviceSlot[index].price.toStringAsFixed(2) + ' ${AppLocalizations.of(context).spaceEuro}',
                                                                                style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  color: BuytimeTheme.TextBlack,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),),
                                                                            ],
                                                                          ),
                                                                          //showSlotInterval(snapshot.serviceState.serviceSlot[index].numberOfInterval, media, index),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    height: 1,
                                                                    color: BuytimeTheme.DividerGrey,
                                                                    margin: EdgeInsets.only(left: 20),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                )
                                                    : Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 1,
                                                        child: Container(
                                                          height: SizeConfig.safeBlockVertical * 5,
                                                          margin: EdgeInsets.only(left: 20, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5),
                                                          decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                                                          child: Center(
                                                              child: Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1),
                                                                alignment: Alignment.center,
                                                                child: Text(
                                                                  (snapshot.serviceState.name != null && snapshot.serviceState.name != ""
                                                                      ? Utils.retriveField(Localizations.localeOf(context).languageCode, snapshot.serviceState.name)
                                                                      : AppLocalizations.of(context).theService) + ' ' +
                                                                      AppLocalizations.of(context).spaceHasNotReservableSlots,
                                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 14),
                                                                ),
                                                              )),
                                                        ))],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )))) :
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Scaffold(
                            appBar: BuytimeAppbar(
                              width: media.width,
                              children: [
                                Container(
                                    child: IconButton(
                                        icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
                                        onPressed: () {
                                          Navigator.of(context).pop();

                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_ServiceList()),);
                                          //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: UI_EditService(), from: false));
                                        })),
                                Flexible(
                                  child: Utils.barTitle('${AppLocalizations.of(context).editSpace}' + widget.serviceName),
                                ),
                                Container(
                                  child: IconButton(
                                      icon: Icon(Icons.check, color: BuytimeTheme.SymbolLightGrey),
                                      onPressed: null,
                                  )
                                ),
                              ],
                            ),
                            body: SafeArea(
                              child: Center(
                                child: SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            )))) ,
                ///Ripple Effect
                rippleTranslate ?
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: BuytimeTheme.BackgroundWhite.withOpacity(.8),
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
                                    color: BuytimeTheme.ManagerPrimary,
                                    size: SizeConfig.safeBlockVertical * 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ):
                rippleLoading
                    ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                        height: double.infinity,
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
                    : Container(),
              ]),
            );
          }),
    );
  }
}
