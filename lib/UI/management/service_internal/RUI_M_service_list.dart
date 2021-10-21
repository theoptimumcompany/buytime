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
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RServiceList extends StatefulWidget {
  static String route = '/managerServiceList';
  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<Spinner>(
      create: (_) => Spinner(true,[],[],[]),
      child: RServiceList(),
    );
  }
  @override
  State<StatefulWidget> createState() => RServiceListState();
}

class RServiceListState extends State<RServiceList> {
  OrderState order = OrderState(itemList: [], date: DateTime.now(), position: "", total: 0.0, business: OrderBusinessSnippetState().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");
  var iconVisibility = Image.asset('assets/img/icon/service_visible.png');
  bool uploadServiceVisibility = false;
  List<List<ServiceSnippetState>> listOfServiceEachRoot = [];
  List<List<bool>> listDOfVisibility = [];
  List<List<bool>> listDDOfVisibility = [];

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

  void setServiceLists(List<CategorySnippetState> categories, BuildContext context) {
    listOfServiceEachRoot = [];
    listDOfVisibility = [];
    listDDOfVisibility = [];
    List<List<dynamic>> listAdd = [];
    for (int c = 0; c < categories.length; c++) {
      List<ServiceSnippetState> listRoot = [];
      List<bool> internalSpinnerVisibility = [];
      for (int s = 0; s < categories[c].serviceList.length; s++) {
        debugPrint('RUI_M_service_list => ${categories[c].categoryName} - ${categories[c].serviceList[s].serviceName}');
        listRoot.add(categories[c].serviceList[s]);
        internalSpinnerVisibility.add(false);
      }
      listRoot.sort((a, b) => a.serviceName.compareTo(b.serviceName));
      listOfServiceEachRoot.add(listRoot);
      listDOfVisibility.add(internalSpinnerVisibility);
      listDDOfVisibility.add(internalSpinnerVisibility);
      listAdd.add([false, listRoot.length]);

      if(Provider.of<Spinner>(context, listen: false).add.isNotEmpty && Provider.of<Spinner>(context, listen: false).add.length == categories.length){
        if(Provider.of<Spinner>(context, listen: false).add[c][0]){
          debugPrint('RUI_M_service_list => ADD WAS TRUE');
          listAdd.last[0] = true;
        }
        if(Provider.of<Spinner>(context, listen: false).add[c][1] != listRoot.length){
          debugPrint('RUI_M_service_list => LIST SIZE DIFFERENCE');
          listAdd.last[0] = false;
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Spinner>(context, listen: false).initAdd(listAdd);
      Provider.of<Spinner>(context, listen: false).initSpinner(listDOfVisibility);
      Provider.of<Spinner>(context, listen: false).initDuplicateSpinner(listDDOfVisibility);
      debugPrint('RUI_M_service_list => ADD List: $listAdd - ${Provider.of<Spinner>(context, listen: false).add}');
    });

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
    debugPrint('RUI_M_service_list => CAN MANAGER ACCESS THE SERVICE? $access');

    if(!access &&  (StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.salesman ||
        StoreProvider.of<AppState>(context).state.user.getRole() == Role.owner)){
        access = true;
    }
    debugPrint('RUI_M_service_list => CAN MANAGER|OTHERS ACCESS THE SERVICE? $access');

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

    debugPrint('RUI_M_service_list => CAN WORKER ACCESS THE SERVICE? $access');

    if(!access && canAccess(id)){
      access = true;
    }

    debugPrint('RUI_M_service_list => CAN WORKER|OTHERS ACCESS THE SERVICE? $access');

    return access;
  }

  bool canWorkerAccessService = false;
  bool canAccessService = false;

  bool canEditVisibility(){
    List<List<bool>> tmp = Provider.of<Spinner>(context, listen: false).getSpinnerList();
    bool found = true;
    tmp.forEach((e1) {
      e1.forEach((e2) {
        if(e2)
          found = false;
      });
    });

    return found;
  }
  bool canEditDuplicateVisibility(){
    List<List<bool>> tmp = Provider.of<Spinner>(context, listen: false).getDuplicateSpinnerList();
    bool found = true;
    tmp.forEach((e1) {
      e1.forEach((e2) {
        if(e2)
          found = false;
      });
    });

    return found;
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;

    final Stream<QuerySnapshot> _businessStream =  FirebaseFirestore.instance.collection("business")
        .doc(StoreProvider.of<AppState>(context).state.business.id_firestore)
        .collection('service_list_snippet').snapshots(includeMetadataChanges: true);

    return  WillPopScope(
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
                key: Key('back_from_interval_service_key'),
                icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                onPressed: () {
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()))
                  Provider.of<Spinner>(context, listen: false).clear();
                  Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: RServiceList(), from: false));
                },
              ),
              Utils.barTitle(AppLocalizations.of(context).serviceList),
              /*listOfServiceEachRoot.isNotEmpty &&*/ (StoreProvider.of<AppState>(context).state.user.getRole() == Role.admin ||
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
                          exitPage: RServiceList(),
                          from: true));
                },
              ) : SizedBox(
                width: 50.0,
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ///Container Redirect To Managing Categories of the Business
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///Manage Categories of the Business
                      InkWell(
                        key: Key('manage_category_key'),
                        onTap: () {
                          Navigator.push(context, EnterExitRoute(enterPage: ManageCategory(), exitPage: RServiceList(), from: true));
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
              StreamBuilder<QuerySnapshot>(
                  stream: _businessStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> businessSnapshot) {
                    if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator()
                        ],
                      );
                    }
                    ServiceListSnippetState serviceListSnippetState = ServiceListSnippetState.fromJson(businessSnapshot.data.docs.first.data());
                    StoreProvider.of<AppState>(context).dispatch(ServiceListSnippetRequestResponse(serviceListSnippetState));
                    //print("RUI_M_business => Business Id from snippet: ${serviceListSnippetState.businessId}");
                    categories.clear();
                    List<CategorySnippetState> tmpCategories = serviceListSnippetState.businessSnippet;
                    tmpCategories.forEach((element) {
                      if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                        categories.add(element);
                    });
                    //print("RUI_M_service_list => AFTER | Categories length: ${categories.length}");
                    tmpCategories.forEach((allC) {
                      //print("UI_M_Business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                      if(allC.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore){
                        categories.forEach((c) {
                          //print("UI_M_Business => Category: ${c.categoryName} | Category services: ${c.serviceList.length}");
                          if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                            //print("RUI_M_service_list => Main category: ${c.categoryName}");
                            //print("RUI_M_service_list => Sub category: ${allC.categoryName}");
                            //print("RUI_M_service_list => Sub category service list length: ${allC.serviceList.length}");
                            //print("RUI_M_service_list => BEFORE | Main category service list length: ${c.serviceList.length}");
                            allC.serviceList.forEach((s) {
                              if(!c.serviceList.contains(s) && s.serviceAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                                c.serviceList.add(s);
                            });
                            //print("RUI_M_service_list => AFTER | Main category service list length: ${c.serviceList.length}");
                            c.serviceNumberInternal = c.serviceList.length;
                          }
                        });
                      }

                    });
                    //categories = snapshot.serviceListSnippetState.businessSnippet;
                    categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                    setServiceLists(categories, context);
                    return Container(
                      height: SizeConfig.safeBlockVertical * 78.9,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          categories.isNotEmpty ?
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: categories.length,
                              itemBuilder: (context, i) {
                                debugPrint('RUI_M_service_list => CATEGORY ID: ${id(categories[i].categoryAbsolutePath)}');
                                canAccessService = canAccess(id(categories[i].categoryAbsolutePath));
                                return Container(
                                  //height: 56,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          ///Static add service to category
                                          canAccessService || canAccess(id(categories[i].categoryAbsolutePath))?
                                          Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                //borderRadius: BorderRadius.all(Radius.circular(10)),
                                                onTap: () async {
                                                  StoreProvider.of<AppState>(context).dispatch(SetService(ServiceState().toEmpty()));
                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    Provider.of<Spinner>(context, listen: false).add[i][0] = true;
                                                    //Provider.of<Spinner>(context, listen: false).initAdd(Provider.of<Spinner>(context, listen: false).add);
                                                  });
                                                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_CreateService(categoryId: categoryRootList[i].id)),);
                                                  Navigator.push(context, EnterExitRoute(enterPage: UI_CreateService(categoryId: id(categories[i].categoryAbsolutePath)), exitPage: RServiceList(), from: true));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets.only(right: 20.0, top: 10.0),
                                                    child: Text(
                                                      AppLocalizations.of(context).addNew,
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
                                              )) : Container(),
                                        ],
                                      ),
                                      ///Divider under category name
                                      Divider(
                                        indent: 20.0,
                                        //color: BuytimeTheme.ManagerPrimary.withOpacity(0.8),
                                        color: BuytimeTheme.SymbolLightGrey,
                                        thickness: 0.5,
                                      ),
                                      ///Service List
                                      // Container(
                                      //   //height: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length * 44.00 : 50,
                                      //   child: ListView.builder(
                                      //     shrinkWrap: true,
                                      //     physics: const NeverScrollableScrollPhysics(),
                                      //     itemCount: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length : 0,
                                      //     itemBuilder: (context, index) {
                                      //       canWorkerAccessService = canWorkerAccess(id(id(categories[i].categoryAbsolutePath)));
                                      //       Widget iconVisibility;
                                      //       bool spinner = false;
                                      //       debugPrint('RUI_M_service_list => ${StoreProvider.of<AppState>(context).state.serviceList.serviceListState.length}');
                                      //       StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((element) {
                                      //         debugPrint('RUI_M_service_list => ${element.name} - ${element.visibility}');
                                      //         if(listOfServiceEachRoot[i][index].serviceVisibility != element.visibility)
                                      //           spinner = true;
                                      //         else
                                      //           spinner = false;
                                      //       });
                                      //       switch (listOfServiceEachRoot[i][index].serviceVisibility) {
                                      //         case 'Active':
                                      //           if (spinner) {
                                      //             iconVisibility = Padding(
                                      //               padding: const EdgeInsets.only(left: 6.3),
                                      //               child: CircularProgressIndicator.adaptive(),
                                      //             );
                                      //           } else {
                                      //             iconVisibility = Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                      //           }
                                      //           break;
                                      //         case 'Deactivated':
                                      //           if (spinner) {
                                      //             iconVisibility = Padding(
                                      //               padding: const EdgeInsets.only(left: 6.3),
                                      //               child: CircularProgressIndicator.adaptive(),
                                      //             );
                                      //           } else {
                                      //             iconVisibility = Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                      //           }
                                      //           break;
                                      //         case 'Invisible':
                                      //           if (spinner) {
                                      //             iconVisibility = Padding(
                                      //               padding: const EdgeInsets.only(left: 6.3),
                                      //               child: CircularProgressIndicator.adaptive(),
                                      //             );
                                      //           } else {
                                      //             iconVisibility = Icon(Icons.do_disturb_alt_outlined, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                      //           }
                                      //           break;
                                      //       }
                                      //       return Material(
                                      //           color: Colors.transparent,
                                      //           child: InkWell(
                                      //             //borderRadius: BorderRadius.all(Radius.circular(10)),
                                      //             onTap: () {
                                      //               debugPrint('RUI_M_service_list => TAP SERVICE in Inkwell');
                                      //             },
                                      //             child: AbsorbPointer(
                                      //               //absorbing: !(snapshot.user.owner || snapshot.user.admin || snapshot.user.salesman),
                                      //               absorbing: false,
                                      //               child: Dismissible(
                                      //                 key: UniqueKey(),
                                      //                 direction:  canAccessService || canAccess(id(categories[i].categoryAbsolutePath)) ? DismissDirection.endToStart : DismissDirection.none,
                                      //                 background: Container(
                                      //                   height: 56,
                                      //                   color: Colors.red,
                                      //                   //margin: EdgeInsets.symmetric(horizontal: 15),
                                      //                   alignment: Alignment.centerRight,
                                      //                   child: Icon(
                                      //                     Icons.delete,
                                      //                     color: BuytimeTheme.SymbolWhite,
                                      //                   ),
                                      //                 ),
                                      //                 onDismissed: (direction) {
                                      //                   /*setState(() {
                                      //
                                      //                   });*/
                                      //                   ///Deleting Service
                                      //                   print("Delete Service " + index.toString());
                                      //                   StoreProvider.of<AppState>(context).dispatch(DeleteService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath)));
                                      //                   ServiceSnippetState tmp ;
                                      //                   serviceListSnippetState.businessSnippet.forEach((element) {
                                      //                     if(element.categoryName == categories[i].categoryName){
                                      //                       element.serviceList.forEach((sL) {
                                      //                         print("BEFORE : ${sL.serviceName}");
                                      //                         if(id(sL.serviceAbsolutePath) == id(listOfServiceEachRoot[i][index].serviceAbsolutePath))
                                      //                           tmp = sL;
                                      //                       });
                                      //                       element.serviceNumberInternal--;
                                      //                       element.serviceList.remove(tmp);
                                      //                     }
                                      //                   });
                                      //                   serviceListSnippetState.businessSnippet.forEach((element) {
                                      //                     if(element.categoryName == categories[i].categoryName){
                                      //                       element.serviceList.forEach((sL) {
                                      //                         print("AFTER : ${sL.serviceName}");
                                      //                       });
                                      //                     }
                                      //                   });
                                      //                   ServiceListSnippetState tmpSLSS = ServiceListSnippetState.fromState(serviceListSnippetState);
                                      //                   categories.clear();
                                      //                   List<CategorySnippetState> tmpCategories = tmpSLSS.businessSnippet;
                                      //                   tmpCategories.forEach((element) {
                                      //                     if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                                      //                       categories.add(element);
                                      //                   });
                                      //                   print("RUI_M_service_list => AFTER | Categories length: ${categories.length}");
                                      //                   tmpCategories.forEach((allC) {
                                      //                     //print("UI_M_Business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                                      //                     if(allC.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore){
                                      //                       categories.forEach((c) {
                                      //                         //print("UI_M_Business => Category: ${c.categoryName} | Category services: ${c.serviceList.length}");
                                      //                         if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                                      //                           print("RUI_M_service_list => Main category: ${c.categoryName}");
                                      //                           print("RUI_M_service_list => Sub category: ${allC.categoryName}");
                                      //                           print("RUI_M_service_list => Sub category service list length: ${allC.serviceList.length}");
                                      //                           print("RUI_M_service_list => BEFORE | Main category service list length: ${c.serviceList.length}");
                                      //                           allC.serviceList.forEach((s) {
                                      //                             if(!c.serviceList.contains(s))
                                      //                               c.serviceList.add(s);
                                      //                           });
                                      //                           print("RUI_M_service_list => AFTER | Main category service list length: ${c.serviceList.length}");
                                      //                           c.serviceNumberInternal = c.serviceList.length;
                                      //                         }
                                      //                       });
                                      //                     }
                                      //
                                      //                   });
                                      //                   //categories = snapshot.serviceListSnippetState.businessSnippet;
                                      //                   categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                                      //                   //setServiceLists(categories, context);
                                      //                   //listOfServiceEachRoot[i].removeAt(index);
                                      //                   /*categories = snapshot.serviceListSnippetState.businessSnippet;
                                      //                 categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                                      //                 setServiceLists(categories);*/
                                      //                 },
                                      //                 child: Container(
                                      //                   child: Row(
                                      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                     children: [
                                      //                       GestureDetector(
                                      //                         onTap: canWorkerAccessService ? () {
                                      //                           /*setState(() {
                                      //
                                      //                           });*/
                                      //                           switch (listOfServiceEachRoot[i][index].serviceVisibility) {
                                      //                             case 'Active':
                                      //                               listOfServiceEachRoot[i][index].serviceVisibility = 'Deactivated';
                                      //                               break;
                                      //                             case 'Deactivated':
                                      //                               listOfServiceEachRoot[i][index].serviceVisibility = 'Invisible';
                                      //                               break;
                                      //                             case 'Invisible':
                                      //                               listOfServiceEachRoot[i][index].serviceVisibility = 'Active';
                                      //                               break;
                                      //                           }
                                      //                           Provider.of<Spinner>(context, listen: false).updateSpinner(listDOfVisibility, i, index);
                                      //                           debugPrint('RUI_M_service_list => SERVICE ID: ${id(listOfServiceEachRoot[i][index].serviceAbsolutePath)}');
                                      //
                                      //                           ///Aggiorno Database
                                      //                           StoreProvider.of<AppState>(context).dispatch(SetServiceListVisibilityOnFirebase(id(listOfServiceEachRoot[i][index].serviceAbsolutePath), listOfServiceEachRoot[i][index].serviceVisibility));
                                      //                         } : null,
                                      //                         child: Padding(
                                      //                             padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                      //                             child: Container(
                                      //                               child: iconVisibility,
                                      //                             )),
                                      //                       ),
                                      //                       Expanded(
                                      //                         child: GestureDetector(
                                      //                           onTap: () {
                                      //                             debugPrint('RUI_M_service_list => TAP SERVICE in Gesture');
                                      //                             if(StoreProvider.of<AppState>(context).state.category.categoryRootId != listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]){
                                      //                               debugPrint('RUI_M_service_list => NOT SAME CATEGORY');
                                      //                               StoreProvider.of<AppState>(context).dispatch(CategoryRequest(listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]));
                                      //                             }
                                      //
                                      //                             //StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                      //                             //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_EditService()),);
                                      //                             Navigator.push(context, EnterExitRoute(enterPage: UI_EditService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath),listOfServiceEachRoot[i][index].serviceName), exitPage: RServiceList(), from: true));
                                      //                           },
                                      //                           child: Container(
                                      //                             height: 56,
                                      //                             decoration: BoxDecoration(
                                      //                               border: Border(
                                      //                                 bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                      //                               ),
                                      //                             ),
                                      //                             child: Row(
                                      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //                               children: [
                                      //                                 Flexible(
                                      //                                   child: Container(
                                      //                                       child: Text(
                                      //                                         Utils.retriveField(Localizations.localeOf(context).languageCode, listOfServiceEachRoot[i][index].serviceName),
                                      //                                         textAlign: TextAlign.start,
                                      //                                         overflow: TextOverflow.ellipsis,
                                      //                                         style: TextStyle(
                                      //                                           fontSize: 16,
                                      //
                                      //                                           ///widget.mediaSize.height * 0.019
                                      //                                           color: BuytimeTheme.TextBlack,
                                      //                                           fontFamily: BuytimeTheme.FontFamily,
                                      //                                           fontWeight: FontWeight.w400,
                                      //                                         ),
                                      //                                       )),
                                      //                                 ),
                                      //                                 /*Container(
                                      //                                     child: Icon(Icons.keyboard_arrow_right, color: BuytimeTheme.SymbolGrey, size: 24),
                                      //                                   ),*/
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ));
                                      //     },
                                      //   ),
                                      // ),
                                      Consumer<Spinner>(
                                        builder: (_, spinnerState, child) {
                                          int arraySize = 0;
                                          listOfServiceEachRoot.length > 0 ?
                                          Provider.of<Spinner>(context, listen: false).add.isNotEmpty && Provider.of<Spinner>(context, listen: false).add[i][0] ?
                                            arraySize = listOfServiceEachRoot[i].length + 1 :
                                            arraySize = listOfServiceEachRoot[i].length : arraySize = 0;

                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: arraySize,
                                            itemBuilder: (context, index) {
                                              debugPrint('RUI_M_service_list => SERVICE IMAGE: ${listOfServiceEachRoot[i][index].serviceImage}');

                                              if(Provider.of<Spinner>(context, listen: false).add.isNotEmpty && Provider.of<Spinner>(context, listen: false).add[i][0] && index == listOfServiceEachRoot[i].length && arraySize == listOfServiceEachRoot[i].length + 1 ){
                                                debugPrint('RUI_M_service_list => not full service length');
                                                return Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(left: 18, top: 7, bottom: 1),
                                                      padding: EdgeInsets.only(bottom: 7),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ///Image
                                                          Container(
                                                            height: 92,
                                                            width: 92,
                                                            child: Utils.imageShimmer(92, 92),
                                                          ),
                                                          Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {},
                                                              child: Container(
                                                                height: 56,
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    ///Service Name
                                                                    Flexible(
                                                                      child: Container(
                                                                          margin: EdgeInsets.only(left: 10),
                                                                        child: Utils.textShimmer(100, 16),
                                                                      )
                                                                    ),
                                                                    ///Visibility & Copy
                                                                    Container(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          ///Visibility
                                                                          GestureDetector(
                                                                            onTap: (){},
                                                                            child: Padding(
                                                                              //padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                                                padding: EdgeInsets.only(left: 0),
                                                                                child: Container(
                                                                                  child: Utils.iconShimmer(Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07)),
                                                                                )),
                                                                          ),
                                                                          ///Copy
                                                                          Container(
                                                                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                                                            child: spinnerState.getDuplicateSpinner(i, index) ?
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: spinner,
                                                                            ) :
                                                                            IconButton(
                                                                                onPressed: () {},
                                                                                icon: Utils.iconShimmer(Icon(Icons.copy, color: BuytimeTheme.SymbolGrey, size: 24))),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 110),
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }

                                              debugPrint('RUI_M_service_list => SERVICE NAME: ${listOfServiceEachRoot[i][index].serviceName}');
                                              canWorkerAccessService = canWorkerAccess(id(id(categories[i].categoryAbsolutePath)));
                                              Widget iconVisibility;
                                              switch (listOfServiceEachRoot[i][index].serviceVisibility) {
                                                case 'Active':
                                                  if(spinnerState.getSpinner(i, index)){
                                                    iconVisibility = spinner;
                                                  } else {
                                                    iconVisibility = Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                                case 'Deactivated':
                                                  if (spinnerState.getSpinner(i, index)) {
                                                    iconVisibility = spinner;
                                                  } else {
                                                    iconVisibility = Icon(Icons.do_disturb_alt_outlined, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                                case 'Invisible':
                                                  if (spinnerState.getSpinner(i, index)) {
                                                    iconVisibility = spinner;
                                                  } else {
                                                    iconVisibility = Icon(Icons.visibility_off, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07);
                                                  }
                                                  break;
                                              }

                                              return Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    //borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    onTap: () {
                                                      debugPrint('RUI_M_service_list => TAP SERVICE in Inkwell');
                                                    },
                                                    child: AbsorbPointer(
                                                      //absorbing: !(snapshot.user.owner || snapshot.user.admin || snapshot.user.salesman),
                                                      absorbing: false,
                                                      child: Dismissible(
                                                        key: UniqueKey(),
                                                        direction:  canAccessService || canAccess(id(categories[i].categoryAbsolutePath)) ? DismissDirection.endToStart : DismissDirection.none,
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
                                                          /*setState(() {

                                                        });*/
                                                          ///Deleting Service
                                                          print("Delete Service " + index.toString());
                                                          StoreProvider.of<AppState>(context).dispatch(DeleteService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath)));
                                                          /*ServiceSnippetState tmp ;
                                                          serviceListSnippetState.businessSnippet.forEach((element) {
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
                                                          serviceListSnippetState.businessSnippet.forEach((element) {
                                                            if(element.categoryName == categories[i].categoryName){
                                                              element.serviceList.forEach((sL) {
                                                                print("AFTER : ${sL.serviceName}");
                                                              });
                                                            }
                                                          });
                                                          ServiceListSnippetState tmpSLSS = ServiceListSnippetState.fromState(serviceListSnippetState);
                                                          categories.clear();
                                                          List<CategorySnippetState> tmpCategories = tmpSLSS.businessSnippet;
                                                          tmpCategories.forEach((element) {
                                                            if(element.categoryAbsolutePath.split('/').length == 2 && element.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore)
                                                              categories.add(element);
                                                          });
                                                          print("RUI_M_service_list => AFTER | Categories length: ${categories.length}");
                                                          tmpCategories.forEach((allC) {
                                                            //print("UI_M_Business => Category: ${allC.categoryName} | Category services: ${allC.serviceList.length}");
                                                            if(allC.categoryAbsolutePath.split('/').first == StoreProvider.of<AppState>(context).state.business.id_firestore){
                                                              categories.forEach((c) {
                                                                //print("UI_M_Business => Category: ${c.categoryName} | Category services: ${c.serviceList.length}");
                                                                if(allC.categoryAbsolutePath != c.categoryAbsolutePath && allC.categoryAbsolutePath.split('/').contains(c.categoryAbsolutePath.split('/').last)){
                                                                  print("RUI_M_service_list => Main category: ${c.categoryName}");
                                                                  print("RUI_M_service_list => Sub category: ${allC.categoryName}");
                                                                  print("RUI_M_service_list => Sub category service list length: ${allC.serviceList.length}");
                                                                  print("RUI_M_service_list => BEFORE | Main category service list length: ${c.serviceList.length}");
                                                                  allC.serviceList.forEach((s) {
                                                                    if(!c.serviceList.contains(s))
                                                                      c.serviceList.add(s);
                                                                  });
                                                                  print("RUI_M_service_list => AFTER | Main category service list length: ${c.serviceList.length}");
                                                                  c.serviceNumberInternal = c.serviceList.length;
                                                                }
                                                              });
                                                            }

                                                          });
                                                          //categories = snapshot.serviceListSnippetState.businessSnippet;
                                                          categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));*/
                                                          //setServiceLists(categories);
                                                          //listOfServiceEachRoot[i].removeAt(index);
                                                          /*categories = snapshot.serviceListSnippetState.businessSnippet;
                                                      categories.sort((a,b) => a.categoryName.compareTo(b.categoryName));
                                                      setServiceLists(categories);*/
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.only(left: 18, top: 7, bottom: 1),
                                                              padding: EdgeInsets.only(bottom: 7),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  ///Image
                                                                  GestureDetector(
                                                                    key: Key('service_${i}_${index}_key'),
                                                                    onTap: () {
                                                                      debugPrint('RUI_M_service_list => TAP SERVICE in Gesture');
                                                                      /// TODO we are not sure about this, look at the history of this if @Nipuna
                                                                      if(StoreProvider.of<AppState>(context).state.category.id != listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]){
                                                                        debugPrint('RUI_M_service_list => NOT SAME CATEGORY');
                                                                        StoreProvider.of<AppState>(context).dispatch(CategoryRequest(listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]));
                                                                      }

                                                                      //StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_EditService()),);
                                                                      Navigator.push(context, EnterExitRoute(enterPage: UI_EditService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath),listOfServiceEachRoot[i][index].serviceName), exitPage: RServiceList(), from: true));
                                                                    },
                                                                    child: Container(
                                                                      height: 92,
                                                                      width: 92,
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: Utils.version200(listOfServiceEachRoot[i][index].serviceImage),
                                                                        imageBuilder: (context, imageProvider) => Container(
                                                                          //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                                          height: 92,
                                                                          width: 92,
                                                                          decoration: BoxDecoration(
                                                                            //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                                                        ),
                                                                        placeholder: (context, url) => Container(
                                                                            height: 92,
                                                                            width: 92,
                                                                            child: Utils.imageShimmer(92, 92)
                                                                        ),
                                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child: GestureDetector(
                                                                      key: Key('service_${i}_${index}_key'),
                                                                      onTap: () {
                                                                        debugPrint('RUI_M_service_list => TAP SERVICE in Gesture');
                                                                        /// TODO we are not sure about this, look at the history of this if @Nipuna
                                                                        if(StoreProvider.of<AppState>(context).state.category.id != listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]){
                                                                          debugPrint('RUI_M_service_list => NOT SAME CATEGORY');
                                                                          StoreProvider.of<AppState>(context).dispatch(CategoryRequest(listOfServiceEachRoot[i][index].serviceAbsolutePath.split('/')[1]));
                                                                        }

                                                                        //StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => UI_EditService()),);
                                                                        Navigator.push(context, EnterExitRoute(enterPage: UI_EditService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath),listOfServiceEachRoot[i][index].serviceName), exitPage: RServiceList(), from: true));
                                                                      },
                                                                      child: Container(
                                                                        height: 92,
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            ///Service Name
                                                                            Flexible(
                                                                              child: Container(
                                                                                height: 92,
                                                                                  margin: EdgeInsets.only(left: 12.5),
                                                                                  alignment: Alignment.centerLeft,
                                                                                  child: Text(
                                                                                    Utils.retriveField(Localizations.localeOf(context).languageCode, listOfServiceEachRoot[i][index].serviceName),
                                                                                    textAlign: TextAlign.start,
                                                                                    //overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      ///widget.mediaSize.height * 0.019
                                                                                      color: BuytimeTheme.TextBlack,
                                                                                      fontFamily: BuytimeTheme.FontFamily,
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  )),
                                                                            ),
                                                                            ///Visibility & Copy
                                                                            Container(
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  ///Visibility
                                                                                  GestureDetector(
                                                                                    onTap: canWorkerAccessService && canEditVisibility() ? () {
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
                                                                                      Provider.of<Spinner>(context, listen: false).updateSpinner(listDOfVisibility, i, index);
                                                                                      debugPrint('RUI_M_service_list => CALLING UPDATE SPINNER');
                                                                                      debugPrint('RUI_M_service_list => SERVICE ID: ${id(listOfServiceEachRoot[i][index].serviceAbsolutePath)}');

                                                                                      ///Aggiorno Database
                                                                                      StoreProvider.of<AppState>(context).dispatch(SetServiceListVisibilityOnFirebase(id(listOfServiceEachRoot[i][index].serviceAbsolutePath), listOfServiceEachRoot[i][index].serviceVisibility));
                                                                                    } : null,
                                                                                    child: Padding(
                                                                                      //padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                                                        padding: EdgeInsets.only(left: 0),
                                                                                        child: Container(
                                                                                          child: iconVisibility,
                                                                                        )),
                                                                                  ),
                                                                                  ///Copy
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                                                                    child: spinnerState.getDuplicateSpinner(i, index) ?
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.all(5.0),
                                                                                      child: spinner,
                                                                                    ) :
                                                                                    IconButton(
                                                                                        onPressed: canAccess(id(categories[i].categoryAbsolutePath)) ? () {
                                                                                          /// chiamare la epic per duplicare il servizio.
                                                                                          StoreProvider.of<AppState>(context).dispatch(DuplicateService(id(listOfServiceEachRoot[i][index].serviceAbsolutePath)));
                                                                                          /// far partire un caricamento e bloccare tutti i duplicates
                                                                                          Provider.of<Spinner>(context, listen: false).updateDuplicateSpinner(listDDOfVisibility, i, index);
                                                                                        } : null,
                                                                                        icon: Icon(Icons.copy, color: BuytimeTheme.SymbolGrey, size: 24)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.only(left: 110),
                                                              decoration: BoxDecoration(
                                                                border: Border(
                                                                  bottom: BorderSide(width: 1.0, color: BuytimeTheme.DividerGrey),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ));
                                            },
                                          );
                                        },
                                      )
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
                        ],
                      ),
                    );
                  }
              ),
            ],
          ),
        ));
  }
}

