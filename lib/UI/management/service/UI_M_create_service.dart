import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/UI_M_service_slot.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/UI/management/service/widget/W_service_step_availabile_time.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  String _serviceDescription = "";
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;
  String radioServiceVisibility = "Invisible";
  TabController bookingController;

  int numberCalendarIntervalAvailability = 1;

  bool errorCategoryListEmpty = false;
  bool resumeServiceBooking = true;
  TextEditingController _tagServiceController = TextEditingController();

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
    if (widget.categoryId != null && widget.categoryId != "") {
      categoryList.forEach((element) {
        if (element.id == widget.categoryId) {
          selectedCategoryList.add(element);
          StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
        }
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

  @override
  void initState() {
    super.initState();
    bookingController = TabController(length: 3, vsync: this);
    bookingController.addListener(() {});
  }

  @override
  void dispose() {
    bookingController.dispose();
    super.dispose();
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
            if (widget.categoryId != null && widget.categoryId != "" && item.parentRootId != widget.categoryId) {
              return null;
            } else {
              setState(() {
                if (selectedCategoryList.any((element) => element.id == item.id)) {
                  selectedCategoryList.removeWhere((element) => element.id == item.id);
                } else {
                  selectedCategoryList.add(item);
                }
                validateChosenCategories();
              });

              ///Aggiorno lo store con la lista di categorie selezionate salvando id e rootId
              StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
            }
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
          //Popolo le categorie
          setCategoryList();
          addDefaultCategory();
          radioServiceVisibility = snapshot.serviceState.visibility;
          return Scaffold(
              appBar: BuytimeAppbar(
                width: media.width,
                children: [
                  Container(
                      child: IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.09),
                          onPressed: () {
                            //Todo: POP o no?
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                            );
                          })),
                  Flexible(
                    child: Container(
                      child: Text(
                        //AppLocalizations.of(context).serviceEdit,
                        "Create Service", //Todo: trans
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: media.height * 0.028,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: IconButton(
                        icon: Icon(Icons.check, color: Colors.white, size: media.width * 0.07),
                        onPressed: () {
                          if (validateChosenCategories() && validateAndSave() && validatePrice(_servicePrice.toString())) {
                            StoreProvider.of<AppState>(context).dispatch(CreateService(snapshot.serviceState));
                          }
                        }),
                  ),
                ],
              ),
              body: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
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
                                        child: WidgetServicePhoto(
                                          remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_1",
                                          maxPhoto: 1,
                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                          onFilePicked: (fileToUpload) {
                                            print("UI_create_service - callback upload image 1!");
                                            StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
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
                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                              },
                                            ),
                                          ),
                                          WidgetServicePhoto(
                                            remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                            maxPhoto: 1,
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
                                      validator: (value) => value.isEmpty
                                          ? 'Service price is blank'
                                          : validatePrice(value)
                                              ? null
                                              : 'Not a valid price',
                                      onChanged: (value) {
                                        if (value == "") {
                                          setState(() {
                                            _servicePrice = 0.0;
                                          });
                                        } else {
                                          setState(() {
                                            _servicePrice = double.parse(value);
                                          });
                                        }
                                        validateAndSave();
                                        StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                                      },
                                      onSaved: (value) {
                                        if (value == "") {
                                          setState(() {
                                            _servicePrice = 0.0;
                                          });
                                        } else {
                                          setState(() {
                                            _servicePrice = double.parse(value);
                                          });
                                        }
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
                              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).selectCateogories,
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
                                          'You have to select at least one category',
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
                                      'Tag', //TODO: trans lang
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
                                                      labelText: 'Add new tag',
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
                                                          snapshot.serviceState.tag.add(_tagServiceController.text); //TODO : Check if is possible without errors
                                                          _tagServiceController.clear();
                                                        }
                                                      });
                                                    },
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

                            ///Column default edit screen
                            Column(
                              children: [
                                ///Divider under category selection
                                Container(
                                  child: Divider(
                                    indent: 0.0,
                                    color: BuytimeTheme.DividerGrey,
                                    thickness: 5.0,
                                  ),
                                ),

                                ///Visibility Block
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
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
                                                fontSize: media.height * 0.02,
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
                                                          value: 'Active',
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
                                                          value: 'Deactivated',
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
                                                          value: 'Invisible',
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

                                ///Divider under visibility block
                                Container(
                                  child: Divider(
                                    indent: 0.0,
                                    color: BuytimeTheme.DividerGrey,
                                    thickness: 20.0,
                                  ),
                                ),

                                ///Switch Auto Confirm
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Switch(
                                            value: snapshot.serviceState.switchAutoConfirm,
                                            onChanged: (value) {
                                              setState(() {
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceSwitchAutoConfirm(value));
                                              });
                                            }),
                                        Expanded(
                                          child: Text(
                                            "Allow users to get this service without manager confirmation",
                                            //  AppLocalizations.of(context).  todo : aggiungere alle lingue
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

                                ///Switch Slots
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20.0, right: 20.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Switch(
                                            value: snapshot.serviceState.switchSlots,
                                            onChanged: (value) {
                                              setState(() {
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceSwitchSlots(value));
                                              });
                                            }),
                                        Expanded(
                                          child: Text(
                                            "The service can be reserved ",
                                            //  AppLocalizations.of(context).  todo : aggiungere alle lingue
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

                                ///Switch MultiPrice
                                Padding(
                                  padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Switch(
                                            value: snapshot.serviceState.switchMultiPrice,
                                            onChanged: (value) {
                                              setState(() {
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceSwitchMultiPrice(value));
                                              });
                                            }),
                                        Expanded(
                                          child: Text(
                                            "The service can have different price per slot",
                                            //  AppLocalizations.of(context).  todo : aggiungere alle lingue
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

                                    ///Resume block for booking settings
                                    resumeServiceBooking
                                        ? Padding(
                                          padding: const EdgeInsets.only(left: 20.0, right:20.0,bottom: 20.0,),
                                          child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Service time availability",
                                                          //  AppLocalizations.of(context).  todo : aggiungere alle lingue
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.021,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: IconButton(
                                                        icon: Icon(Icons.edit, color: BuytimeTheme.SymbolGrey, size: media.width * 0.06),
                                                        onPressed: () {
                                                          print("Edit Slot clicked");
                                                          setState(() {
                                                            resumeServiceBooking = false;
                                                          });
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => UI_M_ServiceSlot()),
                                                          );
                                                        },
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "No availability set, tap on edit to manage it",
                                                          //  AppLocalizations.of(context).  todo : aggiungere alle lingue
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.clip,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.018,
                                                            color: BuytimeTheme.TextBlack,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ):Container()
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
