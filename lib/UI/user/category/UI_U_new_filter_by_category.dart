import 'package:Buytime/UI/user/booking/RUI_notification_bell.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/search/UI_U_filter_general.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/UI/user/turist/RUI_U_service_explorer.dart';
import 'package:Buytime/UI/user/turist/widget/new_discover_card_widget.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/snippet/service_list_snippet_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/appbar/w_buytime_appbar.dart';
import 'package:Buytime/reusable/w_service_list_item.dart';
import 'package:Buytime/reusable/icon/buytime_icons.dart';
import 'package:Buytime/reusable/w_find_your_inspiration_card.dart';
import 'package:Buytime/reusable/icon/material_design_icons.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';

class NewFilterByCategory extends StatefulWidget {
  static String route = '/filterByCategory';
  CategoryState categoryState;
  List<CategoryState> categoryList;
  List<OrderState> orderList;

  Widget create(BuildContext context) {
    //final pageIndex = context.watch<Spinner>();
    return ChangeNotifierProvider<CategoryService>(
      create: (_) => CategoryService([], []),
      child: NewFilterByCategory(this.categoryState, this.categoryList, this.orderList),
    );
  }
  NewFilterByCategory(this.categoryState, this.categoryList, this.orderList);

  @override
  _NewFilterByCategoryState createState() => _NewFilterByCategoryState();
}

