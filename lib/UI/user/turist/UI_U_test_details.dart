import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:Buytime/UI/user/turist/widget/p_r_card_widget.dart';
import 'package:Buytime/helper/pagination/service_helper.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reusable/w_new_discount.dart';
import 'package:Buytime/reusable/w_promo_discount.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'RUI_U_service_explorer.dart';

class TestDetails extends StatefulWidget {
  final String title = 'About Us';
  ServiceState serviceState;
  TestDetails(this.serviceState);
  @override
  State<StatefulWidget> createState() => TestDetailsState();
}

class TestDetailsState extends State<TestDetails> {
  ScrollController popularScoller = ScrollController();
  List<ServiceState> myList = [];
  ServicePagingBloc servicePagingBloc;
  Color _theme;
  Color _bgTheme;
  double height = 30;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(
            () => _isAppBarExpanded ?
        _theme != Colors.black ?
        setState(() {
            _theme = Colors.black;
            _bgTheme = Colors.white;
            height = 30;
            print(
                'setState is called');
          },
        ):{} : _theme != Colors.white ?
        setState((){
          print('setState is called');
          _theme = Colors.white;
          _bgTheme = Colors.transparent;
          height = 50;
        }):{},
      );
  }
  ScrollController _scrollController;
  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > ((SizeConfig.safeBlockVertical * 47) - kToolbarHeight);
  }
  bool get _isAppBarExpanded2 {
    return _scrollController.hasClients &&
        _scrollController.offset > ((SizeConfig.safeBlockVertical * 0) - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: SizeConfig.safeBlockVertical * 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 5,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: _theme,
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
                      title: _theme == Colors.black ? Text(
                        Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontFamily: BuytimeTheme.FontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            //letterSpacing: 0.15,
                            color: _theme
                        ),
                      ) : Container(),
                      pinned: true,
                      elevation: 1,
                      backgroundColor: Colors.white,
                      expandedHeight: SizeConfig.safeBlockVertical * 50,
                      flexibleSpace: Stack(
                        children: [
                          Positioned(
                            child: !_isAppBarExpanded ?
                            CachedNetworkImage(
                              imageUrl: Utils.version1000(widget.serviceState.image1),
                              imageBuilder: (context, imageProvider) => Container(
                                //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                height: SizeConfig.safeBlockVertical * 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    )),
                                child: Container(
                                  height: SizeConfig.safeBlockVertical * 50,
                                  width: double.infinity,
                                  color: BuytimeTheme.TextBlack.withOpacity(0.2),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ///Promotion
                                      Utils.checkPromoDiscount('general_1', context, widget.serviceState.businessId).promotionId == 'empty' ?
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                        child: NewDiscount(widget.serviceState, StoreProvider.of<AppState>(context).state.bookingList.bookingListState.isNotEmpty ?
                                        StoreProvider.of<AppState>(context).state.bookingList.bookingListState.first.business_id : '', true, true),
                                      ) : Container(),
                                      ///Service Name Text
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
                                        child: Text(
                                          widget.serviceState.name != null ? Utils.retriveField(Localizations.localeOf(context).languageCode, widget.serviceState.name) : AppLocalizations.of(context).serviceName,
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w600, fontSize: 24
                                            ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      ),
                                      ///Price
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5, bottom:  SizeConfig.safeBlockVertical * 0.5),
                                        child: Text(
                                          '${AppLocalizations.of(context).currencySpace} ${widget.serviceState.price.toStringAsFixed(2)}',
                                          style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w600, fontSize: 16
                                            ///SizeConfig.safeBlockHorizontal * 4
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 20,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 0.5),
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
                                      /*Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                              child: Text(
                                '',
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
                        )*/
                                      /*Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)
                            )
                          ),
                        )*/
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
                            ) : Container(
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                            ),
                            bottom: -1,
                            left: 0,
                            right: 0,
                          ),
                        ],
                      )
                  ),
                  SliverFixedExtentList(
                    itemExtent: 900,
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          //height: 1000,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              )
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
            ///Add to cart
            Container(
                width: 158,

                ///SizeConfig.safeBlockHorizontal * 40
                height: 44,
                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: 29, right: SizeConfig.safeBlockHorizontal * 2.5),
                decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(5),
                    border: Border.all(color: StoreProvider.of<AppState>(context).state.user.getRole() == Role.user ? (true ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary) : BuytimeTheme.SymbolGrey)),
                child: MaterialButton(
                  key: Key('service_details_add_to_cart_key'),
                  elevation: 0,
                  hoverElevation: 0,
                  focusElevation: 0,
                  highlightElevation: 0,
                  onPressed:  () {

                  },
                  textColor: true ? BuytimeTheme.BackgroundCerulean : BuytimeTheme.UserPrimary,
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
          ],
        ),
      )
    );
  }
}

class PippoSliver extends SliverFixedExtentList{

}