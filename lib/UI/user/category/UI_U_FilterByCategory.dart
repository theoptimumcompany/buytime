import 'package:Buytime/UI/user/cart/UI_U_Cart.dart';
import 'package:Buytime/UI/user/search/UI_U_FilterGeneral.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/category/category_list_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/cart_icon.dart';
import 'package:Buytime/reusable/find_your_inspiration_card_widget.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FilterByCategory extends StatefulWidget {

  static String route = '/filterByCategory';
  bool fromBookingPage;
  CategoryState categoryState;
  FilterByCategory({Key key, this.fromBookingPage, this.categoryState}) : super(key: key);
  @override
  _FilterByCategoryState createState() => _FilterByCategoryState();
}

class _FilterByCategoryState extends State<FilterByCategory> {

  TextEditingController _searchController = TextEditingController();
  List<Widget> subCategories = [];
  CategoryListState categoryListState;
  List<CategoryState> categoryList = [];
  List<CategoryState> subCategoryList = [];
  List<ServiceState> serviceState = [];
  List<ServiceState> tmpServiceList = [];
  String searched = '';
  String sortBy = '';

  OrderState order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");

  bool showAll = false;
  List<CategoryState> row1 = [];
  List<CategoryState> row2 = [];
  List<CategoryState> row3 = [];
  List<CategoryState> row4 = [];

  List<CategoryState> rowLess1 = [];
  List<CategoryState> rowLess2 = [];

  @override
  void initState() {
    super.initState();
  }

  void undoDeletion(index, item){
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState((){
      tmpServiceList.insert(index, item);
    });
  }

  void search(List<ServiceState> list){
    setState(() {
      tmpServiceList.clear();
      serviceState = list;
      if(_searchController.text.isNotEmpty){
        serviceState.forEach((element) {
          if(element.name.toLowerCase().contains(_searchController.text.toLowerCase())){
            tmpServiceList.add(element);
          }
        });
      }
    });
  }

