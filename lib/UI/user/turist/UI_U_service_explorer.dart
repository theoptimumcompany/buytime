import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/login/UI_U_home.dart';
import 'package:Buytime/UI/user/turist/widget/discover_card_widget.dart';
import 'package:Buytime/UI/user/turist/widget/p_r_card_widget.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
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
import 'package:Buytime/reblox/reducer/pipeline_list_reducer.dart';
import 'package:Buytime/reblox/reducer/pipeline_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_reducer.dart';
import 'package:Buytime/reblox/reducer/service/service_slot_time_reducer.dart';
import 'package:Buytime/reblox/reducer/stripe_payment_reducer.dart';
import 'package:Buytime/reblox/reducer/user_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/custom_bottom_button_widget.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceExplorer extends StatefulWidget {
  static String route = '/serviceExplorer';
  bool fromBookingPage;
  String searched;

  ServiceExplorer({Key key, this.fromBookingPage, this.searched}) : super(key: key);

  @override
  _ServiceExplorerState createState() => _ServiceExplorerState();
}

class _ServiceExplorerState extends State<ServiceExplorer> {
  TextEditingController _searchController = TextEditingController();
  //List<ServiceState> serviceState = [];
  List<ServiceState> popularList = [];
  List<ServiceState> recommendedList = [];
  List<CategoryState> categoryList = [];

