import 'package:Buytime/UI/management/service/UI_M_service_list.dart';
import 'package:Buytime/UI/management/service/UI_M_edit_service_old.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'UI_M_create_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_ManageService extends StatefulWidget {
  UI_ManageService({this.creation = false});

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
                appBar: BuytimeAppbarManager(
                  width: media.width,
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.chevron_left,
                            color: Colors.white, size: media.width * 0.09),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_M_ServiceList()),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        widget.creation == true
                            ? AppLocalizations.of(context).serviceCreation
                            : AppLocalizations.of(context).serviceEdit,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: media.height * 0.028,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.check,
                            color: Colors.white, size: media.width * 0.07),
                        onPressed: () {
                          print("Salva nuovo servizio");
                        }
                      ),
                    ),
                  ],
                ),
                body: widget.creation == true
                    ? UI_CreateService()
                    : UI_EditService()),
          );
        });
  }
}