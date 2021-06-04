import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service_internal/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/animations/translate_animation.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_CreateService extends StatefulWidget {
  @override
  String categoryId = "";

  UI_CreateService({this.categoryId});

  State<StatefulWidget> createState() => UI_CreateServiceState();
}

class UI_CreateServiceState extends State<UI_CreateService> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _keyCreateServiceForm = GlobalKey<FormState>();
  String _serviceName = "";
  double _servicePrice = 0.0;
  int _serviceVAT = 22;
  String _serviceDescription = "";
  String _serviceBusinessAddress = "";
  String _serviceAddress = "";
  String _serviceCoordinates = "";
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;
  bool rippleLoading = false;
  bool rippleTranslate = false;
  bool errorCategoryListEmpty = false;
  TextEditingController _tagServiceController = TextEditingController();
  bool defaultCategory = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool validateAndSave() {
    final FormState form = _keyCreateServiceForm.currentState;
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

  void addDefaultCategory() {
    if (widget.categoryId != null && widget.categoryId != "" && defaultCategory && StoreProvider.of<AppState>(context).state.categoryTree != null) {
      categoryList.forEach((element) {
        if (element.id == widget.categoryId) {
          selectedCategoryList.add(element);
          StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
        }
        defaultCategory = false;
      });
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
      if (StoreProvider.of<AppState>(context).state.serviceState.categoryId != null && StoreProvider.of<AppState>(context).state.serviceState.categoryId.contains(list[i]['nodeId'])) {
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

  @override
  void initState() {
    super.initState();
    selectedCategoryList = [];
    vatController.text = _serviceVAT.toString();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => addDefaultCategory());
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    categoryList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.name),
          selected: selectedCategoryList.any((element) => element.id == item.id),
          selectedColor: Theme.of(context).accentColor,
          labelStyle: TextStyle(color: selectedCategoryList.any((element) => element.id == item.id) ? BuytimeTheme.TextBlack : canAccess(item.id) ? BuytimeTheme.TextWhite : BuytimeTheme.TextBlack),
          onSelected: canAccess(item.id) ? (selected) {
            if (widget.categoryId != null && widget.categoryId != "" && item.parentRootId != widget.categoryId) {
              return null;
            } else {
              setState(() {
                selectedCategoryList.clear();
                selectedCategoryList.add(item);
                validateChosenCategories();
              });

              ///Aggiorno lo store con la lista di categorie selezionate salvando id e rootId
              StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
            }
          } : null,
        ),
      ));
    });
    return choices;
  }

  String serviceName = '';
  String serviceDescription = '';
  String serviceAddress = '';

  bool canAccess(String id){
    bool access = false;
    if(StoreProvider.of<AppState>(context).state.user.managerAccessTo != null){
      StoreProvider.of<AppState>(context).state.user.managerAccessTo.forEach((element) {
        if(element == id)
          access = true;
      });
    }
    debugPrint('UI_M_service_list => CAN MANAGER ACCESS THE SERVICE? $access');

    if(!access &&  (StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner)){
      access = true;
    }
    debugPrint('UI_M_service_list => CAN MANAGER|OTHERS ACCESS THE SERVICE? $access');

    return access;
  }

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
          onInit: (store) {
            store.dispatch(CategoryTreeRequest());
            if(store.state.business.businessAddress != null && store.state.business.businessAddress.isNotEmpty)
              _serviceBusinessAddress = store.state.business.businessAddress;
            else
              _serviceBusinessAddress = '${store.state.business.street.isNotEmpty ? store.state.business.street : ''}'
                  '${store.state.business.street_number.isNotEmpty ? ', ' + store.state.business.street_number : ''}'
                  '${store.state.business.ZIP.isNotEmpty ? ', ' + store.state.business.ZIP : ''}'
                  '${store.state.business.state_province.isNotEmpty ? ', ' + store.state.business.state_province : ''}';
            _serviceCoordinates = store.state.business.coordinate;
            addressController.text = _serviceBusinessAddress;
          },
          builder: (context, snapshot) {
            List<String> flagsCharCode = [];
            List<String> languageCode = [];
            Locale myLocale = Localizations.localeOf(context);
            if(snapshot.serviceState.serviceId != null){

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

              if(snapshot.serviceState.name.isNotEmpty && nameController.text.isEmpty){
                debugPrint('UI_M_create_service => Service Name: ${snapshot.serviceState.name}');
                //nameController.clear();
                nameController.text = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.name);
              }
              if(snapshot.serviceState.description.isNotEmpty && descriptionController.text.isEmpty){
                debugPrint('UI_M_create_service => Service Description: ${snapshot.serviceState.description}');
                //descriptionController.clear();
                descriptionController.text = Utils.retriveField(myLocale.languageCode, snapshot.serviceState.description);
              }
            }


            ///Popolo le categorie
            setCategoryList();
            addDefaultCategory();
            return GestureDetector(
              onTap: (){
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Scaffold(
                      //resizeToAvoidBottomInset: false,
                        appBar: BuytimeAppbar(
                          width: media.width,
                          children: [
                            Container(
                                child: IconButton(
                                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
                                    onPressed: () {
                                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_ServiceList()),);
                                      Navigator.of(context).pop();
                                      //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: UI_CreateService(), from: false));
                                    })),
                            Flexible(
                              child: Utils.barTitle(AppLocalizations.of(context).createService),
                            ),
                            Container(
                              child: IconButton(
                                  icon: Icon(Icons.check, color: Colors.white),
                                  onPressed: () {
                                    if(nameController.text.isNotEmpty)
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                    if(descriptionController.text.isNotEmpty)
                                      StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description)));
                                    if (validateChosenCategories() && validateAndSave() && validatePrice(priceController.text)) {
                                      setState(() {
                                        rippleLoading = true;
                                      });
                                      ServiceState tmpService = ServiceState.fromState(snapshot.serviceState);
                                      tmpService.name = Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name);
                                      tmpService.description = Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description);
                                      tmpService.serviceAddress = addressController.text;
                                      tmpService.serviceBusinessAddress = _serviceBusinessAddress;
                                      if(_serviceVAT == 0)
                                        tmpService.vat = 22;
                                      else
                                        tmpService.vat = _serviceVAT;
                                      tmpService.price = _servicePrice;
                                      debugPrint('UI_M_create_service => Service Name: ${tmpService.name}');
                                      debugPrint('UI_M_create_service => Service Description: ${tmpService.description}');
                                      debugPrint('UI_M_create_service => Service Address: ${tmpService.serviceBusinessAddress}');
                                      StoreProvider.of<AppState>(context).dispatch(CreateService(tmpService));
                                    }
                                  }),
                            ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(),
                            child: Form(
                              key: _keyCreateServiceForm,
                              child: Column(
                                children: <Widget>[
                                  /*Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            color: BuytimeTheme.BackgroundLightGrey,
                                            //height: double.infinity,
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
                                            children: [
                                              Container(
                                                child: WidgetServicePhoto(
                                                  remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_2",
                                                  maxPhoto: 1,
                                                  image: snapshot.serviceState.image2,
                                                  cropAspectRatioPreset: CropAspectRatioPreset.square,
                                                  onFilePicked: (fileToUpload) {
                                                    print("UI_create_service -  callback upload image 2!");
                                                    StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                                  },
                                                ),
                                              ),
                                              WidgetServicePhoto(
                                                remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                                maxPhoto: 1,
                                                image: snapshot.serviceState.image3,
                                                cropAspectRatioPreset: CropAspectRatioPreset.square,
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
                                ),*/
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
                                                  controller: nameController,
                                                  validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      serviceName = value;
                                                    });
                                                    //StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                                  },
                                                  onSaved: (value) {
                                                    if (validateAndSave()) {
                                                      //_serviceName = value;
                                                      //StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                                    }
                                                  },
                                                  onEditingComplete: (){
                                                    //StoreProvider.of<AppState>(context).dispatch(SetServiceName(Utils.saveField(myLocale.languageCode, nameController.text, snapshot.serviceState.name)));
                                                    currentFocus.unfocus();
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: AppLocalizations.of(context).name,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  ))
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.g_translate,
                                            color: serviceName.isNotEmpty ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextGrey,
                                          ),
                                          onPressed: serviceName.isNotEmpty ? (){
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
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  controller: descriptionController,
                                                  validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      serviceDescription = value;
                                                    });
                                                  },
                                                  /*onChanged: (value) {
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(value + '-' + myLocale.languageCode));
                                                  },
                                                  onSaved: (value) {
                                                    if (validateAndSave()) {
                                                      //_serviceName = value;
                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(value + '-' + myLocale.languageCode));
                                                    }
                                                  },*/
                                                  onEditingComplete: (){
                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(Utils.saveField(myLocale.languageCode, descriptionController.text, snapshot.serviceState.description)));
                                                    currentFocus.unfocus();
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: AppLocalizations.of(context).description,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),

                                                  ))
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.g_translate,
                                            color: serviceDescription.isNotEmpty ? BuytimeTheme.ManagerPrimary : BuytimeTheme.TextGrey,
                                          ),
                                          onPressed: serviceDescription.isNotEmpty ? (){
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
                                  snapshot.serviceState.switchSlots != null && snapshot.serviceState.switchSlots
                                      ? Container()
                                      : Container(
                                    margin: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 32.0, right: 32.0),
                                    child: Row(
                                      children: [
                                        ///Price
                                        Flexible(
                                          flex: 3,
                                          child: Container(
                                            //width: media.width * 0.9,
                                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                              child: TextFormField(
                                                //enabled: canEditService,
                                                controller: priceController,
                                                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                textInputAction: TextInputAction.done,
                                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
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
                                                      } else if (priceString[1].length == 0) {
                                                        value += "00";
                                                      }
                                                    } else {
                                                      value += ".00";
                                                    }
                                                    setState(() {
                                                      _servicePrice = double.parse(value);
                                                    });
                                                  }
                                                },
                                                onEditingComplete: () {
                                                  StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                                  currentFocus.unfocus();
                                                },
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
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

                                        ///VAT
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 3.0, right: 42.0),
                                              child: TextFormField(
                                                //maxLength: 2,
                                                //enabled: canEditService,
                                                controller: vatController,
                                                keyboardType: TextInputType.number,
                                                textInputAction: TextInputAction.done,
                                                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)],

                                                ///Controllo sotto il 30%
                                                validator: (value) => value.isEmpty
                                                    ? AppLocalizations.of(context).serviceVATBlank
                                                    : validatePrice(value)
                                                    ? null
                                                    : AppLocalizations.of(context).notValidVAT,
                                                onChanged: (value) {
                                                  if (value == "") {
                                                    // setState(() {
                                                    //   _serviceVAT = 22;
                                                    //   value = "22";
                                                    // });
                                                  } else {
                                                    if (int.parse(value) > 25) {
                                                      setState(() {
                                                        _serviceVAT = 25;
                                                        vatController.text = '25';
                                                        vatController.selection = TextSelection.fromPosition(TextPosition(offset: vatController.text.length));
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _serviceVAT = int.parse(value);
                                                        vatController.text = value;
                                                        vatController.selection = TextSelection.fromPosition(TextPosition(offset: vatController.text.length));
                                                      });
                                                    }
                                                  }
                                                },
                                                onFieldSubmitted: (value) {
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVAT(_serviceVAT));
                                                  currentFocus.unfocus();
                                                },
                                                onEditingComplete: () {
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVAT(_serviceVAT));
                                                  currentFocus.unfocus();
                                                },
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack),
                                                decoration: InputDecoration(
                                                  suffixText: '%',
                                                  suffixStyle: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey,fontSize: 16),
                                                  labelText: AppLocalizations.of(context).serviceVAT,
                                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
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
                                                keyboardType: TextInputType.multiline,
                                                maxLines: null,
                                                controller: addressController,
                                                //initialValue: _serviceAddress,
                                                onChanged: (value) {
                                                  _serviceBusinessAddress = value;
                                                  _serviceBusinessAddress = value;
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceAddress(_serviceBusinessAddress));
                                                },
                                                onSaved: (value) {
                                                  _serviceBusinessAddress = value;
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
                                            Icons.add_location_alt,
                                            color: BuytimeTheme.ManagerPrimary,
                                          ),
                                          onPressed: (){
                                            Utils.googleSearch(
                                                context,
                                                    (place){
                                                  //_serviceAddress = store.state.business.street + ', ' + store.state.business.street_number + ', ' + store.state.business.ZIP + ', ' + store.state.business.state_province;
                                                      addressController.text = place[0];
                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceAddress(addressController.text));
                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceCoordinates('${place[1]}, ${place[2]}'));
                                                }
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  ///Categories
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 0.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context).selectCategories,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: media.height * 0.02,
                                              color: BuytimeTheme.TextBlack,
                                              fontWeight: FontWeight.w500,
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
                                                          controller: _tagServiceController,
                                                          textAlign: TextAlign.start,
                                                          decoration: InputDecoration(
                                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                            labelText:  AppLocalizations.of(context).addNewTag,
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
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_tagServiceController.text.isNotEmpty) {
                                                                snapshot.serviceState.tag.add(_tagServiceController.text);
                                                                _tagServiceController.clear();
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  (snapshot.serviceState.tag != null && snapshot.serviceState.tag.length > 0)
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
                                                          onDeleted: () {
                                                            setState(() {
                                                              snapshot.serviceState.tag.remove(snapshot.serviceState.tag[index]);
                                                            });
                                                          },
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
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ),

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
                rippleLoading ?
                Positioned.fill(
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
                ) :
                Container(),
              ]),
            );
          }),
    );
  }
}
