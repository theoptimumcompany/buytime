import 'package:Buytime/UI/management/category/UI_manage_category.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';

import '../../../reusable/appbar/manager_buytime_appbar.dart';

class UI_EditCategory extends StatefulWidget {
  final String title = 'Categories';
  String empty;

  UI_EditCategory({String empty}) {
    this.empty = empty;
  }

  @override
  State<StatefulWidget> createState() => UI_EditCategoryState();
}

class UI_EditCategoryState extends State<UI_EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // TODO hero kacchan fix duplicates all mightaaa "There are multiple heroes that share the same tag within a subtree."
  final GlobalKey<FormState> _formInviteKey = GlobalKey<FormState>();

  Parent _dropdownParentCategory = Parent(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<Parent>> _dropdownMenuParentCategory = new List<DropdownMenuItem<Parent>>();

  var size;

  String _selectedCategoryName = "";
  Parent selectedParentCategory;
  Parent parentValue;
  bool hasChild = false;
  bool stopBuildDropDown = false;
  Parent selectedDropValue;

  ///Managers List
  List<Manager> managerList;
  List<String> managerMailList;

  ///Workers List
  List<Worker> workerList;
  List<String> workerMailList;

  /// Invite mail String
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

  openTree(List<dynamic> list, List<DropdownMenuItem<Parent>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['nodeId'] == StoreProvider.of<AppState>(context).state.category.parent && StoreProvider.of<AppState>(context).state.category.parent != "no_parent") {
        Parent parent = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
        parentValue = parent;
      }
      if (list[i]['nodeId'] == StoreProvider.of<AppState>(context).state.category.id) {
        if (list[i]['nodeCategory'] != null && list[i]['nodeCategory'].length != 0) {
          hasChild = true;
        } else {
          hasChild = false;
        }
      }
      if (list[i]['nodeId'] != StoreProvider.of<AppState>(context).state.category.id) {
        Parent objectState = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
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

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_ManageCategory()),
    );
  }

  Future<Uri> createDynamicLink(String id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://buytime.page.link/categoryInvite/?categoryInvite=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();
    print("Link dinamico creato " + dynamicUrl.toString());
    return dynamicUrl;
  }

  void sendInvitationMailDialog(context, String role) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double wrap_width_text = MediaQuery.of(context).size.width * 0.6;
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          ///Gestire invito manaager/worker da aggiungere alla categoria e alle sue sottocategorie
          FlatButton(
            child: Text("Invite"),
            onPressed: () async {
              print("Category Edit Mail to add : " + inviteMail);

              ///Avviare Spinner una volta pigiato invita, per attendere i controlli fatti dalla cloud function
              if (validateAndSaveInvite()) {
                Uri link = await createDynamicLink(StoreProvider.of<AppState>(context).state.category.id);
                ///Controllo se invito manager o worker e lancio la opportuna dispatch
                CategoryInviteState categoryInvite = CategoryInviteState().toEmpty();
                switch (role) {
                  case 'Manager':
                    Manager newManager = Manager(id: "", name: "", surname: "", mail: inviteMail);
                    categoryInvite.role = role;
                    categoryInvite.link = link.toString();
                    categoryInvite.mail = inviteMail;
                    StoreProvider.of<AppState>(context).dispatch(CreateCategoryInvite(categoryInvite));
                    StoreProvider.of<AppState>(context).dispatch(CategoryInviteManager(newManager));
                    break;
                  case 'Worker':
                    Worker newWorker = Worker(id: "", name: "", surname: "", mail: inviteMail);
                    categoryInvite.role = role;
                    categoryInvite.link = link.toString();
                    categoryInvite.mail = inviteMail;
                    StoreProvider.of<AppState>(context).dispatch(CreateCategoryInvite(categoryInvite));
                    StoreProvider.of<AppState>(context).dispatch(CategoryInviteWorker(newWorker));
                    break;
                }
                final RenderBox box = context.findRenderObject();
                Share.share('check out Buytime App at $link', subject: 'Take your Time!', sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                Navigator.of(context).pop();
              }
            },
          )
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          height: height * 0.28,
          child: new Column(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Invite a $role",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: BuytimeTheme.TextDark,
                            fontSize: height * 0.024,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: wrap_width_text,
                        child: Text(
                          "Type a $role email below. They will receive an email invite to install the application and join the business",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: BuytimeTheme.TextDark,
                            fontSize: height * 0.018,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                  child: Form(
                      key: _formInviteKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          child: TextFormField(
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value.isEmpty
                                ? 'Email cannot be blank'
                                : validateEmail(value)
                                    ? duplicateMail(role, value)
                                        ? 'Esiste già questa mail per un $role'
                                        : null
                                    : 'Not a valid email',
                            onChanged: (value) {
                              setState(() {
                                inviteMail = value;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                inviteMail = value;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Email address',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _modalAddPerson(context) {
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Add Manager'),
                    onTap: () => {
                          Navigator.of(context).pop(),
                          sendInvitationMailDialog(context, 'Manager'),
                        }),
                new ListTile(
                  title: new Text('Add Worker'),
                  onTap: () => {Navigator.of(context).pop(), sendInvitationMailDialog(context, 'Worker')},
                ),
              ],
            ),
          );
        });
  }

  Parent searchDropdownParent(var snapshot) {
    if (widget.empty == 'empty' || snapshot.category.level == 0) {
      return _dropdownMenuParentCategory.first.value;
    }

    for (var element in _dropdownMenuParentCategory) {
      if (snapshot.category.id == element.value.id) {
        return element.value;
      }
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

  bool duplicateMail(String role, String value) {
    switch (role) {
      case 'Manager':
        return managerMailList.contains(value) ? true : false;
        break;
      case 'Worker':
        return workerMailList.contains(value) ? true : false;
        break;
    }
  }

  List<Widget> listOfManagerChips(AppState snapshot) {
    List<Widget> listOfWidget = new List();
    listOfWidget.add(InputChip(
      selected: false,
      label: Text(
        snapshot.business.owner.content,
        style: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ));

    snapshot.business.salesman.content != null && snapshot.business.salesman.content != ''
        ? listOfWidget.add(Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: InputChip(
              selected: false,
              label: Text(
                snapshot.business.salesman.content,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ))
        : listOfWidget.add(Container());

    return listOfWidget;
  }

  List<Widget> listEmptyWidget() {
    List<Widget> listOfWidget = new List();
    listOfWidget.add(Container(
      child: Text("Sono vuoto"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          buildDropDownMenuItemsParent(_dropdownParentCategory);
          if (snapshot.category != null) {
            managerList = snapshot.category.manager;
            managerMailList = snapshot.category.managerMailList;
            workerList = snapshot.category.worker;
            workerMailList = snapshot.category.workerMailList;
            selectedParentCategory = searchDropdownParent(snapshot);
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
                        "Edit " + snapshot.category.name,
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
                            if (canMoveToParent) {
                              Parent newCategoryParent = selectedParentCategory;
                              print("Aggiorno " + newCategoryParent.name);
                              StoreProvider.of<AppState>(context).dispatch(new UpdateCategory(snapshot.category));
                              StoreProvider.of<AppState>(context).dispatch(new UpdateCategoryTree(newCategoryParent));

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
                          }
                        }),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print("add worker/manager");
                  _modalAddPerson(context);
                },
                child: Icon(Icons.add),
                backgroundColor: BuytimeTheme.Secondary,
              ),
              body: Padding(
                padding: EdgeInsets.only(top: 10.0),
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
                                  initialValue: snapshot.category.name,
                                  keyboardType: TextInputType.name,
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
                      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0),
                      child: Center(
                        child: Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<Parent>(
                                  value: selectedParentCategory,
                                  items: _dropdownMenuParentCategory,
                                  decoration: InputDecoration(labelText: 'Parent Category', enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedParentCategory = value;
                                      checkNumberLevelToMove(snapshot.categoryTree.categoryNodeList, snapshot.category.id);
                                      setNewCategoryParent(selectedParentCategory, snapshot.categoryTree.categoryNodeList);
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
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            // height: media.height * 0.266,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: BuytimeTheme.DividerGrey,
                                  width: 16.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.account_balance_rounded,
                                              size: 24,
                                            ),
                                          ),
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                "Managers",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: BuytimeTheme.TextDark,
                                                  fontSize: media.height * 0.023,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: listOfManagerChips(snapshot),
                                    ),
                                  ),
                                  (managerList.length > 0 && managerList != null)
                                      ? Container(
                                          height: media.height * 0.15,
                                          child: ListView.builder(
                                            itemCount: managerList.length,
                                            itemBuilder: (context, i) {
                                              return Row(
                                                children: [
                                                  InputChip(
                                                    selected: false,
                                                    label: Text(
                                                      managerList[i].mail,
                                                      style: TextStyle(
                                                        fontSize: 13.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    //avatar: FlutterLogo(),
                                                    onPressed: () {
                                                      print('Manager is pressed');

                                                      ///Vedere che fare quando si pigia il chip
                                                      setState(() {
                                                        //_selected = !_selected;
                                                      });
                                                    },
                                                    onDeleted: () {
                                                      Manager managerToDelete = Manager(id: "", name: "", surname: "", mail: managerList[i].mail);
                                                      print("Mail di invito Manager da eliminare : " + managerList[i].mail);
                                                      CategoryInviteState categoryInviteState = CategoryInviteState().toEmpty();
                                                      categoryInviteState.role = "Manager";
                                                      categoryInviteState.id_category = snapshot.category.id;
                                                      categoryInviteState.mail = managerList[i].mail;
                                                      StoreProvider.of<AppState>(context).dispatch(DeleteCategoryInvite(categoryInviteState));
                                                      StoreProvider.of<AppState>(context).dispatch(new DeleteCategoryManager(managerToDelete));
                                                      print('Manager is deleted');
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: BuytimeTheme.DividerGrey,
                                    width: 4.0,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.room_service,
                                                size: 24,
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "Workers",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: BuytimeTheme.TextDark,
                                                    fontSize: media.height * 0.023,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    (workerList.length > 0 && workerList != null)
                                        ? Container(
                                            height: media.height * 0.15,
                                            child: ListView.builder(
                                              itemCount: workerList.length,
                                              itemBuilder: (context, i) {
                                                return Row(
                                                  children: [
                                                    InputChip(
                                                      selected: false,
                                                      label: Text(
                                                        workerList[i].mail,
                                                        style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        print('Worker is pressed');

                                                        ///Vedere che fare quando si pigia il chip
                                                        setState(() {
                                                          //_selected = !_selected;
                                                        });
                                                      },
                                                      onDeleted: () {
                                                        Worker workerToDelete = Worker(id: "", name: "", surname: "", mail: workerList[i].mail);
                                                        print("Mail di invito Worker da eliminare : " + workerList[i].mail);
                                                        CategoryInviteState categoryInviteState = CategoryInviteState().toEmpty();
                                                        categoryInviteState.role = "Worker";
                                                        categoryInviteState.id_category = snapshot.category.id;
                                                        categoryInviteState.mail = workerList[i].mail;
                                                        StoreProvider.of<AppState>(context).dispatch(DeleteCategoryInvite(categoryInviteState));
                                                        StoreProvider.of<AppState>(context).dispatch(new DeleteCategoryWorker(workerToDelete));
                                                        print('Worker is deleted');
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
                                            child: Row(
                                              children: [Text("Non ci sono lavoratori assegnati a questa categoria.")],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: BuytimeTheme.DividerGrey,
                                width: 16.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                !hasChild
                                    ? GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          print("CategoryEdit ::: Elimino nodo categoria dall'albero");
                                          StoreProvider.of<AppState>(context).dispatch(DeleteCategoryTree(snapshot.category.id));
                                          print("CategoryEdit ::: Elimino categoria " + snapshot.category.id);
                                          StoreProvider.of<AppState>(context).dispatch(DeleteCategory(snapshot.category.id));
                                          Future.delayed(const Duration(milliseconds: 500), () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => UI_ManageCategory(deleted: true)),
                                            );
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.delete,
                                                size: 25,
                                                color: BuytimeTheme.AccentRed,
                                              ),
                                            ),
                                            Container(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10.0),
                                                child: Text(
                                                  "Delete Category",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: BuytimeTheme.AccentRed,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
