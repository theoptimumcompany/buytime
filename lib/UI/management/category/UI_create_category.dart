import 'package:Buytime/UI/management/category/UI_manage_category.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../../reusable/appbar/manager_buytime_appbar.dart';

class UI_CreateCategory extends StatefulWidget {
  final String title = 'Categories';
  String empty;

  UI_CreateCategory({String empty}) {
    this.empty = empty;
  }

  @override
  State<StatefulWidget> createState() => UI_CreateCategoryState();
}

class UI_CreateCategoryState extends State<UI_CreateCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formInviteKey = GlobalKey<FormState>();

  Parent _dropdownParentCategory = Parent(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<Parent>> _dropdownMenuParentCategory = new List<DropdownMenuItem<Parent>>();

  var size;

  String _selectedCategoryName = "";
  Parent selectedDropValue;
  Parent newParent;
  bool changeParent = false;
  bool stopBuildDropDown = false;
  String inviteMail = '';

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

  bool validateAndSaveInvite() {
    final FormState form = _formInviteKey.currentState;
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  bool validateEmail(String value) {
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  setNewCategoryParent(Parent contentSelectDrop, List<dynamic> list) {
    if (list == null || list.length == 0) {
      Parent parentInitial = Parent(level: 0, id: "no_parent", name: "No Parent");
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(parentInitial));
    } else if (list != null && list.length > 0) {
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(contentSelectDrop.level + 1));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(contentSelectDrop));
    }
  }

  void buildDropDownMenuItemsParent(Parent item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      CategoryTree categoryNode = StoreProvider.of<AppState>(context).state.categoryTree;
      List<DropdownMenuItem<Parent>> items = List();

      items.add(
        DropdownMenuItem(
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
          ),
          value: item,
        ),
      );

      if (categoryNode.categoryNodeList != null) {
        if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
          List<dynamic> list = categoryNode.categoryNodeList;
          items = openTree(list, items);
        }
      }

      _dropdownMenuParentCategory = items;
    }
  }

  openTree(List<dynamic> list, List<DropdownMenuItem<Parent>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['level'] < 4) {
        Parent parent = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
        items.add(
          DropdownMenuItem(
            child: Padding(
              padding: EdgeInsets.only(
                left: double.parse(list[i]["level"].toString()) * 12.0,
              ),
              child: Text(parent.name),
            ),
            value: parent,
          ),
        );
      }

      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_ManageCategory()),
    );
  }

  Parent searchDropdownParent(var snapshot) {
    if (widget.empty == 'empty') {
      return _dropdownMenuParentCategory.first.value;
    }

    for (var element in _dropdownMenuParentCategory) {
      if (snapshot.category.id == element.value.id) {
        return element.value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          buildDropDownMenuItemsParent(_dropdownParentCategory);

          if (snapshot.category != null) {
            selectedDropValue = searchDropdownParent(snapshot);
          }

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: BuytimeAppbarManager(
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
                            print("CategoryCreate : Parent non Scelto");
                            CategoryState categoryCreate = snapshot.category != null ? snapshot.category : CategoryState().toEmpty();
                            Parent newCategoryParent = selectedDropValue;
                            print("Livello prima : " + snapshot.category.level.toString());
                            categoryCreate.parent = newCategoryParent;
                            if (categoryCreate.parent != _dropdownMenuParentCategory.first.value) {
                              categoryCreate.level = newCategoryParent.level + 1;
                            } else {
                              categoryCreate.level = 0;
                            }

                            StoreProvider.of<AppState>(context).dispatch(new CreateCategory(categoryCreate));
                            StoreProvider.of<AppState>(context).dispatch(new AddCategoryTree(newCategoryParent));
                          } else {
                            CategoryState categoryCreate = snapshot.category != null ? snapshot.category : CategoryState().toEmpty();
                            StoreProvider.of<AppState>(context).dispatch(new CreateCategory(categoryCreate));
                            StoreProvider.of<AppState>(context).dispatch(new AddCategoryTree(newParent));
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
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Center(
                            child: Container(
                              width: media.width * 0.9,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                              child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      validator: (value) => value.isEmpty ? 'Category name cannot be blank' : null,
                                      initialValue: _selectedCategoryName,
                                      onChanged: (value) {
                                        _selectedCategoryName = value;
                                        StoreProvider.of<AppState>(context).dispatch(SetCategoryName(_selectedCategoryName));
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
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<Parent>(
                                      isExpanded: true,
                                      value: selectedDropValue,
                                      items: _dropdownMenuParentCategory,
                                      decoration: InputDecoration(labelText: 'Parent Category', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                      onChanged: (Parent newValue) {
                                        setState(() {
                                          changeParent = true;
                                          selectedDropValue = newValue;
                                          newParent = newValue;
                                          print("Drop Selezionato su onchangedrop : " + selectedDropValue.name);
                                          setNewCategoryParent(selectedDropValue, snapshot.categoryTree.categoryNodeList);
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
