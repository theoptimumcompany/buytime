import 'package:BuyTime/UI/management/business/UI_M_business_list.dart';
import 'package:BuyTime/UI/management/category/UI_manage_category.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../reusable/appbar/manager_buytime_appbar.dart';

class UI_CreateCategory extends StatefulWidget {
  final String title = 'Categories';

  @override
  State<StatefulWidget> createState() => UI_CreateCategoryState();
}

class UI_CreateCategoryState extends State<UI_CreateCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ObjectState _dropdownParentCategory = ObjectState(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<ObjectState>> _dropdownMenuParentCategory =
      new List<DropdownMenuItem<ObjectState>>();

  List<DropdownMenuItem<ObjectState>> _dropdownMenuManagerCategory;
  String _selectedManagerCategory;
  var size;

  String _selectedCategoryName = "";
  ObjectState selectedDropValue;
  ObjectState newParent;
  bool changeParent = false;
  bool stopBuildDropDown = false;

  void initState() {
    super.initState();
  }

  bool validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  setNewCategoryParent(ObjectState contentSelectDrop, List<dynamic> list) {
    if (list == null || list.length == 0) {
      ObjectState parentInitial = ObjectState(level: 0, id: "no_parent", name: "No Parent");
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(parentInitial));
    } else if (list != null && list.length > 0) {
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(contentSelectDrop.level + 1));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(contentSelectDrop));
    }
  }

  /* setNewCategoryManager(String id) {
    List<CategoryState> categoryList = StoreProvider.of<AppState>(context).state.categoryList.categoryListState;

    if (categoryList.length == 0 || categoryList.length == null) {
      CategoryManager newCategoryManager = new CategoryManager(["0"], ["Owner"]);
      StoreProvider.of<AppState>(context).dispatch(SetCategoryManager(newCategoryManager));
    } else {
      for (int i = 0; i < categoryList.length; i++) {
        for (int y = 0; y < categoryList[i].manager.managerId.length; y++) {
          if (categoryList[i].manager.managerId[y] == id) {
            List<String> newCategoryManagerName = new List<String>();
            List<String> newCategoryManagerId = new List<String>();
            for (int z = 0; z <= y; z++) {
              newCategoryManagerName.add(categoryList[i].manager.managerName[z]);
              newCategoryManagerId.add(categoryList[i].manager.managerId[z]);
            }
            CategoryManager newCategoryManager = new CategoryManager(newCategoryManagerId, newCategoryManagerName);
            StoreProvider.of<AppState>(context).dispatch(SetCategoryManager(newCategoryManager));
          }
        }
      }
      return null;
    }
  }*/

  void buildDropDownMenuItemsParent(ObjectState item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      CategorySnippet categoryNode = StoreProvider.of<AppState>(context).state.categorySnippet;
      List<DropdownMenuItem<ObjectState>> items = List();

      if (categoryNode.categoryNodeList != null) {
        if (categoryNode.categoryNodeList.length != 0 &&
            categoryNode.categoryNodeList.length != null) {
          List<dynamic> list = categoryNode.categoryNodeList;
          items = openTree(list, items);
        }
      }
      items.insert(
        0,
        DropdownMenuItem(
          child: Text(item.name),
          value: item,
        ),
      );

      _dropdownMenuParentCategory = items;
    }
  }

  openTree(List<dynamic> list, List<DropdownMenuItem<ObjectState>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['level'] < 6) {
        ObjectState objectState = ObjectState(
            name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
        items.add(
          DropdownMenuItem(
            child: Text(objectState.name),
            value: objectState,
          ),
        );
      }

      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }

  /* List<DropdownMenuItem<String>> buildDropDownMenuItemsManager(List listItems) {
    CategoryListState categoryListState = StoreProvider.of<AppState>(context).state.categoryList;
    List<DropdownMenuItem<String>> items = List();
    if (categoryListState.categoryListState.length == 0 || categoryListState.categoryListState.length == null) {
      for (CategoryManager listItem in listItems) {
        items.add(
          DropdownMenuItem(
            child: Text(listItem.managerName[0]),
            value: listItem.managerId[0],
          ),
        );
      }
    } else {
      for (int i = 0; i < categoryListState.categoryListState.length; i++) {
        for (int y = 0; y < categoryListState.categoryListState[i].manager.managerName.length; y++) {
          items.add(
            DropdownMenuItem(
              child: Text(categoryListState.categoryListState[i].manager.managerName[y]),
              value: categoryListState.categoryListState[i].manager.managerId[y],
            ),
          );
        }
      }
    }
    return items;
  }*/

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_ManageCategory()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          buildDropDownMenuItemsParent(_dropdownParentCategory);
          selectedDropValue = _dropdownMenuParentCategory.first.value;

          /* _dropdownMenuManagerCategory = buildDropDownMenuItemsManager(_dropdownManagerCategory);
          _selectedManagerCategory = _dropdownMenuManagerCategory[0].value;*/

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: BuyTimeAppbarManager(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      tooltip: 'Come back',
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_ManageCategory()),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        "Create Category",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: media.height * 0.028,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      tooltip: 'Submit New Category',
                      onPressed: () {
                        if (validateAndSave()) {
                          if (changeParent == false) {
                            print("Non ho scelto parent");
                            ObjectState newCategoryParent =
                                ObjectState(level: 0, id: "no_parent", name: "No Parent");
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryChildren(0));
                            StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
                            StoreProvider.of<AppState>(context)
                                .dispatch(SetCategoryParent(newCategoryParent));
                            StoreProvider.of<AppState>(context)
                                .dispatch(new CreateCategory(snapshot.category));
                            StoreProvider.of<AppState>(context)
                                .dispatch(new AddCategorySnippet(newCategoryParent));
                          } else {
                            StoreProvider.of<AppState>(context)
                                .dispatch(new CreateCategory(snapshot.category));
                            StoreProvider.of<AppState>(context)
                                .dispatch(new AddCategorySnippet(newParent));
                          }

                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UI_ManageCategory(
                                        created: true,
                                      )),
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Form(
                              key: _formKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                child: TextFormField(
                                  validator: (value) =>
                                      value.isEmpty ? 'Category name cannot be blank' : null,
                                  initialValue: _selectedCategoryName,
                                  onChanged: (value) {
                                    _selectedCategoryName = value;
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SetCategoryName(_selectedCategoryName));
                                  },
                                  onSaved: (value) {
                                    _selectedCategoryName = value;
                                  },
                                  decoration: InputDecoration(labelText: 'Category Name'),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<ObjectState>(
                                  value: selectedDropValue,
                                  items: _dropdownMenuParentCategory,
                                  decoration: InputDecoration(
                                      labelText: 'Parent Category',
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white))),
                                  onChanged: (ObjectState newValue) {
                                    setState(() {
                                      changeParent = true;
                                      selectedDropValue = newValue;
                                      newParent = newValue;
                                      print("Drop Selezionato su onchangedrop : " +
                                          selectedDropValue.name);
                                      setNewCategoryParent(selectedDropValue,
                                          snapshot.categorySnippet.categoryNodeList);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ), /*
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<String>(
                                  value: _selectedManagerCategory,
                                  items: _dropdownMenuManagerCategory,
                                  decoration: InputDecoration(labelText: 'Manager Category', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedManagerCategory = value;
                                      setNewCategoryParent(_selectedManagerCategory);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          );
        });
  }
}