class _NewFilterByCategoryState extends State<NewFilterByCategory> {
  TextEditingController _searchController = TextEditingController();
  List<Widget> subCategories = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];
  List<CategoryState> subCategoryList = [];
  List<ServiceState> serviceState = [];
  List<ServiceState> tmpServiceList = [];
  List<ServiceState> serviceList = [];
  String searched = '';
  String sortBy = '';

  OrderState order = OrderState().toEmpty();

  bool showAll = false;
  List<CategoryState> row1 = [];
  List<CategoryState> row2 = [];
  List<CategoryState> row3 = [];
  List<CategoryState> row4 = [];

  List<CategoryState> rowLess1 = [];
  List<CategoryState> rowLess2 = [];

  Map<String, List<String>> categoryListIds = Map();
  Map<String, List<String>> subCategoryListIds = Map();

  Stream<QuerySnapshot> categoryServices;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

    });
    debugPrint('UI_U_new_filter_by_category => BEFORE THIS CATEGORY ID LIST: ${widget.categoryState.categoryIdList}');
    widget.categoryList.forEach((element) {
      if(element.parent.id == widget.categoryState.id){
        debugPrint('UI_U_new_filter_by_category => SUB CATEGORY: ${element.id}');
        subCategoryList.add(element);
        /*element.categoryIdList.forEach((id) {
          widget.categoryState.categoryIdList.remove(id);
        });*/
      }
      if(element.level == 0 && widget.categoryState.id != element.id)
        categoryList.add(element);
    });
    debugPrint('UI_U_new_filter_by_category => AFTER THIS CATEGORY ID LIST: ${widget.categoryState.categoryIdList}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      grid(categoryList);
    });

  }

  void undoDeletion(index, item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      tmpServiceList.insert(index, item);
    });
  }

  void search(List<ServiceState> list) {
    setState(() {
      serviceState = list;
      tmpServiceList.clear();
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            tmpServiceList.add(element);
          }
          if (element.tag != null && element.tag.isNotEmpty) {
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if (!tmpServiceList.contains(element)) {
                  tmpServiceList.add(element);
                }
              }
            });
          }
        });
      }
      Provider.of<CategoryService>(context, listen: false).searchedList = tmpServiceList;
    });
  }

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

  Widget inspiration(List<CategoryState> list, int pos) {
    List<String> i1 = [];
    List<String> i2 = [];
    List<String> i3 = [];
    for (int i = 0; i < list.length; i++) {
      categoryListIds.forEach((key, value) {
        if (key == list[i].name) {
          if (i == 0)
            i1 = value;
          else if (i == 1)
            i2 = value;
          else
            i3 = value;
        }
      });
    }
    debugPrint('UI_U_filter_by_category => i1: ${i1} - i2: ${i2} - i3: ${i3}');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///First showcase for each Row
        list.length >= 1
            ? Flexible(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.all(2.5),
                    child: NewDiscoverCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[0], false, widget.categoryList, 0, widget.orderList)),
                //FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[0], false, true, i1, pos, 0, false),
              )
            : Container(),

        ///Second showcase for each Row
        list.length >= 2
            ? Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.all(2.5),
                    child: NewDiscoverCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[1], false, widget.categoryList, 1, widget.orderList)),
                //FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[1], false, true, i2, pos, 1, false),
              )
            : Container(),

        ///Third showcase for each Row
        list.length == 3
            ? Flexible(
                flex: 1,
                child: Container(
                    margin: EdgeInsets.all(2.5),
                    child: NewDiscoverCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[2], false, widget.categoryList, 2, widget.orderList)),
                //FindYourInspirationCardWidget(list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list.length <= 2 ? SizeConfig.screenWidth / 2 - 2 : SizeConfig.screenWidth / 3 - 2, list[2], false, true, i3, pos, 2, false),
              )
            : Container(),
      ],
    );
  }

  void createSubCategoryList(CategoryState element) {
    bool found = false;
    subCategoryList.forEach((cL) {
      if (cL.name == element.name) found = true;
    });

    if (!found) {
      subCategoryList.add(element);
      subCategoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      if (!subCategoryListIds[element.name].contains(element.id)) {
        subCategoryListIds[element.name].add(element.id);
      }
    }
  }

  void createCategoryList(CategoryState element) {
    bool found = false;
    categoryList.forEach((cL) {
      if (cL.name == element.name) {
        debugPrint('UI_U_filter_by_category => EQUAL CATEGORY NAME: ${element.name} - ${element.id} - ${element.businessId}');
        found = true;
      }
    });

    if (!found) {
      debugPrint('UI_U_filter_by_category => ADD CATEGORY NAME: ${element.name} - ${element.id} - ${element.businessId}');
      categoryList.add(element);
      categoryListIds.putIfAbsent(element.name, () => [element.id]);
    } else {
      debugPrint('UI_U_filter_by_category => ADD EQUAL ? CATEGORY NAME: ${element.name} - ${element.id} - ${element.businessId}');
      if (!categoryListIds[element.name].contains(element.id)) {
        debugPrint('UI_U_filter_by_category => ADD EQUAL CATEGORY NAME: ${element.name} - ${element.id}  - ${element.businessId}');
        categoryListIds[element.name].add(element.id);
      }
    }

    categoryListIds.forEach((key, value) {
      debugPrint('UI_U_filter_by_category => IDS: $key | $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        List<String> tmpCategoryIdList = [];
        widget.categoryList.forEach((category) {
          if(widget.categoryState.id == category.id)
            tmpCategoryIdList = category.categoryIdList;
        });
        if (StoreProvider.of<AppState>(context).state.area != null && StoreProvider.of<AppState>(context).state.area.areaId != null && StoreProvider.of<AppState>(context).state.area.areaId.isNotEmpty) {
          categoryServices = FirebaseFirestore.instance.collection("service")
              .where("tag", arrayContains: StoreProvider.of<AppState>(context).state.area.areaId)
              .where("visibility", isEqualTo: 'Active')
              //.where('categoryId', arrayContainsAny: tmpCategoryIdList.length > 10 ? tmpCategoryIdList.sublist(0, 10) : tmpCategoryIdList)
              .where('categoryId', arrayContainsAny: widget.categoryState.categoryIdList)
          //.limit(4)
              .snapshots(includeMetadataChanges: true);
        }else{
          categoryServices = FirebaseFirestore.instance.collection("service")
              .where("visibility", isEqualTo: 'Active')
              //.where('categoryId', arrayContainsAny: tmpCategoryIdList.length > 10 ? tmpCategoryIdList.sublist(0, 10) : tmpCategoryIdList)
              .where('categoryId', arrayContainsAny: widget.categoryState.categoryIdList)
          //.limit(4)
              .snapshots(includeMetadataChanges: true);
        }

      },
      builder: (context, snapshot) {
        List<ServiceState> s = [];
        Locale myLocale = Localizations.localeOf(context);

        /*if (sortBy == 'A-Z') {
          Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
        } else if (sortBy == 'Z-A'){
          Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
        }*//*else
            tmpServiceList.shuffle();*/

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
                          widget.categoryState.name,
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
                    constraints: BoxConstraints(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Just show me
                        subCategoryList.isNotEmpty
                            ? Flexible(
                                child: Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                                  padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                  height: subCategoryList.isNotEmpty ? SizeConfig.safeBlockVertical * 28 : SizeConfig.safeBlockVertical * 19,
                                  color: BuytimeTheme.BackgroundWhite,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///Just show me
                                      Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                        child: Text(
                                          AppLocalizations.of(context).justShowMe,
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
                                      subCategoryList.isNotEmpty
                                          ?
                                          ///List
                                          Container(
                                              height: SizeConfig.screenWidth / 3,
                                              width: double.infinity,
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                SliverList(
                                                  delegate: SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                                      CategoryState category = subCategoryList.elementAt(index);
                                                      return Container(
                                                        margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, right: SizeConfig.safeBlockHorizontal * 1),
                                                        child: NewDiscoverCardWidget(SizeConfig.screenWidth / 3 - 2, SizeConfig.screenWidth / 3 - 2, category, false, widget.categoryList, index, widget.orderList),
                                                        //FindYourInspirationCardWidget(SizeConfig.screenWidth / 3 - 2, SizeConfig.screenWidth / 3 - 2, category, false, widget.tourist, subCategoryListIds[category.name], 0, index, true),
                                                      );
                                                    },
                                                    childCount: subCategoryList.length,
                                                  ),
                                                ),
                                              ]),
                                            )
                                          :

                                          ///No List
                                          Container(
                                              height: SizeConfig.safeBlockVertical * 8,
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                              decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                              child: Center(
                                                  child: Container(
                                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  AppLocalizations.of(context).noSubCategoryFound,
                                                  style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                                ),
                                              )),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),

                        ///Divider
                        subCategoryList.isNotEmpty
                            ? Container(
                                color: BuytimeTheme.DividerGrey,
                                height: SizeConfig.safeBlockVertical * 2,
                              )
                            : Container(),

                        ///Search & List
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 2),
                            //height: SizeConfig.safeBlockVertical * 28,
                            width: double.infinity,
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ///Search
                                /*Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5),
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
                                          debugPrint('UI_U_filter_by_category => done');
                                          FocusScope.of(context).unfocus();
                                          search(serviceList);
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
                                      debugPrint('UI_U_filter_by_category => done');
                                      FocusScope.of(context).unfocus();
                                      search(serviceList);
                                    },
                                  ),
                                ),*/
                                Container(
                                  margin: EdgeInsets.only(
                                      top: SizeConfig.safeBlockVertical * 3,
                                      left: SizeConfig.safeBlockHorizontal * 3.5,
                                      bottom: SizeConfig.safeBlockVertical * 1,
                                      right: _searchController.text.isNotEmpty ? SizeConfig.safeBlockHorizontal * .5 : SizeConfig.safeBlockHorizontal * 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Search
                                      Flexible(
                                        child: Container(
                                          //width: SizeConfig.safeBlockHorizontal * 60,
                                          // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), border: Border.all(color: Colors.grey)),
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
                                                  debugPrint('UI_U_filter_by_category => done');
                                                  FocusScope.of(context).unfocus();
                                                  search(Provider.of<CategoryService>(context, listen: false).serviceList);
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
                                              debugPrint('UI_U_filter_by_category => done');
                                              FocusScope.of(context).unfocus();
                                              search(Provider.of<CategoryService>(context, listen: false).serviceList);
                                            },
                                          ),
                                        ),
                                      ),
                                      _searchController.text.isNotEmpty
                                          ? Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            BuytimeIcons.remove,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                              //search(Provider.of<CategoryService>(context, listen: false).serviceList);
                                              //first = false;
                                            });
                                          },
                                        ),
                                      )
                                          : Container()
                                    ],
                                  ),
                                ),
                                ///Sort
                                Container(
                                  //width: SizeConfig.safeBlockHorizontal * 20,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        //width: SizeConfig.safeBlockHorizontal * 20,
                                        margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                        child: DropdownButton(
                                          underline: Container(),
                                          hint: Row(
                                            children: [
                                              Icon(
                                                Icons.sort,
                                                color: BuytimeTheme.TextMedium,
                                                size: 24,
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Text(
                                                    AppLocalizations.of(context).sortBy,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                      color: BuytimeTheme.TextMedium,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 4),
                                                  child: Text(
                                                    sortBy,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,

                                                      ///SizeConfig.safeBlockHorizontal * 4
                                                      color: BuytimeTheme.TextBlack,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          isExpanded: false,
                                          iconSize: 0,
                                          style: TextStyle(color: Colors.blue),
                                          items: ['A-Z', 'Z-A'].map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10.0),
                                                        child: Text(
                                                          val,
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: BuytimeTheme.TextMedium,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    sortBy == val
                                                        ? Icon(
                                                            MaterialDesignIcons.done,
                                                            color: BuytimeTheme.TextMedium,
                                                            size: SizeConfig.safeBlockHorizontal * 5,
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                //_dropDownValue = val;
                                                sortBy = val;
                                                // if (sortBy == 'A-Z') {
                                                //   Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
                                                // } else {
                                                //   Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
                                                // }
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                          stream: categoryServices,
                                          builder: (context, AsyncSnapshot<QuerySnapshot> categoryServicesSnapshot) {
                                            if (categoryServicesSnapshot.hasError || categoryServicesSnapshot.connectionState == ConnectionState.waiting) {
                                              debugPrint('RUI_U_service_explorer => CATEGORY SERVICE WAITING');
                                              return Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ///Discover
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 3.5, bottom: SizeConfig.safeBlockVertical * 2),
                                                      //padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 150,
                                                      width: double.infinity,
                                                      color: BuytimeTheme.BackgroundWhite,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Discover
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 0, top: 5, bottom: 5),
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
                                                          ///List
                                                          Flexible(
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    CategoryState category = CategoryState().toEmpty();
                                                                    //debugPrint('RUI_U_service_explorer => ${category.name}: ${categoryListIds[category.name]}');
                                                                    return  Container(
                                                                      width: 100,
                                                                      height: 100,
                                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0, right: 5),
                                                                      child: Utils.imageShimmer(100, 100),
                                                                    );
                                                                  },
                                                                  childCount: 10,
                                                                ),
                                                              ),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  ///Popular
                                                  Flexible(
                                                    child: Container(
                                                      margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                      height: 310,
                                                      color: Colors.white,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ///Popular
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
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
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
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
                                                          Container(
                                                            height: 220,
                                                            width: double.infinity,
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                            child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                              SliverList(
                                                                delegate: SliverChildBuilderDelegate(
                                                                      (context, index) {
                                                                    //MenuItemModel menuItem = menuItems.elementAt(index);
                                                                    //ServiceState service = popularList.elementAt(index);
                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                                          child: Utils.imageShimmer(182, 182),
                                                                        ),
                                                                        Container(
                                                                          width: 180,
                                                                          alignment: Alignment.topLeft,
                                                                          margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                                          child: Utils.textShimmer(150, 10),
                                                                        )
                                                                      ],
                                                                    );
                                                                  },
                                                                  childCount: 10,
                                                                ),
                                                              ),
                                                            ]),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  ///Recommended
                                                  // Flexible(
                                                  //   child: Container(
                                                  //     margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 0),
                                                  //     padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                                                  //     height: 310,
                                                  //     color: BuytimeTheme.BackgroundWhite,
                                                  //     child: Column(
                                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //       children: [
                                                  //         ///Recommended
                                                  //         Container(
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: 20, bottom: SizeConfig.safeBlockVertical * 0.5),
                                                  //           child: Text(
                                                  //             AppLocalizations.of(context).recommended,
                                                  //             style: TextStyle(
                                                  //               //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                  //                 fontFamily: BuytimeTheme.FontFamily,
                                                  //                 color: BuytimeTheme.TextBlack,
                                                  //                 fontWeight: FontWeight.w700,
                                                  //                 fontSize: 18
                                                  //
                                                  //               ///SizeConfig.safeBlockHorizontal * 4
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         ///Text
                                                  //         Container(
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * .5),
                                                  //           child: Text(
                                                  //             AppLocalizations.of(context).recommendedSlogan,
                                                  //             style: TextStyle(
                                                  //               //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                                  //                 fontFamily: BuytimeTheme.FontFamily,
                                                  //                 color: BuytimeTheme.TextBlack,
                                                  //                 fontWeight: FontWeight.w500,
                                                  //                 fontSize: 14
                                                  //
                                                  //               ///SizeConfig.safeBlockHorizontal * 4
                                                  //             ),
                                                  //           ),
                                                  //         ),
                                                  //         Container(
                                                  //           height: 220,
                                                  //           width: double.infinity,
                                                  //           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0, bottom: SizeConfig.safeBlockVertical * 0),
                                                  //           child: CustomScrollView(shrinkWrap: true, scrollDirection: Axis.horizontal, slivers: [
                                                  //             SliverList(
                                                  //               delegate: SliverChildBuilderDelegate(
                                                  //                     (context, index) {
                                                  //                   //MenuItemModel menuItem = menuItems.elementAt(index);
                                                  //                   //ServiceState service = popularList.elementAt(index);
                                                  //                   return Column(
                                                  //                     mainAxisAlignment: MainAxisAlignment.start,
                                                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                     children: [
                                                  //                       Container(
                                                  //                         margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                                  //                         child: Utils.imageShimmer(182, 182),
                                                  //                       ),
                                                  //                       Container(
                                                  //                         width: 180,
                                                  //                         alignment: Alignment.topLeft,
                                                  //                         margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 1, left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 1.5),
                                                  //                         child: Utils.textShimmer(150, 10),
                                                  //                       )
                                                  //                     ],
                                                  //                   );
                                                  //                 },
                                                  //                 childCount: 10,
                                                  //               ),
                                                  //             ),
                                                  //           ]),
                                                  //         )
                                                  //       ],
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              );
                                            }
                                            //Provider.of<CategoryService>(context, listen: false).serviceList.clear();
                                            List<ServiceState> tmpCategoryServices = [];
                                            categoryServicesSnapshot.data.docs.forEach((service) {
                                              ServiceState serviceState = ServiceState.fromJson(service.data());
                                              tmpCategoryServices.add(serviceState);
                                            });

                                            if(_searchController.text.isNotEmpty /*&& Provider.of<CategoryService>(context, listen: false).searchedList.isNotEmpty*/){
                                              debugPrint('UI_U_new_filter_by_category => SEARCHED: ${_searchController.text}');
                                              Provider.of<CategoryService>(context, listen: false).serviceList = Provider.of<CategoryService>(context, listen: false).searchedList;
                                            }else{
                                              Provider.of<CategoryService>(context, listen: false).serviceList = tmpCategoryServices;
                                            }
                                            if (sortBy == 'A-Z') {
                                              Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, a.name)).compareTo(Utils.retriveField(myLocale.languageCode, b.name)));
                                            } else {
                                              Provider.of<CategoryService>(context, listen: false).serviceList.sort((a, b) => (Utils.retriveField(myLocale.languageCode, b.name)).compareTo(Utils.retriveField(myLocale.languageCode, a.name)));
                                            }

                                            return Provider.of<CategoryService>(context, listen: false).serviceList.isNotEmpty
                                                ? Column(
                                              children: Provider.of<CategoryService>(context, listen: false).serviceList.map((ServiceState service) {
                                                int index;
                                                for (int i = 0; i < Provider.of<CategoryService>(context, listen: false).serviceList.length; i++) {
                                                  if (Provider.of<CategoryService>(context, listen: false).serviceList[i].serviceId == service.serviceId) index = i;
                                                }
                                                return Column(
                                                  children: [
                                                    Dismissible(
                                                      // Each Dismissible must contain a Key. Keys allow Flutter to
                                                      // uniquely identify widgets.
                                                      key: UniqueKey(),
                                                      // Provide a function that tells the app
                                                      // what to do after an item has been swiped away.
                                                      onDismissed: (direction) {
                                                        // Remove the item from the data source.
                                                        setState(() {
                                                          Provider.of<CategoryService>(context, listen: false).serviceList.removeAt(index);
                                                        });
                                                        if (StoreProvider.of<AppState>(context).state.user.getRole() == Role.user) {
                                                          if (direction == DismissDirection.startToEnd) {
                                                            debugPrint('UI_U_filter_by_category => DX to DELETE');
                                                            // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                                content: Text("${service.name} removed"),
                                                                action: SnackBarAction(
                                                                    label: AppLocalizations.of(context).undo,
                                                                    onPressed: () {
                                                                      //To undo deletion
                                                                      undoDeletion(index, service);
                                                                    })));
                                                          } else {
                                                            debugPrint('UI_U_filter_by_category => SX to BOOK');
                                                            if (service.switchSlots) {
                                                              StoreProvider.of<AppState>(context).dispatch(OrderReservableListRequest(service.serviceId));
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: service, tourist: true,)),
                                                              );
                                                            } else {
                                                              order.business.name = snapshot.business.name;
                                                              order.business.id = snapshot.business.id_firestore;
                                                              order.user.name = snapshot.user.name;
                                                              order.user.id = snapshot.user.uid;
                                                              order.user.email = snapshot.user.email;
                                                              // order.addItem(service, snapshot.business.ownerId, context);
                                                              if (!order.addingFromAnotherBusiness(service.businessId)) {
                                                                order.addItem(service, snapshot.business.ownerId, context);
                                                                order.cartCounter++;
                                                                StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                              } else {
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
                                                                            order.addItem(service, snapshot.business.ownerId, context);
                                                                            order.cartCounter = 1;
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        )
                                                                      ],
                                                                    ));
                                                              }
                                                              //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                            }
                                                            undoDeletion(index, service);
                                                          }
                                                        } else {
                                                          if (direction == DismissDirection.startToEnd) {
                                                            debugPrint('UI_U_filter_by_category => DX to DELETE');
                                                          } else {
                                                            debugPrint('UI_U_filter_by_category => SX to BOOK');
                                                            undoDeletion(index, service);
                                                          }
                                                        }
                                                      },
                                                      child: Column(
                                                        children: [
                                                          ServiceListItem(service, true, index),
                                                          Container(
                                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                                            height: SizeConfig.safeBlockVertical * .2,
                                                            color: BuytimeTheme.DividerGrey,
                                                          )
                                                        ],
                                                      ),
                                                      background: Container(
                                                        color: BuytimeTheme.AccentRed,
                                                        //margin: EdgeInsets.symmetric(horizontal: 15),
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                                                          child: Icon(
                                                            MaterialDesignIcons.thumb_down,
                                                            size: 24,

                                                            ///SizeConfig.safeBlockHorizontal * 7
                                                            color: BuytimeTheme.SymbolWhite,
                                                          ),
                                                        ),
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
                                            )
                                                : _searchController.text.isNotEmpty ? Container(
                                              height: SizeConfig.safeBlockVertical * 8,
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                                : Provider.of<CategoryService>(context, listen: false).serviceList.isEmpty
                                                ? Container(
                                              height: SizeConfig.safeBlockVertical * 8,
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                                                : Container();
                                          }
                                      ),
                                ///Searched list
                                // Flexible(
                                //   child: Container(
                                //     margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                //     child: tmpServiceList.isNotEmpty
                                //         ? Column(
                                //             children: tmpServiceList.map((ServiceState service) {
                                //               int index;
                                //               for (int i = 0; i < tmpServiceList.length; i++) {
                                //                 if (tmpServiceList[i].serviceId == service.serviceId) index = i;
                                //               }
                                //               return Column(
                                //                 children: [
                                //                   Dismissible(
                                //                     // Each Dismissible must contain a Key. Keys allow Flutter to
                                //                     // uniquely identify widgets.
                                //                     key: UniqueKey(),
                                //                     // Provide a function that tells the app
                                //                     // what to do after an item has been swiped away.
                                //                     onDismissed: (direction) {
                                //                       // Remove the item from the data source.
                                //                       setState(() {
                                //                         tmpServiceList.removeAt(index);
                                //                       });
                                //                       if (StoreProvider.of<AppState>(context).state.user.getRole() == Role.user) {
                                //                         if (direction == DismissDirection.startToEnd) {
                                //                           debugPrint('UI_U_filter_by_category => DX to DELETE');
                                //                           // Show a snackbar. This snackbar could also contain "Undo" actions.
                                //                           Scaffold.of(context).showSnackBar(SnackBar(
                                //                               content: Text("${service.name} removed"),
                                //                               action: SnackBarAction(
                                //                                   label: AppLocalizations.of(context).undo,
                                //                                   onPressed: () {
                                //                                     //To undo deletion
                                //                                     undoDeletion(index, service);
                                //                                   })));
                                //                         } else {
                                //                           debugPrint('UI_U_filter_by_category => SX to BOOK');
                                //                           if (service.switchSlots) {
                                //                             StoreProvider.of<AppState>(context).dispatch(OrderReservableListRequest(service.serviceId));
                                //                             Navigator.push(
                                //                               context,
                                //                               MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: service, tourist: widget.tourist,)),
                                //                             );
                                //                           } else {
                                //                             order.business.name = snapshot.business.name;
                                //                             order.business.id = snapshot.business.id_firestore;
                                //                             order.user.name = snapshot.user.name;
                                //                             order.user.id = snapshot.user.uid;
                                //                             order.user.email = snapshot.user.email;
                                //                             // order.addItem(service, snapshot.business.ownerId, context);
                                //                             if (!order.addingFromAnotherBusiness(service.businessId)) {
                                //                               order.addItem(service, snapshot.business.ownerId, context);
                                //                               order.cartCounter++;
                                //                               StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                //                             } else {
                                //                               showDialog(
                                //                                   context: context,
                                //                                   builder: (_) => AlertDialog(
                                //                                         title: Text(AppLocalizations.of(context).doYouWantToPerformAnotherOrder),
                                //                                         content: Text(AppLocalizations.of(context).youAreAboutToPerformAnotherOrder),
                                //                                         actions: <Widget>[
                                //                                           MaterialButton(
                                //                                             elevation: 0,
                                //                                             hoverElevation: 0,
                                //                                             focusElevation: 0,
                                //                                             highlightElevation: 0,
                                //                                             child: Text(AppLocalizations.of(context).cancel),
                                //                                             onPressed: () {
                                //                                               Navigator.of(context).pop();
                                //                                             },
                                //                                           ),
                                //                                           MaterialButton(
                                //                                             elevation: 0,
                                //                                             hoverElevation: 0,
                                //                                             focusElevation: 0,
                                //                                             highlightElevation: 0,
                                //                                             child: Text(AppLocalizations.of(context).ok),
                                //                                             onPressed: () {
                                //                                               /// svuotare il carrello
                                //                                               // StoreProvider.of<AppState>(context).dispatch(());
                                //                                               /// fare la nuova add
                                //                                               for (int i = 0; i < order.itemList.length; i++) {
                                //                                                 order.removeItem(order.itemList[i],context);
                                //                                               }
                                //                                               order.itemList = [];
                                //                                               order.cartCounter = 0;
                                //                                               order.addItem(service, snapshot.business.ownerId, context);
                                //                                               order.cartCounter = 1;
                                //                                               Navigator.of(context).pop();
                                //                                             },
                                //                                           )
                                //                                         ],
                                //                                       ));
                                //                             }
                                //                             //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                //                           }
                                //                           undoDeletion(index, service);
                                //                         }
                                //                       } else {
                                //                         if (direction == DismissDirection.startToEnd) {
                                //                           debugPrint('UI_U_filter_by_category => DX to DELETE');
                                //                         } else {
                                //                           debugPrint('UI_U_filter_by_category => SX to BOOK');
                                //                           undoDeletion(index, service);
                                //                         }
                                //                       }
                                //                     },
                                //                     child: Column(
                                //                       children: [
                                //                         ServiceListItem(service, widget.tourist, index),
                                //                         Container(
                                //                           margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 30),
                                //                           height: SizeConfig.safeBlockVertical * .2,
                                //                           color: BuytimeTheme.DividerGrey,
                                //                         )
                                //                       ],
                                //                     ),
                                //                     background: Container(
                                //                       color: BuytimeTheme.AccentRed,
                                //                       //margin: EdgeInsets.symmetric(horizontal: 15),
                                //                       alignment: Alignment.centerLeft,
                                //                       child: Container(
                                //                         margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5),
                                //                         child: Icon(
                                //                           MaterialDesignIcons.thumb_down,
                                //                           size: 24,
                                //
                                //                           ///SizeConfig.safeBlockHorizontal * 7
                                //                           color: BuytimeTheme.SymbolWhite,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                     secondaryBackground: Container(
                                //                       color: BuytimeTheme.UserPrimary,
                                //                       //margin: EdgeInsets.symmetric(horizontal: 15),
                                //                       alignment: Alignment.centerRight,
                                //                       child: Container(
                                //                         margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                //                         child: Icon(
                                //                           Icons.add_shopping_cart,
                                //                           size: 24,
                                //
                                //                           ///SizeConfig.safeBlockHorizontal * 7
                                //                           color: BuytimeTheme.SymbolWhite,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                   /*Container(
                                //                     margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                //                     height: SizeConfig.safeBlockVertical * .2,
                                //                     color: BuytimeTheme.DividerGrey,
                                //                   )*/
                                //                 ],
                                //               );
                                //             }).toList(),
                                //           )
                                //         : _searchController.text.isNotEmpty
                                //             ? Container(
                                //                 height: SizeConfig.safeBlockVertical * 8,
                                //                 margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                //                 decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                //                 child: Center(
                                //                     child: Container(
                                //                   margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                //                   alignment: Alignment.centerLeft,
                                //                   child: Text(
                                //                     AppLocalizations.of(context).noServiceFoundFromTheSearch,
                                //                     style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                //                   ),
                                //                 )),
                                //               )
                                //             : tmpServiceList.isEmpty
                                //                 ? Container(
                                //                     height: SizeConfig.safeBlockVertical * 8,
                                //                     margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                //                     decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                //                     child: Center(
                                //                         child: Container(
                                //                       margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                //                       alignment: Alignment.centerLeft,
                                //                       child: Text(
                                //                         AppLocalizations.of(context).noServiceFound,
                                //                         style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                //                       ),
                                //                     )),
                                //                   )
                                //                 : Container(),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),

                        ///Divider
                        categoryList.isNotEmpty ?
                        Container(
                          color: BuytimeTheme.DividerGrey,
                          height: SizeConfig.safeBlockVertical * 2,
                        ) : Container(),

                        ///Inspiration
                        categoryList.isNotEmpty ?
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                            padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 1),
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Inspiration
                                /*Container(
                                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, top: SizeConfig.safeBlockVertical * 1),
                                    child: Text(
                                      'Find your inspiration here',
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Text
                                      Text(
                                        AppLocalizations.of(context).findYourInspirationHere,
                                        maxLines: 2,
                                        style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextBlack, fontWeight: FontWeight.w400, fontSize: 18

                                            ///SizeConfig.safeBlockHorizontal * 4
                                            ),
                                      ),

                                      ///Show All
                                      categoryList.length > 5 ?
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
                                                    // showAll = !showAll;
                                                    categoryList.shuffle();
                                                  });
                                                  grid(categoryList);
                                                },
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                child: Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    AppLocalizations.of(context).showMore,
                                                    // !showAll ? AppLocalizations.of(context).showAll : AppLocalizations.of(context).showLess,
                                                    style: TextStyle(letterSpacing: SizeConfig.safeBlockHorizontal * .2, fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.SymbolMalibu, fontWeight: FontWeight.w400, fontSize: 14

                                                        ///SizeConfig.safeBlockHorizontal * 4
                                                        ),
                                                  ),
                                                )),
                                          )) : Container()
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
                                            // !showAll && rowLess1.isNotEmpty ? inspiration(rowLess1) : Container(),
                                            rowLess1.isNotEmpty ? inspiration(rowLess1, 1) : Container(),
                                            // !showAll && rowLess2.isNotEmpty ? inspiration(rowLess2) : Container(),
                                            rowLess2.isNotEmpty ? inspiration(rowLess2, 2) : Container(),
                                            // showAll && row1.isNotEmpty ? inspiration(row1) : Container(),
                                            // showAll && row2.isNotEmpty ? inspiration(row2) : Container(),
                                            // showAll && row3.isNotEmpty ? inspiration(row3) : Container(),
                                            // showAll && row4.isNotEmpty ? inspiration(row4) : Container(),
                                          ],
                                        )) :
                                    ///No Category
                                    Container(
                                        height: SizeConfig.safeBlockVertical * 8,
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
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
                              ],
                            ),
                          ),
                        ) : Container(),
                      ],
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

class CategoryService with ChangeNotifier{
  List<ServiceState> serviceList;
  List<ServiceState> searchedList;
  CategoryService(this.serviceList, this.searchedList);


  initServiceList(List<ServiceState> serviceList){
    this.serviceList = serviceList;
    debugPrint('RUI_U_service_explorer => SERVICE LIST INIT');
    notifyListeners();
  }

  clear(){
    this.serviceList.clear();
    this.searchedList.clear();
    notifyListeners();
  }

}