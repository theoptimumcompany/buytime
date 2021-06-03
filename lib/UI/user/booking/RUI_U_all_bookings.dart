import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/booking/widget/user_service_list_item.dart';

class RAllBookings extends StatefulWidget {
  static String route = '/bookingPage';
  bool fromConfirm;
  bool tourist;
  RAllBookings({Key key, this.fromConfirm, this.tourist}) : super(key: key);

  @override
  _RAllBookingsState createState() => _RAllBookingsState();
}

class _RAllBookingsState extends State<RAllBookings> {
  TextEditingController _searchController = TextEditingController();

  BookingState bookingState;
  BusinessState businessState;
  ServiceListState serviceListState;
  List<ServiceState> serviceList = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];
  List<OrderState> orderList = [];

  bool sameMonth = false;
  String searched = '';
  OrderState order = OrderState().toEmpty();

  bool showAll = false;

  bool startRequest = false;
  bool rippleLoading = false;

  List<OrderState> orderStateList = [];

  @override
  void initState() {
    super.initState();
  }

  String version1000(String imageUrl) {
    String result = "";
    String extension = "";
    if (imageUrl != null && imageUrl.length > 0 && imageUrl.contains("http")) {
      extension = imageUrl.substring(imageUrl.lastIndexOf('.'), imageUrl.length);
      result = imageUrl.substring(0, imageUrl.lastIndexOf('.'));
      result += "_1000x1000" + extension;
    } else {
      result = "https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200.png?alt=media&token=d40ccab1-7fb5-4290-91c6-634871b7a4f3";
    }
    return result;
  }

  String _selected = '';
  bool isManagerOrAbove = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    order = StoreProvider.of<AppState>(context).state.order.itemList != null ? (StoreProvider.of<AppState>(context).state.order.itemList.length > 0 ? StoreProvider.of<AppState>(context).state.order : OrderState().toEmpty()) : OrderState().toEmpty();
    //debugPrint('UI_U_all_bookings => CART COUNT: ${order.cartCounter}');
    DateTime currentTime = DateTime.now();
    currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
    final Stream<QuerySnapshot> _orderStream =  FirebaseFirestore.instance
        .collection("order")
        .where("businessId", isEqualTo: StoreProvider.of<AppState>(context).state.business.id_firestore)
        .where("userId", isEqualTo: StoreProvider.of<AppState>(context).state.user.uid)
        .where("date", isGreaterThanOrEqualTo: currentTime)
        .limit(50)
        .snapshots(includeMetadataChanges: true);
    return Stack(children: [
      Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
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
                            //widget.fromConfirm != null ? Navigator.of(context).pop() : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()),);
                            Future.delayed(Duration.zero, () {

                              //Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });

                            //StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                          },
                        ),
                      ),
                    ],
                  ),
                  ///Title
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        AppLocalizations.of(context).allBookings,
                        textAlign: TextAlign.start,
                        style: BuytimeTheme.appbarTitle,
                      ),
                    ),
                  ),
                  ///Cart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: IconButton(
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
                                      MaterialPageRoute(builder: (context) => Cart(tourist: false,)),
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
                                        )
                                    );
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
                    ),
                  )
                ],
              ),
              body: SafeArea(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _orderStream,
                    builder: (context, AsyncSnapshot<QuerySnapshot> orderSnapshot) {
                      orderStateList.clear();
                      if (orderSnapshot.hasError || orderSnapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator()
                              ],
                            )
                          ],
                        );
                      }
                      orderSnapshot.data.docs.forEach((element) {
                        orderStateList.add(OrderState.fromJson(element.data()));
                      });
                      return CustomScrollView(shrinkWrap: true, slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            int ind;
                            OrderState order = orderStateList.elementAt(index);
                            for (int i = 0; i < orderStateList.length; i++) {
                              if (orderStateList[i].orderId == order.orderId) ind = i;
                            }
                            //debugPrint('UI_U_all_bookings => CART COUNT: ${order.date}');
                            ServiceState service = ServiceState().toEmpty();
                            StoreProvider.of<AppState>(context).state.notificationListState.notificationListState.forEach((element) {
                              if(element.notificationId != null && element.notificationId.isNotEmpty && order.orderId.isNotEmpty && order.orderId == element.data.state.orderId){
                                StoreProvider.of<AppState>(context).state.serviceList.serviceListState.forEach((s) {
                                  if(element.data.state.serviceId == s.serviceId)
                                    service = s;
                                });
                              }
                            });
                            return Column(
                              children: [
                                UserServiceListItem(order, widget.tourist, service),
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                  height: SizeConfig.safeBlockVertical * .2,
                                  color: BuytimeTheme.DividerGrey,
                                )
                              ],
                            );
                          },
                            childCount: orderStateList.length,
                          ),
                        )
                      ]);
                    }
                ),
              ),
            ),
          ),
        ),
      ),
      ///Ripple Effect
      rippleLoading
          ? Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3),
              height: double.infinity,
              decoration: BoxDecoration(
                color: BuytimeTheme.BackgroundCerulean.withOpacity(.8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: SizeConfig.safeBlockVertical * 20,
                      height: SizeConfig.safeBlockVertical * 20,
                      child: Center(
                        child: SpinKitRipple(
                          color: Colors.white,
                          size: SizeConfig.safeBlockVertical * 18,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      )
          : Container(),
    ]);
  }
}