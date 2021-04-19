import 'dart:async';
import 'package:Buytime/UI/management/service_external/UI_M_external_service_list.dart';
import 'package:Buytime/UI/management/service_external/UI_M_p_a_service_list.dart';
import 'package:Buytime/UI/management/service_external/widget/W_external_service_item.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/cart/UI_U_ConfirmOrder.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/enterExitRoute.dart';
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
  final BusinessState businessState;
  bool fromMy;
  static String route = '/externalServiceDetails';
  ExternalBusinessDetails({@required this.businessState, this.fromMy});

  @override
  createState() => _ExternalBusinessDetailsState();

}

class _ExternalBusinessDetailsState extends State<ExternalBusinessDetails> with SingleTickerProviderStateMixin {

  List<ServiceState> popularServiceList = [];
  List<ServiceState> allServiceList = [];

  ServiceState tmpService = ServiceState();

  @override
  void initState() {
    super.initState();
    popularServiceList.add(tmpService);
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

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;

    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store){
      },
      builder: (context, snapshot) {

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
                  Utils.barTitle('test'),
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
                          imageUrl:  version1000(widget.businessState.wide),
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
                                              widget.businessState.name ?? 'test',
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '...',
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                            )
                          ],
                        ),
                        ///Divider
                        Container(
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
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
                                            Navigator.push(context, EnterExitRoute(enterPage: ExternalBusinessDetails(businessState: widget.businessState, fromMy: false,), exitPage: ExternalBusinessDetails(businessState: widget.businessState, fromMy: true,), from: true));
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
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(popularServiceList, AppLocalizations.of(context).popularService), exitPage: ExternalBusinessDetails(businessState: widget.businessState, fromMy: widget.fromMy,), from: true));
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
                                                      ExternalServiceItem(service, true, popularServiceList, AppLocalizations.of(context).popularService),
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
                                ),
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
                                                    Navigator.push(context, EnterExitRoute(enterPage: PAServiceList(allServiceList, AppLocalizations.of(context).allService), exitPage: ExternalBusinessDetails(businessState: widget.businessState, fromMy: widget.fromMy,), from: true));
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
                                                      ExternalServiceItem(service, true, allServiceList, AppLocalizations.of(context).allService),
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
