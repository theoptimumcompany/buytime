import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_M_ExternalServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_ExternalServiceListState();
}

class UI_M_ExternalServiceListState extends State<UI_M_ExternalServiceList> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() {}

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => {},
        builder: (context, snapshot) {
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
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: UI_M_ExternalServiceList(), from: false));
                      },
                    ),
                    Utils.barTitle(AppLocalizations.of(context).externalServices),
                    IconButton(
                      icon: Icon(Icons.add, color: BuytimeTheme.ManagerPrimary),
                      onPressed: () {
                        return null;
                      },
                    ),
                  ],
                ),
                body: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    children: [
                      ///Container Redirect To Add New External Service into the network
                      Container(
                          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  AppLocalizations.of(context).attachedServices,
                                  style: TextStyle(
                                    color: BuytimeTheme.TextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              ///Manage Categories of the Business
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    AppLocalizations.of(context).addNew,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 18, color: BuytimeTheme.ManagerPrimary),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, i) {
                            return Container();
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
