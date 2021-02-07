import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_CreateService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_CreateServiceState();
}

class UI_CreateServiceState extends State<UI_CreateService> with SingleTickerProviderStateMixin {
  String _serviceName = "";
  double _servicePrice = 0.0;
  String _serviceDescription = "";
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');
  Image image;
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;
  ServiceVisibility radioServiceVisibility = ServiceVisibility.Invisible;
  bool switchBooking = false;
  TabController bookingController;
  int numberIntervalAvailability = 1;
  int numberCalendarIntervalAvailability = 1;
  List<bool> weekSwitch = [false, false, false, false, false, false, false];
  double heightBookingBlock = 0.0;

  void setHeightBookingBlock(){
    setState(() {
      switch (bookingController.index) {
        case 0 :
          heightBookingBlock = (250 + numberIntervalAvailability.toDouble() * 50).toDouble();
          break;
        case 1 :
          heightBookingBlock = 230;
          break;
        case 2 :
          heightBookingBlock = (730 + numberCalendarIntervalAvailability.toDouble() * 50).toDouble();
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
          parentRootId: list[i]['parentRootId'],
        ),
      );
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
    heightBookingBlock = (250 + numberIntervalAvailability.toDouble() * 50).toDouble();
    bookingController.addListener((){
      setHeightBookingBlock();
    });
  }

  @override
  void dispose() {
    bookingController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
    );
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

    ///Tab 1 : Availability -> todo : Convert in dynamic widget
    tabList.add(Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Row(
            children: [
              Text(
                "1. Availabile time",
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
                        Icon(Icons.av_timer, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
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
                        Icon(Icons.av_timer, color: BuytimeTheme.SymbolGrey, size: media.width * 0.07),
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
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Row(
            children: [
              Text(
                "Weekday availability",
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
        weekSwitchDay(media, weekSwitch[0], 'Monday'), //todo: lang
        weekSwitchDay(media, weekSwitch[1], 'Tuesday'), //todo: lang
        weekSwitchDay(media, weekSwitch[2], 'Wednesday'), //todo: lang
        weekSwitchDay(media, weekSwitch[3], 'Thursday'), //todo: lang
        weekSwitchDay(media, weekSwitch[4], 'Friday'), //todo: lang
        weekSwitchDay(media, weekSwitch[5], 'Saturday'), //todo: lang
        weekSwitchDay(media, weekSwitch[6], 'Sunday'), //todo: lang
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

  Widget weekSwitchDay(Size media, bool switchDay, String dayName) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: media.width * 0.05, right: media.width * 0.07),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Switch(
                  value: switchDay,
                  onChanged: (value) {
                    setState(() {
                      weekSwitch[0] = value;
                    });
                  }),
            ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    dayName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: BuytimeTheme.TextBlack,
                      fontSize: media.height * 0.018,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(CategoryTreeRequest()),
        builder: (context, snapshot) {
          //Popolo le categorie
          setCategoryList();
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: SingleChildScrollView(
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
                                    print("UI_create_service - callback!");
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
                                        print("UI_create_service - callback!");
                                        StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                                      },
                                    ),
                                  ),
                                  WidgetServicePhoto(
                                    remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name + "_3",
                                    maxPhoto: 1,
                                    cropAspectRatioPreset: CropAspectRatioPreset.square,
                                    onFilePicked: (fileToUpload) {
                                      print("UI_create_service - callback!");
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: _serviceName,
                              onChanged: (value) {
                                _serviceName = value;
                                StoreProvider.of<AppState>(context).dispatch(SetServiceName(_serviceName));
                              },
                              onSaved: (value) {
                                _serviceName = value;
                              },
                              decoration: InputDecoration(labelText: AppLocalizations.of(context).name),
                            ),
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Form(
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
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: _servicePrice.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _servicePrice = double.parse(value);
                                StoreProvider.of<AppState>(context).dispatch(SetServicePrice(_servicePrice));
                              },
                              onSaved: (value) {
                                _servicePrice = double.parse(value);
                              },
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context).price,
                              ),
                            ),
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
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
                                left: mediaWidth * 0.05,
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
                                  padding: EdgeInsets.only(left: mediaWidth * 0.05, right: mediaWidth * 0.07),
                                  child: Container(
                                    child: Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07),
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
                                  padding: EdgeInsets.only(left: mediaWidth * 0.05, right: mediaWidth * 0.07),
                                  child: Container(
                                    child: Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07),
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
                                  padding: EdgeInsets.only(left: mediaWidth * 0.05, right: mediaWidth * 0.07),
                                  child: Container(
                                    child: Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07),
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
                                value: switchBooking,
                                onChanged: (value) {
                                  setState(() {
                                    switchBooking = value;
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

                    switchBooking
                        ?

                        ///Booking Block
                        Column(
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
                                height: heightBookingBlock,
                                child: Expanded(
                                  child: TabBarView(
                                    controller: bookingController,
                                    children: getTabs(media),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}