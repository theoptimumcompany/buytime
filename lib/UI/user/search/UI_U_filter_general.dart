import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/UI/user/service/UI_U_service_reserve.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/role/role.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reservable_list_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/reusable/booking_page_service_list_item.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/material_design_icons.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FilterGeneral extends StatefulWidget {
  static String route = '/filterGeneral';
  bool fromBookingPage;
  String searched;

  FilterGeneral({Key key, this.fromBookingPage, this.searched}) : super(key: key);

  @override
  _FilterGeneralState createState() => _FilterGeneralState();
}

class _FilterGeneralState extends State<FilterGeneral> {
  TextEditingController _searchController = TextEditingController();
  List<ServiceState> serviceState = [];
  List<ServiceState> tmpServiceList = [];

  String sortBy = '';
  OrderState order = OrderState().toEmpty();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searched;
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
      tmpServiceList.clear();
      serviceState = list;
      if (_searchController.text.isNotEmpty) {
        serviceState.forEach((element) {
          if (element.name.toLowerCase().contains(_searchController.text.toLowerCase())) {
            tmpServiceList.add(element);
          }
          if(element.tag != null && element.tag.isNotEmpty){
            element.tag.forEach((tag) {
              if (tag.toLowerCase().contains(_searchController.text.toLowerCase())) {
                if(!tmpServiceList.contains(element)){
                  tmpServiceList.add(element);
                }
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // no
          search(store.state.serviceList.serviceListState);
        });
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
                        AppLocalizations.of(context).search,
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
                                    search(snapshot.serviceList.serviceListState);
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
                                search(snapshot.serviceList.serviceListState);
                              },
                            ),
                          ),

                          ///Sort By
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
                                          if (sortBy == 'A-Z') {
                                            tmpServiceList.sort((a, b) => a.name.compareTo(b.name));
                                          } else {
                                            tmpServiceList.sort((a, b) => b.name.compareTo(a.name));
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
                              child: tmpServiceList.isNotEmpty
                                  ? Column(
                                      children: tmpServiceList.map((ServiceState service) {
                                        int index;
                                        for (int i = 0; i < tmpServiceList.length; i++) {
                                          if (tmpServiceList[i].serviceId == service.serviceId) index = i;
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
                                                  tmpServiceList.removeAt(index);
                                                });
                                                if(StoreProvider.of<AppState>(context).state.user.getRole() == Role.user){
                                                  if (direction == DismissDirection.startToEnd) {
                                                    debugPrint('UI_U_SearchPage => DX to DELETE');
                                                    // Show a snackbar. This snackbar could also contain "Undo" actions.
                                                    Scaffold.of(context).showSnackBar(SnackBar(
                                                        content: Text(service.name + AppLocalizations.of(context).spaceRemoved),
                                                        action: SnackBarAction(
                                                            label: AppLocalizations.of(context).undo,
                                                            onPressed: () {
                                                              //To undo deletion
                                                              undoDeletion(index, service);
                                                            })));
                                                  } else {
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');
                                                    if (service.switchSlots) {
                                                      StoreProvider.of<AppState>(context).dispatch(OrderReservableListRequest(service.serviceId));
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ServiceReserve(serviceState: service)),
                                                      );
                                                    } else {
                                                      order.business.name = snapshot.business.name;
                                                      order.business.id = snapshot.business.id_firestore;
                                                      order.user.name = snapshot.user.name;
                                                      order.user.id = snapshot.user.uid;
                                                      order.addItem(service, snapshot.business.ownerId, context);
                                                      order.cartCounter++;
                                                      //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                      StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                    }
                                                    undoDeletion(index, service);
                                                  }
                                                }else{
                                                  if (direction == DismissDirection.startToEnd) {
                                                    debugPrint('UI_U_SearchPage => DX to DELETE');

                                                  } else {
                                                    debugPrint('UI_U_SearchPage => SX to BOOK');
                                                    undoDeletion(index, service);
                                                  }
                                                }

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
                                  /*ListView.builder(
                                itemCount: tmpServiceList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  ServiceState service = tmpServiceList.elementAt(index);
                                  return Dismissible(
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
                                          margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 38),
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
                                          size: SizeConfig.safeBlockHorizontal * 7,
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
                                          size: SizeConfig.safeBlockHorizontal * 7,
                                          color: BuytimeTheme.SymbolWhite,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )*/
                                  : _searchController.text.isNotEmpty
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
                                      : tmpServiceList.isEmpty
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
                                            )
                                          : Container(),
                            ),
                          )
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
