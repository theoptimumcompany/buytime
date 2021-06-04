import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_list_state.dart';
import 'package:Buytime/reblox/model/snippet/reservations_orders_list_snippet_state.dart';
import 'package:Buytime/utils/size_config.dart';
import 'package:Buytime/utils/theme/buytime_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/utils/utils.dart';

import 'order_room_service_list_item.dart';


class UI_M_RoomPaymentList extends StatefulWidget {
  static String route = '/roomPaymentList';
  String bookingId;

  UI_M_RoomPaymentList(this.bookingId);

  @override
  State<StatefulWidget> createState() => UI_M_RoomPaymentListState();
}

class UI_M_RoomPaymentListState extends State<UI_M_RoomPaymentList> {
  List<dynamic> reservationAndOrderList;
  bool noActivity = false;
  double total = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var mediaHeight = media.height;
    print(widget.bookingId);
    final Stream<DocumentSnapshot> _reservationsOrdersStream = FirebaseFirestore.instance.collection('booking').doc(widget.bookingId).collection('roomCharge').doc('listOfRoomCharge').snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BuytimeTheme.ManagerPrimary,
          title: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                AppLocalizations.of(context).reservationsAndOrders,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: _reservationsOrdersStream,
            builder: (context, AsyncSnapshot<DocumentSnapshot> reservationsOrdersListSnapshot) {
              if (reservationsOrdersListSnapshot.hasError || reservationsOrdersListSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (reservationsOrdersListSnapshot.data.data() == null) {
                return Container(
                  height: SizeConfig.safeBlockVertical * 8,
                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                  decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Container(
                    margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).noActiveBusinesses,
                      style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  )),
                );
              }
              ReservationsOrdersListSnippetListState reservationsOrdersListSnippetListState = ReservationsOrdersListSnippetListState.fromJson(reservationsOrdersListSnapshot.data.data());
              print(reservationsOrdersListSnippetListState.reservationsOrdersListSnippetListState.length);
              reservationAndOrderList = reservationsOrdersListSnippetListState.reservationsOrdersListSnippetListState;
              /// update the total.
              total = 0;
              for (int i = 0; i < reservationAndOrderList.length; i++) {
                OrderState orderState = reservationsOrdersListSnippetListState.reservationsOrdersListSnippetListState[i].order;
                debugPrint("ordersList price" + orderState.total.toString());
                if(orderState.progress == Utils.enumToString(OrderStatus.toBePaidAtCheckout)) {
                  total += orderState.total;
                }
              }
              return ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reservationAndOrderList != null && reservationAndOrderList.length > 0
                        ? Expanded(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                  padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 8),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Center(
                                          child: Text(
                                              AppLocalizations.of(context).total,
                                              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 24, color: BuytimeTheme.TextBlack)
                                          ))),
                                      Expanded(flex: 3, child: Center(
                                          child: Text(
                                              total.toStringAsFixed(2).toString(),
                                              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: BuytimeTheme.FontFamily, fontSize: 24, color: BuytimeTheme.TextBlack)
                                          )))
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: CustomScrollView(shrinkWrap: true, slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          ReservationsOrdersListSnippetState reservationsOrdersListSnippetState = reservationAndOrderList.elementAt(index);

                                          ///TODO: Item Reservation/Order CategoryListItemWidget
                                          return
                                            OrderRoomServiceListItem(reservationsOrdersListSnippetState.order, false);

                                            Text(reservationsOrdersListSnippetState.orderId);
                                          // return InkWell(
                                          //   onTap: () {
                                          //     debugPrint('Category Item: ${categoryItem.name.toUpperCase()} Clicked!');
                                          //   },
                                          //   //child: MenuItemListItemWidget(menuItem),
                                          //   child: CategoryListItemWidget(categoryItem),
                                          // );
                                        },
                                        childCount: reservationAndOrderList.length,
                                      ),
                                    ),
                                  ]),
                                ),
                                // Flexible(
                                //   child: ListView.builder(
                                //       scrollDirection: Axis.vertical,
                                //       shrinkWrap: true,
                                //       itemCount: reservationAndOrderList.length,
                                //       itemBuilder: (BuildContext ctxt, int index) {
                                //         return Container(
                                //           margin: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3, left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.blockSizeHorizontal * 5),
                                //           child: Text("Prova"),
                                //         );
                                //       }),
                                // ),
                              ],
                            ),
                          )
                        : noActivity
                            ? Expanded(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(BuytimeTheme.ManagerPrimary),
                                  )
                                ],
                              ))
                            : Container(
                                height: SizeConfig.safeBlockVertical * 8,
                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 5, right: SizeConfig.safeBlockHorizontal * 5, top: SizeConfig.safeBlockVertical * 2),
                                decoration: BoxDecoration(color: BuytimeTheme.SymbolLightGrey.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                    child: Container(
                                  margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 4),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocalizations.of(context).noActiveBusinesses,
                                    style: TextStyle(fontFamily: BuytimeTheme.FontFamily, color: BuytimeTheme.TextGrey, fontWeight: FontWeight.w500, fontSize: 16),
                                  ),
                                )),
                              ),
                  ],
                ),
              );
            }));

    // return StoreConnector<AppState, AppState>(
    //     converter: (store) => store.state,
    //     onInit: (store){
    //       print("On Init Room Payment List");
    //     //  store.state.serviceListSnippetListState.serviceListSnippetListState.clear();
    //    //   store.state.businessList.businessListState.clear();
    //       store.dispatch(ReservationAndOrdersListSnippetListRequest(widget.bookingId));
    //       },
    //     builder: (context, snapshot) {
    //       reservationAndOrderList = snapshot.businessList.businessListState;
    //
    //     });
  }
}
