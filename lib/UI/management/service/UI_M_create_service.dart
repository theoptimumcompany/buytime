import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_CreateService extends StatefulWidget {
  UI_CreateService();

  @override
  State<StatefulWidget> createState() => UI_CreateServiceState();
}

class UI_CreateServiceState extends State<UI_CreateService> {
  final GlobalKey<FormState> _keyCreateServiceForm = GlobalKey<FormState>();
  String _serviceName = "";
  double _servicePrice = 0.0;
  String _serviceDescription = "";
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');
  Image image;
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  ServiceVisibility radioServiceVisibility = ServiceVisibility.Invisible;

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
      return true;
    } else {
      return false;
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
          parentRootId: list[i]['parentRootId'],
        ),
      );
      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
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
          labelStyle: TextStyle(color: selectedCategoryList.any((element) => element.id == item.id) ? BuytimeTheme.TextBlack : BuytimeTheme.TextWhite),
          onSelected: (selected) {
            setState(() {
              if (selectedCategoryList.any((element) => element.id == item.id)) {
                selectedCategoryList.removeWhere((element) => element.id == item.id);
              } else {
                selectedCategoryList.add(item);
              }
            });

            ///Aggiorno lo store con la lista di categorie selezionate salvando id e rootId
            StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(CategoryTreeRequest()),
        builder: (context, snapshot) {
          setCategoryList();
          return Scaffold(
              appBar: BuytimeAppbarManager(
                width: media.width,
                children: [
                  Container(
                    child: IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.09),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      AppLocalizations.of(context).serviceCreation,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: media.height * 0.028,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white, size: media.width * 0.07),
                        onPressed: () {
                          // if (validateAndSave() || validateChosenCategories()) {
                          if (validateAndSave()) {
                            print("Salva nuovo servizio");
                          }
                        }),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _keyCreateServiceForm,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: Colors.yellow,
                                  child: WidgetServicePhoto(
                                    remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_1",
                                    maxPhoto: 1,
                                    cropAspectRatioPreset: CropAspectRatioPreset.square,
                                    onFilePicked: (fileToUpload) {
                                      print("UI_create_service - callback upload image 1!");
                                      // StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Container(
                                      child: WidgetServicePhoto(
                                        remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_2",
                                        maxPhoto: 1,
                                        cropAspectRatioPreset: CropAspectRatioPreset.square,
                                        onFilePicked: (fileToUpload) {
                                          print("UI_create_service -  callback upload image 2!");
                                          // StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                        },
                                      ),
                                    ),
                                    WidgetServicePhoto(
                                      remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                      maxPhoto: 1,
                                      cropAspectRatioPreset: CropAspectRatioPreset.square,
                                      onFilePicked: (fileToUpload) {
                                        print("UI_create_service -  callback upload image 3!");
                                        //StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Container(
                            width: media.width * 0.9,
                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                              child: TextFormField(
                                initialValue: _serviceName,
                                validator: (value) => value.isEmpty ? 'Service name is blank' : null,
                                onChanged: (value) {
                                  if (validateAndSave()) {
                                    _serviceName = value;
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceName(_serviceName));
                                  }
                                },
                                onSaved: (value) {
                                  if (validateAndSave()) {
                                    _serviceName = value;
                                    StoreProvider.of<AppState>(context).dispatch(SetServiceName(_serviceName));
                                  }
                                },
                                decoration: InputDecoration(labelText: AppLocalizations.of(context).name),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Container(
                            width: media.width * 0.9,
                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                initialValue: _serviceDescription,
                                onChanged: (value) {
                                  _serviceDescription = value;
                                  StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(_serviceDescription));
                                },
                                onSaved: (value) {
                                  _serviceDescription = value;
                                },
                                decoration: InputDecoration(labelText: AppLocalizations.of(context).description),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Container(
                            width: media.width * 0.9,
                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                              child: TextFormField(
                                initialValue: _servicePrice.toString(),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                                onChanged: (value) {
                                  if (value == "") {
                                    value = "0.0";
                                  }
                                  _servicePrice = double.parse(value);
                                  StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                },
                                onSaved: (value) {
                                  if (value == "") {
                                    value = "0.0";
                                  }
                                  _servicePrice = double.parse(value);
                                  StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                },
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context).price,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).selectCateogories,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: media.height * 0.018,
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                            child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: media.width * 0.05,
                              ),
                              child: Text(
                                'You have to select at least one category',
                                style: TextStyle(
                                  fontSize: media.height * 0.016,
                                  color: BuytimeTheme.ErrorRed,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        )),
                      ),

                      ///Divider under category selection

                      Container(
                        child: Divider(
                          indent: 0.0,
                          color: BuytimeTheme.DividerGrey,
                          thickness: 20.0,
                        ),
                      ),

                      ///Visibility Block
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: media.width * 0.05,
                                ),
                                child: Container(
                                  child: Text(
                                    "Visibility",
                                    //  AppLocalizations.of(context).visibility,  todo : aggiungere alle lingue
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: media.height * 0.018,
                                      color: BuytimeTheme.TextBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: media.width * 0.05, right: media.width * 0.07),
                                    child: Container(
                                      child: Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Text(
                                            "Active", //todo: lang
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: BuytimeTheme.TextBlack,
                                              fontSize: media.height * 0.018,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                          Container(
                                            child: Radio(
                                                value: ServiceVisibility.Active,
                                                groupValue: radioServiceVisibility,
                                                onChanged: (value) {
                                                  setState(() {
                                                    radioServiceVisibility = value;
                                                  });
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVisibility(value));
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: media.width * 0.05, right: media.width * 0.07),
                                    child: Container(
                                      child: Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Text(
                                            "Deactivated", //todo: lang
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: BuytimeTheme.TextBlack,
                                              fontSize: media.height * 0.018,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                          Container(
                                            child: Radio(
                                                value: ServiceVisibility.Deactivated,
                                                groupValue: radioServiceVisibility,
                                                onChanged: (value) {
                                                  setState(() {
                                                    radioServiceVisibility = value;
                                                  });
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVisibility(value));
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: media.width * 0.05, right: media.width * 0.07),
                                    child: Container(
                                      child: Icon(Icons.do_disturb_alt_outlined, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              child: Text(
                                            "Invisible", //todo: lang
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: BuytimeTheme.TextBlack,
                                              fontSize: media.height * 0.018,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                          Container(
                                            child: Radio(
                                                value: ServiceVisibility.Invisible,
                                                groupValue: radioServiceVisibility,
                                                onChanged: (value) {
                                                  setState(() {
                                                    radioServiceVisibility = value;
                                                  });
                                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVisibility(value));
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
