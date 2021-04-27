import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/invitation/category_invite_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/reducer/category_invite_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/model/snippet/manager.dart';
import 'package:Buytime/reblox/model/snippet/parent.dart';
import 'package:Buytime/reblox/model/snippet/worker.dart';
import 'package:Buytime/reusable/form/optimum_form_multi_photo.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:share/share.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../reusable/appbar/buytime_appbar.dart';

class UI_M_EditCategory extends StatefulWidget {
  final String title = 'Categories';

  @override
  State<StatefulWidget> createState() => UI_M_EditCategoryState();
}

class UI_M_EditCategoryState extends State<UI_M_EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // TODO hero kacchan fix duplicates all mightaaa "There are multiple heroes that share the same tag within a subtree."
  final GlobalKey<FormState> _formInviteKey = GlobalKey<FormState>();

  Parent _dropdownParentCategory = Parent(level: 0, id: "no_parent", name: "No Parent", parentRootId: "");

  List<DropdownMenuItem<Parent>> _dropdownMenuParentCategory = [];

  List<DropdownMenuItem<CustomTag>> _dropdownMenuCustomTag = [];

  var size;

  String selectedCategoryName = "";
  TextEditingController nameController = TextEditingController();
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

  CustomTag customTag;
  String bookingRequest = '';

  bool edit = false;

  void initState() {
    super.initState();
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) { nameController.text = selectedCategoryName;}
    // );
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
      Parent parentInitial = Parent(level: 0, id: "no_parent", name: "No Parent", parentRootId: "");
      StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(parentInitial));
    } else if (list != null && list.length > 0) {
      int nestedLevel = 0;
      if (contentSelectDrop.id == 'no_parent') {
        StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(0));
      } else {
        StoreProvider.of<AppState>(context).dispatch(SetCategoryLevel(contentSelectDrop.level + 1));
        nestedLevel = contentSelectDrop.level + 1;
      }
      StoreProvider.of<AppState>(context).dispatch(SetCategoryParent(contentSelectDrop));
    }
  }

  setNewCategoryName(String name) {
    StoreProvider.of<AppState>(context).dispatch(SetCategoryName(name));
  }

  setNewCategoryCustomTag(CustomTag customTag) {
    StoreProvider.of<AppState>(context).dispatch(SetCustomTag(Utils.enumToString(customTag)));
  }

  void buildDropDownMenuItemsParent(Parent item) {
    if (stopBuildDropDown == false) {
      stopBuildDropDown = true;
      CategoryTree categoryNode = StoreProvider
          .of<AppState>(context)
          .state
          .categoryTree;
      List<DropdownMenuItem<Parent>> items = [];

      if (categoryNode.categoryNodeList != null) {
        if (categoryNode.categoryNodeList.length != 0 && categoryNode.categoryNodeList.length != null) {
          List<dynamic> list = categoryNode.categoryNodeList;
          items = openTree(list, items);
        }
      }
      items.insert(
        0,
        DropdownMenuItem(
          child: Text(
            item.name,
            overflow: TextOverflow.ellipsis,
          ),
          value: item,
        ),
      );
      _dropdownMenuParentCategory = items;
    }
  }

  /*void buildDropDownMenuItemsCustomTag() {
    List<DropdownMenuItem<CustomTag>> items = [];

    items.insert(
      0,
      DropdownMenuItem(
        child: Text(
          item.name,
          overflow: TextOverflow.ellipsis,
        ),
        value: item,
      ),
    );
    _dropdownMenuParentCategory = items;
  }*/

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
        Parent parent = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level'], parentRootId: list[i]['categoryRootId']);
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
        debugPrint('UI_M_edit_category => NODE LEVEL: ${list[i]['level']}');
        if(list[i]['nodeName'] != StoreProvider.of<AppState>(context).state.category.name){
          Parent objectState = Parent(name: list[i]['nodeName'].toString(), id: list[i]['nodeId'], level: list[i]['level'], parentRootId: list[i]['categoryRootId']);
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
      }

      if (list[i]['nodeCategory'] != null) {
        openTree(list[i]['nodeCategory'], items);
      }
    }
    return items;
  }

  Future<bool> _onWillPop() {
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ManageCategory()),
    );*/
  }

  Future<Uri> createDynamicLink(String id, String businessId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://buytime.page.link',
      link: Uri.parse('https://buytime.page.link/categoryInvite/?categoryInvite=$id&businessId=$businessId'),
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
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    double wrap_width_text = MediaQuery
        .of(context)
        .size
        .width * 0.6;
    showDialog(
      context: context,
      builder: (_) =>
      new AlertDialog(
        actions: <Widget>[
          MaterialButton(
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            child: Text(AppLocalizations
                .of(context)
                .cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),

          ///Gestire invito manaager/worker da aggiungere alla categoria e alle sue sottocategorie
          MaterialButton(
            elevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            child: Text(AppLocalizations
                .of(context)
                .invite),
            onPressed: () async {
              print("Category Edit Mail to add : " + inviteMail);

              ///Avviare Spinner una volta pigiato invita, per attendere i controlli fatti dalla cloud function
              if (validateAndSaveInvite()) {
                Uri link = await createDynamicLink(StoreProvider.of<AppState>(context).state.category.id, StoreProvider.of<AppState>(context).state.business.id_firestore);

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
                Share.share(AppLocalizations
                    .of(context)
                    .checkOutBuytimeApp + ' $link',
                    subject: AppLocalizations
                        .of(context)
                        .takeYourTime, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
                          AppLocalizations
                              .of(context)
                              .inviteA + " " + role,
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
                          AppLocalizations
                              .of(context)
                              .typeA + " " + role + " " + AppLocalizations
                              .of(context)
                              .emailBelow,
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
                            validator: (value) =>
                            value.isEmpty
                                ? AppLocalizations
                                .of(context)
                                .emailCannotBeBlank
                                : validateEmail(value)
                                ? duplicateMail(role, value)
                                ? AppLocalizations
                                .of(context)
                                .emailExistsFor + role
                                : null
                                : AppLocalizations
                                .of(context)
                                .notAValidEmail,
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
                              labelText: AppLocalizations
                                  .of(context)
                                  .emailAddress,
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
                    title: new Text(AppLocalizations
                        .of(context)
                        .addManager),
                    onTap: () =>
                    {
                      Navigator.of(context).pop(),
                      sendInvitationMailDialog(context, 'Manager'),
                    }),
                new ListTile(
                  title: new Text(AppLocalizations
                      .of(context)
                      .addWorker),
                  onTap: () => {Navigator.of(context).pop(), sendInvitationMailDialog(context, 'Worker')},
                ),
              ],
            ),
          );
        });
  }

  Parent searchDropdownParent(var snapshot) {
    for (var element in _dropdownMenuParentCategory) {
      if (snapshot.category.parent.id == element.value.id) {
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
    List<Widget> listOfWidget = [];
    snapshot.business.owner.name != null && snapshot.business.owner.name != '' ?
    listOfWidget.add(
        InputChip(
          onPressed: (){},
          selected: false,
          label: Text(
            snapshot.business.owner.name != null ? snapshot.business.owner.name : AppLocalizations.of(context).owner,
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        )): null;

    snapshot.business.salesman.name != null && snapshot.business.salesman.name != '' ?
    listOfWidget.add(Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: InputChip(
        selected: false,
        label: Text(
          snapshot.business.salesman.name != null ? snapshot.business.salesman.name : AppLocalizations.of(context).salesman,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ))
        : null;

    if(listOfWidget.isEmpty)
      listOfWidget.add(
          Container(
            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
            child: Text(
              AppLocalizations.of(context).noManagerAssigned,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
      );

    return listOfWidget;
  }

  List<Widget> listEmptyWidget() {
    List<Widget> listOfWidget = new List();
    listOfWidget.add(Container(
      child: Text(AppLocalizations.of(context).empty),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, snapshot) {
          buildDropDownMenuItemsParent(_dropdownParentCategory);

          managerList = snapshot.category.manager;
          managerMailList = snapshot.category.managerMailList;
          workerList = snapshot.category.worker;
          workerMailList = snapshot.category.workerMailList;
          selectedParentCategory = searchDropdownParent(snapshot);
          selectedCategoryName = snapshot.category.name;
          nameController.text = snapshot.category.name;
          nameController.selection = TextSelection(baseOffset: snapshot.category.name.length, extentOffset: snapshot.category.name.length);
          //debugPrint('UI_M_edit_category: category Name: ${snapshot.category.name}, category Image: ${snapshot.category.categoryImage}');

          customTag = snapshot.category.customTag == 'showcase'
              ? CustomTag.showcase
              : snapshot.category.customTag == 'external'
              ? CustomTag.external
              : CustomTag.other;

          String businessName = snapshot.business.name;

          return GestureDetector(
            onTap: (){
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Stack(
              children: [
                ///Booking Code
                Positioned.fill(
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: WillPopScope(
                        onWillPop: _onWillPop,
                        child: Scaffold(
                          resizeToAvoidBottomInset: false,
                          appBar: BuytimeAppbar(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///Back button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_left,
                                        color: Colors.white,
                                        size: 25.0,
                                      ),
                                      tooltip: AppLocalizations.of(context).comeBack,
                                      onPressed: () {
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageCategory()),);
                                        Navigator.of(context).pop();
                                        //Navigator.pushReplacement(context, EnterExitRoute(enterPage: ManageCategory(), exitPage: UI_M_EditCategory(), from: false));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ///Title
                              Utils.barTitle(AppLocalizations.of(context).editSpace + snapshot.category.name),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                child: IconButton(
                                    icon: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                    tooltip: AppLocalizations.of(context).submitNewCategory,
                                    onPressed: !edit ? () {
                                      if (validateAndSave()) {
                                        /*setState(() {
                                          edit = true;
                                        });*/
                                        if (canMoveToParent) {
                                          setState(() {
                                            bookingRequest = 'send';
                                          });

                                          Parent newCategoryParent = selectedParentCategory;
                                          print("Aggiorno " + newCategoryParent.name);
                                          //StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequest(snapshot.business.id_firestore));
                                          ///aggiorno category tree
                                          StoreProvider.of<AppState>(context).dispatch(new UpdateCategoryTree(newCategoryParent));
                                          ///aggiorno singola categoria
                                          StoreProvider.of<AppState>(context).dispatch(new UpdateCategory(snapshot.category));
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AlertDialog(
                                                title: new Text(AppLocalizations.of(context).caution),
                                                content: new Text(AppLocalizations.of(context).youCannotMoveBranch),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    } : null),
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
                          body: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Column(
                                  children: <Widget>[
                                    ///Caterogry Image
                                    OptimumFormMultiPhoto(
                                      text: AppLocalizations.of(context).categoryImage,
                                      remotePath: "business/" + businessName + "/category",
                                      maxHeight: 1000,
                                      maxPhoto: 1,
                                      maxWidth: 800,
                                      minHeight: 200,
                                      minWidth: 600,
                                      cropAspectRatioPreset: CropAspectRatioPreset.square,
                                      image: snapshot.category.categoryImage == null || snapshot.category.categoryImage.isEmpty
                                          ? null
                                          : snapshot.category.categoryImage,
                                      //Image.network(snapshot.category.categoryImage, width: media.width * 0.3),
                                      onFilePicked: (fileToUpload) {
                                        fileToUpload.remoteFolder = "business/" + businessName + "/category";
                                        StoreProvider.of<AppState>(context).dispatch(AddFileToUploadInCategory(fileToUpload, fileToUpload.state, 0));
                                      },
                                    ),
                                    ///Category Name
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                      child: Center(
                                        child: Container(
                                          //width: media.width * 0.9,
                                          child: Form(
                                              key: _formKey,
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 20.0, right: 20.0),
                                                child: TextFormField(
                                                  enabled: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? true :false,
                                                  validator: (value) => value.isEmpty ? AppLocalizations.of(context).categoryNameIsBlank : null,
                                                  controller: nameController,
                                                  keyboardType: TextInputType.name,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedCategoryName = value;
                                                      setNewCategoryName(value);
                                                    });
                                                  },
                                                  style: TextStyle(
                                                      color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? BuytimeTheme.TextBlack : BuytimeTheme.TextGrey
                                                  ),
                                                  decoration: InputDecoration(
                                                    labelText: AppLocalizations.of(context).categoryName,
                                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.DividerGrey), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.DividerGrey), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.SymbolGrey), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: BuytimeTheme.AccentRed), borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  ),
                                                ),
                                              )),
                                        ),
                                      ),
                                    ),
                                    ///Category Tag
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
                                      child: Center(
                                        child: Container(
                                          //width: media.width * 0.9,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: BuytimeTheme.DividerGrey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<CustomTag>(
                                                  isExpanded: true,
                                                  value: customTag,
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        Utils.enumToString(CustomTag.showcase),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      value: CustomTag.showcase,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        Utils.enumToString(CustomTag.external),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      value: CustomTag.external,
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        Utils.enumToString(CustomTag.other),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      value: CustomTag.other,
                                                    ),
                                                  ],
                                                  decoration:
                                                  InputDecoration(labelText: AppLocalizations.of(context).customTag, enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      customTag = value;
                                                      setNewCategoryCustomTag(customTag);
                                                    });
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ///Parent Category
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 25.0, left: 20.0, right: 20.0),
                                      child: Center(
                                        child: Container(
                                          //width: media.width * 0.9,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: BuytimeTheme.DividerGrey)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButtonFormField<Parent>(
                                                  isExpanded: true,
                                                  value: selectedParentCategory,
                                                  items: _dropdownMenuParentCategory,
                                                  decoration: InputDecoration(
                                                      enabled: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? true : false,
                                                      labelText: AppLocalizations.of(context).parentCategory,
                                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                                                  onChanged: StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ? (value) {
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
                                                  } : null),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ///Manager & Worker
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ///Manager
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                                AppLocalizations.of(context).managers,
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(color: BuytimeTheme.TextDark, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily),
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
                                                  (managerList.length > 0 && managerList != null) ?
                                                  Flexible(
                                                    child: Container(
                                                      // height: media.height * 0.15,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: managerList.length,
                                                        physics: ClampingScrollPhysics(),
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
                                                    ),
                                                  ) : Container()
                                                ],
                                              ),
                                            ),
                                          ),
                                          ///Worker
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: BorderSide(
                                                    color: BuytimeTheme.DividerGrey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                                                child: Column(
                                                  children: [
                                                    ///Icon & Manager text
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
                                                                  AppLocalizations.of(context).workers,
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(color: BuytimeTheme.TextDark, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    (workerList.length > 0 && workerList != null) ?
                                                    Flexible(
                                                      child: Container(
                                                        height: media.height * 0.15,
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
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
                                                      ),
                                                    ) :
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 0, bottom: 0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 1),
                                                            child: Text(
                                                              AppLocalizations.of(context).noWorkersHere,
                                                              style: TextStyle(
                                                                fontSize: 13.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          )
                                                        ],
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
                                    ///Delete
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
                                                  onTap: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? () {
                                                    print("CategoryEdit ::: Elimino nodo categoria dall'albero");
                                                    StoreProvider.of<AppState>(context).dispatch(DeleteCategoryTree(snapshot.category.id));
                                                    print("CategoryEdit ::: Elimino categoria " + snapshot.category.id);
                                                    StoreProvider.of<AppState>(context).dispatch(DeleteCategory(snapshot.category.id));
                                                    Future.delayed(const Duration(milliseconds: 500), () {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ManageCategory(deleted: true)),
                                                      );
                                                    });
                                                  }  :null,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 25,
                                                          color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? BuytimeTheme.AccentRed : BuytimeTheme.SymbolGrey,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 10.0),
                                                          child: Text(
                                                            AppLocalizations.of(context).deleteCategory,
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? BuytimeTheme.AccentRed : BuytimeTheme.TextGrey,
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
                          ),
                        ),
                      )),
                ),

                ///Ripple Effect
                bookingRequest.isNotEmpty
                    ? Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
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
                    : Container()
              ],
            ),
          );
        });
  }
}
