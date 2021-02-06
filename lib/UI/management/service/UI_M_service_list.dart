import 'dart:async';
import 'dart:core';

import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service/UI_M_manage_service.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_reducer.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
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
        builder: (context, snapshot) {
          List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
          List<ServiceState> serviceList = StoreProvider.of<AppState>(context).state.serviceList.serviceListState;
          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
          return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: BuytimeAppbarManager(
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
                          MaterialPageRoute(builder: (context) => UI_ManageService(creation: true)),
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
                                          print("Tap on add new service");

                                          ///QUi mi passo parent root e costruisco albero parent nel crea servizio solo costituito dal parent scelto e i suoi children
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
                                                      "Add a " + categoryRootList[i].name,
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
                                      Container(
                                        height: serviceList.length * 44.00,
                                        child: ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: serviceList.length,
                                          itemBuilder: (context, index) {
                                            // print("Index " + index.toString() + "  della lista ha visibilità : " + snapshot.serviceList.serviceListState[index].visibility);
                                            // switch (snapshot.serviceList.serviceListState[index].visibility) {
                                            //   case 'Visible':
                                            //     iconVisibility = Image.asset('assets/img/icon/service_visible.png');
                                            //     break;
                                            //   case 'Shadow':
                                            //     iconVisibility = Image.asset('assets/img/icon/service_disabled.png');
                                            //     break;
                                            //   case 'Invisible':
                                            //     iconVisibility = Image.asset('assets/img/icon/service_invisible.png');
                                            //     break;
                                            // }
                                            return GestureDetector(
                                              onTap: () {
                                                print("Tap on add new service");

                                                ///QUi mi passo parent root e costruisco albero parent nel crea servizio solo costituito dal parent scelto e i suoi children
                                              },
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left: mediaWidth * 0.12, right: mediaWidth * 0.07),
                                                    child: Container(
                                                      child: Icon(Icons.remove_red_eye, color: BuytimeTheme.SymbolGrey, size: mediaWidth * 0.07),
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
                                                            "Servizio Prova in attesa di veri servizi",
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
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.only(top: 10),
                                      //   child: serviceList.length > 0
                                      //       ? GridView.count(
                                      //           crossAxisCount: 1,
                                      //           childAspectRatio: 3.465,
                                      //           scrollDirection: Axis.vertical,
                                      //           shrinkWrap: true,
                                      //           children: List.generate(serviceList.length, (index) {
                                      //             return OptimumServiceCardMedium(
                                      //               rightWidget1: Column(
                                      //                 children: [
                                      //                   IconButton(
                                      //                     icon: Icon(
                                      //                       Icons.edit,
                                      //                       size: 20.0,
                                      //                     ),
                                      //                     onPressed: () {
                                      //                       StoreProvider.of<AppState>(context).dispatch(new SetService(snapshot.serviceList.serviceListState[index]));
                                      //                       Navigator.pushReplacement(
                                      //                         context,
                                      //                         MaterialPageRoute(builder: (context) => UI_ManageService(false)),
                                      //                       );
                                      //                     },
                                      //                   ),
                                      //                 ],
                                      //               ),
                                      //               rowWidget1: Container(
                                      //                 child: Column(
                                      //                   children: [
                                      //                     !uploadServiceVisibility
                                      //                         ? IconButton(
                                      //                             icon: iconVisibility,
                                      //                             onPressed: () {
                                      //                               ServiceState serviceStateUpdatedVisibility = snapshot.serviceList.serviceListState[index];
                                      //                               String visibilitySnapshot = serviceStateUpdatedVisibility.visibility;
                                      //                               setState(() {
                                      //                                 uploadServiceVisibility = true;
                                      //                                 print("La visibilità quando clicco è " + visibilitySnapshot);
                                      //                                 switch (visibilitySnapshot) {
                                      //                                   case 'Visible':
                                      //                                     serviceStateUpdatedVisibility.visibility = 'Shadow';
                                      //                                     print("Cambio in shadow");
                                      //                                     iconVisibility = Image.asset('assets/img/icon/service_disabled.png');
                                      //                                     break;
                                      //                                   case 'Shadow':
                                      //                                     serviceStateUpdatedVisibility.visibility = 'Invisible';
                                      //                                     print("Cambio in red");
                                      //                                     iconVisibility = Image.asset('assets/img/icon/service_invisible.png');
                                      //                                     break;
                                      //                                   case 'Invisible':
                                      //                                     serviceStateUpdatedVisibility.visibility = 'Visible';
                                      //                                     print("Cambio in visible");
                                      //                                     iconVisibility = Image.asset('assets/img/icon/service_visible.png');
                                      //                                     break;
                                      //                                 }
                                      //                               });
                                      //                               //TODO: DISCUTERE SE UPLOAD ON DB DEL SERVICE AGGIORNATO LO METTIAMO QUI e se viene aggiornata la lista dei servizi quando entro nel singolo servizio
                                      //                               StoreProvider.of<AppState>(context).dispatch(UpdateService(serviceStateUpdatedVisibility));
                                      //                               Future.delayed(const Duration(milliseconds: 1000), () {
                                      //                                 setState(() {
                                      //                                   uploadServiceVisibility = false;
                                      //                                 });
                                      //                               });
                                      //                             },
                                      //                           )
                                      //                         : Center(
                                      //                             child: SizedBox(
                                      //                               child: CircularProgressIndicator(),
                                      //                               height: 15.0,
                                      //                               width: 15.0,
                                      //                             ),
                                      //                           ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               imageUrl: serviceList[index].thumbnail,
                                      //               mediaSize: media,
                                      //               serviceState: serviceList[index],
                                      //               onServiceCardTap: (serviceState) {},
                                      //             );
                                      //           }),
                                      //         )
                                      //       : Center(
                                      //           child: Text("Non ci sono servizi in questo business!"),
                                      //         ),
                                      // ),
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
