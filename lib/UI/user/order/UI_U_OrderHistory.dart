import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/order/order_state.dart';
import 'package:BuyTime/reblox/reducer/order_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reusable/appbar/user_buytime_appbar.dart';
import 'package:BuyTime/reusable/order/optimum_order_history_item_card_medium.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_U_OrderHistory extends StatefulWidget {
  final String title = 'Order History';

  @override
  State<StatefulWidget> createState() => UI_U_OrderHistoryState();
}

class UI_U_OrderHistoryState extends State<UI_U_OrderHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 10.0),
          child: Text(
            "I tuoi ordini",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: media.height * 0.035,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: StoreConnector<AppState, AppState>(
                converter: (store) => store.state,
                rebuildOnChange: true,
                onInitialBuild: (state) {StoreProvider.of<AppState>(context).dispatch(OrderListRequest(state.user.uid));},
                onDispose: (store) => store.dispatch(OrderListRequest(store.state.user.uid)),
                onInit: (store) => store.dispatch(OrderListRequest(store.state.user.uid)),
                builder: (context, snapshot) {
                  print("UI_U_OrderHistory : Number of orders is " + snapshot.orderList.orderListState.length.toString());
                  return snapshot.orderList.orderListState.length > 0
                      ? GridView.builder(
                          itemCount: snapshot.orderList.orderListState.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final item = (index != snapshot.orderList.orderListState.length ? snapshot.orderList.orderListState[index] : null);
                            return OptimumOrderHistoryItemCardMedium(
                              key: ObjectKey(item),
                              order: snapshot.orderList.orderListState[index],
                              mediaSize: media,
                              onOrderHistoryItemCardTap: (OrderState order) {
                                StoreProvider.of<AppState>(context).dispatch(new SetOrder(snapshot.orderList.orderListState[index]));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
                                );
                              },
                              rightWidget1: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.chevron_right,
                                      color: BuytimeTheme.IconGrey,
                                    ),
                                    onPressed: () {
                                      StoreProvider.of<AppState>(context).dispatch(new SetOrder(snapshot.orderList.orderListState[index]));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UI_U_OrderDetail()),
                                      );
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                            child: Text(
                              "Non hai ordini arretrati",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: media.height * 0.025,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                }),
          ),
        ),
      ],
    ));
  }
}
