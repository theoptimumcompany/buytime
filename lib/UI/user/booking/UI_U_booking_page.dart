import 'package:Buytime/UI/management/business/UI_M_business_list.dart';
import 'package:Buytime/UI/user/booking/UI_U_all_bookings.dart';
import 'package:Buytime/UI/user/booking/UI_U_notifications.dart';
import 'package:Buytime/UI/user/booking/widget/user_service_card_widget.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/landing/UI_U_landing.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/UI/user/search/UI_U_filter_general.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/booking_reducer.dart';
import 'package:Buytime/reblox/reducer/business_list_reducer.dart';
import 'package:Buytime/reblox/reducer/business_reducer.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/find_your_inspiration_card_widget.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingPage extends StatefulWidget {
  static String route = '/bookingPage';
  bool fromConfirm;

  BookingPage({Key key, this.fromConfirm}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController _searchController = TextEditingController();

  BookingState bookingState;
  BusinessState businessState;
  ServiceListState serviceListState;
  List<ServiceState> serviceList = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];
  List<OrderState> userOrderList = [];
  List<OrderState> orderList = [];

  List<CategoryState> row1 = [];
  List<CategoryState> row2 = [];
  List<CategoryState> row3 = [];
  List<CategoryState> row4 = [];

  List<CategoryState> rowLess1 = [];
  List<CategoryState> rowLess2 = [];

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

  void grid(List<CategoryState> l) {
    setState(() {
      if (l.length == 1) {
        row1 = [l[0]];
        rowLess1 = [l[0]];
      } else if (l.length == 2) {
        row1 = [l[0], l[1]];
        rowLess1 = [l[0], l[1]];
      } else if (l.length == 3) {
        row1 = [l[0], l[1], l[2]];
        rowLess1 = [l[0], l[1], l[2]];
      } else if (l.length == 4) {
        row1 = [l[0], l[1]];
        row2 = [l[2], l[3]];
        rowLess1 = [l[0], l[1]];
        rowLess2 = [l[2], l[3]];
      } else if (l.length == 5) {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      } else if (l.length == 6) {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4], l[5]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      } else if (l.length == 7) {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      } else if (l.length == 8) {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6], l[7]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      } else if (l.length == 9) {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6]];
        row4 = [l[7], l[8]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      } else {
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6], l[7]];
        row4 = [l[8], l[9]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }
    });
  }

  Widget inspiration(List<CategoryState> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///First showcase for each Row
        list.length >= 1
            ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2,
              list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[0], true, false),
        )
            : Container(),

        ///Second showcase for each Row
        list.length >= 2
            ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2,
              list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[1], true, false),
        )
            : Container(),

        ///Third showcase for each Row
        list.length == 3
            ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2,
              list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[2], true, false),
        )
            : Container(),
      ],
    );
  }

  void undoDeletion(index, item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      serviceList.insert(index, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.dispatch(UserOrderListRequest());
        startRequest = true;
        rippleLoading = true;
      },
      builder: (context, snapshot) {
        debugPrint('UI_U_BookingPage => Order List LENGTH: ${snapshot.orderList.orderListState.length}');
        orderList.clear();
        userOrderList.clear();
        DateTime currentTime = DateTime.now();
        currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
        snapshot.orderList.orderListState.forEach((element) {
          if((element.progress == 'paid' || element.progress == 'pending') && (element.date.isAtSameMomentAs(currentTime) || element.date.isAfter(currentTime)) && element.itemList.first.time != null)
            userOrderList.add(element);
        });
        orderList.addAll(snapshot.orderList.orderListState);
        userOrderList.sort((a,b) => a.date.isBefore(b.date) ? -1 : a.date.isAtSameMomentAs(b.date) ? 0 : 1);

        /*bookingState = snapshot.booking;
        businessState = snapshot.business;
        serviceListState = snapshot.serviceList;
        serviceList = serviceListState.serviceListState;
        categoryListState = snapshot.categoryList;
        categoryList = categoryListState.categoryListState;*/

        //debugPrint('UI_U_BookingPage: category list lenght => ${categoryList.length}');
        //debugPrint('UI_U_BookingPage: business logo => ${businessState.logo}');
        //debugPrint('UI_U_BookingPage: service list lenght => ${serviceList.length}');

        if(snapshot.categoryList.categoryListState.isNotEmpty && startRequest && rippleLoading){
          rippleLoading = false;
          startRequest = false;

          row1.clear();
          row2.clear();
          row3.clear();
          row4.clear();
          rowLess1.clear();
          rowLess2.clear();
          // no
          //grid(store.state.categoryList.categoryListState);
          List<CategoryState> l = snapshot.categoryList.categoryListState;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (l.isNotEmpty) grid(l);
          });
          bookingState = snapshot.booking;
          businessState = snapshot.business;
          serviceListState = snapshot.serviceList;
          serviceList = serviceListState.serviceListState.length >= 5 ? serviceListState.serviceListState.sublist(0,5) : serviceListState.serviceListState;
          categoryListState = snapshot.categoryList;
          categoryList = categoryListState.categoryListState;

          String startMonth = DateFormat('MM').format(bookingState.start_date);
          String endMonth = DateFormat('MM').format(bookingState.end_date);

          if (startMonth == endMonth)
            sameMonth = true;
          else
            sameMonth = false;
        }

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
                      Expanded(
                        flex: 1,
                        child: Row(
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
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landing()));
                                  });

                                  //StoreProvider.of<AppState>(context).dispatch(NavigatePopAction());
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///Title
                      Expanded(
                        flex: 2,
                        child: Utils.barTitle(snapshot.business.name),
                      ),
                      ///Cart
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Container(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.notifications_none_outlined,
                                            color: BuytimeTheme.TextWhite,
                                            size: 30.0,
                                          ),
                                          onPressed: () async{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      bottom: 20,
                                      left: 15,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                            color: BuytimeTheme.AccentRed,
                                            borderRadius: BorderRadius.all(Radius.circular(7.5))
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Flexible(
                                  child:
                                  Container(
                                    margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
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
                                          bottom: 20,
                                          left: 2.5,
                                          child: Align(
                                            alignment: Alignment.center,
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
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  body: SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(),
                          child: !rippleLoading ?
                          Container(
                            width: double.infinity,
                            color: BuytimeTheme.DividerGrey,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Business Logo
                                Container(
                                  //margin: EdgeInsets.only(left: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                  width: double.infinity,///25% SizeConfig.safeBlockVertical * 20
                                  height: 125,///25% SizeConfig.safeBlockVertical * 20
                                  decoration: BoxDecoration(
                                    color: Color(0xffE6E7E8),
                                    /*gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.orange.withOpacity(.5),
                                          Colors.white,
                                        ],
                                      )*/
                                  ),
                                  child: Container(
                                    //width: 300,
                                    height: 125,
                                    child: CachedNetworkImage(
                                      //width: 125,
                                      imageUrl: businessState.wide != null ? businessState.wide : 'https://firebasestorage.googleapis.com/v0/b/buytime-458a1.appspot.com/o/general%2Fimage_placeholder_200x200_1000x1000.png?alt=media&token=082a1896-32d8-4750-b7cc-141f00bc060c',
                                      imageBuilder: (context, imageProvider) => Container(
                                        //margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5), ///5%
                                        decoration: BoxDecoration(
                                          //borderRadius: BorderRadius.all(Radius.circular(SizeConfig.blockSizeHorizontal * 5)), ///12.5%
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitWidth,
                                            )
                                        ),
                                      ),
                                      placeholder: (context, url) => Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [CircularProgressIndicator()],
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                ///Greetings & Portfolio & Search
                                Flexible(
                                  child: Container(
                                    //height: SizeConfig.safeBlockVertical * 30,
                                    width: double.infinity,
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///Greetings
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                                          child: Text(
                                            //AppLocalizations.of(context).hi + bookingState.user.first.name,
                                            '${AppLocalizations.of(context).hi} ${Emojis.wavingHand}',
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w700, fontSize: 24

                                              ///SizeConfig.safeBlockHorizontal * 7
                                            ),
                                          ),
                                        ),
                                        ///Portfolio
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                          child: Text(
                                            AppLocalizations.of(context).yourHolidayInSpace + businessState.municipality,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16

                                              ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                        ///Date & Share
                                        Row(
                                          children: [
                                            ///Date
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0.5),
                                              child: Text(
                                                sameMonth
                                                    ? '${DateFormat('dd').format(bookingState.start_date)} - ${DateFormat('dd MMMM').format(bookingState.end_date)}'
                                                    : '${DateFormat('dd MMM').format(bookingState.start_date)} - ${DateFormat('dd MMM').format(bookingState.end_date)}',
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16

                                                  ///izeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                            ),
                                            ///Share
                                            Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                alignment: Alignment.center,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                      onTap: () {
                                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                        //Navigator.of(context).pop();
                                                        final RenderBox box = context.findRenderObject();
                                                        Share.share(AppLocalizations.of(context).share, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                                                      },
                                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                      child: Container(
                                                        padding: EdgeInsets.all(5.0),
                                                        child: Text(
                                                          AppLocalizations.of(context).share,
                                                          style: TextStyle(
                                                              letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                              fontFamily: BuytimeTheme.FontFamily,
                                                              color: BuytimeTheme.UserPrimary,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 16

                                                            ///SizeConfig.safeBlockHorizontal * 4
                                                          ),
                                                        ),
                                                      )),
                                                )),
                                          ],
                                        ),
                                        ///Search
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: SizeConfig.safeBlockVertical * 2,
                                              left: SizeConfig.safeBlockHorizontal * 5,
                                              right: SizeConfig.safeBlockHorizontal * 5,
                                              bottom: SizeConfig.safeBlockVertical * 4),
                                          height: SizeConfig.safeBlockHorizontal * 20,
                                          child: TextFormField(
                                            controller: _searchController,
                                            textAlign: TextAlign.start,
                                            textInputAction: TextInputAction.search,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffe0e0e0)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff666666)), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              labelText: AppLocalizations.of(context).whatAreYouLookingFor,
                                              helperText: AppLocalizations.of(context).searchForServicesAndIdeasAroundYou,
                                              labelStyle: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              helperStyle: TextStyle(
                                                fontFamily: BuytimeTheme.FontFamily,
                                                color: Color(0xff666666),
                                                fontWeight: FontWeight.w400,
                                              ),
                                              suffixIcon: InkWell(
                                                onTap: () {
                                                  debugPrint('done');
                                                  FocusScope.of(context).unfocus();
                                                  setState(() {
                                                    searched = _searchController.text;
                                                  });
                                                  _searchController.clear();
                                                  if (searched.isNotEmpty)
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => FilterGeneral(
                                                              searched: searched,
                                                            )));
                                                },
                                                child: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  Icons.search,
                                                  color: Color(0xff666666),
                                                ),
                                              ),
                                            ),
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextMedium, fontWeight: FontWeight.w400, fontSize: 16),
                                            onEditingComplete: () {
                                              debugPrint('done');
                                              FocusScope.of(context).unfocus();
                                              setState(() {
                                                searched = _searchController.text;
                                              });
                                              _searchController.clear();
                                              if (searched.isNotEmpty)
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => FilterGeneral(
                                                          searched: searched,
                                                        )));
                                            },
                                          ),
                                        ),
                                        ///My bookings & View all
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ///My bookings
                                                Container(
                                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 1),
                                                  child: Text(
                                                    AppLocalizations.of(context).myBookings,
                                                    style: TextStyle(
                                                      //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.TextBlack,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 18

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                ),
                                                ///View All
                                                Container(
                                                    margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                    alignment: Alignment.center,
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => AllBookings(orderStateList: orderList,)),);
                                                          },
                                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                          child: Container(
                                                            padding: EdgeInsets.all(5.0),
                                                            child: Text(
                                                              AppLocalizations.of(context).viewAll,
                                                              style: TextStyle(
                                                                  letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                  fontFamily: BuytimeTheme.FontFamily,
                                                                  color: BuytimeTheme.UserPrimary,
                                                                  fontWeight: FontWeight.w400,
                                                                  fontSize: 16

                                                                ///SizeConfig.safeBlockHorizontal * 4
                                                              ),
                                                            ),
                                                          )),
                                                    ))
                                              ],
                                            ),
                                            userOrderList.isNotEmpty ?
                                            ///List
                                            Container(
                                              height: 120,
                                              width: double.infinity,
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5),
                                              child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                SliverList(
                                                  delegate: SliverChildBuilderDelegate(
                                                        (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      OrderState order = userOrderList.elementAt(index);
                                                      return Container(
                                                        width: 151,
                                                        height: 100,
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                        child: UserServiceCardWidget(order),
                                                      );
                                                    },
                                                    childCount: userOrderList.length,
                                                  ),
                                                ),
                                              ]),
                                            ): Container(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ///Top Service
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 5),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///Top Services
                                        Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 3),
                                          child: Text(
                                            AppLocalizations.of(context).topServices,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 18

                                              ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                          ),
                                        ),
                                        ///List
                                        serviceList.isNotEmpty
                                            ?
                                        ///Service List
                                        Column(
                                          children: serviceList
                                              .map((ServiceState service) {
                                            int index;
                                            for (int i = 0; i < serviceList.length; i++) {
                                              if (serviceList[i].serviceId == service.serviceId) index = i;
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
                                                      serviceList.removeAt(index);
                                                    });
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');
                                                    if(StoreProvider.of<AppState>(context).state.user.getRole() == Role.user){
                                                      if (service.switchSlots) {
                                                        StoreProvider.of<AppState>(context).dispatch(OrderReservableListRequest(service.serviceId));
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: service, tourist: false,)),
                                                        );
                                                      } else {
                                                        order.business.name = snapshot.business.name;
                                                        order.business.id = snapshot.business.id_firestore;
                                                        order.user.name = snapshot.user.name;
                                                        order.user.id = snapshot.user.uid;
                                                        order.addItem(service, snapshot.business.ownerId);
                                                        order.cartCounter++;
                                                        //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                        StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                      }
                                                    }

                                                    undoDeletion(index, service);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      BookingListServiceListItem(service, false),
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
                                                    color: BuytimeTheme.UserPrimary,
                                                    //margin: EdgeInsets.symmetric(horizontal: 15),
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                                      child: Icon(
                                                        Icons.add_shopping_cart,
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
                                                  AppLocalizations.of(context).noActiveServiceFound,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                                ),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ///Inspiration
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                    color: BuytimeTheme.BackgroundWhite,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ///Inspiration
                                        /*Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      AppLocalizations.of(context).findYourInspirationHere,
                                      style: TextStyle(
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                    height: SizeConfig.safeBlockVertical * 50,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.AccentRed,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.Secondary,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 18,
                                                  height: SizeConfig.safeBlockVertical * 18,
                                                  color: BuytimeTheme.ManagerPrimary,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 28,
                                                  height: SizeConfig.safeBlockVertical * 28,
                                                  color: BuytimeTheme.BackgroundLightBlue,
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Container(
                                                  margin: EdgeInsets.all(SizeConfig.safeBlockVertical*.25),
                                                  //width: double.infinity,
                                                  //height: double.infinity,
                                                  width: SizeConfig.safeBlockVertical * 28,
                                                  height: SizeConfig.safeBlockVertical * 28,
                                                  color: BuytimeTheme.TextPurple,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )*/
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: SizeConfig.safeBlockHorizontal * 5,
                                              right: SizeConfig.safeBlockHorizontal * 5,
                                              top: SizeConfig.safeBlockVertical * 3,
                                              bottom: SizeConfig.safeBlockVertical * 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              ///Text
                                              Text(
                                                AppLocalizations.of(context).findYourInspirationHere,
                                                style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 18

                                                  ///SizeConfig.safeBlockHorizontal * 4
                                                ),
                                              ),
                                              ///Show All
                                              Container(
                                                //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                                  alignment: Alignment.center,
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        onTap: () {
                                                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
                                                          //Navigator.of(context).pop();
                                                          setState(() {
                                                            showAll = !showAll;
                                                          });
                                                        },
                                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        child: Container(
                                                          padding: EdgeInsets.all(5.0),
                                                          child: Text(
                                                            !showAll ? AppLocalizations.of(context).showAll : AppLocalizations.of(context).showLess,
                                                            style: TextStyle(
                                                                letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                                fontFamily: BuytimeTheme.FontFamily,
                                                                color: BuytimeTheme.UserPrimary,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16

                                                              ///SizeConfig.safeBlockHorizontal * 4
                                                            ),
                                                          ),
                                                        )),
                                                  ))
                                            ],
                                          ),
                                        ),

                                        ///Category List
                                        categoryList.isNotEmpty
                                            ? Container(
                                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                            //height: SizeConfig.safeBlockVertical * 50,
                                            width: double.infinity,
                                            child: Column(
                                              children: [
                                                !showAll && rowLess1.isNotEmpty ? inspiration(rowLess1) : Container(),
                                                !showAll && rowLess2.isNotEmpty ? inspiration(rowLess2) : Container(),
                                                showAll && row1.isNotEmpty ? inspiration(row1) : Container(),
                                                showAll && row2.isNotEmpty ? inspiration(row2) : Container(),
                                                showAll && row3.isNotEmpty ? inspiration(row3) : Container(),
                                                showAll && row4.isNotEmpty ? inspiration(row4) : Container(),
                                              ],
                                            ))
                                            :

                                        ///No Category
                                        Container(
                                          height: SizeConfig.safeBlockVertical * 8,
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                          decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                          child: Center(
                                              child: Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppLocalizations.of(context).noActiveServiceFound,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                                ),
                                              )),
                                        ),

                                        ///Contact
                                        Container(
                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                                          //height: SizeConfig.safeBlockVertical * 28,
                                          width: double.infinity,
                                          color: BuytimeTheme.BackgroundWhite,
                                          child: Column(
                                            children: [
                                              ///Contact
                                              Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 0, right: SizeConfig.safeBlockHorizontal * 0),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
                                                  child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        onTap: () async {
                                                          String url = businessState.phone_number;
                                                          debugPrint('Restaurant phonenumber: ' + url);
                                                          if (await canLaunch('tel:$url')) {
                                                            await launch('tel:$url');
                                                          } else {
                                                            throw 'Could not launch $url';
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 2),
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4, right: SizeConfig.safeBlockHorizontal * 4),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              ///Text
                                                              Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      AppLocalizations.of(context).speakWith + businessState.responsible_person_name,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 16

                                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                                                    child: Text(
                                                                      AppLocalizations.of(context).yourDedicatedAdvisor,
                                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w400, fontSize: 14

                                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              ///Icon
                                                              Icon(
                                                                Icons.call,
                                                                color: BuytimeTheme.ActionButton,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))),
                                              Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10),
                                                height: SizeConfig.safeBlockVertical * .2,
                                                color: BuytimeTheme.DividerGrey,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ///Goto Business Management
                                StoreConnector<AppState, AppState>(
                                    converter: (store) => store.state,
                                    builder: (context, snapshot) {
                                      isManagerOrAbove = snapshot.user != null && (snapshot.user.getRole() != Role.user) ? true : false;
                                      return isManagerOrAbove
                                          ? Flexible(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.white,
                                          height: 60,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                                StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => UI_M_BusinessList()),
                                                );
                                              },
                                              child: CustomBottomButtonWidget(
                                                  Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                    child: Text(
                                                      AppLocalizations.of(context).goToBusiness,
                                                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: Colors.black.withOpacity(.7), fontWeight: FontWeight.w500, fontSize: 16),
                                                    ),
                                                  ),
                                                  '',
                                                  Container(
                                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                    child: Icon(
                                                      Icons.business_center,
                                                      color: BuytimeTheme.SymbolGrey,
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      )
                                          : Container();
                                    }),
                                ///Log out
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    height: 60,
                                    padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                          onTap: () async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            await prefs.setBool('easy_check_in', false);
                                            await prefs.setBool('star_explanation', false);

                                            FirebaseAuth.instance.signOut().then((_) {
                                              googleSignIn.signOut();
                                              //Svuotare lo Store sul Logout
                                              StoreProvider.of<AppState>(context).dispatch(SetCategoryToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetCategoryListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetCategoryTreeToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetOrderToEmpty(""));
                                              StoreProvider.of<AppState>(context).dispatch(SetOrderListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetBookingListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetBookingToEmpty(''));
                                              StoreProvider.of<AppState>(context).dispatch(SetBusinessToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetBusinessListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetServiceToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetServiceListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetServiceSlotToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetPipelineToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetPipelineListToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetStripeToEmpty());
                                              StoreProvider.of<AppState>(context).dispatch(SetUserStateToEmpty());
                                              //Torno al Login
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(builder: (context) => Home()),
                                              );
                                            });
                                          },
                                          child: CustomBottomButtonWidget(
                                              Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                child: Text(
                                                  AppLocalizations.of(context).logOut,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w500, fontSize: 16),
                                                ),
                                              ),
                                              '',
                                              Container(
                                                margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1.5),
                                                child: Icon(
                                                  MaterialDesignIcons.exit_to_app,
                                                  color: BuytimeTheme.SymbolGrey,
                                                ),
                                              ))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) :
                          Container(
                            color: BuytimeTheme.BackgroundWhite,
                          ),
                        ),
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