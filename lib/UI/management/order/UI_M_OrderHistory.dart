import 'package:Buytime/UI/user/order/UI_U_OrderDetail.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/user_buytime_appbar.dart';
import 'package:Buytime/reusable/order/optimum_order_history_item_card_medium.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_M_OrderHistory extends StatefulWidget {
  final String title = 'Order History';

  @override
  State<StatefulWidget> createState() => UI_M_OrderHistoryState();
}

class UI_M_OrderHistoryState extends State<UI_M_OrderHistory> {
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
                onInit: (store) => store.dispatch(OrderListRequest("any")),
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
                                      color: Colors.grey,
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
                      :  Center(
                    child: Text("Non hai ordini da vedere!"),
                  );
                }),
          ),
        ),
      ],
    ));
  }
}
