import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
  String _serviceDescription = "";
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;
  bool rippleLoading = false;
  bool errorCategoryListEmpty = false;
  TextEditingController _tagServiceController = TextEditingController();
  bool defaultCategory = true;

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
    selectedCategoryList = [];
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
    return WillPopScope(
      onWillPop: () async {
        ///Block iOS Back Swipe
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          onInit: (store) => store.dispatch(CategoryTreeRequest()),
          builder: (context, snapshot) {
            ///Popolo le categorie
            setCategoryList();
            addDefaultCategory();
            return Stack(children: [
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
                                    //Todo: POP o no?
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                                    );
                                  })),
                          Flexible(
                            child: Container(
                              child: Text(
                                AppLocalizations.of(context).createService,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: BuytimeTheme.appbarTitle,
                              ),
                            ),
                          ),
                          Container(
                            child: IconButton(
                                icon: Icon(Icons.check, color: Colors.white, size: media.width * 0.07),
                                onPressed: () {
                                  if (validateChosenCategories() && validateAndSave() && validatePrice(_servicePrice.toString())) {
                                    setState(() {
                                      rippleLoading = true;
                                    });
                                    StoreProvider.of<AppState>(context).dispatch(CreateService(snapshot.serviceState));
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
                                Padding(
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
                                Center(
                                  child: Container(
                                    width: media.width * 0.9,
                                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                      child: TextFormField(
                                          initialValue: _serviceName,
                                          validator: (value) => value.isEmpty ? AppLocalizations.of(context).serviceNameBlank : null,
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
                                          decoration: InputDecoration(
                                            labelText: AppLocalizations.of(context).name,
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          )),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: media.width * 0.9,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
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
                                        decoration: InputDecoration(
                                          labelText: AppLocalizations.of(context).description,
                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                        child: TextFormField(
                                          initialValue: _servicePrice.toString(),
                                          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              ),

              ///Ripple Effect
              rippleLoading
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
                            )),
                      ),
                    )
                  : Container(),
            ]);
          }),
    );
  }
}
