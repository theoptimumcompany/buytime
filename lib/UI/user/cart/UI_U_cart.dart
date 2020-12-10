import 'package:BuyTime/utils/theme/buytime_theme.dart';
import 'package:BuyTime/UI/user/service/UI_U_service_list.dart';
import 'package:BuyTime/reblox/model/app_state.dart';
import 'package:BuyTime/reblox/model/order/order_state.dart';
import 'package:BuyTime/reblox/reducer/order_list_reducer.dart';
import 'package:BuyTime/reblox/reducer/order_reducer.dart';
import 'package:BuyTime/reusable/appbar/user_buytime_appbar.dart';
import 'package:BuyTime/utils/globals.dart';
import 'package:BuyTime/reusable/order/optimum_order_item_card_medium.dart';
import 'package:BuyTime/reusable/order/order_total.dart';
import 'package:BuyTime/UI/user/cart/UI_U_stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_U_Cart extends StatefulWidget {
  final String title = 'Cart';

  @override
  State<StatefulWidget> createState() => UI_U_CartState();
}

class UI_U_CartState extends State<UI_U_Cart> {
  @override
  void initState() {
    super.initState();
  }

  void deleteItem(OrderState snapshot, int index) {
    setState(() {
      if (snapshot.itemList.length > 1) {
        cartCounter = cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
      } else {
        cartCounter = cartCounter - snapshot.itemList[index].number;
        snapshot.removeItem(snapshot.itemList[index]);
        snapshot.itemList.removeAt(index);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UI_U_ServiceList()),
        );
      }
      StoreProvider.of<AppState>(context).dispatch(UpdateOrder(OrderState(
          itemList: snapshot.itemList, date: snapshot.date, position: snapshot.position, total: snapshot.total, business: snapshot.business, user: snapshot.user, businessId: snapshot.businessId, userId: snapshot.userId)));
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, snapshot) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: BuyTimeAppbarUser(
                    width: media.width,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.1),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => UI_U_ServiceList()),
                        ),
                      ),
                      ColorFiltered(
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                        child: Image.network(
                          StoreProvider.of<AppState>(context).state.business.logo,
                          height: media.height * 0.05,
                        ),
                      ),
                      SizedBox(
                        width: 40.0,
                      )
                    ],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                        child: Text(
                          "Ordine presso " + StoreProvider.of<AppState>(context).state.business.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: media.height * 0.025,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: StoreConnector<AppState, OrderState>(
                              converter: (store) => store.state.order,
                              rebuildOnChange: true,
                              builder: (context, snapshot) {
                                print("UI_U_cart" + snapshot.itemList.length.toString());
                                return GridView.builder(
                                  itemCount: snapshot.itemList.length + 1,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: 5,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    final item = (index != snapshot.itemList.length ? snapshot.itemList[index] : null);
                                    return index != snapshot.itemList.length
                                        ? OptimumOrderItemCardMedium(
                                            key: ObjectKey(item),
                                            orderEntry: snapshot.itemList[index],
                                            mediaSize: media,
                                            rightWidget1: Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.remove_shopping_cart,
                                                    color: BuytimeTheme.IconGrey,
                                                  ),
                                                  onPressed: () {
                                                    deleteItem(snapshot, index);
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        : OrderTotal(media: media, orderState: snapshot);
                                  },
                                );
                              }),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // trigger payment information page
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => UI_U_StripePayment()),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: (media.height * 0.05)),
                                  child: Container(
                                    width: media.width * 0.55,
                                    decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text("ORDINA E PAGA", style: TextStyle(color: Colors.white))],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         // trigger payment information page
                          //         print("Dispatch Order create!");
                          //         StoreProvider.of<AppState>(context).dispatch(CreateOrder(OrderState(
                          //             itemList: snapshot.order.itemList,
                          //             date: snapshot.order.date,
                          //             progress: "paid",
                          //             position: snapshot.order.position,
                          //             total: snapshot.order.total,
                          //             business: snapshot.order.business,
                          //             user: snapshot.order.user,
                          //             businessId: snapshot.business.id_firestore)));
                          //         StoreProvider.of<AppState>(context).dispatch(OrderListRequest());
                          //       },
                          //       child: Padding(
                          //         padding: EdgeInsets.only(top: (media.height * 0.05)),
                          //         child: Container(
                          //           width: media.width * 0.55,
                          //           decoration: BoxDecoration(color: Color.fromRGBO(1, 175, 81, 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(8.0),
                          //             child: Row(
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [Icon(Icons.credit_card, color: Colors.white), SizedBox(width: 10.0), Text("Test Order Create", style: TextStyle(color: Colors.white))],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: media.height * 0.05,
                          )
                        ],
                      )
                    ],
                  ));
            }));
  }
}
