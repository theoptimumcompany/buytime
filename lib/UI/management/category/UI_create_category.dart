import 'package:BuyTime/UI/management/category/UI_manage_category.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/category/category_snippet_state.dart';
import 'package:BuyTime/reblox/model/category/category_state.dart';
import 'package:BuyTime/reblox/model/object_state.dart';
import 'package:BuyTime/reblox/reducer/category_snippet_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:share/share.dart';
import '../../../reusable/appbar/manager_buytime_appbar.dart';
import '../../../utils/theme/buytime_theme.dart';
import '../../../utils/theme/buytime_theme.dart';
import '../../../utils/theme/buytime_theme.dart';

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

  ObjectState _dropdownParentCategory = ObjectState(level: 0, id: "no_parent", name: "No Parent");

  List<DropdownMenuItem<ObjectState>> _dropdownMenuParentCategory = new List<DropdownMenuItem<ObjectState>>();

  var size;

  String _selectedCategoryName = "";
  ObjectState selectedDropValue;
  ObjectState newParent;
  bool changeParent = false;
  bool stopBuildDropDown = false;

  ///Managers List
  List<ObjectState> managerList;

  ///Workers List
  List<ObjectState> workerList;

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
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
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

  void buildDropDownMenuItemsParent(ObjectState item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      CategorySnippet categoryNode = StoreProvider.of<AppState>(context).state.categorySnippet;
      List<DropdownMenuItem<ObjectState>> items = List();

      items.add(
        DropdownMenuItem(
          child: Text(item.name),
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

  openTree(List<dynamic> list, List<DropdownMenuItem<ObjectState>> items) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['level'] < 4) {
        ObjectState objectState =
            ObjectState(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level']);
        items.add(
          DropdownMenuItem(
            child: Padding(
              padding: EdgeInsets.only(
                left: double.parse(list[i]["level"].toString()) * 12.0,
              ),
              child: Text(objectState.name),
            ),
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
          FlatButton(
            child: Text("Invite"),
            onPressed: () async {
              if (validateAndSaveInvite()) {
                Uri link = await _createDynamicLink(false);
                Share.share('check out Buytime App at $link', subject: 'Take your Time!');
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                  child: Form(
                      key: _formInviteKey,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Container(
                          child: TextFormField(
                            autofocus: true,
                            validator: (value) => value.isEmpty
                                ? 'Email cannot be blank'
                                : validateEmail(value)
                                    ? null
                                    : 'Not a valid email',
                            onChanged: (value) {},
                            onSaved: (value) {},
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
                          sendInvitationMailDialog(context,'Manager'),
                        }),
                new ListTile(
                  title: new Text('Add Worker'),
                  onTap: () => {Navigator.of(context).pop(), sendInvitationMailDialog(context,'Worker')},
                ),
              ],
            ),
          );
        });
  }

  Future<Uri> _createDynamicLink(bool short) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://beta.itunes.apple.com/v1/app/1508552491'),
      androidParameters: AndroidParameters(
        packageName: 'com.theoptimumcompany.buytime',
        minimumVersion: 1,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.theoptimumcompany.buytime',
        minimumVersion: '1',
        appStoreId: '1508552491',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }
    return url;
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_ManageCategory()),
    );
  }

  ObjectState searchDropdownParent(var snapshot) {
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
            managerList = snapshot.category.manager;
            workerList = snapshot.category.worker;
            selectedDropValue = searchDropdownParent(snapshot);
          }

          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
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
                            print("CategoryCreate : Parent non Scelto");
                            CategoryState categoryCreate = snapshot.category;
                            ObjectState newCategoryParent = selectedDropValue;
                            print("Livello prima : " + snapshot.category.level.toString());
                            categoryCreate.level = newCategoryParent.level + 1;
                            categoryCreate.parent = newCategoryParent;

                            StoreProvider.of<AppState>(context).dispatch(new CreateCategory(categoryCreate));
                            StoreProvider.of<AppState>(context).dispatch(new AddCategorySnippet(newCategoryParent));
                          } else {
                            StoreProvider.of<AppState>(context).dispatch(new CreateCategory(snapshot.category));
                            StoreProvider.of<AppState>(context).dispatch(new AddCategorySnippet(newParent));
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
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print("add worker/manager");
                  _modalAddPerson(context);
                },
                child: Icon(Icons.add),
                backgroundColor: BuytimeTheme.Secondary,
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                              child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      validator: (value) => value.isEmpty ? 'Category name cannot be blank' : null,
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
                                  borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<ObjectState>(
                                      value: selectedDropValue,
                                      items: _dropdownMenuParentCategory,
                                      decoration: InputDecoration(
                                          labelText: 'Parent Category',
                                          enabledBorder:
                                              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                      onChanged: (ObjectState newValue) {
                                        setState(() {
                                          changeParent = true;
                                          selectedDropValue = newValue;
                                          newParent = newValue;
                                          print("Drop Selezionato su onchangedrop : " + selectedDropValue.name);
                                          setNewCategoryParent(
                                              selectedDropValue, snapshot.categorySnippet.categoryNodeList);
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: BuytimeTheme.DividerGrey,
                          width: 4.0,
                        ),
                        bottom: BorderSide(
                          color: BuytimeTheme.DividerGrey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InputChip(
                                  selected: false,
                                  label: Text(snapshot.business.owner.name + " " + snapshot.business.owner.surname),
                                ),
                              ),
                              snapshot.business.salesman.name != null && snapshot.business.salesman.name != ''
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 10.0),
                                      child: InputChip(
                                        selected: false,
                                        label: Text(
                                            snapshot.business.salesman.name + " " + snapshot.business.salesman.surname),
                                      ),
                                    )
                                  : Container(),
                              managerList.length > 1 && managerList != null
                                  ? List.generate(
                                      managerList.length,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 10.0),
                                          child: InputChip(
                                            selected: false,
                                            label: Text(managerList[index].name),
                                            //avatar: FlutterLogo(),
                                            onPressed: () {
                                              print('Manager is pressed');

                                              setState(() {
                                                //_selected = !_selected;
                                              });
                                            },
                                            onDeleted: () {
                                              print('Manager is deleted');
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
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
                          workerList.length > 1 && workerList != null
                              ? Wrap(
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                    workerList.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: InputChip(
                                          selected: false,
                                          label: Text(workerList[index].name),
                                          //avatar: FlutterLogo(),
                                          onPressed: () {
                                            print('Worker is pressed');

                                            setState(() {
                                              //_selected = !_selected;
                                            });
                                          },
                                          onDeleted: () {
                                            print('Worker is deleted');
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Text("Non ci sono lavoratori assegnati a questa categoria."),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
