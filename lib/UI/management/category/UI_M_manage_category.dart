import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/category/UI_M_edit_category.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/UI/management/category/UI_M_create_category.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/tree_view/expander_theme_data.dart';
import 'package:Buytime/utils/tree_view/models/node.dart';
import 'package:Buytime/utils/tree_view/tree_view.dart';
import 'package:Buytime/utils/tree_view/tree_view_controller.dart';
import 'package:Buytime/utils/tree_view/tree_view_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class ManageCategory extends StatefulWidget {
  final String title = 'Categories';

  ManageCategory({this.edited = false, this.created = false, this.deleted = false});

  bool edited;
  bool created;
  bool deleted;
  final GlobalKey<ScaffoldState> _keyScaffoldCategory = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => ManageCategoryState();
}

class ManageCategoryState extends State<ManageCategory> with SingleTickerProviderStateMixin {

  AnimationController animate;
  Animation<double> _iconTurns;
  @override
  void initState() {
    super.initState();
    _iconTurns = AnimationController(duration: Duration(milliseconds: 200), vsync: this).drive(Tween<double>(begin: 0.0, end: 0.5).chain(CurveTween(curve: Curves.easeIn)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openSnackbar();
    });
  }

  void openSnackbar() {
    setState(() {
      if (widget.created) {
        final snackBar = SnackBar(
          backgroundColor: Colors.blue,
          elevation: 5,
          duration: Duration(seconds: 3),
          content: Text(
            AppLocalizations.of(context).categoryCreated,
            style: TextStyle(color: Colors.white),
          ),
        );
        widget._keyScaffoldCategory.currentState.showSnackBar(snackBar);
      } else if (widget.edited) {
        final snackBar = SnackBar(
          elevation: 5,
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          content: Text(
            AppLocalizations.of(context).categoryEdited,
            style: TextStyle(color: Colors.white),
          ),
        );
        widget._keyScaffoldCategory.currentState.showSnackBar(snackBar);
      } else if (widget.deleted) {
        final snackBar = SnackBar(
          elevation: 5,
          backgroundColor: BuytimeTheme.ManagerPrimary,
          duration: Duration(seconds: 3),
          content: Text(
            AppLocalizations.of(context).categoryDeleted,
            style: TextStyle(color: BuytimeTheme.TextWhite),
          ),
        );
        widget._keyScaffoldCategory.currentState.showSnackBar(snackBar);
      }
      widget.edited = false;
      widget.created = false;
      widget.deleted = false;
    });
  }

