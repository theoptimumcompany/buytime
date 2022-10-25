import 'package:Buytime/UI/user/category/UI_U_filter_by_category.dart';
import 'package:Buytime/UI/user/service/UI_U_new_service_details.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/UI/user/turist/UI_U_test_details.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/w_convention_discount.dart';
import 'package:Buytime/reusable/w_new_discount.dart';
import 'package:Buytime/reusable/w_promo_discount.dart';
import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../RUI_U_service_explorer.dart';

class NewPRCardWidget extends StatefulWidget {

  double width;
  double heigth;
  ServiceState serviceState;
  bool fromBookingPage;
  bool isBlack;
  int index;
  String section;

  NewPRCardWidget(this.width, this.heigth,this.serviceState, this.fromBookingPage, this.isBlack, this.index, this.section);

  @override
  _NewPRCardWidgetState createState() => _NewPRCardWidgetState();
}

class _NewPRCardWidgetState extends State<NewPRCardWidget> {

  @override
  void initState() {
    super.initState();
    //debugPrint('p_r_card_widget => ${widget.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint('p_r_card_widget => BUSINES ID: ${StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id}');
    return  Container(
      height: 200,
      width: SizeConfig.screenWidth/2,
      //width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: Utils.version200(widget.serviceState.image1),
                  imageBuilder: (context, imageProvider) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 0, right:  10),
                            width: widget.width, ///SizeConfig.safeBlockVertical * widget.width
                            height: widget.heigth, ///SizeConfig.safeBlockVertical * widget.width
                            decoration: BoxDecoration(
                                color: BuytimeTheme.BackgroundWhite,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.black.withOpacity(.3),
                                onTap: (){
                                  FirebaseAnalytics().logEvent(
                                      name: 'category_discover',
                                      parameters: {
                                        'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                        'date': DateTime.now().toString(),
                                        'service_name': widget.serviceState.name.isNotEmpty ? widget.serviceState.name : 'no name found',
                                        'service_position': 'popular'  + ', pos: ' + widget.index.toString(),
                                      });
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewServiceDetails(serviceState: widget.serviceState, tourist: true,)));
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => TestDetails(widget.serviceState)));
                                  /*widget.fromBookingPage ?
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: true, categoryState: widget.categoryState,))) :
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterByCategory(fromBookingPage: false,categoryState: widget.categoryState,)));*/
                                },
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    /*Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            //color: Colors.black.withOpacity(.2)
                                          ),
                                          child: ///Promo Discount label
                                          Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty'
                                              ? Container(
                                            alignment: Alignment.bottomLeft,
                                            margin: EdgeInsets.only(left: 5, bottom: 5),
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: W_PromoDiscount(true),
                                            ),
                                          ) : Container(),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            //color: Colors.black.withOpacity(.2)
                                          ),
                                          child: ///Promo Discount label
                                          ConventionHelper().getConvention(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState)
                                              ? Container(
                                            alignment: Alignment.bottomLeft,
                                            margin: EdgeInsets.only(left: 5, bottom: 5),
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: W_ConventionDiscount(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id, true),
                                            ),
                                          ): Container(),
                                        )
                                      ],
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: 180,
                              //height: 40,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 0.5),
                              child: Row(
                                children: [
                                  Flexible(child: Text(
                                    Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: true ?  BuytimeTheme.TextBlack : BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 14
                                      ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),)
                                ],
                              )
                          ),
                          Container(
                              width: 180,
                              //height: 40,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 0, top: 2),
                              child: Row(
                                children: [
                                  widget.serviceState.switchSlots?
                                  Flexible(child: Text(
                                    '${AppLocalizations.of(context).from} ',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: true ?  BuytimeTheme.TextBlack : BuytimeTheme.TextWhite, fontWeight: FontWeight.w400, fontSize: 12
                                      ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),) : Container(),
                                  Flexible(child: Text(
                                    '${widget.serviceState.price.toStringAsFixed(2)}${AppLocalizations.of(context).currencySpace}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: true ?  BuytimeTheme.TextBlack : BuytimeTheme.TextWhite, fontWeight: FontWeight.w400, fontSize: 12
                                      ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),)
                                ],
                              )
                          )
                        ],
                      ),
                  placeholder: (context, url) => Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 0, right: 10),
                        child: Utils.imageShimmer(182, 182),
                      ),
                      Container(
                        width: 180,
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                        child: Utils.textShimmer(150, 10),
                      )
                    ],
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
            ),
          ),
          /*Positioned.fill(
            right: 10,
            top: 5,
            child: Align(
                alignment: Alignment.topRight,
                child: NewDiscount(widget.serviceState,StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id, true, true)
            ),
          ),Positioned.fill(
            right: 10,
            top: 40,
            child: Align(
                alignment: Alignment.topRight,
                child: NewDiscount(widget.serviceState,StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id, true, false)
            ),
          ),*/
          Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty' ?
          Positioned.fill(
            right: 10,
            top: 5,
            child: Align(
                alignment: Alignment.topRight,
                child: NewDiscount(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isNotEmpty ?
                StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id : '', true, true)
            ),
          ) : Container(),
          ConventionHelper().getConvention(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState ?? [], context) ?
          Positioned.fill(
            right: 10,
            top: Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty' ? 40 : 5,
            child: Align(
                alignment: Alignment.topRight,
                child: NewDiscount(widget.serviceState, Provider.of<Explorer>(context, listen: false).businessState.id_firestore, false, false)
            ),
          ) : Container()
        ],
      ),
    );
  }
}

