import 'package:BuyTime/UI/management/service/UI_M_service_list.dart';
import 'package:BuyTime/UI/management/service/UI_manage_service_old.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/tree/category_tree_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/model/pipeline/pipeline_list_state.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reusable/form/optimum_chip.dart';
import 'package:BuyTime/reusable/form/optimum_dropdown.dart';
import 'package:BuyTime/reusable/form/optimum_form_multi_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
  List<ObjectState> categoryList = [
    ObjectState(name: "Category 1"),
    ObjectState(name: "Category 2"),
    ObjectState(name: "Category 3")
  ];
  List<ObjectState> pipelineListName = [
    ObjectState(name: "Pipeline 1"),
    ObjectState(name: "Pipeline 2"),
    ObjectState(name: "Pipeline 3")
  ];
  List<ObjectState> _tags = [
    ObjectState(name: "Tag 1"),
    ObjectState(name: "Tag 2"),
    ObjectState(name: "Tag 3")
  ];
  List<ObjectState> _actions = [
    ObjectState(name: "Action 1"),
    ObjectState(name: "Action 2"),
    ObjectState(name: "Action 3")
  ];
  List<ObjectState> _constraints = [
    ObjectState(name: "Constraint 1"),
    ObjectState(name: "Constraint 2"),
    ObjectState(name: "Constraint 3")
  ];
  List<ObjectState> _positions = [
    ObjectState(name: "Position 1"),
    ObjectState(name: "Position 2"),
    ObjectState(name: "Position 3")
  ];
  List<ObjectState> _visibility = [
    ObjectState(name: "Visible"),
    ObjectState(name: "Shadow"),
    ObjectState(name: "Invisible")
  ];

  List<DropdownMenuItem<ObjectState>> _dropActions;
  ObjectState _selectedAction;

  List<DropdownMenuItem<ObjectState>> _dropTags;
  ObjectState _selectedTag;

  List<DropdownMenuItem<ObjectState>> _dropConstraints;
  ObjectState _selectedConstraint;

  List<DropdownMenuItem<ObjectState>> _dropPositions;
  ObjectState _selectedPosition;

  List<DropdownMenuItem<ObjectState>> _dropVisibility;
  ObjectState _selectedVisibility;

  var size;

  void setPipelineList() {
    PipelineList pipelineList =
        StoreProvider.of<AppState>(context).state.pipelineList;
    List<ObjectState> items = List();
    for (int i = 0; i < pipelineList.pipelineList.length; i++) {
      items.add(ObjectState(
        name: pipelineList.pipelineList[i].name,
      ));
    }
    pipelineListName = items;
  }

  void setCategoryList() {
    CategoryTree categoryNode =
        StoreProvider.of<AppState>(context).state.categoryTree;
    List<ObjectState> items = List();

    if (categoryNode.categoryNodeList != null) {
      if (categoryNode.categoryNodeList.length != 0 &&
          categoryNode.categoryNodeList.length != null) {
        List<dynamic> list = categoryNode.categoryNodeList;
        items = openTree(list, items);
      }
    }

    categoryList = items;
  }

  openTree(List<dynamic> list, List<ObjectState> items) {
    for (int i = 0; i < list.length; i++) {
      items.add(
        ObjectState(name: list[i]['nodeName']),
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
          switch (snapshot.serviceState.visibility) {
            case 'Visible':
              _selectedVisibility =  _visibility[0];
              break;
            case 'Shadow':
              _selectedVisibility =  _visibility[1];
              break;
            case 'Invisible':
              _selectedVisibility =  _visibility[2];
              break;
          }
          //Popolo le categorie
          setCategoryList();
          setPipelineList();
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context)
                      .dispatch(DeleteService(snapshot.serviceState.id));

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
                      image: snapshot.serviceState == null ||
                              snapshot.serviceState.thumbnail == null ||
                              snapshot.serviceState.thumbnail.isEmpty
                          ? null
                          : Image.network(snapshot.serviceState.thumbnail,
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
                                  InputDecoration(labelText: 'Description'),
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
                                selectedChoices:
                                    snapshot.serviceState.categoryList,
                                optimumChipListToDispatch:
                                    (List<ObjectState> selectedChoices) {
                                  StoreProvider.of<AppState>(context).dispatch(
                                      SetServiceCategory(selectedChoices));
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedAction,
                              items: _dropActions,
                              list: _actions,
                              optimumDropdownToDispatch:
                                  (ObjectState selectedAction) {
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
                                selectedChoices:
                                    snapshot.serviceState.categoryList,
                                optimumChipListToDispatch:
                                    (List<ObjectState> selectedChoices) {
                                  StoreProvider.of<AppState>(context).dispatch(
                                      SetServicePipeline(selectedChoices));
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedTag,
                              items: _dropTags,
                              list: _tags,
                              optimumDropdownToDispatch:
                                  (ObjectState selectedTag) {
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedConstraint,
                              items: _dropConstraints,
                              list: _constraints,
                              optimumDropdownToDispatch:
                                  (ObjectState selectedConstraint) {
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedPosition,
                              items: _dropPositions,
                              list: _positions,
                              optimumDropdownToDispatch:
                                  (ObjectState selectedPosition) {
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OptimumDropdown(
                              value: _selectedVisibility,
                              items: _dropVisibility,
                              list: _visibility,
                              optimumDropdownToDispatch:
                                  (ObjectState selectedVisibility) {
                                  StoreProvider.of<AppState>(context).dispatch(SetServiceVisibility(selectedVisibility.name));
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    FlatButton(
                      textColor: Colors.black,
                      onPressed: () {
                        StoreProvider.of<AppState>(context)
                            .dispatch(new UpdateService(snapshot.serviceState));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UI_M_ServiceList()),
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
