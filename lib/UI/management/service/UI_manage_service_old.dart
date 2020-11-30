import 'package:BuyTime/UI/management/service/UI_M_service_list.dart';
import 'package:BuyTime/UI/management/service/UI_edit_service.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/reducer/service_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reusable/service/optimum_service_card_medium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../old_design/UI_M_Tabs.dart';
import 'UI_create_service.dart';

class UI_ManageService extends StatefulWidget {
  final String title = 'Services';

  UI_ManageService({this.edited = false, this.created = false,this.deleted = false});

  bool edited;
  bool created;
  bool deleted;
  final GlobalKey<ScaffoldState> _keyScaffoldService = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => UI_ManageServiceState();
}

class UI_ManageServiceState extends State<UI_ManageService> {
  int numberOfServices = 0;
  List<Card> listServiceCard = new List<Card>();
  bool canBuildCards = true;


  @override
  void initState() {
    super.initState();
    numberOfServices = 0;
    listServiceCard = new List<Card>();

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
            'Service Created!',
            style: TextStyle(color: Colors.white),
          ),
        );
        widget._keyScaffoldService.currentState.showSnackBar(snackBar);
      } else if (widget.edited) {
        final snackBar = SnackBar(
          elevation: 5,
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          content: Text(
            'Service Edited!',
            style: TextStyle(color: Colors.white),
          ),
        );
        widget._keyScaffoldService.currentState.showSnackBar(snackBar);
      }
      else if (widget.deleted) {
        final snackBar = SnackBar(
          elevation: 5,
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
          content: Text(
            'Service Deleted!',
            style: TextStyle(color: Colors.white),
          ),
        );
        widget._keyScaffoldService.currentState.showSnackBar(snackBar);
      }
      widget.edited = false;
      widget.created = false;
      widget.deleted = false;
    });
  }

  seekNumbercategory(List<dynamic> list) {
    if (list != null) {
      for (int i = 0; i < list.length; i++) {
        numberOfServices += 1;
        Card categoryCard = Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.only(left: double.parse(list[i]["level"].toString()) * 10.0),
            child: GridTile(
              footer: Text(list[i]["nodeName"]),
              child: Text(list[i]["level"].toString()),
            ),
          ),
        );
        listServiceCard.add(categoryCard);
        if (list[i]['nodeCategory'] != null) {
          seekNumbercategory(list[i]['nodeCategory']);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        /*onInit:  (store) => */
        builder: (context, snapshot) {
          if (canBuildCards == true) {
            seekNumbercategory(snapshot.categorySnippet.categoryNodeList);
            canBuildCards = false;
          }
          return WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
              );
              return false;
            },
          child: Scaffold(
              key: widget._keyScaffoldService,
              appBar: AppBar(
                title: Text(
                  'Services',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                iconTheme: new IconThemeData(color: Colors.black),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  //             StoreProvider.of<AppState>(context).dispatch(new CategoryNodeRequest());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UI_CreateService()),
                  );
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                backgroundColor: Colors.orangeAccent,
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(children: <Widget>[
                    Container(
                      height: media.height * 0.9,
                      child: StoreConnector<AppState, AppState>(
                          onInit: (store) => store.dispatch(new ServiceListRequest(store.state.business.id_firestore,"user")),
                          rebuildOnChange: true,
                          converter: (store) => store.state,
                          builder: (context, snapshot) {
                            List<ServiceState> serviceListState = snapshot.serviceList.serviceListState;
                            return GridView.count(
                              crossAxisCount: 1,
                              childAspectRatio: 3.1,
                              children: List.generate(serviceListState.length, (index) {
                                return Container(
                                  child: serviceListState.length > 0
                                      ? OptimumServiceCardMedium(
                                        imageUrl: serviceListState[index].thumbnail,
                                        mediaSize: media,
                                        serviceState: serviceListState[index],
                                        onServiceCardTap: (serviceState) {
                                          StoreProvider.of<AppState>(context).dispatch(new SetService(StoreProvider.of<AppState>(context).state.serviceList.serviceListState[index]));
                                          Future.delayed(const Duration(milliseconds: 500), () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => UI_EditService()),
                                            );
                                          });
                                        },
                                      )
                                      : Center(
                                          child: Text("Chi non osa nulla, non speri in nulla."),
                                        ),
                                );
                              }),
                            );
                          }),
                    )
                  ]),
                ),
              )),);
        });
  }
}
