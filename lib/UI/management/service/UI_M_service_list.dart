import 'dart:async';
import 'dart:core';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service/UI_M_create_service.dart';
import 'package:Buytime/UI/management/service/UI_M_edit_service.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/service/optimum_service_card_medium.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
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
    for (int c = 0; c < categoryRootList.length; c++) {
      List<ServiceState> listRoot = [];
      for (int s = 0; s < serviceList.length; s++) {
        if (serviceList[s].categoryRootId.contains(categoryRootList[c].id)) {
          listRoot.add(serviceList[s]);
        }
      }
      listRoot.sort((a, b) => a.name.compareTo(b.name));
      listOfServiceEachRoot.add(listRoot);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => UI_M_Business()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => {store.dispatch(ServiceListRequest(store.state.business.id_firestore, 'manager'))},
        onWillChange: (store, storeNew) => setServiceLists(storeNew.categoryList.categoryListState, storeNew.serviceList.serviceListState),
        builder: (context, snapshot) {
          List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
          categoryRootList.sort((a, b) => a.name.compareTo(b.name));
          List<ServiceState> serviceList = StoreProvider.of<AppState>(context).state.serviceList.serviceListState;
          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
          return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: BuytimeAppbar(
                  width: media.width,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.white, size: mediaWidth * 0.1),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UI_M_Business()),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(
                          "Service List", //TODO: <-- ADD TO LANGUAGE TRANSLATE
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: BuytimeTheme.TextWhite,
                            fontSize: mediaHeight * 0.025,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: mediaWidth * 0.085),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_CreateService()),
                        );
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Start Structure List of Services
                      Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: categoryRootList.length,
                            itemBuilder: (context, i) {
                              return Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  child: Column(
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
                                                  color: BuytimeTheme.TextBlack,
                                                  fontSize: media.height * 0.018,
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
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => UI_CreateService(categoryId: categoryRootList[i].id)),
                                          );
                                        },
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
                                                      "Add a " + categoryRootList[i].name, //todo translate
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: BuytimeTheme.TextBlack,
                                                        fontSize: media.height * 0.018,
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    )),
                                                    Container(
                                                      child: Icon(Icons.chevron_right, color: BuytimeTheme.SymbolGrey, size: media.width * 0.1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///Service List
                                      serviceList.length > 0
                                          ? Container(
                                              height: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length * 44.00 : 50,
                                              child: ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: listOfServiceEachRoot.length > 0 ? listOfServiceEachRoot[i].length : 0,
                                                itemBuilder: (context, index) {
                                                  Widget iconVisibility;
                                                  switch (listOfServiceEachRoot[i][index].visibility) {
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
                                                  return GestureDetector(
                                                    onTap: () {
                                                      StoreProvider.of<AppState>(context).dispatch(SetService(listOfServiceEachRoot[i][index]));
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => UI_EditService()),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                          child: Container(
                                                            child: iconVisibility,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
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
                                                                  listOfServiceEachRoot[i][index].name,
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                    color: BuytimeTheme.TextBlack,
                                                                    fontSize: media.height * 0.018,
                                                                    fontWeight: FontWeight.w400,
                                                                  ),
                                                                )),
                                                                Container(
                                                                  child: Icon(Icons.chevron_right, color: BuytimeTheme.SymbolGrey, size: media.width * 0.1),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
