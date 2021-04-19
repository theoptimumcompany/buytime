import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service_external/UI_M_add_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_business_list_item.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ExternalServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExternalServiceListState();
}

class ExternalServiceListState extends State<ExternalServiceList> {

  List<ExternalBusinessState> externalServiceList = [];

  ExternalBusinessState tmpBusiness = ExternalBusinessState();

  @override
  void initState() {
    super.initState();
    externalServiceList.add(tmpBusiness);
  }

  Future<bool> _onWillPop() {}

  void undoDeletion(index, ExternalBusinessState item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      externalServiceList.insert(index, item);
      //orderState.total += item.price * item.number;
    });
  }

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
                        Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: ExternalServiceList(), from: false));
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
                                  AppLocalizations.of(context).servicesByPartners,
                                  style: TextStyle(
                                    color: BuytimeTheme.TextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              ///Add new
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, EnterExitRoute(enterPage: AddExternalServiceList(true), exitPage: ExternalServiceList(), from: true));
                                },
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    AppLocalizations.of(context).addNew,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                  ),
                                ),
                              ),
                            ],
                          )),
                       externalServiceList.isNotEmpty ?
                      Expanded(
                        child: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                ExternalBusinessState item = externalServiceList.elementAt(index);
                                  return Dismissible(
                                    // Each Dismissible must contain a Key. Keys allow Flutter to
                                    // uniquely identify widgets.
                                    key: UniqueKey(),
                                    // Provide a function that tells the app
                                    // what to do after an item has been swiped away.
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      // Remove the item from the data source.
                                      setState(() {
                                        externalServiceList.removeAt(index);
                                      });
                                      if (direction == DismissDirection.endToStart) {

                                        debugPrint('UI_U_external_service_list => DX to DELETE');
                                        // Show a snackbar. This snackbar could also contain "Undo" actions.
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(context).spaceRemoved),
                                            action: SnackBarAction(
                                                label: AppLocalizations.of(context).undo,
                                                onPressed: () {
                                                  //To undo deletion
                                                  undoDeletion(index, item);
                                                })));
                                      } else {
                                        externalServiceList.insert(index, item);
                                      }
                                    },
                                    child: ExternalBusinessListItem(item, true),
                                    background: Container(
                                      color: BuytimeTheme.BackgroundWhite,
                                      //margin: EdgeInsets.symmetric(horizontal: 15),
                                      alignment: Alignment.centerRight,
                                    ),
                                    secondaryBackground: Container(
                                      color: BuytimeTheme.AccentRed,
                                      //margin: EdgeInsets.symmetric(horizontal: 15),
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                        child: Icon(
                                          BuytimeIcons.remove,
                                          size: 24,

                                          ///SizeConfig.safeBlockHorizontal * 7
                                          color: BuytimeTheme.SymbolWhite,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: externalServiceList.length,
                              ),
                            ),
                          ],
                        ),
                      )  : Container(
                         height: SizeConfig.safeBlockVertical * 8,
                         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                         decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                         child: Center(
                             child: Container(
                               margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                               alignment: Alignment.centerLeft,
                               child: Text(
                                 AppLocalizations.of(context).noExternalServiceFound,
                                 style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                               ),
                             )),
                       ),
                    ],
                  ),
                ),
              ));
        });
  }
}
