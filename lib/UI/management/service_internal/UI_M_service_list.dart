import 'dart:async';
import 'dart:core';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_create_service.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_edit_service.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_M_ServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_ServiceListState();
}

class UI_M_ServiceListState extends State<UI_M_ServiceList> {
  OrderState order = OrderState(itemList: [], date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");
  var iconVisibility = Image.asset('assets/img/icon/service_visible.png');
  bool uploadServiceVisibility = false;
  List<List<ServiceState>> listOfServiceEachRoot = [];

  void setServiceLists(List<CategoryState> categoryRootList, List<ServiceState> serviceList) {
    listOfServiceEachRoot = [];
    for (int c = 0; c < categoryRootList.length; c++) {
      List<ServiceState> listRoot = [];
      List<bool> internalSpinnerVisibility = [];
      for (int s = 0; s < serviceList.length; s++) {
        if (serviceList[s].categoryRootId.contains(categoryRootList[c].id)) {
          listRoot.add(serviceList[s]);
          internalSpinnerVisibility.add(false);
        }
      }
      listRoot.sort((a, b) => a.name.compareTo(b.name));
      listOfServiceEachRoot.add(listRoot);
    }
  }

  bool startRequest = false;
  bool noActivity = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {
    /*Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_M_Business()),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onDidChange: (store) {
          if (store.serviceState.serviceCreated) {
            store.serviceState.serviceCreated = false;
            StoreProvider.of<AppState>(context).dispatch(SetCreatedService(false));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).serviceCreated),
              duration: Duration(seconds: 3),
            ));
          } else if (store.serviceState.serviceEdited) {
            store.serviceState.serviceEdited = false;
            StoreProvider.of<AppState>(context).dispatch(SetEditedService(false));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).serviceEdited),
              duration: Duration(seconds: 3),
            ));
          }
        },
        onInit: (store){
          store.state.serviceList.serviceListState.clear();
          store.dispatch(ServiceListRequest(store.state.business.id_firestore, 'manager'));
          store.dispatch(RequestRootListCategory(store.state.business.id_firestore));
          startRequest = true;
          noActivity = false;
          debugPrint('UI_M_service_list => no activity ON INIT: ${noActivity}');
        },
        //onWillChange: (store, storeNew) => setServiceLists(storeNew.categoryList.categoryListState, storeNew.serviceList.serviceListState),
        builder: (context, snapshot) {
          List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
          List<ServiceState> serviceList = snapshot.serviceList.serviceListState;
          categoryRootList.sort((a, b) => a.name.compareTo(b.name));
          debugPrint('UI_M_service_list => SERVICE LIST LENGTH: ${serviceList.length}');
          if (serviceList.isEmpty && startRequest) {
            noActivity = true;
            startRequest = false;
            debugPrint('UI_M_service_list => no activity IF: ${noActivity}');
          } else {
            debugPrint('UI_M_service_list => no activity ELSE BEFORE: ${noActivity}  | no activity ELSE BEFORE: $startRequest} ');
            noActivity = false;
            startRequest = false;
            debugPrint('UI_M_service_list => no activity ELSE AFTER: ${noActivity}');
            if(serviceList.isNotEmpty && serviceList.first.businessId == null)
              serviceList.removeLast();
            else
              setServiceLists(snapshot.categoryList.categoryListState, snapshot.serviceList.serviceListState);
          }

          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();

          return WillPopScope(
              onWillPop: () async {
                ///Block iOS Back Swipe
                if (Navigator.of(context).userGestureInProgress)
                  return false;
                else
                  _onWillPop();
                return true;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: BuytimeAppbar(
                  width: media.width,
                  children: [
                    ///Back Button
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                      onPressed: () {
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()))
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: UI_M_ServiceList(), from: false));
                      },
                    ),
                    Utils.barTitle(AppLocalizations.of(context).serviceList),
                    snapshot.categoryList.categoryListState.isNotEmpty ? IconButton(
                      icon: Icon(Icons.add, color: BuytimeTheme.SymbolWhite),
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(SetService(ServiceState().toEmpty()));
                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_CreateService(categoryId: "",)));
                        Navigator.push(
                            context,
                            EnterExitRoute(
                                enterPage: UI_CreateService(
                                  categoryId: "",
                                ),
                                exitPage: UI_M_ServiceList(),
                                from: true));
                      },
                    ) : SizedBox(
                      width: 56.0,
                    ),
                  ],
                ),
                body: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    children: [
                      ///Container Redirect To Managing Categories of the Business
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ///Manage Categories of the Business
                              InkWell(
                                onTap: () {
                                  StoreProvider.of<AppState>(context).dispatch(CategoryTreeCreateIfNotExists(snapshot.business.id_firestore, context));
                                  Navigator.push(context, EnterExitRoute(enterPage: ManageCategory(), exitPage: UI_M_ServiceList(), from: true));
                                },
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    AppLocalizations.of(context).manageCategories,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: categoryRootList.length,
                          itemBuilder: (context, i) {
                            return Container(
                              //height: 56,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Category Name
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            categoryRootList[i].name,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,

                                              ///widget.mediaSize.height * 0.019
                                              color: BuytimeTheme.TextBlack,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                  ///Divider under category name
                                  Divider(
                                    indent: 30.0,
                                    color: BuytimeTheme.DividerGrey,
                                    thickness: 1.0,
                                  ),

                                  ///Static add service to category
                                  Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        onTap: () async {
                                          StoreProvider.of<AppState>(context).dispatch(SetService(ServiceState().toEmpty()));
                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_CreateService(categoryId: categoryRootList[i].id)),);
                                          Navigator.push(context, EnterExitRoute(enterPage: UI_CreateService(categoryId: categoryRootList[i].id), exitPage: UI_M_ServiceList(), from: true));
                                        },
                                        child: Container(
                                          height: 56,
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                child: Container(
                                                  child: Icon(Icons.add_box_rounded, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                        AppLocalizations.of(context).addA + categoryRootList[i].name,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                            fontSize: 16,

                                                            ///widget.mediaSize.height * 0.019
                                                            color: BuytimeTheme.TextBlack,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            fontWeight: FontWeight.w400,
                                                            letterSpacing: 0.15),
                                                      )),
                                                      Container(
                                                        child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),

                                  ///Service List
                                  serviceList.isNotEmpty
                                      ? Container(
                                          //height: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length * 44.00 : 50,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length : 0,
                                            itemBuilder: (context, index) {
                                              Widget iconVisibility;
                                              switch (listOfServiceEachRoot[i][index].visibility) {
                                                case 'Active':
                                                  if (listOfServiceEachRoot[i][index].spinnerVisibility) {
                                                    iconVisibility = Padding(
                                                      padding: const EdgeInsets.only(left: 6.3),
                                                      child: CircularProgressIndicator.adaptive(),
                                                    );
                                                  } else {
                                                    iconVisibility = Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                                case 'Deactivated':
                                                  if (listOfServiceEachRoot[i][index].spinnerVisibility) {
                                                    iconVisibility = Padding(
                                                      padding: const EdgeInsets.only(left: 6.3),
                                                      child: CircularProgressIndicator.adaptive(),
                                                    );
                                                  } else {
                                                    iconVisibility = Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                                case 'Invisible':
                                                  if (listOfServiceEachRoot[i][index].spinnerVisibility) {
                                                    iconVisibility = Padding(
                                                      padding: const EdgeInsets.only(left: 6.3),
                                                      child: CircularProgressIndicator.adaptive(),
                                                    );
                                                  } else {
                                                    iconVisibility = Icon(Icons.do_disturb_alt_outlined, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                              }
                                              return Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () async {},
                                                    child: AbsorbPointer(
                                                      absorbing: !(snapshot.user.owner || snapshot.user.admin || snapshot.user.salesman),
                                                      child: Dismissible(
                                                        key: UniqueKey(),
                                                        direction: DismissDirection.endToStart,
                                                        background: Container(
                                                          height: 56,
                                                          color: Colors.red,
                                                          //margin: EdgeInsets.symmetric(horizontal: 15),
                                                          alignment: Alignment.centerRight,
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: BuytimeTheme.SymbolWhite,
                                                          ),
                                                        ),
                                                        onDismissed: (direction) {
                                                          setState(() {
                                                            ///Deleting Service
                                                            print("Delete Service " + index.toString());
                                                            StoreProvider.of<AppState>(context).dispatch(DeleteService(listOfServiceEachRoot[i][index].serviceId));
                                                          });
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    switch (listOfServiceEachRoot[i][index].visibility) {
                                                                      case 'Active':
                                                                        listOfServiceEachRoot[i][index].visibility = 'Deactivated';
                                                                        break;
                                                                      case 'Deactivated':
                                                                        listOfServiceEachRoot[i][index].visibility = 'Invisible';
                                                                        break;
                                                                      case 'Invisible':
                                                                        listOfServiceEachRoot[i][index].visibility = 'Active';
                                                                        break;
                                                                    }

                                                                    ///Aggiorno Database
                                                                    StoreProvider.of<AppState>(context).dispatch(SetServiceListVisibilityOnFirebase(listOfServiceEachRoot[i][index].serviceId, listOfServiceEachRoot[i][index].visibility));
                                                                  });
                                                                },
                                                                child: Padding(
                                                                    padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                                    child: Container(
                                                                      child: iconVisibility,
                                                                    )),
                                                              ),
                                                              Expanded(
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_EditService()),);
                                                                    Navigator.push(context, EnterExitRoute(enterPage: UI_EditService(), exitPage: UI_M_ServiceList(), from: true));
                                                                  },
                                                                  child: Container(
                                                                    height: 56,
                                                                    decoration: BoxDecoration(
                                                                      border: Border(
                                                                        bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Flexible(
                                                                          child: Container(
                                                                              child: Text(
                                                                            listOfServiceEachRoot[i][index].name,
                                                                            textAlign: TextAlign.start,
                                                                            overflow: TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                              fontSize: 16,

                                                                              ///widget.mediaSize.height * 0.019
                                                                              color: BuytimeTheme.TextBlack,
                                                                              fontFamily: BuytimeTheme.FontFamily,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          )),
                                                                        ),
                                                                        Container(
                                                                          child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          ),
                                        )
                                      : noActivity
                                          ? Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [CircularProgressIndicator()],
                                              ),
                                  ) : Container(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}