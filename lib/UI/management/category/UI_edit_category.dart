import 'package:BuyTime/UI/management/business/UI_M_business_list.dart';
import 'package:BuyTime/UI/management/category/UI_manage_category.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:BuyTime/reusable/form/optimum_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class UI_EditCategory extends StatefulWidget {
  final String title = 'Categories';

  @override
  State<StatefulWidget> createState() => UI_EditCategoryState();
}

class UI_EditCategoryState extends State<UI_EditCategory> {
  ObjectState _dropdownParentCategory = ObjectState(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<ObjectState>> _dropdownMenuParentCategory = new List<DropdownMenuItem<ObjectState>>();

  List<DropdownMenuItem<ObjectState>> _dropdownMenuManagerCategory;
  String _selectedManagerCategory;
  var size;

  String _selectedCategoryName = "";
  ObjectState selectedParentCategory;
  ObjectState parentValue;
  bool hasChild = false;
  bool stopBuildDropDown = false;

  void initState() {
    super.initState();
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

  void  buildDropDownMenuItemsParent(ObjectState item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      CategorySnippet categoryNode = StoreProvider
          .of<AppState>(context)
          .state
          .categorySnippet;
      List<DropdownMenuItem<ObjectState>> items = List();

      if (categoryNode.categoryNodeList != null) {
        if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
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

  int numberLevel = 0;
  bool canMoveToParent = true;

  countNestedLevels(List<dynamic> list) {
    for (int i = 0; i < list.length; i++) {
      numberLevel++;
      if (list[i]['nodeCategory'] != null) {
        countNestedLevels(list[i]['nodeCategory']);
      }
    }
  }

  checkNumberLevelToMove(List<dynamic> list, String idCategory) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['nodeId'] == idCategory) {
        numberLevel++;
        if (list[i]['nodeCategory'] != null) {
          countNestedLevels(list[i]['nodeCategory']);
        }
      }
      if (list[i]['nodeCategory'] != null) {
        checkNumberLevelToMove(list[i]['nodeCategory'], idCategory);
      }
    }
  }

  openTree(List<dynamic> list, List<DropdownMenuItem<ObjectState>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['nodeId'] == StoreProvider.of<AppState>(context).state.category.parent && StoreProvider.of<AppState>(context).state.category.parent != "no_parent") {
        ObjectState objectState = ObjectState(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
        parentValue = objectState;
      }
      if (list[i]['nodeId'] == StoreProvider.of<AppState>(context).state.category.id) {
        if (list[i]['nodeCategory'] != null && list[i]['nodeCategory'].length != 0) {
          hasChild = true;
        } else {
          hasChild = false;
        }
      }
      if (list[i]['nodeId'] != StoreProvider.of<AppState>(context).state.category.id) {
        ObjectState objectState = ObjectState(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
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

  final GlobalKey<FormState> _formKeyManagerField = GlobalKey<FormState>();

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
          ObjectState objectState =  ObjectState(level: 0, id: "no_parent", name: "No Parent");
          parentValue = snapshot.category.parent.id == "no_parent" ? objectState : snapshot.category.parent;
          buildDropDownMenuItemsParent(_dropdownParentCategory);
          for (int i = 0; i < _dropdownMenuParentCategory.length; i++) {
            if (parentValue.id == _dropdownMenuParentCategory[i].value.id) {
              selectedParentCategory = _dropdownMenuParentCategory[i].value;
            }
          }

          /* _dropdownMenuManagerCategory = buildDropDownMenuItemsManager(_dropdownManagerCategory);
          _selectedManagerCategory = _dropdownMenuManagerCategory[0].value;*/

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  'Edit Category',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.blue,
                actions: <Widget>[
                  FlatButton(
                    textColor: Colors.black,
                    onPressed: () {
                      if (canMoveToParent) {
                        ObjectState newCategoryParent = selectedParentCategory;
                        print("Aggiorno " + newCategoryParent.name);
                        StoreProvider.of<AppState>(context).dispatch(new UpdateCategory(snapshot.category));
                        StoreProvider.of<AppState>(context).dispatch(new UpdateCategorySnippet(newCategoryParent));

                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UI_ManageCategory(
                                      edited: true,
                                    )),
                          );
                        });
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Caution"),
                              content: new Text("You can't move the branch to selected parent!"),
                            );
                          },
                        );
                      }
                    },
                    child: Icon(Icons.check),
                  ),
                ],
                iconTheme: new IconThemeData(color: Colors.black),
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                        accountName: snapshot.user.name != null ? Text(snapshot.user.name) : Text(""),
                        accountEmail: Text(snapshot.user.email),
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                        ),
                        currentAccountPicture: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: snapshot != null && snapshot.user != null && snapshot.user.photo != null && snapshot.user.photo.isEmpty ? NetworkImage("${snapshot.user.photo}") : null,
                          backgroundColor: Colors.transparent,
                        )),
                    ListTile(
                      leading: Icon(Icons.business_center),
                      title: Text('Businesses'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_M_BusinessList()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              floatingActionButton: !hasChild
                  ? FloatingActionButton(
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(DeleteCategorySnippet(snapshot.category.id));
                        StoreProvider.of<AppState>(context).dispatch(DeleteCategory(snapshot.category.id));
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => UI_ManageCategory(deleted: true)),
                          );
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.red,
                    )
                  : null,
              body: Padding(
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
                              child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              initialValue: snapshot.category.name,
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
                              child: DropdownButtonFormField<ObjectState>(
                                  value: selectedParentCategory,
                                  items: _dropdownMenuParentCategory,
                                  decoration: InputDecoration(labelText: 'Parent Category', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedParentCategory = value;
                                      checkNumberLevelToMove(snapshot.categorySnippet.categoryNodeList, snapshot.category.id);
                                      setNewCategoryParent(selectedParentCategory, snapshot.categorySnippet.categoryNodeList);
                                      if (selectedParentCategory.level + numberLevel < 6) {
                                        canMoveToParent = true;
                                        numberLevel = 0;
                                      } else {
                                        canMoveToParent = false;
                                        numberLevel = 0;
                                      }
                                    });
                                  }),
                            ),
                          ),
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
                            child: OptimumFormField(
                              field: "manager",
                              validateEmail: true,
                              minLength: 4,
                              inputDecoration: InputDecoration(labelText: 'invite manager by email'),
                              globalFieldKey: _formKeyManagerField,
                              typeOfValidate: "email",
                              initialFieldValue: "",
                              onSaveOrChangedCallback: (value) {
                             //TODO : Settare un objectState manager da aggiungere ? O vogliamo mail e basta?
                                //StoreProvider.of<AppState>(context).dispatch(AddCategoryManager(value));
                              },
                              
                            ),
                          ),
                        ),
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
