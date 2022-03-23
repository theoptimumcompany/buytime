import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_p_a_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_service_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/external_service_imported_state.dart';
import 'package:Buytime/reblox/reducer/external_service_imported_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/animation/enterExitRoute.dart';
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


class ExternalServiceDetails extends StatefulWidget {
  final ServiceState serviceState;
  final ExternalBusinessState externalBusinessState;
  //bool fromMy;
  static String route = '/externalServiceDetails';
  ExternalServiceDetails(this.serviceState, this.externalBusinessState);

  @override
  createState() => _ExternalServiceDetailsState();

}

class _ExternalServiceDetailsState extends State<ExternalServiceDetails> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
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

  List<double> convertCoordinateString(String coordinates) {
    double lat = 0;
    double lng = 0;
    List<String> latLng = coordinates.replaceAll(' ', '').split(',');
    if(latLng.length == 2){
      lat = double.parse(latLng[0]);
      lng = double.parse(latLng[1]);
    }
    return [lat, lng];
  }

  String address = '';
  double distance;

  ///TODO: Non funziona calcolo distanza nel modo giusto
  double calculateDistance(BusinessState businessState){
    double lat1 = 0.0;
    double lon1 = 0.0;
    double lat2 = 0.0;
    double lon2 = 0.0;
    if(businessState.coordinate != null && businessState.coordinate.isNotEmpty){
      List<String> latLng1 = businessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('UI_M_external_service_details => $businessState.name} | Cordinates 1: $latLng1');
      if(latLng1.length == 2){
        lat1 = double.parse(latLng1[0]);
        lon1 = double.parse(latLng1[1]);
      }
    }
    if(widget.serviceState.serviceCoordinates != null && widget.serviceState.serviceCoordinates.isNotEmpty){
      List<String> latLng2 = widget.serviceState.serviceCoordinates.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('UI_M_external_service_details => ${widget.serviceState.name} | Cordinates 2: $latLng2');
      if(latLng2.length == 2){
        lat2 = double.parse(latLng2[0]);
        lon2 = double.parse(latLng2[1]);
      }
    }else if(widget.externalBusinessState.coordinate != null && widget.externalBusinessState.coordinate.isNotEmpty){
      List<String> latLng2 = widget.externalBusinessState.coordinate.replaceAll('(', '').replaceAll(')', '').replaceAll(' ', '').split(',');
      debugPrint('UI_M_external_service_details => ${widget.externalBusinessState.name} | Cordinates 2: $latLng2');
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
    debugPrint('UI_M_external_service_details => Distance: $tmp');

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
        if(widget.serviceState.serviceAddress != null && widget.serviceState.serviceAddress.isNotEmpty)
          address = widget.serviceState.serviceAddress;
        else if(widget.serviceState.serviceBusinessAddress != null && widget.serviceState.serviceBusinessAddress.isNotEmpty)
          address = widget.serviceState.serviceBusinessAddress;
        else if(widget.externalBusinessState.businessAddress != null && widget.externalBusinessState.businessAddress.isNotEmpty)
          address = widget.externalBusinessState.businessAddress;
        else
          address = widget.externalBusinessState.street + ', ' + widget.externalBusinessState.street_number + ', ' + widget.externalBusinessState.ZIP + ', ' + widget.externalBusinessState.state_province;
        debugPrint('UI_M_external_service_details => ADDRESS: $address');
        },
      builder: (context, snapshot) {
        distance = calculateDistance(snapshot.business);
        bool equalService = false;
        bool equalBusiness = false;
        StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
          if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
            equalService = true;
          }
        });
        StoreProvider.of<AppState>(context).state.externalBusinessImportedListState.externalBusinessImported.forEach((element) {
          if(element.externalBusinessId == widget.serviceState.businessId && element.imported == true){
            equalBusiness = true;
          }
        });
        if(equalBusiness){
          debugPrint('UI_M_external_service_details => ${ widget.serviceState.name} | if | business true');
          StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
            if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
              debugPrint('${ widget.serviceState.name} | if | business true | service true');
              equalService = true;
            }
            if(element.externalServiceId == widget.serviceState.serviceId && element.imported == false){
              debugPrint('UI_M_external_service_details => ${ widget.serviceState.name} | if | business true | service false');
              equalService = false;
              equalBusiness = false;
            }
          });
          bool found = false;
          StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.forEach((element) {
            if(element.externalServiceId == widget.serviceState.serviceId && element.imported == true){
              found = true;
            }
          });

          if(!found && StoreProvider.of<AppState>(context).state.externalServiceImportedListState.externalServiceImported.length != 0){
            equalService = false;
            equalBusiness = false;
          }
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
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                  ///Title
                  Utils.barTitle(widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : 'test'),
                  SizedBox(
                    width: 56,
                  )
                ],
              ),
              /*floatingActionButton: Container(
                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5, bottom: SizeConfig.safeBlockVertical *4),
                  width: 272, ///media.width * .4
                  height: 44,
                  child: MaterialButton(
                    elevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    highlightElevation: 0,
                    onPressed: () {

                    },
                    textColor: BuytimeTheme.BackgroundWhite.withOpacity(0.3),
                    color:  BuytimeTheme.ActionButton,
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
                          AppLocalizations.of(context).addToYourNetwork.toUpperCase(),
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
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,*/
              body: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    //minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        //height: SizeConfig.safeBlockVertical * 81,
                        child: ListView(
                          children: [
                            ///Image
                            CachedNetworkImage(
                              imageUrl:  version1000(widget.serviceState.image1),
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
                                                  widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : 'test',
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
                              placeholder: (context, url) => Utils.imageShimmer(double.infinity, 275),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                            ///Address & Map
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
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
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
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    distance.toString().split('.').first.startsWith('0') && distance.toString().split('.').first.length != 1?
                                                    distance.toString().split('.').last.substring(0,3) + ' m' :
                                                    distance.toStringAsFixed(1) + ' Km',
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
                                                              serviceState: widget.serviceState,
                                                              tourist: false,
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
                                  )
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
                                        serviceState: widget.serviceState,
                                        tourist: false,
                                      )),);
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                    },
                                    child: Container(
                                      width: 174,
                                      height: 125,
                                      //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:  getShopLocationImage(
                                            widget.serviceState.serviceCoordinates != null && widget.serviceState.serviceCoordinates.isNotEmpty ?
                                                widget.serviceState.serviceCoordinates : widget.externalBusinessState.coordinate,
                                        address),
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
                                        placeholder: (context, url) => Utils.imageShimmer(174, 125),
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
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               ///Amount
                               Container(
                                 margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                 child: Text(
                                   '${AppLocalizations.of(context).startingFromCurrency} ${widget.serviceState.price}',
                                   style: TextStyle(
                                       fontFamily: BuytimeTheme.FontFamily,
                                       color: BuytimeTheme.ManagerPrimary,
                                       fontWeight: FontWeight.w400,
                                       fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                   ),
                                 ),
                               ),
                               ///Description
                               Flexible(
                                 child: Container(
                                   width: double.infinity,
                                   margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * 2),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       /*Container(
                                         margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
                                         child: Text(
                                           AppLocalizations.of(context).serviceDescription,
                                           style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w600, fontSize: 18

                                             ///SizeConfig.safeBlockHorizontal * 5
                                           ),
                                         ),
                                       ),*/
                                       Container(
                                         margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                                         child: Text(
                                           widget.serviceState.description.isNotEmpty ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.description) : AppLocalizations.of(context).loreIpsum,
                                           style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16

                                             ///SizeConfig.safeBlockHorizontal * 4
                                           ),
                                         ),
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
                              ExternalServiceImportedState eSIS = ExternalServiceImportedState();
                              eSIS.internalBusinessId = snapshot.business.id_firestore;
                              eSIS.internalBusinessName = snapshot.business.name;
                              eSIS.externalBusinessId = widget.externalBusinessState.id_firestore;
                              eSIS.externalBusinessName = widget.externalBusinessState.name;
                              eSIS.externalServiceId = widget.serviceState.serviceId;
                              eSIS.importTimestamp = DateTime.now();
                              eSIS.imported = true;
                              snapshot.serviceListSnippetListState.serviceListSnippetListState.forEach((sLSL) {
                                sLSL.businessSnippet.forEach((bS) {
                                  bS.serviceList.forEach((sL) {
                                    if(sL.serviceAbsolutePath.split('/').last == widget.serviceState.serviceId){
                                      eSIS.externalCategoryName = bS.categoryName;
                                    }
                                  });
                                });
                              });
                              StoreProvider.of<AppState>(context).dispatch(CreateExternalServiceImported(eSIS));
                              Flushbar(
                                padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                                margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2, left: SizeConfig.blockSizeHorizontal * 20, right: SizeConfig.blockSizeHorizontal * 20), ///2% - 20% - 20%
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                backgroundColor: BuytimeTheme.SymbolGrey,
                                boxShadows: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    offset: Offset(3, 3),
                                    blurRadius: 3,
                                  ),
                                ],
                                // All of the previous Flushbars could be dismissed by swiping down
                                // now we want to swipe to the sides
                                //dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                                // The default curve is Curves.easeOut
                                duration:  Duration(seconds: 2),
                                forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
                                messageText: Text(
                                  AppLocalizations.of(context).externalServiceAdded,
                                  style: TextStyle(
                                      color: BuytimeTheme.TextWhite,
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )..show(context);
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
                      )
                    ],
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
}
