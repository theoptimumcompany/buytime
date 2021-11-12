import 'package:Buytime/UI/user/service/UI_U_new_service_details.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/w_convention_discount.dart';
import 'package:Buytime/reusable/w_green_choice.dart';
import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/reusable/w_new_discount.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'w_promo_discount.dart';

class ServiceListItem extends StatefulWidget {
  ServiceState serviceState;
  bool tourist;
  int index;
  ServiceListItem(this.serviceState, this.tourist, this.index);

  @override
  _ServiceListItemState createState() => _ServiceListItemState();
}

class _ServiceListItemState extends State<ServiceListItem> {
  @override
  Widget build(BuildContext context) {
    //debugPrint('image: ${widget.serviceState.image1}');
    ConventionHelper conventionHelper = ConventionHelper();
    return Container(
        //margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: Key('top_service_${widget.index}'),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewServiceDetails(
                            serviceState: widget.serviceState,
                            tourist: widget.tourist,
                          )),
                );
              },
              child: Container(
                height: 100,
                ///SizeConfig.safeBlockVertical * 15
                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, right: SizeConfig.safeBlockHorizontal * 0, top: 1, bottom: 1),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                imageUrl: Utils.version200(widget.serviceState.image1),
                                imageBuilder: (context, imageProvider) => Container(
                                  //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                  height: 91,
                                  width: 91,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)), ///12.5%
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          width: 91,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              ///ECO label
                                              widget.serviceState.tag != null && widget.serviceState.tag.contains('ECO')
                                                  ? Container(
                                                margin: EdgeInsets.only(left: 5),
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: W_GreenChoice(true),
                                                ),
                                              )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                placeholder: (context, url) => Utils.imageShimmer(91, 91),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
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
                            right: 0,
                            top: 0,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: NewDiscount(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isNotEmpty ?
                                StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id : '', true, true)
                            ),
                          ) : Container(),
                          ConventionHelper().getConvention(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState ?? []) ?
                          Positioned.fill(
                            right: 0,
                            top: Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty' ? 35 : 0,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: NewDiscount(widget.serviceState,StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id, false, false)
                            ),
                          ) : Container()
                        ],
                      ),
                    ),
                    ///Service Image
                    /*Container(
                      height: 91, ///SizeConfig.safeBlockVertical * 15
                      width: 91, ///SizeConfig.safeBlockVertical * 15
                      //margin: EdgeInsets.all(SizeConfig.safeBlockVertical * 2),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(0)),
                          image: DecorationImage(
                            image: widget.serviceState.image1.isNotEmpty ? NetworkImage(widget.serviceState.image1) : AssetImage('assets/img/image_placeholder.png'),
                            fit: BoxFit.cover,
                          )
                      ),
                    ),*/

                    ///Service Name & Description
                    Container(
                      //width: SizeConfig.safeBlockHorizontal * 60,
                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              ///Service Name
                              Container(
                                  width: SizeConfig.safeBlockHorizontal * 60,
                                  //height: 40,
                                  child: Row(
                                    children: [Flexible(
                                      child: Text(
                                        widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : '',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(letterSpacing: 0.15, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16

                                          /// SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                    )],
                                  )
                              ),
                              ///Description
                              Container(
                                //color: Colors.black,
                                width: SizeConfig.safeBlockHorizontal * 60,
                                ///SizeConfig.safeBlockHorizontal * 50
                                //height: 40,
                                ///SizeConfig.safeBlockVertical * 10
                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5),
                                child: Text(
                                  widget.serviceState.description != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.description) : '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(letterSpacing: 0.25, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w400, fontSize: 14

                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              widget.serviceState.switchSlots ?
                              Container(
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: SizeConfig.safeBlockVertical * 2, bottom:  SizeConfig.safeBlockVertical * 0.5),
                                child: Text(
                                  AppLocalizations.of(context).from,
                                  style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.TextGrey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    //decoration: TextDecoration.lineThrough
                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ) : Container(),
                              Container(
                                margin: EdgeInsets.only(left: !widget.serviceState.switchSlots ? SizeConfig.safeBlockHorizontal * 0 : 5, top: SizeConfig.safeBlockVertical * 2, bottom:  SizeConfig.safeBlockVertical * 0.5),
                                child: Text(
                                  '${widget.serviceState.price.toStringAsFixed(2)}${AppLocalizations.of(context).currencySpace}',
                                  style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                      color: BuytimeTheme.TextGrey,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      decoration: Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty' ?
                                      TextDecoration.lineThrough : TextDecoration.none
                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ),
                              Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId != 'empty' ?
                              Container(
                                margin: EdgeInsets.only(left: 5, top: SizeConfig.safeBlockVertical * 2, bottom:  SizeConfig.safeBlockVertical * 0.5),
                                child: Text(
                                  '${(widget.serviceState.price-((widget.serviceState.price*StoreProvider.of<AppState>(context).state.promotionState.discount)/100)).toStringAsFixed(2)}${AppLocalizations.of(context).currencySpace}',
                                  style: TextStyle(
                                    fontFamily: BuytimeTheme.FontFamily,
                                    color: BuytimeTheme.SymbolMalibu,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                    ///SizeConfig.safeBlockHorizontal * 4
                                  ),
                                ),
                              ) : Container(),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
