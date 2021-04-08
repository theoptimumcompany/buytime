import 'package:Buytime/UI/management/activity/widget/W_cancel_popup.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_card.dart';
import 'package:Buytime/UI/management/activity/widget/W_dashboard_list_item.dart';
import 'package:Buytime/UI/management/business/UI_M_edit_business.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/booking_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/UI/management/category/UI_M_manage_category.dart';
import 'package:Buytime/UI/management/category/W_category_list_item.dart';
import 'package:Buytime/UI/management/service_internal/UI_M_service_list.dart';
import 'package:Buytime/UI/model/manager_model.dart';
import 'package:Buytime/UI/model/service_model.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/booking/booking_state.dart';
import 'package:Buytime/reblox/model/category/category_state.dart';
import 'package:Buytime/reblox/reducer/category_list_reducer.dart';
import 'package:Buytime/reblox/reducer/category_tree_reducer.dart';
import 'package:Buytime/reusable/buytime_icons.dart';
import 'package:Buytime/reusable/menu/UI_M_business_list_drawer.dart';
import 'package:Buytime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:Buytime/reusable/order/order_total.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
//import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ActivityManagementItemDetails extends StatefulWidget {
  static String route = '/activityManagementItemDetails';

  OrderState orderState;
  OrderEntry orderEntry;

  ActivityManagementItemDetails({Key key, this.orderState, this.orderEntry}) : super(key: key);

  @override
  _ActivityManagementItemDetailsState createState() => _ActivityManagementItemDetailsState();
}

class _ActivityManagementItemDetailsState extends State<ActivityManagementItemDetails> {
  List<BookingState> bookingList = [];
  bool seeAll = false;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  List<OrderState> pendingList = [];
  List<OrderState> acceptedList = [];
  List<List> orderList = [];

  @override
  void initState() {
    super.initState();
  }

  void undoDeletion(index, OrderEntry item) {
    /*
  This method accepts the parameters index and item and re-inserts the {item} at
  index {index}
  */
    setState(() {
      //orderState.addReserveItem(item., snapshot.business.ownerId, widget.serviceState.serviceSlot.first.startTime[i], widget.serviceState.serviceSlot.first.minDuration.toString(), dates[index]);
      widget.orderState.itemList.insert(index, item);
      widget.orderState.total += item.price * item.number;
    });
  }

