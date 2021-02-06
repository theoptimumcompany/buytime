import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/UI_M_manage_service_old.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/snippet/generic.dart';
import 'package:Buytime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/form/optimum_chip.dart';
import 'package:Buytime/reusable/form/optimum_dropdown.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UI_EditService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_EditServiceState();
}

class UI_EditServiceState extends State<UI_EditService> {
  String _serviceName = "";
  double _servicePrice = 0.0;
  String _serviceDescription = "";
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');
  Image image;
  final ImagePicker imagePicker = ImagePicker();
  List<Parent> selectedCategoryList = [];
  List<Parent> categoryList = [];
  var size;

  void setCategoryList() {
    CategoryTree categoryNode =
        StoreProvider.of<AppState>(context).state.categoryTree;
    List<Parent> items = [];

    if (categoryNode.categoryNodeList != null) {
      if (categoryNode.categoryNodeList.length != 0 &&
          categoryNode.categoryNodeList.length != null) {
        List<dynamic> list = categoryNode.categoryNodeList;
        items = openTree(list, items);
      }
    }

    categoryList = items;
  }

  openTree(List<dynamic> list, List<Parent> items) {
    for (int i = 0; i < list.length; i++) {
      items.add(
        Parent(name: list[i]['nodeName']),
      );
      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }

  void initState() {
    super.initState();
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
          labelStyle: TextStyle(color: selectedCategoryList.any((element) => element.id == item.id) ? Colors.black : Colors.white),
          onSelected: (selected) {

            setState(() {
              if (selectedCategoryList.any((element) => element.id == item.id)) {
                selectedCategoryList.removeWhere((element) => element.id == item.id);
              } else {
                selectedCategoryList.add(item);
              }
            });

            selectedCategoryList.forEach((element) {
              print(element.id);
            });
            // StoreProvider.of<AppState>(context).dispatch(SetServiceCategory(selectedChoices));
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
        // onInit: (store) => store.dispatch(new CategoryNodeRequest()),
        builder: (context, snapshot) {
          // switch (snapshot.serviceState.visibility) {
          //   case 'Visible':
          //     _selectedVisibility =  _visibility[0];
          //     break;
          //   case 'Shadow':
          //     _selectedVisibility =  _visibility[1];
          //     break;
          //   case 'Invisible':
          //     _selectedVisibility =  _visibility[2];
          //     break;
          // }
          //Popolo le categorie
          setCategoryList();
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(DeleteService(snapshot.serviceState.serviceId));

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UI_M_ServiceList()),
                    );

                },
                child: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                backgroundColor: Colors.red,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    OptimumFormMultiPhoto(
                      text: "profile",
                      remotePath: "service/" +
                          (snapshot.business.name != null
                              ? snapshot.business.name + "/"
                              : "") +
                          snapshot.serviceState.name,
                      maxHeight: 1000,
                      maxPhoto: 1,
                      maxWidth: (media.width * 0.9).toInt(),
                      minHeight: 200,
                      minWidth: 600,
                      cropAspectRatioPreset: CropAspectRatioPreset.square,
                      image: snapshot.serviceState == null ||
                              snapshot.serviceState.image1 == null ||
                              snapshot.serviceState.image1.isEmpty
                          ? null
                          : Image.network(snapshot.serviceState.image1,
                              width: media.width * 0.5),
                      onFilePicked: (fileToUpload) {
                        print("UI_create_service - callback!");
                        StoreProvider.of<AppState>(context)
                            .dispatch(AddFileToUploadInService(fileToUpload));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: snapshot.serviceState.name,
                              onChanged: (value) {
                                _serviceName = value;
                                StoreProvider.of<AppState>(context)
                                    .dispatch(SetServiceName(_serviceName));
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: snapshot.serviceState.description,
                              onChanged: (value) {
                                _serviceDescription = value;
                                StoreProvider.of<AppState>(context).dispatch(
                                    SetServiceDescription(_serviceDescription));
                              },
                              onSaved: (value) {
                                _serviceDescription = value;
                              },
                              decoration:
                                  InputDecoration(labelText: AppLocalizations.of(context).description),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Form(
                              child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue:
                                  snapshot.serviceState.price.toString(),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _servicePrice = double.parse(value);
                                StoreProvider.of<AppState>(context)
                                    .dispatch(SetServicePrice(_servicePrice));
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
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context).selectCateogories,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context).selectCateogories,
                                ),
                                Container(
                                    width: media.width * 0.8,
                                    child: Wrap(
                                      children: _buildChoiceList(),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
