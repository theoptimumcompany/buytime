import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/category/UI_M_edit_category.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/UI/management/category/UI_M_create_category.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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

class ManageCategoryState extends State<ManageCategory> {
  @override
  void initState() {
    super.initState();
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
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          content: Text(
            AppLocalizations.of(context).categoryDeleted,
            style: TextStyle(color: Colors.white),
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
                        ),
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
      return Padding(
          padding: EdgeInsets.only(bottom: 15.0, left: double.parse(list[index]["level"].toString()) * 12.0, right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0),
          child: Container(
            child: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)
                ? Container(
                    child: ExpansionTile(
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
                            Text(
                              list[index]["nodeName"],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, fontFamily: BuytimeTheme.FontFamily),
                            ),
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
                              },
                            ),
                          ],
                        ),
                      ),
                      children: listChildrenBranchCategory(list[index]['nodeCategory']),
                    ),
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
                                },
                              )
                            : Container(),
                      ],
                    ),
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_EditCategory()),);
                        Navigator.push(context, EnterExitRoute(enterPage: UI_M_EditCategory(), exitPage: ManageCategory(), from: true));
                      });
                    },
                  ),
          ));
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

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(CategoryTreeRequest()),
        builder: (context, snapshot) {
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
                       Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_ServiceList(), exitPage: ManageCategory(), from: false));
                      //Navigator.of(context).pop();
                    },
                  ),

                  ///Title
                  Utils.barTitle(AppLocalizations.of(context).categories),
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
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: listBranchCategory(),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
