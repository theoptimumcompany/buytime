import 'package:Buytime/UI/management/business/UI_M_business.dart';
import 'package:Buytime/UI/management/service_external/UI_M_add_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_business_list_item.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_service_item.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PAServiceList extends StatefulWidget {
  List<ServiceState> serviceState;
  String title;
  ExternalBusinessState externalBusinessState;
  PAServiceList(this.serviceState, this.title, this.externalBusinessState);
  @override
  State<StatefulWidget> createState() => PAServiceListState();
}

class PAServiceListState extends State<PAServiceList> {

  List<ServiceState> serviceList = [];

  BusinessState tmpBusiness = BusinessState();

  @override
  void initState() {
    super.initState();
    serviceList = widget.serviceState;
    //serviceList.add(tmpBusiness);
  }

  Future<bool> _onWillPop() {}

  void undoDeletion(index, ServiceState item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      serviceList.insert(index, item);
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
          bool equalService = false;
          bool equalBusiness = false;
          List<String> tmp = [];
          StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
            if(widget.externalBusinessState.id_firestore == element.externalBusinessId && element.imported == true){
              if(!tmp.contains(element.externalServiceId)){
                tmp.add(element.externalServiceId);
              }
            }
          });

          int count = 0;
          snapshot.serviceList.serviceListState.forEach((sLS) {
            if(sLS.visibility != 'Invisible')
              count++;
          });
          debugPrint('UI_M_p_a_service_list => Count: $count | tmp: ${tmp.length}');
          if(count != 0 && count == tmp.length)
            equalService = true;

          StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported.forEach((element) {
            if(element.externalBusinessId == widget.externalBusinessState.id_firestore && element.imported == true){
              equalBusiness = true;
            }
          });

          if(count != 0 && tmp.length != 0 && count != tmp.length && equalBusiness){
            equalService = false;
            equalBusiness = false;
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
                appBar: AppBar(
                 backgroundColor: BuytimeTheme.BackgroundWhite,
                  leading: IconButton(
                    icon: Icon(Icons.keyboard_arrow_left, color: Colors.black),
                    onPressed: () {
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UI_M_Business()))
                      //Navigator.pushReplacement(context, EnterExitRoute(enterPage: UI_M_Business(), exitPage: PAServiceList(), from: false));
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text(
                    widget.title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: BuytimeTheme.TextBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  centerTitle: true,
                  elevation: 1,
                ),
                floatingActionButton: Container(
                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                    width: 272, ///media.width * .4
                    height: 44,
                    child: MaterialButton(
                      elevation: 0,
                      hoverElevation: 0,
                      focusElevation: 0,
                      highlightElevation: 0,
                      onPressed: !equalService && !equalBusiness ? () {
                        List<String> tmp = [];
                        StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
                          //debugPrint('UI_M_p_a_service_list => here');
                          widget.serviceState.forEach((sL) {
                            //debugPrint('UI_M_p_a_service_list => 2');
                            if(element.externalServiceId != sL.serviceId && element.externalBusinessId == widget.externalBusinessState.id_firestore){
                              //debugPrint('UI_M_p_a_service_list => here 3');
                              tmp.add(sL.serviceId);
                            }
                          });
                        });
                        if(tmp.isEmpty){
                          widget.serviceState.forEach((sL) {
                            tmp.add(sL.serviceId);
                          });
                        }
                        debugPrint('UI_M_p_a_service_list => ${tmp}');
                        tmp.forEach((serviceId) {
                          ExternalServiceImportedState eSIS = ExternalServiceImportedState();
                          eSIS.internalBusinessId = snapshot.business.id_firestore;
                          eSIS.internalBusinessName = snapshot.business.name;
                          eSIS.externalBusinessId = widget.externalBusinessState.id_firestore;
                          eSIS.externalBusinessName = widget.externalBusinessState.name;
                          eSIS.externalServiceId = serviceId;
                          eSIS.importTimestamp = DateTime.now();
                          eSIS.imported = true;
                          snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSL) {
                            sLSL.businessSnippet.forEach((bS) {
                              bS.serviceList.forEach((sL) {
                                if(sL.serviceAbsolutePath.split('/').last == serviceId){
                                  debugPrint('UI_M_p_a_service_list => External category name: ${bS.categoryName}');
                                  eSIS.externalCategoryName = bS.categoryName;
                                }
                              });
                            });
                          });
                          StoreProvider.of<AppState>(context).dispatch(CreateExternalServiceImported(eSIS));
                        });
                      } : null,
                      textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                      color:  BuytimeTheme.ActionButton,
                      disabledColor: BuytimeTheme.SymbolGrey,
                      padding: EdgeInsets.all(media.width * 0.03),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10.0, bottom: 5),
                            child: Icon(
                              Icons.settings_ethernet,
                              color: BuytimeTheme.SymbolWhite,
                              size: 19,
                            ),
                          ),
                          Text(
                            !equalService && !equalBusiness ? AppLocalizations.of(context).addToYourNetwork.toUpperCase() : AppLocalizations.of(context).alreadyInYourNetwork.toUpperCase(),
                            style: TextStyle(
                              letterSpacing: 1.25,
                              fontSize: 14,
                              fontFamily: BuytimeTheme.FontFamily,
                              fontWeight: FontWeight.w500,
                              color: BuytimeTheme.TextWhite,

                            ),
                          )
                        ],
                      ),
                    )
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                body: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    children: [
                      ///Container Redirect To Add New External Service into the network
                      /*Container(
                          margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    color: BuytimeTheme.TextBlack,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )),*/
                       serviceList.isNotEmpty ?
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                          child: CustomScrollView(
                            physics: new ClampingScrollPhysics(),
                            shrinkWrap: true,
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate((context, index){
                                  ServiceState item = serviceList.elementAt(index);
                                  DismissDirection tmpDismiss;
                                  bool equalService = false;
                                  bool equalBusiness = false;
                                  StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
                                    if(element.externalServiceId == item.serviceId){
                                      equalService = true;
                                    }
                                  });
                                  StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported.forEach((element) {
                                    if(element.externalBusinessId == item.businessId){
                                      equalBusiness = true;
                                    }
                                  });
                                  if(equalService || equalBusiness){
                                    tmpDismiss = DismissDirection.none;
                                  }else{
                                    tmpDismiss = DismissDirection.endToStart;
                                  }
                                  if (item.serviceCrossSell) { /// only show the item if the service is flagged as cross-sellable
                                    return Dismissible(
                                      // Each Dismissible must contain a Key. Keys allow Flutter to
                                      // uniquely identify widgets.
                                      key: UniqueKey(),
                                      // Provide a function that tells the app
                                      // what to do after an item has been swiped away.
                                      direction: tmpDismiss,
                                      onDismissed: (direction) {
                                        // Remove the item from the data source.
                                        setState(() {
                                          serviceList.removeAt(index);
                                        });
                                        debugPrint('UI_M_p_a_service_list => SX to BOOK');
                                        ExternalServiceImportedState eSIS = ExternalServiceImportedState();
                                        eSIS.internalBusinessId = snapshot.business.id_firestore;
                                        eSIS.internalBusinessName = snapshot.business.name;
                                        eSIS.externalBusinessId = widget.externalBusinessState.id_firestore;
                                        eSIS.externalBusinessName = widget.externalBusinessState.name;
                                        eSIS.externalServiceId = item.serviceId;
                                        eSIS.importTimestamp = DateTime.now();
                                        snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSL) {
                                          sLSL.businessSnippet.forEach((bS) {
                                            bS.serviceList.forEach((sL) {
                                              if(sL.serviceAbsolutePath.split('/').last == item.serviceId){
                                                eSIS.externalCategoryName = bS.categoryName;
                                              }
                                            });
                                          });
                                        });
                                        StoreProvider.of<AppState>(context).dispatch(CreateExternalServiceImported(eSIS));
                                        undoDeletion(index, item);
                                      },
                                      child: Column(
                                        children: [
                                          ExternalServiceItem(item, false, widget.serviceState, widget.title, widget.externalBusinessState),
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                            height: SizeConfig.safeBlockVertical * .2,
                                            color: BuytimeTheme.DividerGrey,
                                          )
                                        ],
                                      ),
                                      background: Container(
                                        color: BuytimeTheme.BackgroundWhite,
                                        //margin: EdgeInsets.symmetric(horizontal: 15),
                                        alignment: Alignment.centerRight,
                                      ),
                                      secondaryBackground: Container(
                                        color: BuytimeTheme.ManagerPrimary,
                                        //margin: EdgeInsets.symmetric(horizontal: 15),
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                          child: Icon(
                                            Icons.add_circle_outline,
                                            size: 24,
                                            ///SizeConfig.safeBlockHorizontal * 7
                                            color: BuytimeTheme.SymbolWhite,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                                  childCount: serviceList.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )  : Container(
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
