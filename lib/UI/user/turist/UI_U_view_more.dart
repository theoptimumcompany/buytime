import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:Buytime/UI/user/booking/RUI_notification_bell.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/service/UI_U_service_details.dart';
import 'package:Buytime/UI/user/turist/widget/new_p_r_card_widget.dart';
import 'package:Buytime/UI/user/turist/widget/p_r_card_widget.dart';
import 'package:Buytime/helper/convention/convention_helper.dart';
import 'package:Buytime/helper/pagination/service_helper.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/w_convention_discount.dart';
import 'package:Buytime/reusable/w_new_discount.dart';
import 'package:Buytime/reusable/w_promo_discount.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'RUI_U_service_explorer.dart';

class ViewMore extends StatefulWidget {
  String title;
  List<OrderState> orderList;
  bool normalServiceList;
  bool hubServices;
  List<String> categoryIdList;
  ViewMore(this.title, this.orderList, this.normalServiceList, this.categoryIdList, this.hubServices);
  @override
  State<StatefulWidget> createState() => ViewMoreState();
}

class ViewMoreState extends State<ViewMore> {
  ScrollController popularScoller = ScrollController();
  List<ServiceState> myList = [];
  ServicePagingBloc servicePagingBloc;
  OrderState order = OrderState().toEmpty();
  List<int> randomNumbers;
  @override
  void initState() {
    popularScoller.addListener(_scrollListener);
    super.initState();
    servicePagingBloc = ServicePagingBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(widget.hubServices)
        servicePagingBloc.requestHubServices(context);
      else if(widget.normalServiceList)
        servicePagingBloc.requestServices(context);
      else
        servicePagingBloc.requestCategoryServices(context, widget.categoryIdList);
    });


  }

  void _scrollListener() {
    //_currentUserStreamCtrl = StreamController.broadcast();
    //debugPrint('OFFSET: ${popularScoller.offset}');
    //debugPrint('SCROLL POSITION: ${popularScoller.position.pixels}');
    //debugPrint('MAX SCROLL EXTENT: ${popularScoller.position.maxScrollExtent}');
    //debugPrint('POSITION OUT OF RANGE: ${popularScoller.position.outOfRange}');
    if (popularScoller.offset >= popularScoller.position.maxScrollExtent && !popularScoller.position.outOfRange) {
      print("at the end of list");
      if(widget.normalServiceList)
        servicePagingBloc.requestServices(context);
      else
        servicePagingBloc.requestCategoryServices(context, widget.categoryIdList);
    }
  }

/*PreferredSize(
        preferredSize: Size.fromHeight(44), //// Set this height
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('One'),
              Text('Two'),
              Text('Three'),
              Text('Four'),
            ],
          ),
        ),
      )*/
  @override
  Widget build(BuildContext context) {
    order =  StoreProvider.of<AppState>(context).state.order.itemList != null ? ( StoreProvider.of<AppState>(context).state.order.itemList.length > 0 ?  StoreProvider.of<AppState>(context).state.order : OrderState().toEmpty()) : OrderState().toEmpty();


    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {

      },
      builder: (context, snapshot) {

        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
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
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  child: IconButton(
                    key: Key('action_button_discover'),
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    tooltip: AppLocalizations.of(context).comeBack,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                centerTitle: true,
                title: Container(
                  width: SizeConfig.safeBlockHorizontal * 60,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontFamily: BuytimeTheme.FontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              //letterSpacing: 0.15,
                              color: BuytimeTheme.TextBlack
                          ),
                        ),
                      )),
                ),
                actions: [
                  Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///Notification
                        Flexible(
                            child: StoreProvider.of<AppState>(context).state.user.uid != null && StoreProvider.of<AppState>(context).state.user.uid.isNotEmpty
                                ? RNotificationBell(
                              orderList: widget.orderList,
                              userId: StoreProvider.of<AppState>(context).state.user.uid,
                              tourist: true,
                            ): Container()),
                        ///Cart
                        Flexible(
                            child: Container(
                              margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        key: Key('cart_key'),
                                        icon: Icon(
                                          BuytimeIcons.shopping_cart,
                                          color: BuytimeTheme.TextBlack,
                                          size: 19.0,
                                        ),
                                        onPressed: () {
                                          debugPrint("RUI_U_service_explorer => + cart_discover");
                                          FirebaseAnalytics().logEvent(
                                              name: 'cart_discover',
                                              parameters: {
                                                'user_email': StoreProvider.of<AppState>(context).state.user.email,
                                                'date': DateTime.now().toString(),
                                              });
                                          if (order.cartCounter > 0) {
                                            // dispatch the order
                                            StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                            // go to the cart page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Cart(
                                                    tourist: true,
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
                                    bottom: 20,
                                    left: 3,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${order.cartCounter}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: SizeConfig.safeBlockHorizontal * 3,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ))
                      ],
                    ),
                  )
                ],
                elevation: 1,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: SizeConfig.safeBlockVertical * 100),
                    child: Container(
                        width: double.infinity,
                        //color: BuytimeTheme.DividerGrey,
                        child:
                        StreamBuilder<List<ServiceState>>(
                            stream: servicePagingBloc.serviceStream,
                            builder: (context, AsyncSnapshot<List<ServiceState>> orderSnapshot) {
                              //myList.clear();
                              if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircularProgressIndicator()
                                      ],
                                    )
                                  ],
                                );
                              }
                              myList = orderSnapshot.data;
                              debugPrint('MYLIST LENGTH: ${myList.length}');
                              return ///List
                                Container(
                                  //height: double.infinity,
                                    width: double.infinity,
                                    //height: SizeConfig.safeBlockVertical * 100,
                                    //alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
                                    child: Stack(
                                      children: [
                                        ///Paged service list
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 6),
                                              child: CustomScrollView(
                                                  controller: popularScoller,
                                                  shrinkWrap: true, scrollDirection: Axis.vertical, slivers: [
                                                SliverGrid(
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    //maxCrossAxisExtent: SizeConfig.screenWidth/2,
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 10.0,
                                                    crossAxisSpacing: 0.0,
                                                    mainAxisExtent: 228
                                                    //childAspectRatio: .77,
                                                  ),
                                                  delegate: SliverChildBuilderDelegate(
                                                        (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      ServiceState service = myList.elementAt(index);
                                                      return NewPRCardWidget(182, 182, service, false, true, index, 'Popular')
                                                      /*Container(
                                          height: 300,
                                          width: 182,
                                          child: PRCardWidget(182, 182, service, false, true, index, 'popular'),
                                        )*/;
                                                    },
                                                    childCount: myList.length,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                        ///Page loading indicator
                                        Positioned.fill(
                                          top: SizeConfig.safeBlockVertical * 80,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: StreamBuilder<bool>(
                                                stream: servicePagingBloc.getShowIndicatorStream,
                                                builder: (context, AsyncSnapshot<bool> businessSnapshot) {
                                                  //myList.clear();
                                                  if (businessSnapshot.hasError || businessSnapshot.connectionState == ConnectionState.waiting) {
                                                    debugPrint('RUI_U_service_explorer => SERVICE LOADER WAITING');
                                                    return Container();
                                                  }
                                                  debugPrint('RUI_U_service_explorer => LOADING INDICATOR IS: ${businessSnapshot.data}');
                                                  return businessSnapshot.data ? Container(
                                                    height: 35,
                                                    width: 35,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(25)),
                                                        border: Border.all(color: BuytimeTheme.SymbolMalibu, width: .25)
                                                    ),
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.SymbolMalibu),
                                                    ),
                                                  ) : Container();
                                                }
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                );
                            }
                        )
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
