import 'dart:async';
import 'dart:io';
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
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
import 'package:Buytime/utils/theme/buytime_config.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';


class ExternalBusinessDetails extends StatefulWidget {
  final ExternalBusinessState externalBusinessState;
  bool fromMy;
  static String route = '/externalServiceDetails';
  ExternalBusinessDetails({@required this.externalBusinessState, this.fromMy});

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
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
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

  String getShopLocationImage(String coordinates){
    String url;
    if(Platform.isIOS)
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${BuytimeConfig.AndroidApiKey}';
    else
      url = 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=18&size=640x640&scale=2&markers=color:red|$lat,$lng&key=${BuytimeConfig.AndroidApiKey}';

    return url;
  }

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
        if(widget.externalBusinessState.id_firestore != null){
          debugPrint('UI_U_external_business_details => Business coordinate: ${widget.externalBusinessState.coordinate}');
          debugPrint('UI_U_external_business_details => Business id: ${widget.externalBusinessState.id_firestore}');
          store.state.serviceList.serviceListState.clear();
          store.dispatch(ServiceListRequest(widget.externalBusinessState.id_firestore, 'user'));
          if(widget.externalBusinessState.coordinate.isNotEmpty){
            List<String> latLng = widget.externalBusinessState.coordinate.split(', ');
            if(latLng.length == 2){
              lat = double.parse(latLng[0]);
              lng = double.parse(latLng[1]);
            }
          }
          startRequest = true;
        }
      },
      builder: (context, snapshot) {
        popularServiceList.clear();
        allServiceList.clear();
        List<ServiceState> tmpServiceList = snapshot.serviceList.serviceListState;
        if(tmpServiceList.isEmpty && startRequest){
          noActivity = true;
        }else{
          if(tmpServiceList.isNotEmpty && tmpServiceList.first.businessId == null)
            tmpServiceList.removeLast();
          else{
            popularServiceList.addAll(snapshot.serviceList.serviceListState);
            allServiceList.addAll(snapshot.serviceList.serviceListState);
          }
          noActivity = false;
          startRequest = false;
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
                            Navigator.of(context).pop();
                          },
                        ),
                      ),

                    ],
                  ),
                  ///Title
                  Utils.barTitle(widget.externalBusinessState.name ?? 'Test'),
                  SizedBox(
                    width: 56,
                  )
                ],
              ),
              floatingActionButton: !widget.fromMy ?
              Container(
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
                                        color: Colors.black.withOpacity(.4)
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Address text
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.externalBusinessState.id_firestore != null ?
                                        widget.externalBusinessState.street + ', ' + widget.externalBusinessState.street_number + ', ' + widget.externalBusinessState.ZIP + ', ' + widget.externalBusinessState.state_province :
                                        'Test',
                                        style: TextStyle(
                                            letterSpacing: 0.15,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ),
                                  ///Hour text
                                  Container(
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
                                  ),
                                  ///Open until value
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        AppLocalizations.of(context).openUntil + ' ...',
                                        style: TextStyle(
                                            letterSpacing: 0.15,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    ),
                                  ),
                                  ///Directions
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.directions_walk,
                                          size: 14,
                                          color: BuytimeTheme.SymbolGrey,
                                        ),
                                        ///Min
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '? ' + AppLocalizations.of(context).min,
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
                                                      MaterialPageRoute(builder: (context) => BuytimeMap(user: false, title: widget.externalBusinessState.name, businessState: BusinessState.fromExternalState(widget.externalBusinessState),)),
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
                            ///Map
                            Flexible(
                              flex: 2,
                              child: InkWell(
                                onTap: (){
                                  String address = widget.externalBusinessState.name;
                                  //Utils.openMap(lat, lng);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: true, title: widget.orderState.itemList.length > 1 ? widget.orderState.business.name : widget.orderState.itemList.first.name, businessState: snapshot.business,)),);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BuytimeMap(user: false, title: address, businessState: BusinessState.fromExternalState(widget.externalBusinessState),)),);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedScreen()));
                                },
                                child: Container(
                                  width: 174,
                                  height: 169,
                                  //margin: EdgeInsets.only(left:10.0, right: 10.0),
                                  child: CachedNetworkImage(
                                    imageUrl:  getShopLocationImage(snapshot.business.coordinate),
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
                        widget.fromMy ?
                            Column(
                              children: [
                                ///Add new
                                Container(
                                    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 10.0, bottom: SizeConfig.safeBlockVertical * 1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ///View business
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, EnterExitRoute(enterPage: ExternalBusinessDetails(externalBusinessState: widget.externalBusinessState, fromMy: false,), exitPage: ExternalBusinessDetails(externalBusinessState: widget.externalBusinessState, fromMy: true,), from: true));
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
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(popularServiceList, AppLocalizations.of(context).popularService), exitPage: ExternalBusinessDetails(externalBusinessState: widget.externalBusinessState, fromMy: widget.fromMy,), from: true));
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
                                        Column(
                                          children: popularServiceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < popularServiceList.length; i++) {
                                              if (popularServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            return Column(
                                              children: [
                                                Dismissible(
                                                  // Each Dismissible must contain a Key. Keys allow Flutter to
                                                  // uniquely identify widgets.
                                                  key: UniqueKey(),
                                                  // Provide a function that tells the app
                                                  // what to do after an item has been swiped away.
                                                  direction: DismissDirection.endToStart,
                                                  onDismissed: (direction) {
                                                    // Remove the item from the data source.
                                                    setState(() {
                                                      popularServiceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');

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
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(allServiceList, AppLocalizations.of(context).allService), exitPage: ExternalBusinessDetails(externalBusinessState: widget.externalBusinessState, fromMy: widget.fromMy,), from: true));
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
                                        Column(
                                          children: allServiceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < allServiceList.length; i++) {
                                              if (allServiceList[i].serviceId == service.serviceId) index = i;
                                            }
                                            return Column(
                                              children: [
                                                Dismissible(
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
                                                    });
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');

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
}
