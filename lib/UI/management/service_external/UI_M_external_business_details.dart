import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/UI/management/service_external/UI_M_add_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_p_a_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_service_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_imported_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/model/service/snippet/service_snippet_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/external_business_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_list_reducer.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

import '../../../environment_abstract.dart';


class ExternalBusinessDetails extends StatefulWidget {
   ExternalBusinessState externalBusinessState;
  bool fromMyList;
  bool fromMyBusiness;
  static String route = '/externalServiceDetails';
  ExternalBusinessDetails(this.externalBusinessState, this.fromMyList, this.fromMyBusiness);

  @override
  createState() => _ExternalBusinessDetailsState();

}

class _ExternalBusinessDetailsState extends State<ExternalBusinessDetails> with SingleTickerProviderStateMixin {

  List<ServiceState> popularServiceList = [];
  List<ServiceState> allServiceList = [];

  ServiceState tmpService = ServiceState();
  double lat = 0.0;
  double lng = 0.0;

  bool startRequest = false;
  bool noActivity = false;

  @override
  void initState() {
    super.initState();
    //popularServiceList.add(tmpService);
   }

  @override
  void dispose() {
    super.dispose();
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    }else {
      result = "https://firebasestorage.googleapis.com/v0/b/${Environment().config.fireStorageServiceStorageBucket}/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  void undoPopularDeletion(index, item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      popularServiceList.insert(index, item);
    });
  }
  void undoAllDeletion(index, item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      allServiceList.insert(index, item);
    });
  }

  String getShopLocationImage(String coordinates, String address){
    String url;
    List<double> coordinatesDouble = convertCoordinateString(coordinates);
    if(coordinatesDouble.isNotEmpty){
      if(Platform.isIOS)
        url = 'https://maps.googleapis.com/maps/api/staticmap?center=${coordinatesDouble[0]},${coordinatesDouble[1]}&zoom=18&size=640x640&scale=2&markers=color:red|${coordinatesDouble[0]},${coordinatesDouble[1]}&key=${Environment().config.googleApiKey}';
      else
        url = 'https://maps.googleapis.com/maps/api/staticmap?center=${coordinatesDouble[0]},${coordinatesDouble[1]}&zoom=18&size=640x640&scale=2&markers=color:red|${coordinatesDouble[0]},${coordinatesDouble[1]}&key=${Environment().config.googleApiKey}';
      return url;
    }else{
      if(Platform.isIOS)
        url = 'https://maps.googleapis.com/maps/api/staticmap?center=$address&zoom=18&size=640x640&scale=2&markers=color:red|$address&key=${Environment().config.googleApiKey}';
      else
        url = 'https://maps.googleapis.com/maps/api/staticmap?center=$address&zoom=18&size=640x640&scale=2&markers=color:red|$address&key=${Environment().config.googleApiKey}';
      return url;
    }
  }

  void createExternalService(BusinessState businessState, String serviceId, List<ServiceListSnippetState> serviceSnippetList){
    ExternalServiceImportedState eSIS = ExternalServiceImportedState();
    eSIS.internalBusinessId = businessState.id_firestore;
    eSIS.internalBusinessName = businessState.name;
    eSIS.externalBusinessId = widget.externalBusinessState.id_firestore;
    eSIS.externalBusinessName = widget.externalBusinessState.name;
    eSIS.externalServiceId = serviceId;
    eSIS.importTimestamp = DateTime.now();
    eSIS.imported = true;
    serviceSnippetList.forEach((sLSL) {
      sLSL.businessSnippet.forEach((bS) {
        bS.serviceList.forEach((sL) {
          if(sL.serviceAbsolutePath.split('/').last == serviceId){
            eSIS.externalCategoryName = bS.categoryName;
          }
        });
      });
    });
    StoreProvider.of<AppState>(context).dispatch(CreateExternalServiceImported(eSIS));
  }

  void cancelExternalService(BusinessState businessState, String serviceId, List<ServiceListSnippetState> serviceSnippetList){
    ExternalServiceImportedState eSIS = ExternalServiceImportedState();
    eSIS.internalBusinessId = businessState.id_firestore;
    eSIS.internalBusinessName = businessState.name;
    eSIS.externalBusinessId = widget.externalBusinessState.id_firestore;
    eSIS.externalBusinessName = widget.externalBusinessState.name;
    eSIS.externalServiceId = serviceId;
    eSIS.importTimestamp = DateTime.now();
    eSIS.imported = false;
    serviceSnippetList.forEach((sLSL) {
      sLSL.businessSnippet.forEach((bS) {
        bS.serviceList.forEach((sL) {
          if(sL.serviceAbsolutePath.split('/').last == serviceId){
            eSIS.externalCategoryName = bS.categoryName;
          }
        });
      });
    });
    StoreProvider.of<AppState>(context).dispatch(CancelExternalServiceImported(eSIS));
  }

  DismissDirection getDismiss(List<ExternalServiceImportedState> externalServices, List<ExternalBusinessImportedState> externalBusiness, ServiceState service){
    DismissDirection tmpDismiss;
    bool equalService = false;
    bool equalBusiness = false;
    externalServices.forEach((element) {
      if(element.externalServiceId == service.serviceId && element.imported == true){
        equalService = true;
      }
    });
    externalBusiness.forEach((element) {
      if(element.externalBusinessId == service.businessId && element.imported == true){
        equalBusiness = true;
      }
    });
    if(equalBusiness){
      debugPrint('${ service.name} | if | business true');
      externalServices.forEach((element) {
        if(element.externalServiceId == service.serviceId && element.imported == true){
          debugPrint('${ service.name} | if | business true | service true');
          equalService = true;
        }
        if(element.externalServiceId == service.serviceId && element.imported == false){
          debugPrint('${ service.name} | if | business true | service false');
          equalService = false;
          equalBusiness = false;
        }
      });
      bool found = false;
      externalServices.forEach((element) {
        if(element.externalServiceId == service.serviceId && element.imported == true){
          found = true;
        }
      });

      if(!found && externalServices.length != 0){
        equalService = false;
        equalBusiness = false;
      }
    }
    if(equalService || equalBusiness){
      tmpDismiss = DismissDirection.none;
    }else{
      tmpDismiss = DismissDirection.endToStart;
    }

    return tmpDismiss;
  }

  String address = '';
  double distance;

  double calculateDistance(BusinessState businessState){
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
    if(businessState.coordinate != null && businessState.coordinate.isNotEmpty){
      List<String> latLng1 = businessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('W_add_external_business_list_item => $businessState.name} | Cordinates 1: $latLng1');
      if(latLng1.length == 2){
        lat1 = double.parse(latLng1[0]);
        lon1 = double.parse(latLng1[1]);
      }
    }
    if(widget.externalBusinessState.coordinate != null && widget.externalBusinessState.coordinate.isNotEmpty){
      List<String> latLng2 = widget.externalBusinessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('W_add_external_business_list_item => ${widget.externalBusinessState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    double tmp = (12742 * asin(sqrt(a)));
    debugPrint('W_add_external_business_list_item => Distance: $tmp');

    return  tmp;
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        store.state.serviceList.serviceListState.clear();
        if(!widget.fromMyList){
          debugPrint('UI_U_external_business_details => Business coordinate: ${widget.externalBusinessState.coordinate}');
          debugPrint('UI_U_external_business_details => Business id: ${widget.externalBusinessState.id_firestore}');
          //store.state.serviceList.serviceListState.clear();
          store.dispatch(ServiceListRequest(widget.externalBusinessState.id_firestore, 'user'));
          if(widget.externalBusinessState.coordinate != null && widget.externalBusinessState.coordinate.isNotEmpty){
            convertCoordinateString(widget.externalBusinessState.coordinate);
          }
        }
        else{
          store.state.externalBusiness = ExternalBusinessState().toEmpty();
          debugPrint('UI:M_external_business_details => Request Business for: ${widget.externalBusinessState.id_firestore}');
          store.dispatch(ExternalBusinessRequest(widget.externalBusinessState.id_firestore));
          //store.state.serviceList.serviceListState.clear();
          List<String> serviceIds = [];
           store.state.externalServiceImportedListState.externalServiceImported.forEach((eSI) {
            if(eSI.externalBusinessId == widget.externalBusinessState.id_firestore && eSI.imported == true){
              if(!serviceIds.contains(eSI.externalServiceId))
                serviceIds.add(eSI.externalServiceId);
            }
          });
          store.state.externalBusinessImportedListState.externalBusinessImported.forEach((eBI) {
            store.state.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSL) {
              if(sLSL.businessId == eBI.externalBusinessId && eBI.externalBusinessId == widget.externalBusinessState.id_firestore && sLSL.businessId == widget.externalBusinessState.id_firestore && eBI.imported == true){
                sLSL.businessSnippet.forEach((bS) {
                    bS.serviceList.forEach((sL) {
                      serviceIds.forEach((element) {
                        if(sL.serviceAbsolutePath.split('/').last == element)
                          if(!serviceIds.contains(sL.serviceAbsolutePath.split('/').last))
                            serviceIds.add(sL.serviceAbsolutePath.split('/').last);
                      });
                    });
                });
              }
            });

          });
          /*store.state.serviceListSnippetState.businessSnippet.forEach((bS) {
            if(bS.categoryAbsolutePath.split('/').first == widget.externalBusinessState.id_firestore){
              bS.serviceList.forEach((sL) {
                serviceIds.add(sL.serviceAbsolutePath.split('/').last);
              });
            }
          });*/
          debugPrint('UI_M_external_business_details => SERVICE IDS: ${serviceIds}');
          store.dispatch(ServiceListRequestByIds(serviceIds));
        }
        startRequest = true;
      },
      builder: (context, snapshot) {
        distance = calculateDistance(snapshot.business);
        if(widget.externalBusinessState.businessAddress != null && widget.externalBusinessState.businessAddress.isNotEmpty)
          address = widget.externalBusinessState.businessAddress;
        else
          address = widget.externalBusinessState.email != null ?
          widget.externalBusinessState.street + ', ' + widget.externalBusinessState.street_number + ', ' + widget.externalBusinessState.ZIP + ', ' + widget.externalBusinessState.state_province :
          '...';
        popularServiceList.clear();
        allServiceList.clear();
        List<ServiceState> tmpServiceList = snapshot.serviceList.serviceListState;
        if(!widget.fromMyList){
          if(tmpServiceList.isEmpty && startRequest){
            noActivity = true;
          }else{
            if(tmpServiceList.isNotEmpty && tmpServiceList.first.businessId == null)
              tmpServiceList.removeLast();
            else{
              popularServiceList.addAll(snapshot.serviceList.serviceListState);
              allServiceList.addAll(snapshot.serviceList.serviceListState);
              removeCrossSellServices(popularServiceList);
              removeCrossSellServices(allServiceList);
            }
            noActivity = false;
            startRequest = false;
          }
        }else{
          if(snapshot.externalBusiness.id_firestore.isEmpty && tmpServiceList.isEmpty && startRequest){
            debugPrint('UI:M_external_business_details => Requesting: ${snapshot.externalBusiness.id_firestore}');
            noActivity = true;
          }else{
            if(snapshot.externalBusiness != null && snapshot.externalBusiness.id_firestore != null && snapshot.externalBusiness.id_firestore.isNotEmpty){
              debugPrint('UI:M_external_business_details => Business from request: ${snapshot.externalBusiness.id_firestore}');
              widget.externalBusinessState = snapshot.externalBusiness;
            }

            if(tmpServiceList.isNotEmpty && tmpServiceList.first.businessId == null)
              tmpServiceList.removeLast();
            else{
              allServiceList.addAll(snapshot.serviceList.serviceListState);
            }

            if(widget.externalBusinessState.email != null && allServiceList.isNotEmpty){
              noActivity = false;
              startRequest = false;
            }
          }
        }

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
        /*snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((element) {
          if(element.businessId == widget.externalBusinessState.id_firestore){
            element.businessSnippet.forEach((bS) {
              bS.serviceList.forEach((sL) {
                //if(sL.serviceVisibility != 'Invisible')
                  count++;
              });
            });
          }
        });*/
        snapshot.serviceList.serviceListState.forEach((sLS) {
          if(sLS.visibility != 'Invisible')
            count++;
        });
        debugPrint('Count: $count | tmp: ${tmp.length}');
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

        return  GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: BuytimeAppbar(
                background: BuytimeTheme.ManagerPrimary,
                width: media.width,
                children: [
                  ///Back Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          tooltip: AppLocalizations.of(context).comeBack,
                          onPressed: () {
                            if(widget.fromMyList && !widget.fromMyBusiness){
                              StoreProvider.of<AppState>(context).dispatch(ExternalServiceImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                              StoreProvider.of<AppState>(context).dispatch(ExternalBusinessImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                              Navigator.pushReplacement(context, EnterExitRoute(enterPage: ExternalServiceList(), exitPage: AddExternalServiceList(false), from: false));
                            }else if(!widget.fromMyList && widget.fromMyBusiness){
                              StoreProvider.of<AppState>(context).dispatch(ExternalServiceImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                              StoreProvider.of<AppState>(context).dispatch(ExternalBusinessImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                              Navigator.pushReplacement(context, EnterExitRoute(enterPage: ExternalBusinessDetails(widget.externalBusinessState, true, false), exitPage: AddExternalServiceList(false), from: false));
                            }else
                              Navigator.of(context).pop();
                          },
                        ),
                      ),

                    ],
                  ),
                  ///Title
                  Utils.barTitle(widget.externalBusinessState.name ?? 'Test'),
                  SizedBox(
                    width: 50,
                  )
                ],
              ),
              floatingActionButton: !widget.fromMyList ?
              Container(
                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                  width: 272, ///media.width * .4
                  height: 44,
                  child: MaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed: !equalService && !equalBusiness ? () {
                      ExternalBusinessImportedState eBIS = ExternalBusinessImportedState();
                      eBIS.internalBusinessId = snapshot.business.id_firestore;
                      eBIS.internalBusinessName = snapshot.business.name;
                      eBIS.externalBusinessId = widget.externalBusinessState.id_firestore;
                      eBIS.externalBusinessName = widget.externalBusinessState.name;
                      eBIS.importTimestamp = DateTime.now();
                      eBIS.imported = true;
                      StoreProvider.of<AppState>(context).dispatch(CreateExternalBusinessImported(eBIS));
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
              ) : Container(),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      //minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Image
                        noActivity ?
                          Container(
                          margin: EdgeInsets.only(top: 0),
                          //color: BuytimeTheme.ManagerPrimary.withOpacity(0.1),
                          height: 275,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                            ],
                          ),
                        ):
                        CachedNetworkImage(
                          imageUrl:  version1000(widget.externalBusinessState.wide),
                          imageBuilder: (context, imageProvider) => Container(
                            //margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                            //width: double.infinity,
                            //height: double.infinity,
                            //width: 200, ///SizeConfig.safeBlockVertical * widget.width
                            height: 275, ///SizeConfig.safeBlockVertical * widget.width
                            decoration: BoxDecoration(
                                color: BuytimeTheme.BackgroundWhite,
                                //borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                            child: Container(
                              //width: 375,
                              height: 375,
                              decoration: BoxDecoration(
                                //borderRadius: BorderRadius.all(Radius.circular(5)),
                                //color: Colors.black.withOpacity(.2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Service name
                                  Container(
                                    //width: 200,
                                    height: 100/3,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          BuytimeTheme.BackgroundBlack.withOpacity(0.5),
                                        ],
                                        begin : Alignment.topCenter,
                                        end : Alignment.bottomCenter,
                                        stops: [0.0, 5.0],
                                        //tileMode: TileMode.
                                      ),
                                    ),
                                    //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, bottom: SizeConfig.safeBlockVertical * 2),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              widget.externalBusinessState.name ?? 'test',
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextWhite,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            // width: 200, ///SizeConfig.safeBlockVertical * widget.width
                            height: 100, ///SizeConfig.safeBlockVertical * widget.width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator()
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ///Address & Map
                        noActivity ?
                        Container(
                          height: 100,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                            ],
                          ),
                        ):
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                height: 125,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///Address
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///Address text
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.of(context).address.toUpperCase(),
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextMedium,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                              ),
                                            ),
                                          ),
                                        ),
                                        ///Address value
                                        Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    address,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        letterSpacing: 0.15,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextBlack,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                    ///Hour text
                                    /*Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          AppLocalizations.of(context).hours.toUpperCase(),
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextMedium,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10 ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      ),
                                    ),*/
                                    ///Open until value
                                    /*Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          //AppLocalizations.of(context).openUntil + ' ...',
                                          '',
                                          style: TextStyle(
                                              letterSpacing: 0.15,
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextBlack,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      ),
                                    ),*/
                                    ///Directions
                                    Container(
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_pin,
                                            size: 14,
                                            color: BuytimeTheme.SymbolGrey,
                                          ),
                                          ///Min
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * .5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                distance.toString().split('.').first.startsWith('0') ? distance.toString().split('.').last.substring(0,3) + ' m' : distance.toStringAsFixed(1) + ' Km',
                                                style: TextStyle(
                                                    letterSpacing: 0.25,
                                                    fontFamily: BuytimeTheme.FontFamily,
                                                    color: BuytimeTheme.TextMedium,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),
                                          ///Directions
                                          Container(
                                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                              alignment: Alignment.center,
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => BuytimeMap(user: false, title: widget.externalBusinessState.name,
                                                          businessState: BusinessState.fromExternalState(widget.externalBusinessState),
                                                          serviceState: ServiceState().toEmpty(),
                                                        )
                                                        ),
                                                      );
                                                    },
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    child: Container(
                                                      padding: EdgeInsets.all(5.0),
                                                      child: Text(
                                                        AppLocalizations.of(context).directions,
                                                        style: TextStyle(
                                                            letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                            fontFamily: BuytimeTheme.FontFamily,
                                                            color: BuytimeTheme.UserPrimary,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 14

                                                          ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                      ),
                                                    )),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ///Map
                            Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: (){
                                  String address = widget.externalBusinessState.name;
                                  //Utils.openMap(lat, lng);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: widget.orderState.itemList.length > 1 ? widget.orderState.business.name : widget.orderState.itemList.first.name, businessState: snapshot.business,)),);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: false, title: address,
                                    businessState: BusinessState.fromExternalState(widget.externalBusinessState),
                                    serviceState: ServiceState().toEmpty(),
                                  )),);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                },
                                child: Container(
                                  width: 174,
                                  height: 125,
                                  //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                  child: CachedNetworkImage(
                                    imageUrl:  getShopLocationImage(widget.externalBusinessState.coordinate, address),
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                          color: BuytimeTheme.BackgroundWhite,
                                          //borderRadius: BorderRadius.all(Radius.circular(5)),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              BuytimeTheme.BackgroundWhite,
                                              BuytimeTheme.BackgroundWhite.withOpacity(0.1),
                                            ],
                                            begin : Alignment.centerLeft,
                                            end : Alignment.centerRight,
                                            //tileMode: TileMode.
                                          ),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      // width: 200, ///SizeConfig.safeBlockVertical * widget.width
                                      height: 100, ///SizeConfig.safeBlockVertical * widget.width
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator()
                                        ],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ///Divider
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                          height: 15,
                          color: BuytimeTheme.DividerGrey,
                        ),
                        widget.fromMyList ?
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///All service
                                Flexible(
                                  ///Popular service
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///View business
                                        Container(
                                            margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ///View business
                                                InkWell(
                                                  onTap: () {
                                                    StoreProvider.of<AppState>(context).dispatch(ExternalServiceImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                                                    StoreProvider.of<AppState>(context).dispatch(ExternalBusinessImportedListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore));
                                                    Navigator.push(context, EnterExitRoute(enterPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), exitPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), from: true));
                                                  },
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  child: Container(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Text(
                                                      AppLocalizations.of(context).viewBusiness.toUpperCase(),
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        ///List
                                        allServiceList.isNotEmpty ?
                                        Column(
                                          children: allServiceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < allServiceList.length; i++) {
                                              if (allServiceList[i].serviceId == service.serviceId) index = i;
                                            }
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
                                                  allServiceList.removeAt(index);
                                                  snapshot.serviceList.serviceListState.removeAt(index);
                                                });
                                                if (direction == DismissDirection.endToStart) {

                                                  debugPrint('UI_U_external_service_list => DX to DELETE');
                                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                  cancelExternalService(snapshot.business, service.serviceId, snapshot.serviceListSnippetListState.serviceListSnippetListState);
                                                  /*Scaffold.of(context).showSnackBar(SnackBar(
                                                      content: Text(AppLocalizations.of(context).spaceRemoved),
                                                      action: SnackBarAction(
                                                          label: AppLocalizations.of(context).undo,
                                                          onPressed: () {
                                                            //To undo deletion
                                                            undoAllDeletion(index, service);
                                                          })));*/
                                                } else {
                                                  allServiceList.insert(index, service);
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  ExternalServiceItem(service, true, allServiceList, AppLocalizations.of(context).allService, widget.externalBusinessState),
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
                                          }).toList(),
                                        ) : noActivity ?
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        ) :
                                        ///No List
                                        Container(
                                          height: SizeConfig.safeBlockVertical * 8,
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ) :
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Popular service
                                Flexible(
                                  ///Popular service
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///Popular service
                                        Container(
                                            margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    AppLocalizations.of(context).popularService,
                                                    style: TextStyle(
                                                      color: BuytimeTheme.TextBlack,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                ///Show all
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(popularServiceList, AppLocalizations.of(context).popularService, widget.externalBusinessState), exitPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), from: true));
                                                  },
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  child: Container(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Text(
                                                      AppLocalizations.of(context).showAll,
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        ///List
                                        popularServiceList.isNotEmpty ?
                                        ///Service List
                                        popularServiceList.length >= 6 ?
                                        Column(
                                          children: popularServiceList.sublist(0, 6)
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < popularServiceList.length; i++) {
                                              if (popularServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            DismissDirection tmpDismiss;
                                            tmpDismiss = getDismiss(StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported, StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported, service);
                                            return Column(
                                              children: [
                                                Dismissible(
                                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                                  // uniquely identify widgets.
                                                  key: UniqueKey(),
                                                  // Provide a function that tells the app
                                                  // what to do after an item has been swiped away.
                                                  direction: tmpDismiss,
                                                  onDismissed: (direction) {
                                                    // Remove the item from the data source.
                                                    setState(() {
                                                      popularServiceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_external_business_details => SX to BOOK');
                                                    createExternalService(snapshot.business, service.serviceId, snapshot.serviceListSnippetListState.serviceListSnippetListState);
                                                    undoPopularDeletion(index, service);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ExternalServiceItem(service, true, popularServiceList, AppLocalizations.of(context).popularService, widget.externalBusinessState),
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
                                                ),
                                                /*Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                                  height: SizeConfig.safeBlockVertical * .2,
                                                  color: BuytimeTheme.DividerGrey,
                                                )*/
                                              ],
                                            );
                                          }).toList(),
                                        ) :
                                        Column(
                                          children: popularServiceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < popularServiceList.length; i++) {
                                              if (popularServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            DismissDirection tmpDismiss;
                                            tmpDismiss = getDismiss(StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported, StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported, service);
                                            return Column(
                                              children: [
                                                Dismissible(
                                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                                  // uniquely identify widgets.
                                                  key: UniqueKey(),
                                                  // Provide a function that tells the app
                                                  // what to do after an item has been swiped away.
                                                  direction: tmpDismiss,
                                                  onDismissed: (direction) {
                                                    // Remove the item from the data source.
                                                    setState(() {
                                                      popularServiceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_external_business_details => SX to BOOK');
                                                    createExternalService(snapshot.business, service.serviceId, snapshot.serviceListSnippetListState.serviceListSnippetListState);
                                                    undoPopularDeletion(index, service);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ExternalServiceItem(service, true, popularServiceList, AppLocalizations.of(context).popularService, widget.externalBusinessState),
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
                                                ),
                                                /*Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                                  height: SizeConfig.safeBlockVertical * .2,
                                                  color: BuytimeTheme.DividerGrey,
                                                )*/
                                              ],
                                            );
                                          }).toList(),
                                        ) : noActivity ?
                                        Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        ) :
                                        ///No List
                                        Container(
                                          height: SizeConfig.safeBlockVertical * 8,
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                        )
                                      ],
                                    ),
                                  ),
                                ) ,
                                ///Divider
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                  height: 15,
                                  color: BuytimeTheme.DividerGrey,
                                ),
                                ///All service
                                Flexible(
                                  ///Popular service
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///All service
                                        Container(
                                            margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    AppLocalizations.of(context).allService,
                                                    style: TextStyle(
                                                      color: BuytimeTheme.TextBlack,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),

                                                ///Show all
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(allServiceList, AppLocalizations.of(context).allService, widget.externalBusinessState), exitPage: ExternalBusinessDetails(widget.externalBusinessState, false, true), from: true));
                                                  },
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  child: Container(
                                                    padding: EdgeInsets.all(5.0),
                                                    child: Text(
                                                      AppLocalizations.of(context).showAll,
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: BuytimeTheme.FontFamily, fontSize: 14, color: BuytimeTheme.ManagerPrimary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        ///List
                                        allServiceList.isNotEmpty ?
                                        ///Service List
                                        allServiceList.length >= 6 ?
                                        Column(
                                          children: allServiceList.sublist(0, 6)
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < allServiceList.length; i++) {
                                              if (allServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            DismissDirection tmpDismiss;
                                            tmpDismiss = getDismiss(StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported, StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported, service);
                                            return Column(
                                              children: [
                                                Dismissible(
                                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                                  // uniquely identify widgets.
                                                  key: UniqueKey(),
                                                  // Provide a function that tells the app
                                                  // what to do after an item has been swiped away.
                                                  direction: tmpDismiss,
                                                  onDismissed: (direction) {
                                                    // Remove the item from the data source.
                                                    setState(() {
                                                      allServiceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');
                                                    createExternalService(snapshot.business, service.serviceId, snapshot.serviceListSnippetListState.serviceListSnippetListState);
                                                    undoAllDeletion(index, service);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ExternalServiceItem(service, true, allServiceList, AppLocalizations.of(context).allService, widget.externalBusinessState),
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
                                                ),
                                                /*Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                                  height: SizeConfig.safeBlockVertical * .2,
                                                  color: BuytimeTheme.DividerGrey,
                                                )*/
                                              ],
                                            );
                                          }).toList(),
                                        ) :
                                        Column(
                                          children: allServiceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < allServiceList.length; i++) {
                                              if (allServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            DismissDirection tmpDismiss;
                                            tmpDismiss = getDismiss(StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported, StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported, service);
                                            return Column(
                                              children: [
                                                Dismissible(
                                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                                  // uniquely identify widgets.
                                                  key: UniqueKey(),
                                                  // Provide a function that tells the app
                                                  // what to do after an item has been swiped away.
                                                  direction: tmpDismiss,
                                                  onDismissed: (direction) {
                                                    // Remove the item from the data source.
                                                    setState(() {
                                                      allServiceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');
                                                    createExternalService(snapshot.business, service.serviceId, snapshot.serviceListSnippetListState.serviceListSnippetListState);
                                                    undoAllDeletion(index, service);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      ExternalServiceItem(service, true, allServiceList, AppLocalizations.of(context).allService, widget.externalBusinessState),
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
                                                ),
                                                /*Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                                  height: SizeConfig.safeBlockVertical * .2,
                                                  color: BuytimeTheme.DividerGrey,
                                                )*/
                                              ],
                                            );
                                          }).toList(),
                                        ) : noActivity ?
                                        Container(
                                          margin: EdgeInsets.only(top: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              CircularProgressIndicator()
                                            ],
                                          ),
                                        ) :
                                        ///No List
                                        Container(
                                          height: SizeConfig.safeBlockVertical * 8,
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                      ],
                    ),
                  ),
                ),
              ),
              /* )*/
            ),
          ),
        );
      },
    );
  }

  List<double> convertCoordinateString(String coordinates) {
    List<String> latLng = coordinates.replaceAll(' ', '').split(',');
    if(latLng.length == 2){
      lat = double.parse(latLng[0]);
      lng = double.parse(latLng[1]);
    }
    return [lat, lng];
  }

  void removeCrossSellServices(List<ServiceState> popularServiceList) {
    for (int i = 0; i < popularServiceList.length; i++) {
      if (!popularServiceList[i].serviceCrossSell) {
        popularServiceList.remove(popularServiceList[i]);
      }
    }
  }
}