  void grid(List<CategoryState> l){
    setState(() {
      if(l.length == 1){
        row1 = [l[0]];
        rowLess1 = [l[0]];
      }else if(l.length == 2){
        row1 = [l[0], l[1]];
        rowLess1 = [l[0], l[1]];
      }else if(l.length == 3){
        row1 = [l[0], l[1], l[2]];
        rowLess1 = [l[0], l[1], l[2]];
      }else if(l.length == 4){
        row1 = [l[0], l[1]];
        row2 = [l[2], l[3]];
        rowLess1 = [l[0], l[1]];
        rowLess2 = [l[2], l[3]];
      }else if(l.length == 5){
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }else if(l.length == 6){
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4], l[5]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }else if(l.length == 7){
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }else if(l.length == 8){
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6], l[7]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }else if(l.length == 9){
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6]];
        row4 = [l[7], l[8]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }else{
        row1 = [l[0], l[1], l[2]];
        row2 = [l[3], l[4]];
        row3 = [l[5], l[6], l[7]];
        row4 = [l[8], l[9]];
        rowLess1 = [l[0], l[1], l[2]];
        rowLess2 = [l[3], l[4]];
      }
    });
  }

  Widget inspiration(List<CategoryState> list){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///First showcase for each Row
        list.length >= 1 ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(
              list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list[0], false
          ),
        ) : Container(),
        ///Second showcase for each Row
        list.length >= 2 ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(
              list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list[1], false
          ),
        ) : Container(),
        ///Third showcase for each Row
        list.length == 3 ? Flexible(
          flex: 1,
          child: FindYourInspirationCardWidget(
              list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list.length <= 2 ? SizeConfig.screenWidth/2 - 2 : SizeConfig.screenWidth/3 - 2, list[2], false
          ),
        ) : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);

    return  StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        WidgetsBinding.instance.addPostFrameCallback((_) { // no
          //search(store.state.serviceList.serviceListState);
          setState(() {

            List<CategoryState> l = [];
            l.addAll(store.state.categoryList.categoryListState);

            l.remove(widget.categoryState);
            if(l.isNotEmpty){
              subCategoryList.clear();
              grid(l);
              l.forEach((element) {
                if(element.parent != null && element.parent.id == widget.categoryState.id){
                  subCategoryList.add(element);
                }
              });
            }

          });
        });
        categoryListState = store.state.categoryList;
        categoryList = categoryListState.categoryListState;
      },
      builder: (context, snapshot) {
        List<ServiceState> s = [];

        if(_searchController.text.isEmpty){
          tmpServiceList.clear();
          s.addAll(snapshot.serviceList.serviceListState);
          s.forEach((element) {
            element.categoryId.forEach((element2) {
              if(element2 == widget.categoryState.id){
                tmpServiceList.add(element);
              }
            });
          });
        }

        order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
        return  GestureDetector(
          onTap: (){
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
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
                        widget.categoryState.name, //TODO Make it Global
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
                                  CartIcon.add_shopping_cart_24px,
                                  color: BuytimeTheme.TextWhite,
                                  size: 24.0,
                                ),
                                onPressed: (){
                                  if (cartCounter > 0) {
                                    // dispatch the order
                                    StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                    // go to the cart page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Cart()),
                                    );
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => new AlertDialog(
                                          title: new Text(AppLocalizations.of(context).warning),
                                          content: new Text(AppLocalizations.of(context).emptyCart),
                                          actions: <Widget>[
                                            FlatButton(
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
                          cartCounter > 0 ? Positioned.fill(
                            top: 5,
                            left: 2.5,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '$cartCounter', //TODO Make it Global
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  color: BuytimeTheme.TextWhite,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ) : Container(),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ///Just shoe me
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
                            padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
                            height: subCategoryList.isNotEmpty ? SizeConfig.safeBlockVertical * 28 : SizeConfig.safeBlockVertical * 17,
                            color: BuytimeTheme.BackgroundWhite,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///Just show me
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical*1),
                                  child: Text(
                                    'Just Show Me', //TODO Make it Global
                                    style: TextStyle(
                                        //letterSpacing: SizeConfig.safeBlockVertical * .4,
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18 ///SizeConfig.safeBlockHorizontal * 4
                                    ),
                                  ),
                                ),
                                subCategoryList.isNotEmpty ?
                                    ///List
                                Container(
                                  height: SizeConfig.screenWidth/3,
                                  width: double.infinity,
                                  child: CustomScrollView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      slivers: [
                                        SliverList(
                                          delegate: SliverChildBuilderDelegate((context, index) {
                                            //MenuItemModel menuItem = menuItems.elementAt(index);
                                            CategoryState category = subCategoryList.elementAt(index);
                                            return Container(
                                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2),
                                              child: FindYourInspirationCardWidget(
                                                  SizeConfig.screenWidth/3 - 2 ,SizeConfig.screenWidth/3 - 2, category, false
                                              ),
                                            );
                                          },
                                            childCount: subCategoryList.length,
                                          ),
                                        ),
                                      ]),
                                ) :
                                    ///No List
                                Container(
                                  height: SizeConfig.safeBlockVertical * 8,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  decoration: BoxDecoration(
                                      color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                      child: Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                        alignment: Alignment.centerLeft,
                                        child:  Text(
                                          'No sub category found', //TODO Make it Global
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextGrey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ///Divider
                        Container(
                          color: BuytimeTheme.DividerGrey,
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
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
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5),
                                  height: SizeConfig.safeBlockHorizontal * 20,
                                  child: TextFormField(
                                    controller: _searchController,
                                    textAlign: TextAlign.start,
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffe0e0e0)),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xff666666)),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                                      ),
                                      labelText: 'What are you looking for?', //TODO Make it Global
                                      helperText: 'Search for services and ideas around you', //TODO Make it Global
                                      //hintText: "email *",
                                      //hintStyle: TextStyle(color: Color(0xff666666)),
                                      labelStyle: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      helperStyle:  TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        color: Color(0xff666666),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      suffixIcon: InkWell(
                                        onTap: (){
                                          debugPrint('done');
                                          FocusScope.of(context).unfocus();
                                          search(snapshot.serviceList.serviceListState);
                                        },
                                        child: Icon(
                                          // Based on passwordVisible state choose the icon
                                          Icons.search,
                                          color: Color(0xff666666),
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontFamily: BuytimeTheme.FontFamily,
                                        color: BuytimeTheme.TextMedium,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16
                                    ),
                                    onEditingComplete: (){
                                      debugPrint('done');
                                      FocusScope.of(context).unfocus();
                                      search(snapshot.serviceList.serviceListState);
                                    },
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
                                                    'SORT BY', //TODO Make it Global
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14, ///SizeConfig.safeBlockHorizontal * 4
                                                      color: BuytimeTheme.TextMedium,
                                                      fontWeight: FontWeight.w400,
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
                                                          val, //TODO Make it Global
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: BuytimeTheme.TextMedium,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    sortBy == val ? Icon(
                                                      MaterialDesignIcons.done,
                                                      color: BuytimeTheme.TextMedium,
                                                      size: SizeConfig.safeBlockHorizontal * 5,
                                                    ) : Container(),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            setState(() {
                                              //_dropDownValue = val;
                                              sortBy = val;
                                              if(sortBy == 'A-Z'){
                                                tmpServiceList.sort((a,b) => a.name.compareTo(b.name));
                                              }else{
                                                tmpServiceList.sort((a,b) => b.name.compareTo(a.name));
                                              }
                                            },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ///Searched list
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                                    child:
                                    tmpServiceList.isNotEmpty ?
                                    Column(
                                      children: tmpServiceList.map((ServiceState service){
                                        int index;
                                        for(int i = 0; i < tmpServiceList.length; i++){
                                          if(tmpServiceList[i].serviceId == service.serviceId)
                                            index = i;
                                        }
                                        return  Column(
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
                                                  tmpServiceList.removeAt(index);
                                                });
                                                if(direction == DismissDirection.startToEnd){
                                                  debugPrint('UI_U_SearchPage => DX to DELETE');
                                                  // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                  Scaffold.of(context).showSnackBar(SnackBar(
                                                      content: Text("${service.name} removed"),
                                                      action: SnackBarAction(
                                                          label: "UNDO",
                                                          onPressed: () {
                                                            //To undo deletion
                                                            undoDeletion(index, service);
                                                          })));
                                                }else{
                                                  debugPrint('UI_U_SearchPage => SX to BOOK');
                                                  order.business.name = snapshot.business.name;
                                                  order.business.id = snapshot.business.id_firestore;
                                                  order.user.name = snapshot.user.name;
                                                  order.user.id = snapshot.user.uid;
                                                  order.addItem(service, snapshot.business.ownerId);
                                                  setState(() {
                                                    cartCounter++;
                                                  });
                                                  undoDeletion(index, service);
                                                }

                                              },
                                              child: Column(
                                                children: [
                                                  BookingListServiceListItem(service),
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
                                                    size: 24, ///SizeConfig.safeBlockHorizontal * 7
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
                                                    size: 24, ///SizeConfig.safeBlockHorizontal * 7
                                                    color: BuytimeTheme.SymbolWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
                                              height: SizeConfig.safeBlockVertical * .2,
                                              color: BuytimeTheme.DividerGrey,
                                            )
                                          ],
                                        );
                                      }).toList(),
                                    ):
                                    _searchController.text.isNotEmpty ?
                                    Container(
                                      height: SizeConfig.safeBlockVertical * 8,
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                      decoration: BoxDecoration(
                                          color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                          child: Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                            alignment: Alignment.centerLeft,
                                            child:  Text(
                                              'No service found from the search', //TODO Make it Global
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                              ),
                                            ),
                                          )
                                      ),
                                    ) :
                                    tmpServiceList.isEmpty ?
                                    Container(
                                      height: SizeConfig.safeBlockVertical * 8,
                                      margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                      decoration: BoxDecoration(
                                          color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                          child: Container(
                                            margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                            alignment: Alignment.centerLeft,
                                            child:  Text(
                                              'No service found', //TODO Make it Global
                                              style: TextStyle(
                                                  fontFamily: BuytimeTheme.FontFamily,
                                                  color: BuytimeTheme.TextGrey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16
                                              ),
                                            ),
                                          )
                                      ),
                                    ) :
                                    Container(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ///Divider
                        Container(
                          color: BuytimeTheme.DividerGrey,
                          height: SizeConfig.safeBlockVertical * 2,
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
                                      'Find your inspiration here', //TODO Make it Global
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
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 3, bottom: SizeConfig.safeBlockVertical * 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ///Text
                                      Text(
                                        'Find your inspiration here', //TODO Make it Global
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            color: BuytimeTheme.TextBlack,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18 ///SizeConfig.safeBlockHorizontal * 4
                                        ),
                                      ),
                                      ///Show All
                                      Container(
                                        //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 2.5, top: SizeConfig.safeBlockVertical * 0.5),
                                          alignment: Alignment.center,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                                onTap: (){
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
                                                    !showAll ? 'Show All' : 'Show Less',//AppLocalizations.of(context).somethingIsNotRight, ///TODO make it Global
                                                    style: TextStyle(
                                                        letterSpacing: SizeConfig.safeBlockHorizontal * .2,
                                                        fontFamily: BuytimeTheme.FontFamily,
                                                        color: BuytimeTheme.UserPrimary,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 16 ///SizeConfig.safeBlockHorizontal * 4
                                                    ),
                                                  ),
                                                )
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                ///Category List
                                categoryList.isNotEmpty ? Container(
                                    margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, left: SizeConfig.safeBlockHorizontal * 2, right: SizeConfig.safeBlockHorizontal * 2),
                                    //height: SizeConfig.safeBlockVertical * 50,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        row1.isNotEmpty ?
                                        inspiration(row1) : Container(),
                                        row2.isNotEmpty ?
                                        inspiration(row2)  : Container(),
                                        showAll && row3.isNotEmpty ?
                                        inspiration(row3)  : Container(),
                                        showAll && row4.isNotEmpty ?
                                        inspiration(row4): Container(),
                                      ],
                                    )
                                ) :
                                ///No Category
                                Container(
                                  height: SizeConfig.safeBlockVertical * 8,
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                  decoration: BoxDecoration(
                                      color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Center(
                                      child: Container(
                                        margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                        alignment: Alignment.centerLeft,
                                        child:  Text(
                                          'No active service found',
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              color: BuytimeTheme.TextGrey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16
                                          ),
                                        ),
                                      )
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }
}