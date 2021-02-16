import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/UI/management/service/widget/W_service_tab_availability.dart';
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

class UI_EditService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_EditServiceState();
}

class UI_EditServiceState extends State<UI_EditService> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _keyEditServiceForm = GlobalKey<FormState>();
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


  double heightBookingBlock = 0.0;
  double heightBookingBlockTab1 = 350.00;

  bool errorCategoryListEmpty = false;
  bool editBasicInformation = false;
  bool resumeServiceBooking = true;
  TextEditingController _tagServiceController = TextEditingController();

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

  void setHeightBookingBlock() {
    setState(() {
      switch (bookingController.index) {
        case 0:
          heightBookingBlock = heightBookingBlockTab1;
          break;
        case 1:
          heightBookingBlock = 800;
          break;
        case 2:
          heightBookingBlock = (800 + numberCalendarIntervalAvailability.toDouble() * 50).toDouble();
          break;
      }
    });
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
    setHeightBookingBlock();
    bookingController.addListener(() {
      setHeightBookingBlock();
    });
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

  List<Widget> getTabs(Size media) {
    List<Widget> tabList = [];

    ///Tab Availability
    tabList.add(TabAvailability(media: media));

    ///Tab 2 : Length
    tabList.add(Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Row(
            children: [
              Text(
                "Service duration",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: media.height * 0.018,
                  color: BuytimeTheme.TextBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),
        ),
        Container(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundLightGrey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "0",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.020,
                            color: BuytimeTheme.TextGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "min", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.020,
                            color: BuytimeTheme.TextGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: media.width * 0.55,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: BuytimeTheme.BackgroundLightGrey),
                    color: BuytimeTheme.UserPrimary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
                    child: Center(
                      child: Text(
                        "SAVE", //todo: lang
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.020,
                          color: BuytimeTheme.TextWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));

    ///Tab 3 : ???
    tabList.add(Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Row(
            children: [
              Text(
                "1. Calendar availability",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: media.height * 0.018,
                  color: BuytimeTheme.TextBlack,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )),
        ),
        Container(
            child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundLightGrey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Start", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.024,
                            color: BuytimeTheme.TextGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: BuytimeTheme.BackgroundLightGrey,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Stop", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.024,
                            color: BuytimeTheme.TextGrey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Icon(Icons.calendar_today, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.00, horizontal: 0.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: media.width * 0.55,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: BuytimeTheme.BackgroundLightGrey),
                    color: BuytimeTheme.BackgroundWhite,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.add, color: BuytimeTheme.UserPrimary, size: media.width * 0.08),
                        Text(
                          "ADD INTERVAL", //todo: lang
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.025,
                            color: BuytimeTheme.UserPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: media.width * 0.55,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: BuytimeTheme.BackgroundLightGrey),
                    color: BuytimeTheme.UserPrimary,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
                    child: Center(
                      child: Text(
                        "SAVE", //todo: lang
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.020,
                          color: BuytimeTheme.TextWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ));

    return tabList;
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
          radioServiceVisibility = snapshot.serviceState.visibility;
          return Scaffold(
              appBar: BuytimeAppbar(
                width: media.width,
                children: [
                  Container(
                      child: IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.09),
                          onPressed: () {
                            if (!editBasicInformation) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                              );
                            } else {
                              setState(() {
                                editBasicInformation = false;
                              });
                            }
                          })),
                  Flexible(
                    child: Container(
                      child: Text(
                        //AppLocalizations.of(context).serviceEdit,
                        "Edit " + snapshot.serviceState.name,
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
                            StoreProvider.of<AppState>(context).dispatch(UpdateService(snapshot.serviceState));
                            if (editBasicInformation) {
                              setState(() {
                                editBasicInformation = false;
                              });
                            }
                            else{
                           //   Navigator.pop(context);
                            }
                          }
                        }),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: _keyEditServiceForm,
                  child: Column(
                    children: <Widget>[
                      !editBasicInformation
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 30.00),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: snapshot.serviceState.image1 == null || snapshot.serviceState.image1.isEmpty
                                          ? Image.asset('assets/img/image_placeholder.png',width: 100,height: 100,)
                                          : Image.network(
                                              Utils.sizeImage(snapshot.serviceState.image1, Utils.imageSizing200),
                                              height: 100,
                                              width: 100,
                                            ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.00),
                                        child: Container(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Container(
                                                      child: Text(
                                                        snapshot.serviceState.name,
                                                        style: TextStyle(
                                                          fontSize: media.height * 0.028,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        editBasicInformation = true;
                                                      });
                                                    },
                                                    child: Container(
                                                      child: Icon(Icons.edit, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        snapshot.serviceState.description,
                                                        style: TextStyle(
                                                          fontSize: media.height * 0.028,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),

                      ///Edit service basic information (clicked pencil)
                      editBasicInformation
                          ? Padding(
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
                                          image: snapshot.serviceState.image1 == null || snapshot.serviceState.image1.isEmpty
                                              ? null
                                              : Image.network(Utils.sizeImage(snapshot.serviceState.image1, Utils.imageSizing600)),
                                          cropAspectRatioPreset: CropAspectRatioPreset.square,
                                          onFilePicked: (fileToUpload) {
                                            print("UI_edit_service - callback!");
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
                                              image: snapshot.serviceState.image2 == null || snapshot.serviceState.image2.isEmpty
                                                  ? null
                                                  : Image.network(Utils.sizeImage(snapshot.serviceState.image2, Utils.imageSizing200)),
                                              cropAspectRatioPreset: CropAspectRatioPreset.square,
                                              onFilePicked: (fileToUpload) {
                                                print("UI_edit_service - callback!");
                                                StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                              },
                                            ),
                                          ),
                                          WidgetServicePhoto(
                                            remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                            maxPhoto: 1,
                                            image: snapshot.serviceState.image3 == null || snapshot.serviceState.image3.isEmpty
                                                ? null
                                                : Image.network(Utils.sizeImage(snapshot.serviceState.image3, Utils.imageSizing200)),
                                            cropAspectRatioPreset: CropAspectRatioPreset.square,
                                            onFilePicked: (fileToUpload) {
                                              print("UI_edit_service - callback!");
                                              StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      editBasicInformation
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Center(
                                child: Container(
                                  width: media.width * 0.9,
                                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      initialValue: snapshot.serviceState.name,
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
                            )
                          : Container(),
                      editBasicInformation
                          ? Padding(
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
                                      initialValue: snapshot.serviceState.description,
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
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Container(
                            width: media.width * 0.9,
                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                              child: TextFormField(
                                initialValue: snapshot.serviceState.price.toString(),
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

                      ///Categories Chip Block
                      editBasicInformation
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
                            )
                          : Container(),

                      ///Error message Empty CategoryList
                      errorCategoryListEmpty && editBasicInformation
                          ? Padding(
                              padding: const EdgeInsets.only(left: 30.0, bottom: 10.0),
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

                      ///Tag Block
                      editBasicInformation
                          ? Padding(
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
                                      padding: const EdgeInsets.only(top: 15.0),
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
                                                          snapshot.serviceState.tag.add(_tagServiceController.text);  //TODO : Check if is possible without errors
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
                            )
                          : Container(),

                      ///Column default edit screen
                      !editBasicInformation
                          ? Column(
                              children: [
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
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0, right: 15.0),
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

                                ///Switch Booking
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, left: 20.0, right: 20.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Switch(
                                            value: snapshot.serviceState.enabledBooking,
                                            onChanged: (value) {
                                              setState(() {
                                                StoreProvider.of<AppState>(context).dispatch(SetServiceEnabledBooking(value));
                                              });
                                            }),
                                        Expanded(
                                          child: Text(
                                            "The service can be booked by guests with time slots",
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
                                snapshot.serviceState.enabledBooking
                                    ?

                                    ///Resume block for booking settings
                                    resumeServiceBooking
                                        ? Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 15.0),
                                                child: Row(
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
                                              Padding(
                                                padding: const EdgeInsets.only(top: 20.0),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.00),
                                                  child: Container(
                                                    width: media.width * 0.50,
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        print("Edit Booking clicked");
                                                        setState(() {
                                                          resumeServiceBooking = false;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: Text(
                                                          "EDIT", //todo: lang
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: media.height * 0.022,
                                                            color: BuytimeTheme.ManagerPrimary,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        :

                                        ///Booking Settings Block
                                        Container(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0),
                                                  child: Container(
                                                    height: 50,
                                                    color: BuytimeTheme.ManagerPrimary,
                                                    child: TabBar(
                                                      controller: bookingController,
                                                      tabs: [
                                                        Text(
                                                          "AVAILABILITY", //todo: lang
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: BuytimeTheme.TextWhite,
                                                            fontSize: media.height * 0.018,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          "LENGTH", //todo: lang
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: BuytimeTheme.TextWhite,
                                                            fontSize: media.height * 0.018,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          "TAB", //todo: lang
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: BuytimeTheme.TextWhite,
                                                            fontSize: media.height * 0.018,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: snapshot.serviceState.tabAvailability.height,
                                                  child: TabBarView(
                                                    controller: bookingController,
                                                    children: getTabs(media),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                    : Container(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ));
        });
  }
}