Widget spinner = Container(
  margin: EdgeInsets.only(left:3),
  width: 24,
  height: 24,
  child: CircularProgressIndicator(),
);

class Spinner with ChangeNotifier{
  bool load;
  List<List<dynamic>> add;
  List<List<bool>> spinners;
  List<List<bool>> duplicateSpinners;
  Spinner(this.load, this.add, this.spinners, this.duplicateSpinners);

  initLoad(bool load){
    this.load = load;
    debugPrint('RUI_M_service_list => LOAD INIT');
    notifyListeners();
  }
  initAdd(List<List<dynamic>> add){
    this.add = add;
    debugPrint('RUI_M_service_list => ADD INIT');
    notifyListeners();
  }
  initSpinner(List<List<bool>> spinnerList){
    this.spinners = spinnerList;
    debugPrint('RUI_M_service_list => SPINNER INIT');
    notifyListeners();
  }
  initDuplicateSpinner(List<List<bool>> spinnerList){
    this.duplicateSpinners = spinnerList;
    debugPrint('RUI_M_service_list => UPLICATE SPINNER INIT');
    notifyListeners();
  }

  updateSpinner(List<List<bool>> spinnerList, int i, int index){
    spinnerList[i][index] = true;
    this.spinners = spinnerList;
    debugPrint('RUI_M_service_list => SPINNER UPDATE VISIBILITY: ${spinners[i][index]}');
    notifyListeners();
  }

