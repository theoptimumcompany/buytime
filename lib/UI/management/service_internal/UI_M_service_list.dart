import 'dart:async';
import 'dart:core';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_create_service.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_edit_service.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/business/snippet/order_business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/category/snippet/category_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_reducer.dart';
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
  static String route = '/managerServiceList';
  @override
  State<StatefulWidget> createState() => UI_M_ServiceListState();
}

class UI_M_ServiceListState extends State<UI_M_ServiceList> {
  OrderState order = OrderState(itemList: [], date: DateTime.now(), position: "", total: 0.0, business: OrderBusinessSnippetState().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");
  var iconVisibility = Image.asset('assets/img/icon/service_visible.png');
  bool uploadServiceVisibility = false;
  List<List<ServiceSnippetState>> listOfServiceEachRoot = [];

  /*void setServiceLists(List<CategoryState> categoryRootList, List<ServiceState> serviceList) {
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
  }*/

  void setServiceLists(List<CategorySnippetState> categories) {
    listOfServiceEachRoot = [];
    for (int c = 0; c < categories.length; c++) {
      List<ServiceSnippetState> listRoot = [];
      List<bool> internalSpinnerVisibility = [];
      for (int s = 0; s < categories[c].serviceList.length; s++) {
        debugPrint('UI_M_service_litt => ${categories[c].categoryName} - ${categories[c].serviceList[s].serviceName}');
        listRoot.add(categories[c].serviceList[s]);
        internalSpinnerVisibility.add(false);
      }
      listRoot.sort((a, b) => a.serviceName.compareTo(b.serviceName));
      listOfServiceEachRoot.add(listRoot);
    }
  }

  bool startRequest = false;
  bool noActivity = false;
  bool generated = false;

  List<CategorySnippetState> categories = [];

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

  String id(String path){
    return path.split('/').last;
  }

  bool canAccess(String id){
    bool access = false;
    if(StoreProvider.of<AppState>(context).state.user.managerAccessTo != null){
      StoreProvider.of<AppState>(context).state.user.managerAccessTo.forEach((element) {
        if(element == id)
          access = true;
      });
    }
    debugPrint('UI_M_service_list => CAN MANAGER ACCESS THE SERVICE? $access');

    if(!access &&  (StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner)){
        access = true;
    }
    debugPrint('UI_M_service_list => CAN MANAGER|OTHERS ACCESS THE SERVICE? $access');

    return access;
  }

  bool canWorkerAccess(String id){
    bool access = false;
    if(StoreProvider.of<AppState>(context).state.user.workerAccessTo != null){
      StoreProvider.of<AppState>(context).state.user.workerAccessTo.forEach((element) {
        if(element == id)
          access = true;
      });
    }

    debugPrint('UI_M_service_list => CAN WORKER ACCESS THE SERVICE? $access');

    if(!access && !StoreProvider.of<AppState>(context).state.user.worker){
      access = true;
    }

    debugPrint('UI_M_service_list => CAN WORKER|OTHERS ACCESS THE SERVICE? $access');

    return access;
  }

  bool canWorkerAccessService = false;
  bool canAccessService = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        /*onDidChange: (store) {
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
        },*/
        onInit: (store){
          /*store.state.serviceListSnippetState = ServiceListSnippetState();
          store.dispatch(ServiceListSnippetRequest(store.state.business.id_firestore));*/
          store.state.serviceList.serviceListState.clear();
          //store.dispatch(ServiceListRequest(store.state.business.id_firestore, 'manager'));
          //store.dispatch(RequestRootListCategory(store.state.business.id_firestore));
          startRequest = true;
          noActivity = false;
          debugPrint('UI_M_service_list => no activity ON INIT: ${noActivity}');
          debugPrint('UI_M_service_list => USER ACCESS LIST: ${store.state.user.managerAccessTo}');
        },
        //onWillChange: (store, storeNew) => setServiceLists(storeNew.categoryList.categoryListState, storeNew.serviceList.serviceListState),
        builder: (context, snapshot) {
          /*List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
          List<ServiceState> serviceList = snapshot.serviceList.serviceListState;
          categoryRootList.sort((a, b) => a.name.compareTo(b.name));
          //debugPrint('UI_M_service_list => SERVICE LIST LENGTH: ${serviceList.length}');
          if (serviceList.isEmpty && startRequest) {
            noActivity = true;
            startRequest = false;
           // debugPrint('UI_M_service_list => no activity IF: ${noActivity}');
          } else {
            //debugPrint('UI_M_service_list => no activity ELSE BEFORE: ${noActivity}  | no activity ELSE BEFORE: $startRequest} ');
            noActivity = false;
            startRequest = false;
            //debugPrint('UI_M_service_list => no activity ELSE AFTER: ${noActivity}');
            if(serviceList.isNotEmpty && serviceList.first.businessId == null)
              serviceList.removeLast();
            else
              setServiceLists(snapshot.serviceListSnippetState.businessSnippet);
          }*/

          //categories.clear();

          if(snapshot.serviceListSnippetState.businessId == null && startRequest){
            noActivity = true;
          }else{
            if(snapshot.serviceListSnippetState.businessId != null && snapshot.serviceListSnippetState.businessId.isNotEmpty && !generated){
              categories.clear();
              List<CategorySnippetState> tmpCategories = snapshot.serviceListSnippetState.businessSnippet;
              tmpCategories.forEach((element) {
                if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == snapshot.business.id_firestore)
                  categories.add(element);
              });
              print("UI_M_service_list => AFTER | Categories length: ${categories.length}");
              tmpCategories.forEach((allC) {
                //print("UI_M_Business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                if(allC.categoryAbsolutePath.split('/').first == snapshot.business.id_firestore){
                  categories.forEach((c) {
                    //print("UI_M_Business => Category: ${c.categoryName} | Category services: ${c.serviceList.length}");
                    if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                      print("UI_M_service_list => Main category: ${c.categoryName}");
                      print("UI_M_service_list => Sub category: ${allC.categoryName}");
                      print("UI_M_service_list => Sub category service list length: ${allC.serviceList.length}");
                      print("UI_M_service_list => BEFORE | Main category service list length: ${c.serviceList.length}");
                      allC.serviceList.forEach((s) {
                        if(!c.serviceList.contains(s))
                          c.serviceList.add(s);
                      });
                      print("UI_M_service_list => AFTER | Main category service list length: ${c.serviceList.length}");
                      c.serviceNumberInternal = c.serviceList.length;
                    }
                  });
                }

              });
              //categories = snapshot.serviceListSnippetState.businessSnippet;
              categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
              setServiceLists(categories);
              generated = true;
            }
            noActivity = false;
            startRequest = false;
          }

          /*if (snapshot.serviceState.serviceCreated) { //TODO Check
            snapshot.serviceState.serviceCreated = false;
            StoreProvider.of<AppState>(context).dispatch(SetCreatedService(false));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).serviceCreated),
              duration: Duration(seconds: 3),
            ));
          } else if (snapshot.serviceState.serviceEdited) {
            snapshot.serviceState.serviceEdited = false;
            StoreProvider.of<AppState>(context).dispatch(SetEditedService(false));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).serviceEdited),
              duration: Duration(seconds: 3),
            ));
          }*/

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
                    categories.isNotEmpty && (StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner ||
                        StoreProvider.of<AppState>(context).state.user.getRole() == Role.manager) ? IconButton(
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
                      width: 50.0,
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
                      categories.isNotEmpty ?
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: categories.length,
                          itemBuilder: (context, i) {
                            debugPrint('UI:M:service:list => CATEGORY ID: ${id(categories[i].categoryAbsolutePath)}');
                            canAccessService = canAccess(id(categories[i].categoryAbsolutePath));
                            return Container(
                              //height: 56,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///Category Name
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                                    child: Container(
                                      height: 36,
                                      child: Row(
                                        children: [
                                          Text(
                                            categories[i].categoryName,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18,

                                              ///widget.mediaSize.height * 0.019
                                              //color: BuytimeTheme.ManagerPrimary.withOpacity(0.8),
                                              color: BuytimeTheme.TextBlack,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  ///Divider under category name
                                  Divider(
                                    indent: 20.0,
                                    //color: BuytimeTheme.ManagerPrimary.withOpacity(0.8),
                                    color: BuytimeTheme.SymbolLightGrey,
                                    thickness: 0.5,
                                  ),
                                  ///Static add service to category
                                  canAccessService || canAccess(id(categories[i].categoryAbsolutePath))? Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        //borderRadius: BorderRadius.all(Radius.circular(10)),
                                        onTap: () async {
                                          StoreProvider.of<AppState>(context).dispatch(SetService(ServiceState().toEmpty()));
                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_CreateService(categoryId: categoryRootList[i].id)),);
                                          Navigator.push(context, EnterExitRoute(enterPage: UI_CreateService(categoryId: id(categories[i].categoryAbsolutePath)), exitPage: UI_M_ServiceList(), from: true));
                                        },
                                        child: Container(
                                          height: 56,
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                child: Container(
                                                  child: Icon(Icons.add_box_rounded,
                                                      color: BuytimeTheme.ManagerPrimary.withOpacity(0.5),
                                                      size: mediaWidth * 0.07),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 56,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: .5,
                                                          //color: BuytimeTheme.ManagerPrimary.withOpacity(0.25)
                                                          color: BuytimeTheme.SymbolLightGrey
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                          child: Text(
                                                            AppLocalizations.of(context).addA + ' ' + categories[i].categoryName,
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                ///widget.mediaSize.height * 0.019
                                                                //color: BuytimeTheme.ManagerPrimary.withOpacity(0.5),
                                                                color: BuytimeTheme.ManagerPrimary,
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                fontWeight: FontWeight.w600,
                                                                letterSpacing: 0.15),
                                                          )),
                                                      /*Container(
                                                        child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                      ),*/
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )) : Container(),
                                  ///Service List
                                  Container(
                                    //height: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length * 44.00 : 50,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length : 0,
                                      itemBuilder: (context, index) {
                                        canWorkerAccessService = canWorkerAccess(id(id(categories[i].categoryAbsolutePath)));
                                        Widget iconVisibility;
                                        switch (listOfServiceEachRoot[i][index].serviceVisibility) {
                                          case 'Active':
                                            iconVisibility = Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                            break;
                                          case 'Deactivated':
                                            iconVisibility = Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                            break;
                                          case 'Invisible':
                                            iconVisibility = Icon(Icons.do_disturb_alt_outlined, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                            break;
                                        }
                                        return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              //borderRadius: BorderRadius.all(Radius.circular(10)),
                                              onTap: () {
                                                debugPrint('UI_M_service_list => TAP SERVICE in Inkwell');
                                              },
                                              child: AbsorbPointer(
                                                //absorbing: !(snapshot.user.owner || snapshot.user.admin || snapshot.user.salesman),
                                                absorbing: false,
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  direction: !snapshot.user.worker ? DismissDirection.endToStart : DismissDirection.none,
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
                                                      StoreProvider.of<AppState>(context).dispatch(DeleteService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath)));
                                                      ServiceSnippetState tmp ;
                                                      snapshot.serviceListSnippetState.businessSnippet.forEach((element) {
                                                        if(element.categoryName == categories[i].categoryName){
                                                          element.serviceList.forEach((sL) {
                                                            print("BEFORE : ${sL.serviceName}");
                                                            if(id(sL.serviceAbsolutePath) == id(listOfServiceEachRoot[i][index].serviceAbsolutePath))
                                                              tmp = sL;
                                                          });
                                                          element.serviceNumberInternal--;
                                                          element.serviceList.remove(tmp);
                                                        }
                                                      });
                                                      snapshot.serviceListSnippetState.businessSnippet.forEach((element) {
                                                        if(element.categoryName == categories[i].categoryName){
                                                          element.serviceList.forEach((sL) {
                                                            print("AFTER : ${sL.serviceName}");
                                                          });
                                                        }
                                                      });
                                                      ServiceListSnippetState tmpSLSS = ServiceListSnippetState.fromState(snapshot.serviceListSnippetState);
                                                      categories.clear();
                                                      List<CategorySnippetState> tmpCategories = tmpSLSS.businessSnippet;
                                                      tmpCategories.forEach((element) {
                                                        if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == snapshot.business.id_firestore)
                                                          categories.add(element);
                                                      });
                                                      print("UI_M_service_list => AFTER | Categories length: ${categories.length}");
                                                      tmpCategories.forEach((allC) {
                                                        //print("UI_M_Business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                                                        if(allC.categoryAbsolutePath.split('/').first == snapshot.business.id_firestore){
                                                          categories.forEach((c) {
                                                            //print("UI_M_Business => Category: ${c.categoryName} | Category services: ${c.serviceList.length}");
                                                            if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                                                              print("UI_M_service_list => Main category: ${c.categoryName}");
                                                              print("UI_M_service_list => Sub category: ${allC.categoryName}");
                                                              print("UI_M_service_list => Sub category service list length: ${allC.serviceList.length}");
                                                              print("UI_M_service_list => BEFORE | Main category service list length: ${c.serviceList.length}");
                                                              allC.serviceList.forEach((s) {
                                                                if(!c.serviceList.contains(s))
                                                                  c.serviceList.add(s);
                                                              });
                                                              print("UI_M_service_list => AFTER | Main category service list length: ${c.serviceList.length}");
                                                              c.serviceNumberInternal = c.serviceList.length;
                                                            }
                                                          });
                                                        }

                                                      });
                                                      //categories = snapshot.serviceListSnippetState.businessSnippet;
                                                      categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                                                      setServiceLists(categories);
                                                      //listOfServiceEachRoot[i].removeAt(index);
                                                      /*categories = snapshot.serviceListSnippetState.businessSnippet;
                                                      categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                                                      setServiceLists(categories);*/
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: canWorkerAccessService && canAccessService ? () {
                                                            setState(() {
                                                              switch (listOfServiceEachRoot[i][index].serviceVisibility) {
                                                                case 'Active':
                                                                  listOfServiceEachRoot[i][index].serviceVisibility = 'Deactivated';
                                                                  break;
                                                                case 'Deactivated':
                                                                  listOfServiceEachRoot[i][index].serviceVisibility = 'Invisible';
                                                                  break;
                                                                case 'Invisible':
                                                                  listOfServiceEachRoot[i][index].serviceVisibility = 'Active';
                                                                  break;
                                                              }

                                                              debugPrint('UI_M_service_list => SERVICE ID: ${id(listOfServiceEachRoot[i][index].serviceAbsolutePath)}');

                                                              ///Aggiorno Database
                                                              StoreProvider.of<AppState>(context).dispatch(SetServiceListVisibilityOnFirebase(id(listOfServiceEachRoot[i][index].serviceAbsolutePath), listOfServiceEachRoot[i][index].serviceVisibility));
                                                            });
                                                          } : null,
                                                          child: Padding(
                                                              padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                              child: Container(
                                                                child: iconVisibility,
                                                              )),
                                                        ),
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              debugPrint('UI_M_service_list => TAP SERVICE in Gesture');
                                                              if(snapshot.category.categoryRootId != listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]){
                                                                debugPrint('UI_M_service_list => NOT SAME CATEGORY');
                                                                StoreProvider.of<AppState>(context).dispatch(CategoryRequest(listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]));
                                                              }

                                                              //StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_EditService()),);
                                                              Navigator.push(context, EnterExitRoute(enterPage: UI_EditService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath),listOfServiceEachRoot[i][index].serviceName), exitPage: UI_M_ServiceList(), from: true));
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
                                                                          Utils.retriveField(Localizations.localeOf(context).languageCode, listOfServiceEachRoot[i][index].serviceName),
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
                                                                  /*Container(
                                                                          child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                                        ),*/
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
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ) :
                      noActivity ?
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        ),
                      ) :
                      ///No List
                      Container(),
                      /*Expanded(
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
                                    padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            categoryRootList[i].name,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18,

                                              ///widget.mediaSize.height * 0.019
                                              color: BuytimeTheme.TextBlack,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w800,
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
                                                  child: Icon(Icons.add_box_rounded, color: BuytimeTheme.ManagerPrimary.withOpacity(0.6), size: mediaWidth * 0.07),
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
                                                            color: BuytimeTheme.ManagerPrimary.withOpacity(0.6),
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            fontWeight: FontWeight.w600,
                                                            letterSpacing: 0.15),
                                                      )),
                                                      *//*Container(
                                                        child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                      ),*//*
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
                                                                        *//*Container(
                                                                          child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                                                        ),*//*
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
                      ),*/
                    ],
                  ),
                ),
              ));
        });
  }
}