  void deleteItem(OrderState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_Cart => Remove Normal Item');
    setState(() {
      if (snapshot.itemList.length >= 1) {
        snapshot.cartCounter = snapshot.cartCounter - entry.number;
        snapshot.itemList.remove(entry);
        double serviceTotal =  snapshot.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        snapshot.total = serviceTotal;
        //snapshot.removeItem(snapshot.itemList[index]);
        //snapshot.itemList.removeAt(index);
      } else {
        snapshot.cartCounter = snapshot.cartCounter - entry.number;
        snapshot.itemList.remove(entry);
        double serviceTotal =  snapshot.total;
        serviceTotal = serviceTotal - (entry.price * entry.number);
        snapshot.total = serviceTotal;
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServiceList()),);
        Navigator.of(context).pop();
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  void deleteReserveItem(OrderState snapshot, OrderEntry entry, int index) {
    debugPrint('UI_U_Cart => Remove Normal Item');
    setState(() {
      snapshot.cartCounter = snapshot.cartCounter - entry.number;
      snapshot.removeReserveItem(entry);
      snapshot.selected.removeAt(index);
      snapshot.itemList.remove(entry);
      if (snapshot.itemList.length == 0) Navigator.of(context).pop();

      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(snapshot));
    });
  }

  void onCancel(OrderState order){
    showDialog(
        context: context,
        builder: (context) {
          return CancelPop(order: order);
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    ///Init sizeConfig
    SizeConfig().init(context);
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
      },
      builder: (context, snapshot) {

        //List<CategoryState> categoryRootList = snapshot.categoryList.categoryListState;
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            drawerEnableOpenDragGesture: false,
            key: _drawerKey,

            ///Appbar
            appBar: BuytimeAppbar(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      '${widget.orderState.user.name} ${widget.orderState.user.surname ?? ''}',
                      textAlign: TextAlign.start,
                      style: BuytimeTheme.appbarTitle,
                    ),
                  ),
                ),
                SizedBox(
                  width: 56.0,
                )
              ],
            ),
            //drawer: UI_M_BusinessListDrawer(),
            body: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///Service List
                  Expanded(
                    flex: 2,
                    child: Container(
                      //color: Colors.black87,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            widget.orderEntry == null ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    '${widget.orderState.business.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextBlack,
                                        fontSize: 18 /// mediaSize.height * 0.024
                                    ),
                                  ),
                                )
                              ],
                            ) :
                            ///Service name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    '${widget.orderEntry.name}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextBlack,
                                        fontSize: 18 /// mediaSize.height * 0.024
                                    ),
                                  ),
                                )
                              ],
                            ),
                            widget.orderEntry == null ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1, bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    widget.orderState.itemList.length > 1 ? '${widget.orderState.itemList.length} ${AppLocalizations.of(context).items}' : '${widget.orderState.itemList.length} ${AppLocalizations.of(context).item}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w600,
                                        color: BuytimeTheme.TextBlack,
                                        fontSize: 18 /// mediaSize.height * 0.024
                                    ),
                                  ),
                                )
                              ],
                            ) :
                            ///Sub text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * .5, bottom: SizeConfig.safeBlockVertical * 1),
                                  child: Text(
                                    '${widget.orderEntry.description}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontFamily: BuytimeTheme.FontFamily,
                                        fontWeight: FontWeight.w500,
                                        color: BuytimeTheme.TextBlack,
                                        fontSize: 16 /// mediaSize.height * 0.024
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ///Order List
                            widget.orderEntry == null ?
                            Flexible(
                              flex: 1,
                              child: CustomScrollView(shrinkWrap: true, slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                      //MenuItemModel menuItem = menuItems.elementAt(index);
                                      debugPrint('UI_M_activity_management_item_details => LIST| ${widget.orderState.itemList[index].name} ITEM COUNT: ${widget.orderState.itemList[index].number}');
                                      var item = (index != widget.orderState.itemList.length ? widget.orderState.itemList[index] : null);
                                      //int itemCount = orderState.itemList[index].number;
                                      return  Dismissible(
                                        // Each Dismissible must contain a Key. Keys allow Flutter to
                                        // uniquely identify widgets.
                                        key: UniqueKey(),
                                        // Provide a function that tells the app
                                        // what to do after an item has been swiped away.
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          // Remove the item from the data source.
                                          setState(() {
                                            widget.orderState.itemList.removeAt(index);
                                          });
                                          if (direction == DismissDirection.endToStart) {
                                            widget.orderState.selected == null || widget.orderState.selected.isEmpty ?
                                            deleteItem(widget.orderState, item, index) :
                                            deleteReserveItem(widget.orderState, item, index);
                                            debugPrint('UI_U_SearchPage => DX to DELETE');
                                            // Show a snackbar. This snackbar could also contain "Undo" actions.
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text(item.name + AppLocalizations.of(context).spaceRemoved),
                                                action: SnackBarAction(
                                                    label: AppLocalizations.of(context).undo,
                                                    onPressed: () {
                                                      //To undo deletion
                                                      undoDeletion(index, item);
                                                    })));
                                          } else {
                                            widget.orderState.itemList.insert(index, item);
                                          }
                                        },
                                        child: OptimumOrderItemCardMedium(
                                          key: ObjectKey(item),
                                          orderEntry: widget.orderState.itemList[index],
                                          mediaSize: media,
                                          orderState: widget.orderState,
                                          index: index,
                                          show: true,
                                        ),
                                        background: Container(
                                          color: BuytimeTheme.BackgroundWhite,
                                          //margin: EdgeInsets.symmetric(horizontal: 15),
                                          alignment: Alignment.centerRight,
                                        ),
                                        secondaryBackground: Container(
                                          color: BuytimeTheme.AccentRed,
                                          //margin: EdgeInsets.symmetric(horizontal: 15),
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 2.5),
                                            child: Icon(
                                              BuytimeIcons.remove,
                                              size: 24,

                                              ///SizeConfig.safeBlockHorizontal * 7
                                              color: BuytimeTheme.SymbolWhite,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: widget.orderState.itemList.length,
                                  ),
                                ),
                              ]),
                            ) :
                            Container(
                              margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 1),
                              height: 64,
                              decoration: BoxDecoration(
                                //color: Colors.blue,
                                border: Border(
                                  bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ///Summary & Price
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///Date
                                        Text(
                                          '${DateFormat('dd MMM').format(widget.orderEntry.date)}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w600,
                                              color: BuytimeTheme.TextBlack,
                                              fontSize: 16 /// mediaSize.height * 0.024
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ///Time & Date
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ///Time & Date
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ///Time
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:5.0),
                                                    child: Text(
                                                      '${widget.orderEntry.time}',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: BuytimeTheme.FontFamily,
                                                          fontWeight: FontWeight.w400,
                                                          color: BuytimeTheme.TextBlack,
                                                          fontSize: 24 /// mediaSize.height * 0.024
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ///Minutes
                                  Expanded(
                                    flex: 1,
                                    child:  Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${widget.orderEntry.minutes}${AppLocalizations.of(context).spaceMin}.',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w400,
                                              color: BuytimeTheme.TextMedium,
                                              fontSize: 14 /// mediaSize.height * 0.024
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ///Total Order
                            widget.orderEntry == null ?
                            OrderTotal(media: media, orderState: widget.orderState) :
                            Container(
                              width: media.width,
                              height: SizeConfig.safeBlockVertical * 10,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///Total Price Text
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context).total,
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16, ///SizeConfig.safeBlockHorizontal * 4
                                            color: BuytimeTheme.TextMedium,
                                            letterSpacing: 0.25
                                        ),
                                      ),
                                    ),
                                  ),
                                  ///Total Value
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.center,
                                        //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 20),
                                        child: Text(
                                          '${AppLocalizations.of(context).euroSpace}${widget.orderEntry.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontFamily: BuytimeTheme.FontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 24, ///SizeConfig.safeBlockHorizontal * 7,
                                              color: BuytimeTheme.TextBlack
                                          ),
                                        ),
                                      )
                                  ),
                                  ///Tax
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      //margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 8),
                                      child: Text(
                                        '${(AppLocalizations.of(context).vat).toString().substring(0,7)}.',
                                        style: TextStyle(
                                            fontFamily: BuytimeTheme.FontFamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16, ///SizeConfig.safeBlockHorizontal * 4
                                            color: BuytimeTheme.TextMedium,
                                            letterSpacing: 0.25
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ///Divider
                            Container(
                              color: BuytimeTheme.DividerGrey,
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ///Accept & Cancel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.orderState.progress != 'canceled' && widget.orderState.progress != 'declined' ?
                      ///Decline
                      Container(
                          width: 158, ///SizeConfig.safeBlockHorizontal * 40
                          height: 44,
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2, right: SizeConfig.safeBlockHorizontal * 5),
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.circular(5),

                          ),
                          child: MaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              if(widget.orderState.progress == 'paid'){
                                //StoreProvider.of<AppState>(context).dispatch(SetOrderProgress('canceled'));
                                onCancel(widget.orderState);
                              }else{
                                //StoreProvider.of<AppState>(context).dispatch(SetOrderProgress('declined'));
                                widget.orderState.progress = 'declined';
                                StoreProvider.of<AppState>(context).dispatch(UpdateOrder(widget.orderState));
                              }
                            },
                            textColor: BuytimeTheme.TextWhite,
                            color: BuytimeTheme.ManagerPrimary,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Text(
                                widget.orderState.progress == 'paid' ? AppLocalizations.of(context).cancel.toUpperCase() : AppLocalizations.of(context).decline.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.25
                              ),
                            ),
                          )
                      ) : Container(),
                      ///Accept
                      widget.orderState.progress == 'canceled' || widget.orderState.progress == 'declined' ?
                      Container(
                          width: 158, ///SizeConfig.safeBlockHorizontal * 40
                          height: 44,
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                          child: MaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              widget.orderState.progress = 'pending';
                              StoreProvider.of<AppState>(context).dispatch(UpdateOrder(widget.orderState));
                            },
                            textColor: BuytimeTheme.TextWhite,
                            color: BuytimeTheme.ManagerPrimary,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context).reOpen.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.25
                              ),
                            ),
                          )
                      ) :
                      widget.orderState.progress != 'paid' ?
                      Container(
                          width: 158, ///SizeConfig.safeBlockHorizontal * 40
                          height: 44,
                          margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2, bottom: SizeConfig.safeBlockVertical * 2),
                          child: MaterialButton(
                            elevation: 0,
                            hoverElevation: 0,
                            focusElevation: 0,
                            highlightElevation: 0,
                            onPressed: () {
                              widget.orderState.progress = 'paid';
                              StoreProvider.of<AppState>(context).dispatch(UpdateOrder(widget.orderState));
                            },
                            textColor: BuytimeTheme.TextWhite,
                            color: BuytimeTheme.ManagerPrimary,
                            padding: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalizations.of(context).accept.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: BuytimeTheme.FontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.25
                              ),
                            ),
                          )
                      ) :
                      Container(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

