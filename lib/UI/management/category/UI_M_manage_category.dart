/* Copyright 2022 The Buytime Authors. All Rights Reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

import 'dart:convert';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/category/UI_M_edit_category.dart';
import 'package:Buytime/UI/management/service_internal/RUI_M_service_list.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/UI/management/category/UI_M_create_category.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/category/tree/category_tree_state.dart';
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
  static String route = '/categories';

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
  List<dynamic> firebaseTree = [];

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

  ///Funzione che costruisce tree dallo snippet, senza avere gestione del tree su DB
  List<dynamic> buildTreeFromSnippet() {
    List<dynamic> snippet = StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessSnippet;
    if(snippet != null && snippet.isNotEmpty)
      snippet.sort((a, b) => a.categoryAbsolutePath.length.compareTo(b.categoryAbsolutePath.length));

    List<dynamic> tree = [];
    if (snippet != null && snippet.isNotEmpty) {
      for (var i = 0; i < snippet.length; i++) {
        String categoryPath = snippet[i].categoryAbsolutePath;
        List<String> categoryRoute = categoryPath.split('/');
        if (categoryRoute.length <= 2) {
          ///La categoria è una foglia
          CategoryTree singleNode = CategoryTree();
          singleNode.nodeName = snippet[i].categoryName;
          singleNode.nodeId = categoryRoute[1];
          singleNode.nodeLevel = 0;
          singleNode.categoryNodeList = [];

          ///Controllare che non esista già il ramo prima di aggiungere al tree
          if (!searchIfExistsOnTree(categoryRoute[1], tree)) {
            addToTree(tree, singleNode, 'no_parent');
          }
        } else {
          ///La categoria è nodo di un ramo e ha delle foglie
          List<dynamic> placeHolder = [];

          ///Controllare se esistono fratelli o altrimenti creare ex novo il ramo
          for (var y = 1; y < categoryRoute.length; y++) {
            if (y == 1) {
              if (!searchIfExistsOnTree(categoryRoute[1], tree)) {
                CategoryTree singleNode = CategoryTree();
                singleNode.nodeName = searchCategoryNameIntoSnippet(categoryRoute[y], snippet);
                singleNode.nodeId = categoryRoute[1];
                singleNode.nodeLevel = 0;
                singleNode.categoryNodeList = [];
                //addToTree(tree, singleNode, 'no_parent');
              }
            } else {
              if (!searchIfExistsOnTree(categoryRoute[y], tree)) {
                CategoryTree singleNode = CategoryTree();
                singleNode.nodeName = searchCategoryNameIntoSnippet(categoryRoute[y], snippet);
                singleNode.nodeId = categoryRoute[y];
                singleNode.nodeLevel = y - 1;
                singleNode.categoryNodeList = [];
                addToTree(tree, singleNode, categoryRoute[y - 1]);
              }
            }
          }
        }
      }
    }
    return tree;
  }

  String searchCategoryNameIntoSnippet(String id, List<dynamic> snippet) {
    for (var i = 0; i < snippet.length; i++) {
      if (snippet[i].categoryAbsolutePath.split('/').last == id) {
        return snippet[i].categoryName;
      }
    }
  }

  void addToTree(List<dynamic> tree, CategoryTree singleNode, String idFather) {
    if (idFather == 'no_parent') {
      tree.add(singleNode);
      print(singleNode.nodeName +  " " + singleNode.nodeId);
    } else {
      for (var i = 0; i < tree.length; i++) {
        if (tree[i].nodeId == idFather) {
          ///QUA AGGIUNGO IL NUOVO FIGLIO
          tree[i].categoryNodeList.add(singleNode);
        } else {
          if (tree[i].categoryNodeList != null && tree[i].categoryNodeList.length != 0) {
            addToTree(tree[i].categoryNodeList, singleNode, idFather);
          }
        }
      }
    }
  }

  bool searchIfExistsOnTree(String id, List<dynamic> tree) {
    bool result = false;
    for (var i = 0; i < tree.length; i++) {
      if (tree[i].nodeId == id) {
        return true;
      } else {
        if (tree[i].categoryNodeList != null && tree[i].categoryNodeList.length != 0 && !result) {
          result = searchIfExistsOnTree(id, tree[i].categoryNodeList);
        }
      }
    }
    return result;
  }

  Widget buildBranchesAfterRoot(List<dynamic> list, int index) {
    if (list != null) {
      return Padding(
        padding: EdgeInsets.only(left: double.parse(list[index].nodeLevel.toString()) * 12.0, right: (list[index].categoryNodeList != null && list[index].categoryNodeList.length != 0) ? 0.0 : 39.0),
        child: (list[index].categoryNodeList != null && list[index].categoryNodeList.length != 0)
            ? ExpansionTile(
                title: GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));

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
                              list[index].nodeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin
                            ? IconButton(
                                icon: const Icon(
                                  Icons.add_circle_sharp,
                                  color: Colors.black,
                                  size: 25.0,
                                ),
                                tooltip: AppLocalizations.of(context).createSubCategory,
                                onPressed: () {
                                  StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UI_M_CreateCategory(
                                              empty: false,
                                            )),
                                  );
                                  // : showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       // return object of type Dialog
                                  //       return AlertDialog(
                                  //         title: new Text(AppLocalizations.of(context).caution),
                                  //         content: new Text(AppLocalizations.of(context).maxCategories),
                                  //       );
                                  //     },
                                  //   );
                                },
                              )
                            : Container(),
                      ],
                    )),
                children: [
                  (list[index].categoryNodeList != null) ? buildBranchesAfterRoot(list[index].categoryNodeList, index) : Text(AppLocalizations.of(context).empty),
                ],
              )
            : ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        child: Text(
                          list[index].nodeName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    list[index].nodeLevel < 4
                        ? IconButton(
                            icon: const Icon(
                              Icons.add_circle_sharp,
                              color: Colors.black,
                              size: 25.0,
                            ),
                            tooltip: AppLocalizations.of(context).createSubCategory,
                            onPressed: () {
                              StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UI_M_CreateCategory(
                                          empty: false,
                                        )),
                              );
                              // : showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       // return object of type Dialog
                              //       return AlertDialog(
                              //         title: new Text(AppLocalizations.of(context).caution),
                              //         content: new Text(AppLocalizations.of(context).maxCategories),
                              //       );
                              //     },
                              //   );
                            },
                          )
                        : Container(),
                  ],
                ),
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UI_M_EditCategory()),
                    );
                  });
                },
              ),
      );
    } else {
      return Container();
    }
  }

  Widget buildBranchesRoot(List<dynamic> list, int index) {
    if (list != null) {
      return Container(
        child: (list[index].categoryNodeList != null && list[index].categoryNodeList.length != 0)
            ? Container(
                padding: EdgeInsets.only(
                  top: 5.0,
                  bottom: 0.0,
                  left: list[index].nodeLevel * 20.0,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: GestureDetector(
                          onTap: () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
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
                                  list[index].nodeName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: BuytimeTheme.FontFamily,
                                    //color: BuytimeTheme.ManagerPrimary.withOpacity(0.6)
                                  ),
                                ),
                              ),
                              StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                  ? IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      splashRadius: 1.0,
                                      alignment: Alignment.centerRight,
                                      icon: Icon(
                                        Icons.my_library_add,
                                        color: BuytimeTheme.SymbolWhite,
                                        size: 24.0,
                                      ),
                                      tooltip: AppLocalizations.of(context).createSubCategory,
                                      onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                          ? () {
                                              StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                                              Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true));
                                              // : showDialog(
                                              //     context: context,
                                              //     builder: (BuildContext context) {
                                              //       // return object of type Dialog
                                              //       return AlertDialog(
                                              //         title: new Text(AppLocalizations.of(context).caution),
                                              //         content: new Text(AppLocalizations.of(context).createSubCategory),
                                              //       );
                                              //     },
                                              //   );
                                            }
                                          : null,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        children: listChildrenBranchCategory(list[index].categoryNodeList),
                      ),
                      Divider(
                        indent: list[index].nodeLevel == 0 ? 20 : ((list[index].nodeLevel) * 40 / list[index].nodeLevel) - 20,
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
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditCategory()),);
                        Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditCategory(), exitPage: ManageCategory(), from: true));
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 8.0,
                        left: double.parse(list[index].nodeLevel.toString()) * 20.0,
                      ),
                      child: Container(
                        height: 36,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  list[index].nodeName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            list[index].nodeLevel < 4
                                ? StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                    ? Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: IconButton(
                                          //padding: EdgeInsets.all(0.0),
                                          alignment: Alignment.centerLeft,
                                          icon: Icon(
                                            Icons.my_library_add,
                                            color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                                ? BuytimeTheme.ManagerPrimary
                                                : BuytimeTheme.SymbolGrey,
                                            size: 24.0,
                                          ),
                                          tooltip: AppLocalizations.of(context).createSubCategory,
                                          onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                                              ? () {
                                                  StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                                                  Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true));
                                                  // : showDialog(
                                                  //     context: context,
                                                  //     builder: (BuildContext context) {
                                                  //       // return object of type Dialog
                                                  //       return AlertDialog(
                                                  //         title: new Text(AppLocalizations.of(context).caution),
                                                  //         content: new Text(AppLocalizations.of(context).maxCategories),
                                                  //       );
                                                  //     },
                                                  //   );
                                                }
                                              : null,
                                        ),
                                      )
                                    : Container()
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ///Divider under category name
                  Divider(
                    indent: list[index].nodeLevel == 0 ? 20 : double.parse(list[index].nodeLevel.toString()) * 40 - 20,
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

  Node addNode(Node node) {
    nodeBranches.last.children.add(node);
    return nodeBranches.last;
  }

  List<String> keys = [];
  Map<String, bool> expand = Map();

  Node buildNodeBranchesRoot(List<dynamic> list, int index) {
    keys.add(list[index].nodeId);
    String bg = '';
    if (StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessId != null) {
      StoreProvider.of<AppState>(context).state.serviceListSnippetState.businessSnippet.forEach((element) {
        if (element.categoryAbsolutePath.split('/').last == list[index].nodeId) bg = Utils.sizeImage(element.categoryImage, Utils.imageSizing600);
      });
    }

    expand.putIfAbsent(list[index].nodeId, () => false);
    if (list != null) {
      if ((list[index].categoryNodeList != null && list[index].categoryNodeList.length != 0)) {
        return Node(
          bg: bg,
          label: list[index].nodeName,
          key: list[index].nodeId,
          expanded: expand[list[index].nodeId],
          children: listChildrenNodeBranchCategory(list[index].categoryNodeList),
          actionIcon: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
              ? InkWell(
                  /*padding: EdgeInsets.all(0.0),
              splashRadius: 1.0,
              alignment: Alignment.centerRight,*/
                  child: Icon(
                    Icons.my_library_add,
                    color: BuytimeTheme.SymbolWhite,
                    size: 24.0,
                  ),
                  // tooltip: AppLocalizations.of(context).createSubCategory,
                  onTap: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                      ? () {
                          StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                          Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true));
                          // : showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       // return object of type Dialog
                          //       return AlertDialog(
                          //         title: new Text(AppLocalizations.of(context).caution),
                          //         content: new Text(AppLocalizations.of(context).createSubCategory),
                          //       );
                          //     },
                          //   );
                        }
                      : null,
                )
              : Container(),
        );
      }
      return Node(
        bg: bg,
        label: list[index].nodeName,
        key: list[index].nodeId,
        actionIcon: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
            ? InkWell(
                child: Icon(
                  Icons.my_library_add,
                  color: BuytimeTheme.SymbolWhite,
                  size: 24.0,
                ),
                onTap: StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                    ? () {
                        StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index].nodeId));
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: false), exitPage: ManageCategory(), from: true));
                        // : showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       // return object of type Dialog
                        //       return AlertDialog(
                        //         title: new Text(AppLocalizations.of(context).caution),
                        //         content: new Text(AppLocalizations.of(context).createSubCategory),
                        //       );
                        //     },
                        //   );
                      }
                    : null,
              )
            : Container(),
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
    Node node = _treeViewController.getNode(key);
    if (node != null) {
      List<Node> updated;
      for (int i = 0; i < keys.length; i++) {
        if (key == keys[i]) {
          updated = _treeViewController.updateNode(
            key,
            node.copyWith(
              expanded: expanded,
              icon: Icon(expand[key] ? Icons.folder_open : Icons.folder).icon,
            ),
          );
        } else {
          updated = _treeViewController.updateNode(key, node.copyWith(expanded: expanded));
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
        onInit: (store) {
          store.state.categoryList.categoryListState.clear();
        },
        builder: (context, snapshot) {
          firebaseTree.clear();
          branches.clear();
          nodeBranches.clear();
          firebaseTree = buildTreeFromSnippet();
          print("FIREBASE TREE DIMENSIONE : " + firebaseTree.length.toString());
          if(firebaseTree.isNotEmpty)
            firebaseTree.sort((a, b) => a.nodeName.compareTo(b.nodeName));
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
          _treeViewController = TreeViewController(
            children: nodeBranches,
            selectedKey: _selectedNode,
          );
          noActivity = false;

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
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: RServiceList(), exitPage: ManageCategory(), from: false));
                        //Navigator.of(context).pop();
                      },
                    ),

                    ///Title
                    Utils.barTitle(AppLocalizations.of(context).categories),
                    StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin || StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman
                        ? IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: BuytimeTheme.SymbolWhite,
                              size: 24.0,
                            ),
                            tooltip: AppLocalizations.of(context).createCategory,
                            onPressed: () {
                              Navigator.push(context, EnterExitRoute(enterPage: UI_M_CreateCategory(empty: true), exitPage: ManageCategory(), from: true));
                              // : showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       // return object of type Dialog
                              //       return AlertDialog(
                              //         title: new Text(AppLocalizations.of(context).caution),
                              //         content: new Text(AppLocalizations.of(context).noCategoriesForBusiness),
                              //       );
                              //     },
                              //   );
                            },
                          )
                        : SizedBox(
                            width: 50.0,
                          ),
                  ],
                ),
                body: SafeArea(
                  child: Container(
                    //color: Colors.black54,
                    child: nodeBranches.isNotEmpty
                        ? Container(
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
                              onExpansionChanged: (key, expanded) => _expandNode(key, expanded),
                              onNodeTap: (key) {
                                _treeViewController = _treeViewController.copyWith(selectedKey: key);
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
                      ]) */
                        : noActivity
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()],
                              )
                            :

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
                )),
          );
        });
  }
}
