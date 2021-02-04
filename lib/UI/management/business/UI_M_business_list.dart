import 'package:Buytime/UI/management/business/UI_M_manage_business.dart';
import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/reblox/model/business/business_list_state.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reusable/business/optimum_business_card_medium_manager.dart';
import 'package:Buytime/reusable/appbar/manager_buytime_appbar.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UI_M_BusinessList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_M_BusinessListState();
}

class UI_M_BusinessListState extends State<UI_M_BusinessList> {
  List<BusinessState> businessListState;
  GlobalKey<ScaffoldState> _drawerKeyTabs = GlobalKey();

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
          return WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
                key: _drawerKeyTabs,
                appBar: BuytimeAppbarManager(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: BuytimeTheme.TextWhite,
                          size: 30.0,
                        ),
                        tooltip: AppLocalizations.of(context).showMenu,
                        onPressed: () {
                          _drawerKeyTabs.currentState.openDrawer();
                        },
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Text(
                          AppLocalizations.of(context).businessManagement,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: BuytimeTheme.TextWhite,
                            fontSize: media.height * 0.025,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: BuytimeTheme.TextWhite,
                          size: 30.0,
                        ),
                        tooltip: AppLocalizations.of(context).createBusinessPlain,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => UI_M_ManageBusiness(-1)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                drawer: UI_M_BusinessListDrawer(),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: businessListState != null && businessListState.length > 0
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: businessListState.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: new OptimumBusinessCardMediumManager(
                                      businessState: businessListState[index],
                                      onBusinessCardTap: (BusinessState businessState) {
                                        StoreProvider.of<AppState>(context).dispatch(SetBusiness(businessListState[index]));
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => UI_M_Business()),
                                        );
                                      },
                                      imageUrl: businessListState[index].profile,
                                      mediaSize: media,
                                    ),
                                  );
                                })
                            : Center(
                                child: Text(AppLocalizations.of(context).noActiveBusinesses),
                              ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }
}
