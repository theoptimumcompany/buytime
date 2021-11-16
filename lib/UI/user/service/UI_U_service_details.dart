import 'dart:async';
import 'dart:math';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/login/tourist_session/UI_U_tourist_session.dart';
import 'package:Buytime/reblox/model/promotion/promotion_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/UI/user/map/UI_U_map.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/navigation/navigation_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/reusable/w_green_choice.dart';
import 'package:Buytime/reusable/w_promo_discount.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceState serviceState;
  static String route = '/serviceDetails';
  bool tourist;

  ServiceDetails({@required this.serviceState, this.tourist});

  @override
  createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> with SingleTickerProviderStateMixin {
  ServiceState serviceState;
  OrderState order = OrderState().toEmpty();

  List<String> images = [];
  String price = '';

  @override
  void initState() {
    super.initState();
    serviceState = widget.serviceState;
    debugPrint('UI_U_service_details => image: ${widget.serviceState.image1}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool useOriginal = false;

  bool isExternal = false;
  ExternalBusinessState externalBusinessState = ExternalBusinessState().toEmpty();
  String address = '';
  String bussinessName = '-';
  String translatedDescription = '';

  @override
  Widget build(BuildContext context) {
    // the media containing information on width and height
    var media = MediaQuery.of(context).size;
    Locale myLocale = Localizations.localeOf(context);
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        if (widget.serviceState.serviceAddress != null && widget.serviceState.serviceAddress.isNotEmpty)
          address = widget.serviceState.serviceAddress;
        else if (widget.serviceState.serviceBusinessAddress != null && widget.serviceState.serviceBusinessAddress.isNotEmpty)
          address = widget.serviceState.serviceBusinessAddress;
        else
          address = '${AppLocalizations.of(context).noAddress}.';
        debugPrint('UI_U_service_details => ADDRESS: $address');
        store.dispatch(SetService(widget.serviceState));
        //order = store.state.order.itemList != null ? (store.state.order.itemList.length > 0 ? store.state.order : order) : order;
        if (widget.serviceState.image1.isNotEmpty) images.add(widget.serviceState.image1);
        if (widget.serviceState.image2.isNotEmpty) images.add(widget.serviceState.image2);
        if (widget.serviceState.image3.isNotEmpty) images.add(widget.serviceState.image3);

        debugPrint('UI_U_service_details => IMAGES: ${images.length}');

        if (widget.serviceState.switchSlots) {
          double tmpPrice;
          debugPrint('UI_U_service_details => SLOTS LENGTH: ${widget.serviceState.serviceSlot.length}');
          DateTime currentTime = DateTime.now();
          currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0);
          widget.serviceState.serviceSlot.forEach((element) {
            DateTime checkOut = DateFormat('dd/MM/yyyy').parse(element.checkOut);
            if (checkOut.isAtSameMomentAs(currentTime) || checkOut.isAfter(currentTime)) {
              debugPrint('UI_U_service_details => VALID: ${element.checkIn}');
              tmpPrice = element.price;
              if (element.price <= tmpPrice) {
                if (element.day != 0) {
                  debugPrint('UI_U_service_details => SLOT WITH DAYS');
                  if (element.day > 1)
                    price = AppLocalizations.of(context).startingFromCurrency + ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).days}';
                  else
                    price = AppLocalizations.of(context).startingFromCurrency + ' ${element.price.toStringAsFixed(0)} / ${element.day} ${AppLocalizations.of(context).day}';
                } else {
                  debugPrint('UI_U_service_details => SLOT WITHOUT DAYS');
                  int tmpMin = element.hour * 60 + element.minute;
                  if (tmpMin > 90)
                    price = AppLocalizations.of(context).startingFromCurrency + ' ${element.price.toStringAsFixed(0)} / ${element.hour} h ${element.minute} ${AppLocalizations.of(context).spaceMinSpace}';
                  else
                    price = AppLocalizations.of(context).startingFromCurrency + ' ${element.price.toStringAsFixed(0)} / $tmpMin ${AppLocalizations.of(context).spaceMinSpace}';
                }
              }
            }
          });
        } else {
          price = widget.serviceState.price != null
              ? '${AppLocalizations.of(context).currencySpace} ' + widget.serviceState.price.toStringAsFixed(2) /*+ AppLocalizations.of(context).slashOneUnit*/
              : AppLocalizations.of(context).currencyNoPrice + AppLocalizations.of(context).hour;
        }

        store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
          if (eBL.id_firestore == widget.serviceState.businessId) {
            isExternal = true;
            externalBusinessState = eBL;
            if (externalBusinessState.businessAddress != null && externalBusinessState.businessAddress.isNotEmpty)
              address = externalBusinessState.businessAddress;
            else
              address = externalBusinessState.street + ', ' + externalBusinessState.street_number + ', ' + externalBusinessState.ZIP + ', ' + externalBusinessState.state_province;
          }
        });

        ///Business name from booking business
        if (store.state.business.id_firestore.isNotEmpty) {
          bussinessName = store.state.business.name;
        }

        ///Business name from business list
        store.state.businessList.businessListState.forEach((element) {
          debugPrint('UI_U_service_details => BUSINESS NAME: ${element.id_firestore} VS ${widget.serviceState.businessId}');
          if (widget.serviceState.businessId == element.id_firestore) bussinessName = element.name;
        });

        ///Business name from snippet
        store.state.serviceListSnippetListState.serviceListSnippetListState.forEach((element) {
          debugPrint('UI_U_service_details => BUSINESS NAME: ${element.businessId} VS ${widget.serviceState.businessId}');
          if (widget.serviceState.businessId == element.businessId) bussinessName = element.businessName;
        });

        debugPrint('BUSINESS NAME: $bussinessName');
      },
      builder: (context, snapshot) {
        debugPrint('UI_U_service_details => SNAPSHOT CART COUNT: ${snapshot.order}');
        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_service_details => CART COUNT: ${order.cartCounter}');

        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              appBar: BuytimeAppbar(
                background: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
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
                            Future.delayed(Duration.zero, () {
                              Navigator.of(context).pop();
                            });
                            // StoreProvider.of(context).dispatch(NavigatePopAction(AppRoutes.serviceDetails));
                          },
                        ),
                      ),
                    ],
                  ),

                  ///Title
                  Flexible(
                    child: Text(
                      Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: BuytimeTheme.appbarTitle,
                    ),
                  ),

                  ///Cart
                  Container(
                    width: 50,
                    height: 50,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              key: Key('cart_key'),
                              icon: Icon(
                                BuytimeIcons.shopping_cart,
                                color: BuytimeTheme.TextWhite,
                                size: 24.0,
                              ),
                              onPressed: () {
                                if (order.cartCounter > 0) {
                                  // dispatch the order
                                  StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                  // go to the cart page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cart(
                                              tourist: widget.tourist,
                                            )),
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                            title: new Text(AppLocalizations.of(context).warning),
                                            content: new Text(AppLocalizations.of(context).emptyCart),
                                            actions: <Widget>[
                                              MaterialButton(
                                                elevation: 0,
                                                hoverElevation: 0,
                                                focusElevation: 0,
                                                highlightElevation: 0,
                                                child: Text(AppLocalizations.of(context).ok),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                }
                              },
                            ),
                          ),
                        ),
                        order.cartCounter > 0
                            ? Positioned.fill(
                                top: 5,
                                left: 2.5,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    '${order.cartCounter}',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 3,
                                      color: BuytimeTheme.TextWhite,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      //minHeight: (SizeConfig.safeBlockVertical * 100) - 60
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        //height: SizeConfig.safeBlockVertical * 81,
                        child: ListView(
                          children: [
                            ///Background Image
                            Container(
                                height: 348,
                                //width: double.infinity,
                                child: images.isNotEmpty
                                    ? Carousel(
                                        boxFit: BoxFit.cover,
                                        autoplay: false,
                                        animationCurve: Curves.bounceIn,
                                        //animationDuration: Duration(milliseconds: 1000),
                                        dotSize: images.length > 1 ? SizeConfig.blockSizeVertical * 1 : SizeConfig.blockSizeVertical * 0,

                                        ///1%
                                        dotIncreasedColor: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                        dotColor: BuytimeTheme.BackgroundWhite,
                                        dotBgColor: Colors.transparent,
                                        dotPosition: DotPosition.bottomCenter,
                                        dotVerticalPadding: 10.0,
                                        showIndicator: true,
                                        indicatorBgPadding: 7.0,

                                        ///User images
                                        images: images
                                            .map((e) => CachedNetworkImage(
                                                  imageUrl: Utils.version1000(e),
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                                    height: SizeConfig.safeBlockVertical * 55,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                                        image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )),
                                                    child: Container(
                                                      height: SizeConfig.safeBlockVertical * 55,
                                                      width: double.infinity,
                                                      color: BuytimeTheme.TextBlack.withOpacity(0.2),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ///Service Name Text
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                            child: Text(
                                                              widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : AppLocalizations.of(context).serviceName,
                                                              style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w700, fontSize: 18

                                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                                  ),
                                                            ),
                                                          ),
                                                          /*///Service Name Text
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                  child: Text(
                                    widget.serviceState.name ?? AppLocalizations.of(context).serviceName,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 14

                                      ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),*/

                                                          ///Amount
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                                                child: Text(
                                                                  price,
                                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w400, fontSize: 14

                                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                                  ),
                                                                ),
                                                              ),
                                                              ///Promo Discount label
                                                              Utils.checkPromoDiscount('general_1', context, snapshot.serviceState.businessId).promotionId != 'empty'
                                                                  ? Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 0.0),
                                                                  child: FittedBox(
                                                                    fit: BoxFit.fitHeight,
                                                                    child: W_PromoDiscount(true),
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),
                                                              ///ECO label
                                                              widget.serviceState.tag.contains('ECO')
                                                                  ? Container(
                                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                                                                child: FittedBox(
                                                                  fit: BoxFit.fitHeight,
                                                                  child: W_GreenChoice(false),
                                                                ),
                                                              )
                                                                  : Container(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      /*Container(
                                                    height: SizeConfig.safeBlockVertical * 55,
                                                    width: double.infinity,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          //padding: EdgeInsets.only(top: 80, bottom: 80, left: 50, right: 50),
                                                          child: CircularProgressIndicator(
                                                              //valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                                                              ),
                                                        )
                                                      ],
                                                    ),
                                                  )*/
                                                      Utils.imageShimmer(double.infinity, SizeConfig.safeBlockVertical * 55),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ))
                                            .toList(),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                                        imageBuilder: (context, imageProvider) => Container(
                                          //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                          height: SizeConfig.safeBlockVertical * 55,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                              image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.fill,
                                          )),
                                          child: Container(
                                            height: SizeConfig.safeBlockVertical * 55,
                                            width: double.infinity,
                                            color: BuytimeTheme.TextBlack.withOpacity(0.2),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ///Service Name Text
                                                Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 2.5),
                                                  child: Text(
                                                    widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : AppLocalizations.of(context).serviceName,
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w700, fontSize: 18

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                                /*///Service Name Text
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                  child: Text(
                                    widget.serviceState.name ?? AppLocalizations.of(context).serviceName,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 14

                                      ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),*/

                                                ///Amount
                                                Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                                  child: Text(
                                                    price,
                                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w400, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Utils.imageShimmer(double.infinity, SizeConfig.safeBlockVertical * 55),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )),

                            ///Service Name & The rest
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.tourist
                                    ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ///Supplied by
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).suppliedBy.toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                              ),
                                            ),
                                          ),

                                          ///Supplied Value
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                bussinessName,
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.BackgroundCerulean, fontWeight: FontWeight.w500, fontSize: 16

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                              ),
                                            ),
                                          ),

                                          ///Address text
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                AppLocalizations.of(context).address.toUpperCase(),
                                                style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                              ),
                                            ),
                                          ),

                                          ///Address value
                                          Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                address,
                                                style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                    ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                              ),
                                            ),
                                          ),
                                          address.endsWith('.')
                                              ? Container()
                                              :///Directions
                                              Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0.5),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_pin,
                                                        size: 14,
                                                        color: BuytimeTheme.SymbolGrey,
                                                      ),

                                                      ///Min
                                                      /*Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '? ' + AppLocalizations.of(context).min,
                                                style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 14

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),*/

                                                      ///Directions
                                                      Container(
                                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                          alignment: Alignment.center,
                                                          child: Material(
                                                            color: Colors.transparent,
                                                            child: InkWell(
                                                                onTap: () {
                                                                  debugPrint('UI_U_service_details => BUSINESS STATE: ${externalBusinessState.name}');
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => BuytimeMap(
                                                                            user: true,
                                                                            title: widget.serviceState.name,
                                                                            businessState: BusinessState.fromExternalState(externalBusinessState),
                                                                            serviceState: widget.serviceState,
                                                                            tourist: widget.tourist)),
                                                                  );
                                                                },
                                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                                child: Container(
                                                                  padding: EdgeInsets.all(5.0),
                                                                  child: Text(
                                                                    AppLocalizations.of(context).directions,
                                                                    style: TextStyle(
                                                                        letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.BackgroundCerulean, fontWeight: FontWeight.w600, fontSize: 15

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
                                    : isExternal
                                        ? Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ///Supplied by
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    AppLocalizations.of(context).suppliedBy.toUpperCase(),
                                                    style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              ///Supplied Value
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    bussinessName,
                                                    style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.UserPrimary, fontWeight: FontWeight.w500, fontSize: 16

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              ///Address text
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    AppLocalizations.of(context).address.toUpperCase(),
                                                    style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              ///Address value
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    address,
                                                    style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                ),
                                              ),

                                              ///Directions
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0.5),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_pin,
                                                      size: 14,
                                                      color: BuytimeTheme.SymbolGrey,
                                                    ),

                                                    ///Min
                                                    /*Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 1.5, right: SizeConfig.safeBlockHorizontal * 1, top: SizeConfig.safeBlockVertical * 0),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                '? ' + AppLocalizations.of(context).min,
                                                style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 14

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                          ),*/

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
                                                                  MaterialPageRoute(
                                                                      builder: (context) => BuytimeMap(
                                                                          user: true,
                                                                          title: widget.serviceState.name,
                                                                          businessState: BusinessState.fromExternalState(externalBusinessState),
                                                                          serviceState: widget.serviceState,
                                                                          tourist: widget.tourist)),
                                                                );
                                                              },
                                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                              child: Container(
                                                                padding: EdgeInsets.all(5.0),
                                                                child: Text(
                                                                  AppLocalizations.of(context).directions,
                                                                  style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.UserPrimary, fontWeight: FontWeight.w500, fontSize: 15

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
                                        : Container(),
                                ///Condition Text
                                widget.serviceState.condition != null &&  widget.serviceState.condition.isNotEmpty ?
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).conditions.toUpperCase(),
                                      style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ) : Container(),
                                ///Condition Value
                                widget.serviceState.condition != null &&  widget.serviceState.condition.isNotEmpty ?
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.condition),
                                      style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ) : Container(),
                                ///Description text
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      AppLocalizations.of(context).description.toUpperCase(),
                                      style: TextStyle(letterSpacing: 1.5, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w500, fontSize: 10

                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                ),
                                ///Description
                                Flexible(
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 0, top: SizeConfig.safeBlockVertical * .5),
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
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 2),
                                          child: Text(
                                            translatedDescription.isNotEmpty && useOriginal ? translatedDescription : widget.serviceState.description.isNotEmpty ? Utils.retriveField(useOriginal ?
                                                serviceState.originalLanguage :
                                            Localizations.localeOf(context).languageCode, widget.serviceState.description) : AppLocalizations.of(context).loreIpsum,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16

                                                ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                                ///Original & Translate
                                serviceState.originalLanguage.isNotEmpty && myLocale.languageCode != serviceState.originalLanguage && (serviceState.description.split('|').length > 1 || translatedDescription.isNotEmpty) ?
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * .5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                          MaterialDesignIcons.language,
                                        //size: 19,
                                        color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                          AppLocalizations.of(context).translatedWith,
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextMedium,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 7, top: 1),
                                        height: 2,
                                        width: 2,
                                        color: Colors.black,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.center,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    useOriginal = !useOriginal;
                                                  });
                                                },
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    !useOriginal ? AppLocalizations.of(context).original :  AppLocalizations.of(context).translated,
                                                    style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary, fontWeight: FontWeight.w500, fontSize: 15

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                )),
                                          ))
                                    ],
                                  ),
                                ) : serviceState.originalLanguage.isNotEmpty && (serviceState.description.split('|').length == 1 || translatedDescription.isEmpty) ? Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, bottom: SizeConfig.safeBlockVertical * 1, top: SizeConfig.safeBlockVertical * .5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        MaterialDesignIcons.language,
                                        //size: 19,
                                        color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.center,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: (){
                                                  Utils.singleGoogleTranslate(serviceState.originalLanguage, myLocale.languageCode, Utils.retriveField(serviceState.originalLanguage, serviceState.description)).then((value) => setState(() {
                                                    useOriginal = true;
                                                    debugPrint('UI_U_service_details => TRANLATED IN: $value');
                                                    translatedDescription =  value;
                                                  }));

                                                },
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    AppLocalizations.of(context).clickHere,
                                                    style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary, fontWeight: FontWeight.w500, fontSize: 15

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                )),
                                          ))
                                    ],
                                  ),
                                ) : Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                      !widget.serviceState.switchSlots
                          ?
                          ///Add a cart & Buy
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ///Add to cart
                                Container(
                                    width: 158,

                                    ///SizeConfig.safeBlockHorizontal * 40
                                    height: 44,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29, right: SizeConfig.safeBlockHorizontal * 2.5),
                                    decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(5),
                                        border: Border.all(color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user ? (widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary) : BuytimeTheme.SymbolGrey)),
                                    child: MaterialButton(
                                      key: Key('service_details_add_to_cart_key'),
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user
                                          ? () {
                                              if (isExternal) {
                                                order.business.name = externalBusinessState.name;
                                                order.business.id = externalBusinessState.id_firestore;
                                              } else {
                                                order.business.name = snapshot.business.name;
                                                order.business.id = snapshot.business.id_firestore;
                                              }
                                              order.user.name = snapshot.user.name;
                                              order.user.id = snapshot.user.uid;
                                              order.user.email = snapshot.user.email;
                                              if (!order.addingFromAnotherBusiness(widget.serviceState.businessId)) {
                                                order.addItem(widget.serviceState, snapshot.business.ownerId, context);
                                                order.cartCounter++;
                                                StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                              } else {
                                                /// TODO ask if they want the cart to be flushed empty
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                          title: Text(AppLocalizations.of(context).doYouWantToPerformAnotherOrder),
                                                          content: Text(AppLocalizations.of(context).youAreAboutToPerformAnotherOrder),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              child: Text(AppLocalizations.of(context).cancel),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              child: Text(AppLocalizations.of(context).ok),
                                                              onPressed: () {
                                                                /// svuotare il carrello
                                                                // StoreProvider.of<AppState>(context).dispatch(());
                                                                /// fare la nuova add
                                                                for (int i = 0; i < order.itemList.length; i++) {
                                                                  order.removeItem(order.itemList[i],context);
                                                                }
                                                                order.itemList = [];
                                                                order.cartCounter = 0;
                                                                order.addItem(widget.serviceState, snapshot.business.ownerId, context);
                                                                order.cartCounter = 1;
                                                                Navigator.of(context).pop();
                                                              },
                                                            )
                                                          ],
                                                        ));
                                              }
                                              // order.cartCounter++;
                                              // //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                              // StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                            }
                                          : null,
                                      textColor: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                      disabledTextColor: BuytimeTheme.SymbolGrey,
                                      color: BuytimeTheme.BackgroundWhite,
                                      //padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          AppLocalizations.of(context).addToCart,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.25,
                                          ),
                                        ),
                                      ),
                                    )),

                                ///Buy
                                Container(
                                    width: 158,

                                    ///SizeConfig.safeBlockHorizontal * 40
                                    height: 44,
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29),
                                    child: MaterialButton(
                                      key: Key('service_details_buy_key'),
                                      elevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      highlightElevation: 0,
                                      onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user
                                          ? () {
                                              if (isExternal) {
                                                order.business.name = externalBusinessState.name;
                                                order.business.id = externalBusinessState.id_firestore;
                                              } else {
                                                order.business.name = snapshot.business.name;
                                                order.business.id = snapshot.business.id_firestore;
                                              }
                                              order.user.name = snapshot.user.name;
                                              order.user.id = snapshot.user.uid;
                                              order.user.email = snapshot.user.email;
                                              // order.addItem(widget.serviceState, snapshot.business.ownerId, context);
                                              if (!order.addingFromAnotherBusiness(widget.serviceState.businessId)) {
                                                order.addItem(widget.serviceState, snapshot.business.ownerId, context);
                                                order.cartCounter++;
                                                StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Cart(
                                                            tourist: widget.tourist,
                                                          )),
                                                );
                                              } else {
                                                /// TODO ask if they want the cart to be flushed empty
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                          title: Text(AppLocalizations.of(context).doYouWantToPerformAnotherOrder),
                                                          content: Text(AppLocalizations.of(context).youAreAboutToPerformAnotherOrder),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              child: Text(AppLocalizations.of(context).cancel),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              elevation: 0,
                                                              hoverElevation: 0,
                                                              focusElevation: 0,
                                                              highlightElevation: 0,
                                                              child: Text(AppLocalizations.of(context).ok),
                                                              onPressed: () {
                                                                /// svuotare il carrello
                                                                // StoreProvider.of<AppState>(context).dispatch(());
                                                                /// fare la nuova add
                                                                for (int i = 0; i < order.itemList.length; i++) {
                                                                  order.removeItem(order.itemList[i],context);
                                                                }
                                                                order.itemList = [];
                                                                order.cartCounter = 0;
                                                                order.addItem(widget.serviceState, snapshot.business.ownerId, context);
                                                                order.cartCounter = 1;
                                                                Navigator.of(context).pop();
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => Cart(
                                                                            tourist: widget.tourist,
                                                                          )),
                                                                );
                                                              },
                                                            )
                                                          ],
                                                        ));
                                              }
                                              // order.cartCounter++;
                                              // //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                              // StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                              //StoreProvider.of<AppState>(context).dispatch(SetOrder(order));

                                              /* Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ConfirmOrder(reserve: false, tourist: widget.tourist,)),
                                  );*/

                                              ///Discriminare se è un turista o un utente loggato a premere BUY
                                              ///Controllare se c'è utente loggato con firebase
                                              //     if (auth.FirebaseAuth != null && auth.FirebaseAuth.instance != null && auth.FirebaseAuth.instance.currentUser != null)
                                            }
                                          : null,
                                      textColor: BuytimeTheme.TextWhite,
                                      disabledTextColor: BuytimeTheme.TextWhite,
                                      color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                      disabledColor: BuytimeTheme.SymbolGrey,
                                      //padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context).buyUpper,
                                        style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w800, letterSpacing: 1.25),
                                      ),
                                    )),
                              ],
                            )
                          :

                          ///Reserve
                          Container(
                              width: 158,

                              ///SizeConfig.safeBlockHorizontal * 40
                              height: 44,
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29, right: SizeConfig.safeBlockHorizontal * 0),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(5),
                                /*border: Border.all(
                                color: BuytimeTheme.UserPrimary
                            )*/
                              ),
                              child: MaterialButton(
                                key: Key('service_reserve_buy_key'),
                                onPressed: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user
                                    ? () {
                                        StoreProvider.of<AppState>(context).dispatch(SetOrderReservableToEmpty('ok'));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: widget.serviceState, tourist: widget.tourist)),
                                        );
                                      }
                                    : null,
                                elevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                textColor: BuytimeTheme.TextWhite,
                                disabledTextColor: BuytimeTheme.TextWhite,
                                color: widget.tourist ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
                                disabledColor: BuytimeTheme.SymbolGrey,
                                //padding: EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5),
                                ),
                                child: Container(
                                    child: Text(
                                  AppLocalizations.of(context).reserveUpper,
                                  style: TextStyle(fontSize: 14, fontFamily: BuytimeTheme.FontFamily, fontWeight: FontWeight.w800, letterSpacing: 1.25),
                                )),
                              ),
                            ),
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
