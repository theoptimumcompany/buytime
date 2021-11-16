import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service_external/UI_M_add_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_business_list_item.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_snippet_list_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
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

  List<ExternalBusinessState> externalBusinessList = [];
  List<int> externalServiceCount = [];

  ExternalBusinessState tmpBusiness = ExternalBusinessState();

  @override
  void initState() {
    super.initState();
    //externalServiceList.add(tmpBusiness);
  }

  Future<bool> _onWillPop() {}

  void undoDeletion(index, ExternalBusinessState item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      externalBusinessList.insert(index, item);
      //orderState.total += item.price * item.number;
    });
  }

  bool startRequest = false;
  bool noActivity = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaWidth = media.width;
    var mediaHeight = media.height;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) {
          store.state.serviceListSnippetListState.serviceListSnippetListState.clear();
          List<ExternalBusinessState> businessStateList = [];
          List<String> businessIds = [];

          store.state.externalServiceImportedListState.externalServiceImported.forEach((element) {
            if(element.imported == true){
              if(!businessIds.contains(element.externalBusinessId))
                businessIds.add(element.externalBusinessId);
            }

          });
          store.state.externalBusinessImportedListState.externalBusinessImported.forEach((element) {
            if(element.imported == true){
              if(!businessIds.contains(element.externalBusinessId))
                businessIds.add(element.externalBusinessId);
            }
          });

          businessIds.forEach((element) {
            businessStateList.add(ExternalBusinessState(
                id_firestore: element
            ));
          });
          debugPrint('UI_M_external_service_list => EXTERNAL BUSINESS: ${businessStateList.length}');
          store.dispatch(ServiceListSnippetListRequest(businessStateList));
          startRequest = true;
          noActivity = true;
        },
        builder: (context, snapshot) {
          externalServiceCount.clear();
          externalBusinessList.clear();
          debugPrint('UI_M_external_service_list => IMPORTED SERVICE LENGTH: ${snapshot.externalServiceImportedListState.externalServiceImported.length}');
          debugPrint('UI_M_external_service_list => IMPORTED BUSINESS LENGTH: ${snapshot.externalBusinessImportedListState.externalBusinessImported.length}');
          //debugPrint('UI_M_external_service_list => IMPORTED BUSINESS ID: ${snapshot.externalBusinessImportedListState.externalBusinessImported.first.externalBusinessId}');
          debugPrint('UI_M_external_service_list => IMPORTED SNIPPET LENGTH: ${snapshot.serviceListSnippetListState.serviceListSnippetListState.length}');
          if(snapshot.serviceListSnippetListState.serviceListSnippetListState.isEmpty && startRequest){
            debugPrint('UI_M_external_service_list => Requesting');
            noActivity = true;
            startRequest = false;
          }else{
            if(snapshot.serviceListSnippetListState.serviceListSnippetListState.isNotEmpty){
              if(snapshot.serviceListSnippetListState.serviceListSnippetListState.first.businessId == null){
                startRequest = false;
                snapshot.serviceListSnippetListState.serviceListSnippetListState.removeLast();
              }else{
                if(snapshot.serviceListSnippetState.businessId != null){
                  /*snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSLS) {
                    snapshot.serviceListSnippetState.takenConnectedBusinessIds.forEach((tCBI) {
                      if(tCBI.businessId == sLSLS.businessId){
                        externalBusinessList.add(
                            ExternalBusinessState(
                                name: tCBI.businessName,
                                profile: tCBI.businessImage,
                                id_firestore: tCBI.businessId
                            )
                        );
                        externalServiceCount.add(tCBI.serviceTakenNumber);
                      }
                    });

                  });*/

                  snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSLS) {
                    sLSLS.givenConnectedBusinessIds.forEach((gCBI) {
                      if(gCBI.businessId == snapshot.business.id_firestore){
                        externalBusinessList.add(
                            ExternalBusinessState(
                                name: sLSLS.businessName,
                                profile: sLSLS.businessImage,
                                id_firestore: sLSLS.businessId
                            )
                        );
                        externalServiceCount.add(gCBI.serviceGivenNumber);
                      }
                    });
                  });

                  noActivity = false;
                  startRequest = false;
                }

              }
            }else{
              noActivity = false;
              startRequest = false;
            }

            noActivity = false;
            startRequest = false;

          }
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
                      key: Key('external_business_list_back_key'),
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
                                key: Key('add_external_business_list_key'),
                                onTap: () {
                                  //StoreProvider.of<AppState>(context).dispatch(ExternalServiceImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                                  //StoreProvider.of<AppState>(context).dispatch(ExternalBusinessImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                                  Navigator.push(context, EnterExitRoute(enterPage: AddExternalServiceList(true), exitPage: ExternalServiceList(), from: true));
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
                       externalBusinessList.isNotEmpty ?
                      Expanded(
                        child: CustomScrollView(
                          physics: new ClampingScrollPhysics(),
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate((context, index){
                                ExternalBusinessState item = externalBusinessList.elementAt(index);
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
                                        externalBusinessList.removeAt(index);
                                      });
                                      if (direction == DismissDirection.endToStart) {

                                        debugPrint('UI_U_external_service_list => DX to DELETE');
                                        // Show a snackbar. This snackbar could also contain "Undo" actions.
                                        ExternalBusinessImportedState eBIS = ExternalBusinessImportedState();
                                        eBIS.internalBusinessId = snapshot.business.id_firestore;
                                        eBIS.internalBusinessName = snapshot.business.name;
                                        eBIS.externalBusinessId = item.id_firestore;
                                        eBIS.externalBusinessName = item.name;
                                        eBIS.importTimestamp = DateTime.now();
                                        eBIS.imported = false;
                                        StoreProvider.of<AppState>(context).dispatch(CancelExternalBusinessImported(eBIS));
                                        List<ServiceListSnippetState> tmpList = [];
                                        snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((element) {
                                          if(element.businessId != item.id_firestore)
                                            tmpList.add(element);
                                        });

                                        snapshot.serviceListSnippetListState.serviceListSnippetListState = tmpList;

                                        /*Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(AppLocalizations.of(context).spaceRemoved),
                                            action: SnackBarAction(
                                                label: AppLocalizations.of(context).undo,
                                                onPressed: () {
                                                  //To undo deletion
                                                  undoDeletion(index, item);
                                                })));*/
                                      } else {
                                        externalBusinessList.insert(index, item);
                                      }
                                    },
                                    child: ExternalBusinessListItem(item, true, externalServiceCount[index]),
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
                                childCount: externalBusinessList.length,
                              ),
                            ),
                          ],
                        ),
                      )  : noActivity ?
                       Expanded(
                         child: CustomScrollView(
                           physics: new ClampingScrollPhysics(),
                           shrinkWrap: true,
                           slivers: [
                             SliverList(
                               delegate: SliverChildBuilderDelegate((context, index){
                                 //ExternalBusinessState item = externalBuinessList.elementAt(index);
                                 return Column(
                                   children: [
                                     Container(
                                       //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
                                         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
                                         child: Container(
                                           height: 91,  ///SizeConfig.safeBlockVertical * 15
                                           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: 1, bottom: 1),
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Row(
                                                 children: [
                                                   ///Service Image
                                                   Utils.imageShimmer(91, 91),
                                                   ///Service Name & Description
                                                   Container(
                                                     margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                                     child:  Column(
                                                       mainAxisAlignment: MainAxisAlignment.start,
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         ///Service Name
                                                         FittedBox(
                                                           fit: BoxFit.scaleDown,
                                                           child: Container(
                                                               width: SizeConfig.safeBlockHorizontal * 50,
                                                               child: Utils.textShimmer(150, 12.5)
                                                           ),
                                                         ),
                                                         ///Description
                                                         FittedBox(
                                                           fit: BoxFit.fitHeight,
                                                           child: Container(
                                                               margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                               child: Utils.textShimmer(25, 10)
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                               /*Icon(
                      Icons.arrow_forward_ios,
                      color: BuytimeTheme.SymbolLightGrey,
                    )*/
                                             ],
                                           ),
                                         )
                                     ),
                                     Container(
                                       margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                       height: SizeConfig.safeBlockVertical * .2,
                                       color: BuytimeTheme.DividerGrey,
                                     )
                                   ],
                                 );
                               },
                                 childCount: 10,
                               ),
                             ),
                           ],
                         ),
                       ) : Container(
                         height: SizeConfig.safeBlockVertical * 8,
                         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                         decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                         child: Center(
                             child: Container(
                               margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                               alignment: Alignment.centerLeft,
                               child: Text(
                                 AppLocalizations.of(context).noServiceFound,
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
