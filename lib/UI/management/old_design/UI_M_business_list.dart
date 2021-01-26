import 'package:Buytime/UI/management/business/UI_C_manage_business.dart';
import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/business/optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/business/optimum_business_card_medium_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_M_BusinessList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_BusinessListState();
}

class UI_M_BusinessListState extends State<UI_M_BusinessList> {
  List<BusinessState> businessListState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    return StoreConnector<AppState, BusinessListState>(
        converter: (store) => store.state.businessList,
        onInit: (store) => {
              print("Oninitbusinesslist"),
              store.dispatch(BusinessListRequest(store.state.user.uid, store.state.user.getRole())),
            },
        builder: (context, snapshot) {
          businessListState = snapshot.businessListState;
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UI_ManageBusiness(-1)),
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
                      "I tuoi Business",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: media.height * 0.035,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: businessListState != null &&
                              businessListState.length > 0
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: businessListState.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                print("Chiamo " + index.toString());
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: new OptimumBusinessCardMediumManager(
                                    businessState: businessListState[index],
                                    rowWidget1: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20.0,
                                      ),
                                      onPressed: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(new SetBusiness(snapshot
                                                .businessListState[index]));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UI_ManageBusiness(index)),
                                        );
                                      },
                                    ),
                                    onBusinessCardTap:
                                        (BusinessState businessState) {
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(new SetBusiness(
                                              businessListState[index]));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UI_M_ServiceList()),
                                      );
                                    },
                                    imageUrl: businessListState[index].profile,
                                    mediaSize: media,
                                  ),
                                );
                              })
                          : Center(
                              child: Text("Non hai business attivi!"),
                            ),
                    ),
                  ),
                ],
              ));
        });
  }
}
