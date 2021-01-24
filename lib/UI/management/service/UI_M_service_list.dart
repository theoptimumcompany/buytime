import 'dart:async';
import 'dart:core';

import 'package:BuyTime/UI/management/business/UI_M_business.dart';
import 'package:BuyTime/UI/management/old_design/UI_M_Tabs.dart';
import 'package:BuyTime/UI/management/service/UI_manage_service.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:BuyTime/reblox/model/snippet/generic.dart';
import 'package:BuyTime/reblox/model/order/order_state.dart';
import 'package:BuyTime/reblox/model/order/order_entry.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:BuyTime/reblox/reducer/service_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:BuyTime/reusable/service/optimum_service_card_medium.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_M_ServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_ServiceListState();
}

class UI_M_ServiceListState extends State<UI_M_ServiceList> {
  OrderState order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");

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
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => {store.dispatch(ServiceListRequest(store.state.business.id_firestore,'manager'))},
        builder: (context, snapshot) {
          List<ServiceState> serviceList = StoreProvider.of<AppState>(context).state.serviceList.serviceListState;
          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
          return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: BuyTimeAppbarManager(
                  width: media.width,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.1),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UI_M_Business()),
                      ),
                    ),
                    ColorFiltered(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        child: Image.network(
                          StoreProvider.of<AppState>(context).state.business.logo,
                          height: media.height * 0.05,
                        ),
                      ),
                    SizedBox(width: 30,),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => UI_ManageService(true)),
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Color.fromRGBO(50, 50, 100, 1.0),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                      child: Text(
                        StoreProvider.of<AppState>(context).state.business.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                      child: Text(
                        "I nostri servizi",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.025,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: serviceList.length > 0
                            ? GridView.count(
                                crossAxisCount: 1,
                                childAspectRatio: 3.465,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                children: List.generate(serviceList.length, (index) {
                                  print("Index " +  index.toString() + "  della lista ha visibilità : " + snapshot.serviceList.serviceListState[index].visibility);
                                  switch (snapshot.serviceList.serviceListState[index].visibility) {
                                    case 'Visible':
                                      iconVisibility = Image.asset('assets/img/icon/service_visible.png');
                                      break;
                                    case 'Shadow':
                                      iconVisibility = Image.asset('assets/img/icon/service_disabled.png');
                                      break;
                                    case 'Invisible':
                                      iconVisibility = Image.asset('assets/img/icon/service_invisible.png');
                                      break;
                                  }
                                  return OptimumServiceCardMedium(
                                    rightWidget1: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20.0,
                                          ),
                                          onPressed: () {
                                            StoreProvider.of<AppState>(context).dispatch(new SetService(snapshot.serviceList.serviceListState[index]));
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => UI_ManageService(false)),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    rowWidget1: Container(
                                      child: Column(
                                        children: [
                                          !uploadServiceVisibility
                                              ? IconButton(
                                                  icon: iconVisibility,
                                                  onPressed: () {
                                                    ServiceState serviceStateUpdatedVisibility = snapshot.serviceList.serviceListState[index];
                                                    String visibilitySnapshot = serviceStateUpdatedVisibility.visibility;
                                                    setState(() {
                                                      uploadServiceVisibility = true;
                                                      print("La visibilità quando clicco è " + visibilitySnapshot);
                                                      switch (visibilitySnapshot) {
                                                        case 'Visible':
                                                          serviceStateUpdatedVisibility.visibility = 'Shadow';
                                                          print("Cambio in shadow");
                                                          iconVisibility = Image.asset('assets/img/icon/service_disabled.png');
                                                          break;
                                                        case 'Shadow':
                                                          serviceStateUpdatedVisibility.visibility = 'Invisible';
                                                          print("Cambio in red");
                                                          iconVisibility = Image.asset('assets/img/icon/service_invisible.png');
                                                          break;
                                                        case 'Invisible':
                                                          serviceStateUpdatedVisibility.visibility = 'Visible';
                                                          print("Cambio in visible");
                                                          iconVisibility = Image.asset('assets/img/icon/service_visible.png');
                                                          break;
                                                      }
                                                    });
                                                    //TODO: DISCUTERE SE UPLOAD ON DB DEL SERVICE AGGIORNATO LO METTIAMO QUI e se viene aggiornata la lista dei servizi quando entro nel singolo servizio
                                                    StoreProvider.of<AppState>(context).dispatch(UpdateService(serviceStateUpdatedVisibility));
                                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                                      setState(() {
                                                        uploadServiceVisibility = false;
                                                      });
                                                    });
                                                  },
                                                )
                                              : Center(
                                                  child: SizedBox(
                                                    child: CircularProgressIndicator(),
                                                    height: 15.0,
                                                    width: 15.0,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    imageUrl: serviceList[index].thumbnail,
                                    mediaSize: media,
                                    serviceState: serviceList[index],
                                    onServiceCardTap: (serviceState) {},
                                  );
                                }),
                              )
                            : Center(
                                child: Text("Non ci sono servizi in questo business!"),
                              ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