  Widget buildBranchesAfterRoot(List<dynamic> list, int index) {
    if (list != null) {
      return Padding(
        padding: EdgeInsets.only(left: double.parse(list[index]["level"].toString()) * 12.0, right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0),
        child: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)
            ? ExpansionTile(
                title: GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UI_M_EditCategory()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: Text(
                              list[index]["nodeName"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ?
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_sharp,
                            color: Colors.black,
                            size: 25.0,
                          ),
                          tooltip: AppLocalizations.of(context).createSubCategory,
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UI_M_CreateCategory(
                                              empty: false,
                                            )),
                                  )
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text(AppLocalizations.of(context).caution),
                                        content: new Text(AppLocalizations.of(context).maxCategories),
                                      );
                                    },
                                  );
                          },
                        ) : Container(),
                      ],
                    )),
                children: [
                  (list[index]['nodeCategory'] != null) ? buildBranchesAfterRoot(list[index]['nodeCategory'], index) : Text(AppLocalizations.of(context).empty),
                ],
              )
            : ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        child: Text(
                          list[index]["nodeName"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    list[index]['level'] < 4
                        ? IconButton(
                            icon: const Icon(
                              Icons.add_circle_sharp,
                              color: Colors.black,
                              size: 25.0,
                            ),
                            tooltip: AppLocalizations.of(context).createSubCategory,
                            onPressed: () {
                              StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                              StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UI_M_CreateCategory(
                                                empty: false,
                                              )),
                                    )
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        // return object of type Dialog
                                        return AlertDialog(
                                          title: new Text(AppLocalizations.of(context).caution),
                                          content: new Text(AppLocalizations.of(context).maxCategories),
                                        );
                                      },
                                    );
                            },
                          )
                        : Container(),
                  ],
                ),
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UI_M_EditCategory()),
                    );
                  });
                },
              ),
      );

      // print(list[i]["nodeName"]);

    } else {
      return Container();
    }
  }
  
  Widget buildBranchesRoot(List<dynamic> list, int index) {
    if (list != null) {
      return Container(
        child: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)
            ? Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 0.0,left: list[index]["level"] * 20.0, /*right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0*/),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              children: [
                ExpansionTile(
                  title: GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditCategory()),);
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_EditCategory(), exitPage: ManageCategory(), from: true));
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 4.0),
                          child: Text(
                            list[index]["nodeName"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0, 
                                fontWeight: FontWeight.w600, 
                                fontFamily: BuytimeTheme.FontFamily,
                              //color: BuytimeTheme.ManagerPrimary.withOpacity(0.6)
                            ),
                          ),
                        ),
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ?
                        IconButton(
                          padding: EdgeInsets.all(0.0),
                          splashRadius: 1.0,
                          alignment: Alignment.centerRight,
                          icon: Icon(
                            Icons.my_library_add,
                            color: BuytimeTheme.ManagerPrimary,
                            size: 24.0,
                          ),
                          tooltip: AppLocalizations.of(context).createSubCategory,
                          onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                ?
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateCategory(empty: false,)),)
                            Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true))
                                : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text(AppLocalizations.of(context).caution),
                                  content: new Text(AppLocalizations.of(context).createSubCategory),
                                );
                              },
                            );
                          } : null,
                        ) : Container()
                      ],
                    ),
                  ),
                  children: listChildrenBranchCategory(list[index]['nodeCategory']),
                ),
                Divider(
                  indent: list[index]["level"] == 0 ? 20 : ((list[index]["level"]) * 40/list[index]["level"]) - 20,
                  color: BuytimeTheme.ManagerPrimary.withOpacity(0.25),
                  thickness: 1.0,
                ),
              ],
            ),
          ),
        )
            : Column(
          children: [
            ///Category Name
            InkWell(
              onTap: () {
                StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                Future.delayed(const Duration(milliseconds: 500), () {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditCategory()),);
                  Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditCategory(), exitPage: ManageCategory(), from: true));
                });
              },
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 8.0,left: double.parse(list[index]["level"].toString()) * 20.0, /*right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0*/),
                child: Container(
                  height: 36,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 20.0),
                          child: Text(
                            list[index]["nodeName"],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600,
                                //color: BuytimeTheme.ManagerPrimary.withOpacity(0.6)
                            ),
                          ),
                        ),
                      ),
                      list[index]['level'] < 4 ?
                      StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ?
                      Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: IconButton(
                          //padding: EdgeInsets.all(0.0),
                          alignment: Alignment.centerLeft,
                          icon: Icon(
                            Icons.my_library_add,
                            color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? BuytimeTheme.ManagerPrimary : BuytimeTheme.SymbolGrey,
                            size: 24.0,
                          ),
                          tooltip: AppLocalizations.of(context).createSubCategory,
                          onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                ?
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateCategory(empty: false,)),)
                            Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true))
                                : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text(AppLocalizations.of(context).caution),
                                  content: new Text(AppLocalizations.of(context).maxCategories),
                                );
                              },
                            );
                          } : null,
                        ),
                      ) : Container() : Container(),
                    ],
                  ),
                ),
              ),
            ),
            ///Divider under category name
            Divider(
              indent: list[index]["level"] == 0 ? 20 : double.parse(list[index]["level"].toString()) * 40 - 20,
              color: BuytimeTheme.ManagerPrimary.withOpacity(0.25),
              thickness: 1.0,
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> listBranchCategory() {
    List<Widget> branches = [];
    List<dynamic> firebaseTree = StoreProvider.of<AppState>(context).state.categoryTree.categoryNodeList != null ? StoreProvider.of<AppState>(context).state.categoryTree.categoryNodeList : [];
    branches.add(SizedBox(
      height: 10,
    ));
    if (firebaseTree != null && firebaseTree.isNotEmpty) {
      for (int i = 0; i < firebaseTree.length; i++) {
        branches.add(buildBranchesRoot(firebaseTree, i));
      }
      branches.add(Divider(
        height: 1.5,
      ));
    } else {
      branches.add(Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: SizeConfig.safeBlockVertical * 8,
          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5),
          decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context).noCategoriesForBusiness,
                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                ),
              )),
        ),
      ));
    }
    return branches;
  }

  List<Widget> listChildrenBranchCategory(List<dynamic> firebaseTree) {
    List<Widget> branches = new List();
    branches.add(SizedBox(
      height: 10,
    ));
    if (firebaseTree != null) {
      for (int i = 0; i < firebaseTree.length; i++) {
        branches.add(buildBranchesRoot(firebaseTree, i));
      }
    }
    return branches;
  }

  List<Widget> branches = [];
  List<Node> nodeBranches = [];
  bool startRequest = false;
  bool noActivity = false;
  
  Node addNode(Node node){
    nodeBranches.last.children.add(node);
    return nodeBranches.last;
  }

  List<String> keys = [];
  Map<String, bool> expand = Map();

  Node buildNodeBranchesRoot(List<dynamic> list, int index) {
    //debugPrint('UI_M_manager_category => ${list[index]}');
    keys.add(list[index]["nodeId"]);
    String bg = '';
    if(StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessId != null){
      StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessSnippet.forEach((element) {
        if(element.categoryAbsolutePath.split('/').last == list[index]["nodeId"])
          bg = element.categoryImage;
      });
    }

    expand.putIfAbsent(list[index]["nodeId"], () => false);
    if (list != null) {
      if((list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)){
        return Node(
          bg: bg,
          label: list[index]["nodeName"],
          key: list[index]["nodeId"],
          expanded: expand[list[index]["nodeId"]],
          children: listChildrenNodeBranchCategory(list[index]['nodeCategory']),
          actionIcon: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ?
            InkWell(
              /*padding: EdgeInsets.all(0.0),
              splashRadius: 1.0,
              alignment: Alignment.centerRight,*/
              child: Icon(
                Icons.my_library_add,
                color: BuytimeTheme.SymbolWhite,
                size: 24.0,
              ),
             // tooltip: AppLocalizations.of(context).createSubCategory,
              onTap: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? () {
                StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                    ?
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateCategory(empty: false,)),)
                Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true))
                    : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // return object of type Dialog
                    return AlertDialog(
                      title: new Text(AppLocalizations.of(context).caution),
                      content: new Text(AppLocalizations.of(context).createSubCategory),
                    );
                  },
                );
              } : null,
            ) : Container(),
          /*icon: Icon(
              expand[list[index]["nodeId"]] ? Icons.folder_open : Icons.folder
          ).icon*/
        );
      }
      return Node(
        bg: bg,
        label: list[index]["nodeName"],
        key: list[index]["nodeId"],
        /*icon: Icon(
          expand[list[index]["nodeId"]] ? Icons.folder : Icons.folder_open
        ).icon,*/
        actionIcon: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ?
        InkWell(
          /*padding: EdgeInsets.all(0.0),
          splashRadius: 1.0,
          alignment: Alignment.centerRight,*/
          child: Icon(
            Icons.my_library_add,
            color: BuytimeTheme.SymbolWhite,
            size: 24.0,
          ),
          //tooltip: AppLocalizations.of(context).createSubCategory,
          onTap: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ? () {
            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                ?
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_CreateCategory(empty: false,)),)
            Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true))
                : showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text(AppLocalizations.of(context).caution),
                  content: new Text(AppLocalizations.of(context).createSubCategory),
                );
              },
            );
          } : null,
        ) : Container(),
      );
    } else {
      return Node();
    }
  }

  List<Node> listChildrenNodeBranchCategory(List<dynamic> firebaseTree) {
    List<Node> branches = new List();
    if (firebaseTree != null) {
      for (int i = 0; i < firebaseTree.length; i++) {
        branches.add(buildNodeBranchesRoot(firebaseTree, i));
      }
    }
    return branches;
  }

  String _selectedNode;
  TreeViewController _treeViewController;
  TreeViewTheme _treeViewTheme = TreeViewTheme(
    expanderTheme: ExpanderThemeData(
      type: ExpanderType.chevron,
      modifier: ExpanderModifier.squareOutlined,
      position: ExpanderPosition.end,
      color: BuytimeTheme.ManagerPrimary,
      size: 24,
    ),
    labelStyle: TextStyle(
      fontSize: 16,
      letterSpacing: 0.3,
    ),
    parentLabelStyle: TextStyle(
      fontSize: 16,
      letterSpacing: 0.1,
      fontWeight: FontWeight.w800,
      color: BuytimeTheme.ManagerPrimary,
    ),
    iconTheme: IconThemeData(
      size: 18,
      color: BuytimeTheme.ManagerPrimary,
    ),
    colorScheme: ColorScheme.light(),
  );

  bool docsOpen = true;
  ///Expand
  _expandNode(String key, bool expanded) {
    String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    debugPrint(msg);
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      for(int i = 0; i < keys.length; i++){
        if (key == keys[i]) {
          updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon:  Icon(
                  expand[key] ? Icons.folder_open : Icons.folder
              ).icon,),
          );
        } else {
          updated = _treeViewController.updateNode(
              key, node.copyWith(expanded: expanded));
        }
        setState(() {
          if (key == keys[i]) expand[key] = expanded;
          _treeViewController = _treeViewController.copyWith(children: updated);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store){
          //store.dispatch(CategoryTreeRequest());
          store.state.categoryList.categoryListState.clear();
          //store.state.categoryTree.categoryNodeList.clear();
          store.dispatch(CategoryTreeCreateIfNotExists(store.state.business.id_firestore, context));
          startRequest = true;
        },
        builder: (context, snapshot) {
          List<dynamic> firebaseTree = [];
          branches.clear();
          nodeBranches.clear();
          if(snapshot.categoryTree.categoryNodeList == null && startRequest){
            //noActivity = true;
          }else{
            if(snapshot.categoryTree.categoryNodeList != null){
              firebaseTree = snapshot.categoryTree.categoryNodeList;
              firebaseTree.sort((a,b) => a['nodeName'].compareTo(b['nodeName']));
              branches.add(SizedBox(
                height: 10,
              ));
              for (int i = 0; i < firebaseTree.length; i++) {
                branches.add(buildBranchesRoot(firebaseTree, i));
                nodeBranches.add(buildNodeBranchesRoot(firebaseTree, i));
              }
              branches.add(Divider(
                height: 1.5,
                color: BuytimeTheme.DividerGrey,
              ));
              _treeViewController = TreeViewController(children: nodeBranches, selectedKey: _selectedNode,);
            }
            noActivity = false;
            startRequest = false;
          }
          return WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus();
              //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()),);
              return false;
            },
            child: Scaffold(
              key: widget._keyScaffoldCategory,
              appBar: BuytimeAppbar(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.white, size: 24),
                    tooltip: AppLocalizations.of(context).comeBack,
                    onPressed: () {
                      snapshot.serviceListSnippetState = ServiceListSnippetState();
                      StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequest(snapshot.business.id_firestore));
                       Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: ManageCategory(), from: false));
                      //Navigator.of(context).pop();
                    },
                  ),

                  ///Title
                  Utils.barTitle(AppLocalizations.of(context).categories),
                  StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ?
                    IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: BuytimeTheme.SymbolWhite,
                      size: 24.0,
                    ),
                    tooltip: AppLocalizations.of(context).createCategory,
                    onPressed: () {
                      snapshot.categoryTree.numberOfCategories < 50
                          ? Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: true), exitPage: ManageCategory(), from: true))
                          : showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text(AppLocalizations.of(context).caution),
                                  content: new Text(AppLocalizations.of(context).noCategoriesForBusiness),
                                );
                              },
                            );
                    },
                  ) : SizedBox(
                    width: 50.0,
                  ),
                ],
              ),
              body: SafeArea(
                child: Container(
                  //color: Colors.black54,
                  child: nodeBranches.isNotEmpty ?
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: TreeView(
                      //shrinkWrap: false,
                      controller: _treeViewController,
                      theme: TreeViewTheme(
                        expanderTheme: ExpanderThemeData(
                          type: ExpanderType.chevron,
                          modifier: ExpanderModifier.circleOutlined,
                          position: ExpanderPosition.end,
                          color: BuytimeTheme.ManagerPrimary,
                          size: 24,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w600,
                          color: BuytimeTheme.TextWhite,
                        ),
                        parentLabelStyle: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.1,
                          fontWeight: FontWeight.w600,
                          color: BuytimeTheme.TextWhite,
                        ),
                        iconTheme: IconThemeData(
                          size: 24,
                          color: BuytimeTheme.SymbolWhite,
                        ),
                        colorScheme: ColorScheme.light(),
                      ),
                      allowParentSelect: true,
                      onExpansionChanged: (key, expanded) =>
                          _expandNode(key, expanded),
                      onNodeTap: (key) {
                        _treeViewController =
                            _treeViewController.copyWith(selectedKey: key);
                        StoreProvider.of<AppState>(context).dispatch(CategoryRequest(key));
                        Future.delayed(const Duration(milliseconds: 500), () {
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditCategory()),);
                          Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditCategory(), exitPage: ManageCategory(), from: true));
                        });
                      },
                    ),
                  )
                  /*CustomScrollView(shrinkWrap: true, slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              //MenuItemModel menuItem = menuItems.elementAt(index);
                              Widget branch = branches.elementAt(index);
                              return branch;
                            },
                            childCount: branches.length,
                          ),
                        ),
                      ]) */: noActivity ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator()
                    ],
                  ) :
                  ///No List
                  Container(
                    height: SizeConfig.safeBlockVertical * 8,
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2.5),
                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Container(
                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).noCategoriesForBusiness,
                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        )),
                  ),
                ),
              )
            ),
          );
        });
  }
}
