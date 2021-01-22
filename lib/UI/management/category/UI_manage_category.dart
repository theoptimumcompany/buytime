import 'package:BuyTime/UI/management/business/UI_M_business.dart';
import 'package:BuyTime/UI/management/category/UI_edit_category.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/category/UI_create_category.dart';
import 'package:BuyTime/reblox/reducer/category_reducer.dart';
import 'package:BuyTime/reblox/reducer/category_tree_reducer.dart';
import 'package:BuyTime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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

class UI_ManageCategory extends StatefulWidget {
  final String title = 'Categories';

  UI_ManageCategory({this.edited = false, this.created = false, this.deleted = false});

  bool edited;
  bool created;
  bool deleted;
  final GlobalKey<ScaffoldState> _keyScaffoldCategory = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => UI_ManageCategoryState();
}

class UI_ManageCategoryState extends State<UI_ManageCategory> {
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
            'Category Created!',
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
            'Category Edited!',
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
            'Category Deleted!',
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
        padding: EdgeInsets.only(
            left: double.parse(list[index]["level"].toString()) * 12.0,
            right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0),
        child: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)
            ? ExpansionTile(
                title: GestureDetector(
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_EditCategory()),
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          list[index]["nodeName"],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_sharp,
                            color: Colors.black,
                            size: 25.0,
                          ),
                          tooltip: 'Create Sub-Category',
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                ? Future.delayed(const Duration(milliseconds: 500), () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => UI_CreateCategory()),
                                    );
                                  })
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Caution"),
                                        content: new Text("You can't create another category, the maximum is 50!"),
                                      );
                                    },
                                  );
                          },
                        ),
                      ],
                    )),
                children: [
                  (list[index]['nodeCategory'] != null)
                      ? buildBranchesAfterRoot(list[index]['nodeCategory'], index)
                      : Text("Vuoto"),
                ],
              )
            : ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      list[index]["nodeName"],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                    ),
                    list[index]['level'] < 4?
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_sharp,
                        color: Colors.black,
                        size: 25.0,
                      ),
                      tooltip: 'Create Sub-Category',
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                        StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                            ? Future.delayed(const Duration(milliseconds: 500), () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => UI_CreateCategory()),
                                );
                              })
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: new Text("Caution"),
                                    content: new Text("You can't create another category, the maximum is 50!"),
                                  );
                                },
                              );
                      },
                    ):Container(),
                  ],
                ),
                onTap: () {
                  StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UI_EditCategory()),
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
          padding: EdgeInsets.only(
              bottom: 15.0,
              left: double.parse(list[index]["level"].toString()) * 12.0,
              right: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0) ? 0.0 : 39.0),
          child: Container(
            child: (list[index]['nodeCategory'] != null && list[index]['nodeCategory'].length != 0)
                ? Container(
                    child: ExpansionTile(
                      title: GestureDetector(
                        onTap: () {
                          StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => UI_EditCategory()),
                            );
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index]["nodeName"],
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_sharp,
                                color: Colors.black,
                                size: 25.0,
                              ),
                              tooltip: 'Create Sub-Category',
                              onPressed: () {
                                StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                                StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                    ? Future.delayed(const Duration(milliseconds: 500), () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => UI_CreateCategory()),
                                        );
                                      })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // return object of type Dialog
                                          return AlertDialog(
                                            title: new Text("Caution"),
                                            content: new Text("You can't create another category, the maximum is 50!"),
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
                        Text(
                          list[index]["nodeName"],
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                        ),
                        list[index]['level'] < 4?
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_sharp,
                            color: Colors.black,
                            size: 25.0,
                          ),
                          tooltip: 'Create Sub-Category',
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                            StoreProvider.of<AppState>(context).state.categoryTree.numberOfCategories < 50
                                ? Future.delayed(const Duration(milliseconds: 500), () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => UI_CreateCategory()),
                                    );
                                  })
                                : showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // return object of type Dialog
                                      return AlertDialog(
                                        title: new Text("Caution"),
                                        content: new Text("You can't create another category, the maximum is 50!"),
                                      );
                                    },
                                  );
                          },
                        ):Container(),
                      ],
                    ),
                    onTap: () {
                      StoreProvider.of<AppState>(context).dispatch(CategoryRequest(list[index]["nodeId"]));
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_EditCategory()),
                        );
                      });
                    },
                  ),
          ));
    } else {
      return Container();
    }
  }

  List<Widget> listBranchCategory() {
    List<Widget> branches = new List();
    List<dynamic> firebaseTree = StoreProvider.of<AppState>(context).state.categoryTree.categoryNodeList;
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
          child: Center(child: Text("Non ci sono categorie per questo business!")),
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
        onInit: (store) => store.dispatch(new CategoryTreeRequest()),
        onDidChange: (store) {},
        onWillChange: (store, AppState state) {},
        builder: (context, snapshot) {
          return WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UI_M_Business()),
              );
              return false;
            },
            child: Scaffold(
              key: widget._keyScaffoldCategory,
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
                          MaterialPageRoute(builder: (context) => UI_M_Business()),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Text(
                        "Categories",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: media.height * 0.03,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      tooltip: 'Create Category',
                      onPressed: () {
                        snapshot.categoryTree.numberOfCategories < 50
                            ? Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => UI_CreateCategory(empty: "empty")),
                              )
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: new Text("Caution"),
                                    content: new Text("You can't create another category, the maximum is 50!"),
                                  );
                                },
                              );
                      },
                    ),
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
