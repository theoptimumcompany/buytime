import 'package:BuyTime/UI/management/service/UI_M_service_list.dart';
import 'package:BuyTime/UI/management/service/UI_manage_service_old.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/tree/category_tree_state.dart';
import 'package:BuyTime/reblox/model/snippet/generic.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reusable/form/optimum_chip.dart';
import 'package:BuyTime/reusable/form/optimum_dropdown.dart';
import 'package:BuyTime/reusable/form/optimum_form_multi_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UI_CreateService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_CreateServiceState();
}

class UI_CreateServiceState extends State<UI_CreateService> {
  String _serviceName = "";
  double _servicePrice = 0.0;
  String _serviceDescription = "";
  AssetImage assetImage = AssetImage('assets/img/image_placeholder.png');
  Image image;
  final ImagePicker imagePicker = ImagePicker();
  List<GenericState> categoryList = [GenericState(content: "Category 1"), GenericState(content: "Category 2"), GenericState(content: "Category 3")];
  List<GenericState> pipelineListName = [GenericState(content: "Pipeline 1"), GenericState(content: "Pipeline 2"), GenericState(content: "Pipeline 3")];
  List<GenericState> _tags = [GenericState(content: "Tag 1"), GenericState(content: "Tag 2"), GenericState(content: "Tag 3")];
  List<GenericState> _actions = [GenericState(content: "Action 1"), GenericState(content: "Action 2"), GenericState(content: "Action 3")];
  List<GenericState> _constraints = [GenericState(content: "Constraint 1"), GenericState(content: "Constraint 2"), GenericState(content: "Constraint 3")];
  List<GenericState> _positions = [GenericState(content: "Position 1"), GenericState(content: "Position 2"), GenericState(content: "Position 3")];
  List<GenericState> _visibility = [GenericState(content: "Visible"), GenericState(content: "Shadow"), GenericState(content: "Invisible")];

  List<DropdownMenuItem<GenericState>> _dropActions;
  GenericState _selectedAction;

  List<DropdownMenuItem<GenericState>> _dropTags;
  GenericState _selectedTag;

  List<DropdownMenuItem<GenericState>> _dropConstraints;
  GenericState _selectedConstraint;

  List<DropdownMenuItem<GenericState>> _dropPositions;
  GenericState _selectedPosition;

  List<DropdownMenuItem<GenericState>> _dropVisibility;
  GenericState _selectedVisibility;

  var size;

  void setPipelineList() {
    PipelineList pipelineList = StoreProvider.of<AppState>(context).state.pipelineList;
    List<GenericState> items = List();
    for (int i = 0; i < pipelineList.pipelineList.length; i++) {
      items.add(GenericState(
        content: pipelineList.pipelineList[i].name,
      ));
    }
    pipelineListName = items;
  }

  void setCategoryList() {
    CategoryTree categoryNode = StoreProvider.of<AppState>(context).state.categoryTree;
    List<GenericState> items = List();

    if (categoryNode.categoryNodeList != null) {
      if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
        List<dynamic> list = categoryNode.categoryNodeList;
        items = openTree(list, items);
      }
    }

    categoryList = items;
  }

  openTree(List<dynamic> list, List<GenericState> items) {
    for (int i = 0; i < list.length; i++) {
      items.add(
        GenericState(content: list[i]['nodeName']),
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        // onInit: (store) => store.dispatch(new CategoryNodeRequest()),
        builder: (context, snapshot) {
          //Popolo le categorie
          setCategoryList();
          setPipelineList();
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    OptimumFormMultiPhoto(
                      text: "profile",
                      remotePath: "service/" + (snapshot.business.name != null ? snapshot.business.name + "/" : "") + snapshot.serviceState.name,
                      maxHeight: 1000,
                      maxPhoto: 1,
                      maxWidth: (media.width * 0.9).toInt(),
                      minHeight: 200,
                      minWidth: 600,
                      cropAspectRatioPreset: CropAspectRatioPreset.square,
                      onFilePicked: (fileToUpload) {
                        print("UI_create_service - callback!");
                        StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInService(fileToUpload));
                      },
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
                              decoration: InputDecoration(labelText: 'Name'),
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
                              initialValue: _serviceDescription,
                              onChanged: (value) {
                                _serviceDescription = value;
                                StoreProvider.of<AppState>(context).dispatch(SetServiceDescription(_serviceDescription));
                              },
                              onSaved: (value) {
                                _serviceDescription = value;
                              },
                              decoration: InputDecoration(labelText: 'Description'),
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
                                labelText: 'Price',
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
                            "Select Categories",
                          ),
                          Container(
                              width: media.width * 0.8,
                              child: OptimumChip(
                                chipList: categoryList,
                                selectedChoices: snapshot.serviceState.categoryList,
                                optimumChipListToDispatch: (List<GenericState> selectedChoices) {
                                  StoreProvider.of<AppState>(context).dispatch(SetServiceCategory(selectedChoices));
                                },
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedAction,
                              items: _dropActions,
                              list: _actions,
                              optimumDropdownToDispatch: (GenericState selectedAction) {
                                //  StoreProvider.of<AppState>(context).dispatch(SetServicePipelineId(selectedChoices));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Select all pipelines that apply",
                          ),
                          Container(
                              width: media.width * 0.8,
                              child: OptimumChip(
                                chipList: pipelineListName,
                                optimumChipListToDispatch: (List<GenericState> selectedChoices) {
                                  StoreProvider.of<AppState>(context).dispatch(SetServicePipeline(selectedChoices));
                                },
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedTag,
                              items: _dropTags,
                              list: _tags,
                              optimumDropdownToDispatch: (GenericState selectedTag) {
                                //  StoreProvider.of<AppState>(context).dispatch(SetServicePipelineId(selectedChoices));
                              },
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedConstraint,
                              items: _dropConstraints,
                              list: _constraints,
                              optimumDropdownToDispatch: (GenericState Constraint) {
                                //  StoreProvider.of<AppState>(context).dispatch(SetServicePipelineId(selectedChoices));
                              },
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedPosition,
                              items: _dropPositions,
                              list: _positions,
                              optimumDropdownToDispatch: (GenericState selectedPosition) {
                                //  StoreProvider.of<AppState>(context).dispatch(SetServicePipelineId(selectedChoices));
                              },
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedVisibility,
                              items: _dropVisibility,
                              list: _visibility,
                              optimumDropdownToDispatch: (GenericState selectedVisibility) {
                                _selectedVisibility = selectedVisibility;
                                StoreProvider.of<AppState>(context).dispatch(SetServiceVisibility(selectedVisibility.content));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      textColor: Colors.black,
                      onPressed: () {
                        ServiceState serviceState = snapshot.serviceState;
                        _selectedVisibility == null ? serviceState.visibility = _visibility[0].content : serviceState.visibility = snapshot.serviceState.visibility;
                        StoreProvider.of<AppState>(context).dispatch(new CreateService(serviceState, snapshot.business.id_firestore));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                        );
                      },
                      child: Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