  String sortBy = '';
  OrderState order = OrderState().toEmpty();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searched;
  }

  /*void undoDeletion(index, item) {
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}

    setState(() {
      tmpServiceList.insert(index, item);
    });
  }*/
  void searchCategory(List<CategoryState> list) {
    setState(() {
      List<CategoryState> categoryState = list;
      categoryList.clear();
      if (_searchController.text.isNotEmpty) {
        categoryState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            categoryList.add(element);
          }
          if(element.customTag != null && element.customTag.isNotEmpty && element.customTag.toLowerCase().contains(_searchController.text.toLowerCase())) {
            if(!categoryList.contains(element)){
              categoryList.add(element);
            }
          }
        });
      }
      //popularList.shuffle();
    });
  }
  void searchPopular(List<ServiceState> list) {
    setState(() {
      List<ServiceState> serviceState = list;
      popularList.clear();
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            popularList.add(element);
          }
          if(element.tag != null && element.tag.isNotEmpty){
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if(!popularList.contains(element)){
                  popularList.add(element);
                }
              }
            });
          }
        });
      }
      popularList.shuffle();
    });
  }
  void searchRecommended(List<ServiceState> list) {
    setState(() {
      recommendedList.clear();
      List<ServiceState> serviceState = list;
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            recommendedList.add(element);
          }
          if(element.tag != null && element.tag.isNotEmpty){
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if(!recommendedList.contains(element)){
                  recommendedList.add(element);
                }
              }
            });
          }
        });
      }
      recommendedList.shuffle();
    });
  }
  bool startRequest = false;
  bool noActivity = false;


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.state.categoryList.categoryListState.clear();
        store.state.serviceList.serviceListState.clear();
        store.dispatch(AllRequestListCategory());
        startRequest = true;
      },
      builder: (context, snapshot) {
        if(_searchController.text.isEmpty){
          categoryList.clear();
          popularList.clear();
          recommendedList.clear();

          if(snapshot.categoryList.categoryListState.isEmpty && snapshot.serviceList.serviceListState.isEmpty && startRequest){
            noActivity = true;
          }else{
            if(snapshot.categoryList.categoryListState.isNotEmpty && snapshot.serviceList.serviceListState.isNotEmpty && categoryList.isEmpty && popularList.isEmpty && recommendedList.isEmpty || _searchController.text.isEmpty){
              categoryList.addAll(snapshot.categoryList.categoryListState);
              popularList.addAll(snapshot.serviceList.serviceListState);
              recommendedList.addAll(snapshot.serviceList.serviceListState);
              if(snapshot.categoryList.categoryListState.isNotEmpty && snapshot.serviceList.serviceListState.isNotEmpty && categoryList.isEmpty && popularList.isEmpty && recommendedList.isEmpty){
                categoryList.shuffle();
              }
              popularList.shuffle();
              recommendedList.shuffle();
            }
            if(categoryList.isNotEmpty && categoryList.first.name == null)
              categoryList.removeLast();
            if(popularList.isNotEmpty && popularList.first.name == null)
              popularList.removeLast();
            if(recommendedList.isNotEmpty && recommendedList.first.name == null)
              recommendedList.removeLast();
            noActivity = false;
            //categoryList.shuffle();
            //popularList.shuffle();
            //recommendedList.shuffle();
          }
        }
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
              appBar: BuytimeAppbar(
                background: BuytimeTheme.BackgroundCerulean,
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
                              Navigator.of(context).pop();
                            });
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
                        AppLocalizations.of(context).buytime,
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
                                      MaterialPageRoute(builder: (context) => Cart(tourist: true,)),
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
                          ///Search
                          Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
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
                                //hintText: "email *",
                                //hintStyle: TextStyle(color: Color(0xff666666)),
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
                                    searchCategory(snapshot.categoryList.categoryListState);
                                    searchPopular(snapshot.serviceList.serviceListState);
                                    searchRecommended(snapshot.serviceList.serviceListState);
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
                                searchCategory(snapshot.categoryList.categoryListState);
                                searchPopular(snapshot.serviceList.serviceListState);
                                searchRecommended(snapshot.serviceList.serviceListState);
                              },
                            ),
                          ),
                          ///Discover
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                              height: categoryList.isNotEmpty ? 170 : 160,
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Discover
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      AppLocalizations.of(context).discover,
                                      style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 32
                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  categoryList.isNotEmpty ?
                                  ///List
                                  Container(
                                    height: 90,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                    child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                            CategoryState category = categoryList.elementAt(index);
                                            return Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                              child: DiscoverCardWidget(80, 80, category, true),
                                            );
                                          },
                                          childCount: categoryList.length,
                                        ),
                                      ),
                                    ]),
                                  )  :
                                  noActivity ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                        child: CircularProgressIndicator(),
                                      )
                                    ],
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
                                            AppLocalizations.of(context).noCategoryFound,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ///Popular
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                              height: popularList.isNotEmpty ? 310 : 200,
                              color: Color(0xff1E3C4F),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Popular
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                    child: Text(
                                      AppLocalizations.of(context).popular,
                                      style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextWhite,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18
                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  ///Text
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                    child: Text(
                                      AppLocalizations.of(context).popularSlogan,
                                      style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextWhite,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  popularList.isNotEmpty ?
                                  ///List
                                  Container(
                                    height: 220,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                    child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                            ServiceState service = popularList.elementAt(index);
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                  child: PRCardWidget(182, 182, service, false),
                                                ),
                                                Container(
                                                  width: 180,
                                                  alignment: Alignment.topLeft,
                                                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      service.name,
                                                      style: TextStyle(
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextWhite,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          childCount: popularList.length,
                                        ),
                                      ),
                                    ]),
                                  )  :
                                  noActivity ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 200/4),
                                        child: CircularProgressIndicator(),
                                      )
                                    ],
                                  ) :
                                  _searchController.text.isNotEmpty
                                      ? Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  )
                                      : popularList.isEmpty
                                      ? Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).noServiceFound,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  ) :
                                  ///No List
                                  Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
                                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).noServiceFound,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextWhite, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ///Recommended
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                              padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                              height: recommendedList.isNotEmpty ? 310 : 200,
                              color: BuytimeTheme.BackgroundWhite,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Recommended
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                    child: Text(
                                      AppLocalizations.of(context).recommended,
                                      style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18
                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  ///Text
                                  Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                    child: Text(
                                      AppLocalizations.of(context).recommendedSlogan,
                                      style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                          fontFamily: BuytimeTheme.FontFamily,
                                          color: BuytimeTheme.TextBlack,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14
                                        ///SizeConfig.safeBlockHorizontal * 4
                                      ),
                                    ),
                                  ),
                                  recommendedList.isNotEmpty ?
                                  ///List
                                  Container(
                                    height: 220,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                    child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (context, index) {
                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                            ServiceState service = recommendedList.elementAt(index);
                                            return Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                  child: PRCardWidget(182, 182, service, false),
                                                ),
                                                Container(
                                                  width: 180,
                                                  alignment: Alignment.topLeft,
                                                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1),
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      service.name,
                                                      style: TextStyle(
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 14 ///SizeConfig.safeBlockHorizontal * 4
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          childCount: recommendedList.length,
                                        ),
                                      ),
                                    ]),
                                  )  :
                                  noActivity ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 200/4),
                                        child: CircularProgressIndicator(),
                                      )
                                    ],
                                  ) :
                                  _searchController.text.isNotEmpty
                                      ? Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                    decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                        child: Container(
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                            style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                          ),
                                        )),
                                  )
                                      : recommendedList.isEmpty
                                      ? Container(
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
                                  ) :
                                  ///No List
                                  Container(
                                    height: SizeConfig.safeBlockVertical * 8,
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3),
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ///Log out
                          Container(
                            color: Colors.white,
                            height: 64,
                            //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                            margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();

                                    await prefs.setBool('easy_check_in', false);
                                    await prefs.setBool('star_explanation', false);

                                    FirebaseAuth.instance.signOut().then((_) {
                                      googleSignIn.signOut();
                                      //Resetto il carrello
                                      //cartCounter = 0;
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
                                      drawerSelection = DrawerSelection.BusinessList;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home()),
                                      );
                                    });
                                  },
                                  child: CustomBottomButtonWidget(
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                        child: Text(
                                          AppLocalizations.of(context).logOut,
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextBlack,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      '',
                                      Container(
                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2.5),
                                        child:  Icon(
                                          MaterialDesignIcons.exit_to_app,
                                          color: BuytimeTheme.SymbolGrey,
                                        ),
                                      )
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
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