   updateDuplicateSpinner(List<List<bool>> spinnerList, int i, int index){
    spinnerList[i][index] = true;
    this.duplicateSpinners = spinnerList;
    debugPrint('RUI_M_service_list => SPINNER DUPLICATE UPDATE VISIBILITY: ${duplicateSpinners[i][index]}');
    notifyListeners();
  }

  bool getSpinner(int i, int index){
    if(spinners.isNotEmpty && spinners[i].isNotEmpty && spinners[i].asMap().containsKey(index)){
      debugPrint('RUI_M_service_list => SPINNER GET VISIBILITY: ${spinners[i][index]}');
      return spinners[i][index];
    }else
      return false;
  }
  bool getDuplicateSpinner(int i, int index){
    if(duplicateSpinners.isNotEmpty && duplicateSpinners[i].isNotEmpty  && duplicateSpinners[i].asMap().containsKey(index)){
      debugPrint('RUI_M_service_list => DUPLICATE SPINNER GET VISIBILITY: ${duplicateSpinners[i][index]}');
      return duplicateSpinners[i][index];
    }else
      return false;
  }

  List<List<bool>> getSpinnerList(){
    //debugPrint('RUI_M_service_list => SPINNER GET VISIBILITY: ${spinners[i][index]}');
    return spinners;
  }
  List<List<bool>> getDuplicateSpinnerList(){
    //debugPrint('RUI_M_service_list => SPINNER GET VISIBILITY: ${spinners[i][index]}');
    return duplicateSpinners;
  }

  clear(){
    this.load = false;
    this.add = [];
    this.spinners = [];
    this.duplicateSpinners = [];
  }

}