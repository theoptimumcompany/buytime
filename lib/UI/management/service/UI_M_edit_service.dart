import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/UI_M_service_slot.dart';
import 'package:Buytime/UI/management/service/widget/W_service_photo.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
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
  bool errorCategoryListEmpty = false;
  bool rippleLoading = false;
  TextEditingController _tagServiceController = TextEditingController(); //todo: per quando si useranno tag

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
              validateChosenCategories();
            });

            ///Aggiorno lo store con la lista di categorie selezionate salvando id e rootId
            StoreProvider.of<AppState>(context).dispatch(SetServiceSelectedCategories(selectedCategoryList));
          },
        ),
      ));
    });
    return choices;
  }

  String showDaysInterval(int indexSlot, int indexInterval) {
    if (StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].switchWeek[indexInterval] == true &&
        StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].switchWeek[indexInterval] != null) {
      String week = 'Every Day';
      if (indexInterval < (StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].numberOfInterval - 1)) {
        week = week + "/";
      }
      return week;
    } else {
      String week = '';
      for (int z = 0; z < StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].daysInterval[indexInterval].everyDay.length; z++) {
        if (StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].daysInterval[indexInterval].everyDay[z]) {
          switch (z) {
            case 0:
              week = week + "Mon, ";
              break;
            case 1:
              week = week + "Tue, ";
              break;
            case 2:
              week = week + "Wed, ";
              break;
            case 3:
              week = week + "Thu, ";
              break;
            case 4:
              week = week + "Fri, ";
              break;
            case 5:
              week = week + "Sat, ";
              break;
            case 6:
              week = week + "Sun, ";
              break;
          }
        }
      }
      week = week.substring(0, week.length - 2);
      if (indexInterval < (StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].numberOfInterval - 1)) {
        week = week + " / ";
      }
      return week;
    }
  }

  Widget showSlotInterval(int numberOfInterval, Size media, int indexSlot) {
    List<Widget> listWidget = [];
    Widget singleWidget;
    String text = '';
    for (int i = 0; i < numberOfInterval; i++) {
      text = text +
          StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].startTime[i] +
          "-" +
          StoreProvider.of<AppState>(context).state.serviceState.serviceSlot[indexSlot].stopTime[i] +
          " " +
          showDaysInterval(indexSlot, i);
    }
    listWidget.add(Flexible(
      child: Container(
        child: Text(
          text,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontSize: media.height * 0.020,
            color: BuytimeTheme.TextGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ));
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: listWidget);
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
                                    "Edit " + StoreProvider.of<AppState>(context).state.serviceState.name, //Todo: trans
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
                                        setState(() {
                                          rippleLoading = true;
                                        });
                                        StoreProvider.of<AppState>(context).dispatch(UpdateService(snapshot.serviceState));
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
                                    key: _keyEditServiceForm,
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
                                                      image: snapshot.serviceState.image1 != ''
                                                          ? Image.network(
                                                              Utils.sizeImage(snapshot.serviceState.image1, Utils.imageSizing600),
                                                            )
                                                          : Image.asset('assets/img/image_placeholder.png'),
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
                                                          image: snapshot.serviceState.image2 != ''
                                                              ? Image.network(
                                                                  Utils.sizeImage(snapshot.serviceState.image2, Utils.imageSizing200),
                                                                )
                                                              : Image.asset('assets/img/image_placeholder.png'),
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
                                                        image: snapshot.serviceState.image3 != ''
                                                            ? Image.network(
                                                                Utils.sizeImage(snapshot.serviceState.image3, Utils.imageSizing200),
                                                              )
                                                            : Image.asset('assets/img/image_placeholder.png'),
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
                                              padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
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
                                        Center(
                                          child: Container(
                                            width: media.width * 0.9,
                                            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
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
                                        snapshot.serviceState.switchSlots
                                            ? Container()
                                            : Padding(
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
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0, top: 10.0),
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

                                        // ///Divider under category selection
                                        // Container(
                                        //   child: Divider(
                                        //     indent: 0.0,
                                        //     color: BuytimeTheme.DividerGrey,
                                        //     thickness: 5.0,
                                        //   ),
                                        // ),

                                        // ///Tag Block
                                        // Padding(
                                        //   padding: const EdgeInsets.only(left: 30.0, top: 5.0, bottom: 10.0, right: 30.0),
                                        //   child: Container(
                                        //     child: Column(
                                        //       crossAxisAlignment: CrossAxisAlignment.start,
                                        //       children: [
                                        //         Text(
                                        //           'Tag', //TODO: trans lang
                                        //           textAlign: TextAlign.start,
                                        //           style: TextStyle(
                                        //             fontSize: media.height * 0.02,
                                        //             color: BuytimeTheme.TextBlack,
                                        //             fontWeight: FontWeight.w500,
                                        //           ),
                                        //         ),
                                        //
                                        //         ///Tags
                                        //         Padding(
                                        //           padding: const EdgeInsets.only(top: 5.0),
                                        //           child: Container(
                                        //             child: Column(
                                        //               children: [
                                        //                 Row(
                                        //                   children: [
                                        //                     ///Add Tag field & Add Tag Button
                                        //                     Container(
                                        //                       height: 45,
                                        //                       width: media.width * 0.55,
                                        //                       child: TextFormField(
                                        //                         controller: _tagServiceController,
                                        //                         textAlign: TextAlign.start,
                                        //                         decoration: InputDecoration(
                                        //                           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        //                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        //                           errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.ErrorRed), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        //                           labelText: 'Add new tag',
                                        //                           labelStyle: TextStyle(
                                        //                             fontSize: 14,
                                        //                             fontFamily: BuytimeTheme.FontFamily,
                                        //                             color: BuytimeTheme.TextGrey,
                                        //                             fontWeight: FontWeight.w400,
                                        //                           ),
                                        //                         ),
                                        //                         style: TextStyle(
                                        //                           fontFamily: BuytimeTheme.FontFamily,
                                        //                           color: BuytimeTheme.TextGrey,
                                        //                           fontWeight: FontWeight.w800,
                                        //                         ),
                                        //                       ),
                                        //                     ),
                                        //
                                        //                     ///Add tag button
                                        //                     Container(
                                        //                       child: IconButton(
                                        //                         icon: Icon(
                                        //                           Icons.add_circle_rounded,
                                        //                           size: 30,
                                        //                           color: BuytimeTheme.TextGrey,
                                        //                         ),
                                        //                         onPressed: () {
                                        //                           setState(() {
                                        //                             if (_tagServiceController.text.isNotEmpty) {
                                        //                               snapshot.serviceState.tag.add(_tagServiceController.text); //TODO : Check if is possible without errors
                                        //                               _tagServiceController.clear();
                                        //                             }
                                        //                           });
                                        //                         },
                                        //                       ),
                                        //                     ),
                                        //                   ],
                                        //                 ),
                                        //                 (snapshot.serviceState.tag.length > 0 && snapshot.serviceState.tag != null)
                                        //                     ? Align(
                                        //                         alignment: Alignment.topLeft,
                                        //                         child: Wrap(
                                        //                           spacing: 3.0,
                                        //                           runSpacing: 3.0,
                                        //                           children: List<Widget>.generate(snapshot.serviceState.tag.length, (int index) {
                                        //                             return InputChip(
                                        //                               selected: false,
                                        //                               label: Text(
                                        //                                 snapshot.serviceState.tag[index],
                                        //                                 style: TextStyle(
                                        //                                   fontSize: 13.0,
                                        //                                   fontWeight: FontWeight.w500,
                                        //                                 ),
                                        //                               ),
                                        //                               onDeleted: () {
                                        //                                 setState(() {
                                        //                                   snapshot.serviceState.tag.remove(snapshot.serviceState.tag[index]);
                                        //                                 });
                                        //                               },
                                        //                             );
                                        //                           }),
                                        //                         ),
                                        //                       )
                                        //                     : Container()
                                        //               ],
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         Container(
                                        //             width: media.width * 0.9,
                                        //             child: Wrap(
                                        //               children: [Container()],
                                        //             )),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),

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

                                        ///Switch Service Bookable
                                        Padding(
                                          padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 20.0, right: 20.0),
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
                                                  left: 20.0,
                                                  right: 20.0,
                                                  bottom: 20.0,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
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
                                                              child: GestureDetector(
                                                            child: Icon(Icons.add, color: BuytimeTheme.SymbolGrey, size: media.width * 0.06),
                                                            onTap: () {
                                                              ///Svuoto lo stato dello slot
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotToEmpty());
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => UI_M_ServiceSlot(createSlot: true,editSlot: false,)),
                                                              );
                                                            },
                                                          )),
                                                        ],
                                                      ),
                                                    ),
                                                    snapshot.serviceState.serviceSlot.length > 0
                                                        ? Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                                            child: ConstrainedBox(
                                                              constraints: BoxConstraints(),
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                itemCount: snapshot.serviceState.serviceSlot.length,
                                                                itemBuilder: (context, index) {
                                                                  return Dismissible(
                                                                    key: UniqueKey(),
                                                                    direction: DismissDirection.endToStart,
                                                                    background: Container(
                                                                      color: Colors.red,
                                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                                      alignment: Alignment.centerRight,
                                                                      child: Icon(
                                                                        Icons.delete,
                                                                        color: BuytimeTheme.SymbolWhite,
                                                                      ),
                                                                    ),
                                                                    onDismissed: (direction) {
                                                                      setState(() {
                                                                        ///Deleting Slot
                                                                        print("Delete Slot " + index.toString());
                                                                        StoreProvider.of<AppState>(context).dispatch(DeleteServiceSlot(index));
                                                                      });
                                                                    },
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        StoreProvider.of<AppState>(context).dispatch(SetServiceSlot(snapshot.serviceState.serviceSlot[index]));
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => UI_M_ServiceSlot(createSlot:false,editSlot: true,indexSlot: index,)),
                                                                        );
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                                                        child: Card(
                                                                          elevation: 1.0,
                                                                          child: ListTile(
                                                                            title: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  'Time Availability ' + (index + 1).toString(),
                                                                                  style: TextStyle(
                                                                                    fontSize: media.height * 0.020,
                                                                                    color: BuytimeTheme.TextBlack,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                                // Text("Prezzo"),
                                                                              ],
                                                                            ),
                                                                            subtitle: Column(
                                                                              children: [
                                                                                Row(
                                                                                  children: [
                                                                                    Text(snapshot.serviceState.serviceSlot[index].checkIn + " - " + snapshot.serviceState.serviceSlot[index].checkOut),
                                                                                  ],
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    Text(snapshot.serviceState.serviceSlot[index].price.toString() + " euro"),
                                                                                  ],
                                                                                ),
                                                                                //showSlotInterval(snapshot.serviceState.serviceSlot[index].numberOfInterval, media, index),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  child: Text(
                                                                    (snapshot.serviceState.name != null && snapshot.serviceState.name != "" ? snapshot.serviceState.name : "The service") +
                                                                        " has not reservable slots",
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
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )))),

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
