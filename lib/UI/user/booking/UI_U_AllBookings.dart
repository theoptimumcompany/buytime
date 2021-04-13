import 'package:Buytime/UI/user/cart/UI_U_Cart.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/booking/widget/user_service_list_item.dart';

class AllBookings extends StatefulWidget {
  static String route = '/bookingPage';
  bool fromConfirm;
  List<OrderState> orderStateList;
  AllBookings({Key key, this.fromConfirm, this.orderStateList}) : super(key: key);

  @override
  _AllBookingsState createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings> {
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
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        //store.dispatch(UserOrderListRequest());
        //startRequest = true;
        //rippleLoading = true;
      },
      builder: (context, snapshot) {
        debugPrint('UI_U_BookingPage => Order List LENGTH: ${snapshot.orderList.orderListState.length}');
        orderList.clear();
        orderList.addAll(snapshot.orderList.orderListState);
        widget.orderStateList.sort((a,b) => b.date.isBefore(a.date) ? -1 : b.date.isAtSameMomentAs(a.date) ? 0 : 1);
        /*bookingState = snapshot.booking;
        businessState = snapshot.business;
        serviceListState = snapshot.serviceList;
        serviceList = serviceListState.serviceListState;
        categoryListState = snapshot.categoryList;
        categoryList = categoryListState.categoryListState;*/

        //debugPrint('UI_U_BookingPage: category list lenght => ${categoryList.length}');
        //debugPrint('UI_U_BookingPage: business logo => ${businessState.logo}');
        //debugPrint('UI_U_BookingPage: service list lenght => ${serviceList.length}');

        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
        debugPrint('UI_U_BookingPage => CART COUNT: ${order.cartCounter}');

        return Stack(children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  appBar: BuytimeAppbar(
                    background: BuytimeTheme.UserPrimary,
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
                    child: SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: Container(
                            width: double.infinity,
                            //color: BuytimeTheme.DividerGrey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Orders
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: widget.orderStateList
                                              .map((OrderState order) {
                                            int index;
                                            for (int i = 0; i <  widget.orderStateList.length; i++) {
                                              if ( widget.orderStateList[i].orderId == order.orderId) index = i;
                                            }
                                            return Column(
                                              children: [
                                                UserServiceListItem(order),
                                                Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                                  height: SizeConfig.safeBlockVertical * .2,
                                                  color: BuytimeTheme.DividerGrey,
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
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
                          width: 50,
                          height: 50,
                          child: Center(
                            child: SpinKitRipple(
                              color: Colors.white,
                              size: 50,
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
      },
    );
  }
}