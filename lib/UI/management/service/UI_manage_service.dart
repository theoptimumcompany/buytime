import 'package:BuyTime/UI/management/service/UI_M_service_list.dart';
import 'package:BuyTime/UI/management/service/UI_edit_service.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/UI/management/business/UI_C_business_list.dart';
import 'package:BuyTime/reblox/model/service/service_state.dart';
import 'package:BuyTime/reblox/reducer/service_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/service_reducer.dart';
import 'package:BuyTime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:BuyTime/reusable/service/optimum_service_card_medium.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../old_design/UI_M_Tabs.dart';
import 'UI_create_service.dart';

class UI_ManageService extends StatefulWidget {
  UI_ManageService(bool creation) {
    this.creation = creation;
  }

  bool creation;

  final GlobalKey<ScaffoldState> _keyScaffoldService =
      GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => UI_ManageServiceState();
}

class UI_ManageServiceState extends State<UI_ManageService> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        /*onInit:  (store) => */
        builder: (context, snapshot) {
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
                appBar: BuyTimeAppbarManager(
                  width: media.width,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left,
                          color: Colors.white, size: media.width * 0.1),
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                      ),
                    ),
                    Text(
                      widget.creation == true
                          ? "Creazione Servizio"
                          : "Modifica Servizio",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: media.height * 0.035,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 40.0,
                    )
                  ],
                ),
                body: widget.creation == true
                    ? UI_CreateService()
                    : UI_EditService()),
          );
        });
  }
}
