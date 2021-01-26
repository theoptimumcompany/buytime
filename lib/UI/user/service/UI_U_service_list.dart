import 'dart:async';
import 'dart:core';
import 'package:Buytime/UI/user/business/UI_U_business_list.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_list_state.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/service_list_reducer.dart';
import 'package:Buytime/reusable/appbar/user_buytime_appbar.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/reusable/service/optimum_service_card_medium.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UI_U_ServiceList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UI_U_ServiceListState();
}

class UI_U_ServiceListState extends State<UI_U_ServiceList> {
  OrderState order = OrderState(itemList: List<OrderEntry>(), date: DateTime.now(), position: "", total: 0.0, business: BusinessSnippet().toEmpty(), user: UserSnippet().toEmpty(), businessId: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(ServiceListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore, 'user')),
        builder: (context, snapshot) {
          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : order) : order;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: BuytimeAppbarUser(
              width: media.width,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, color: Colors.white, size: media.width * 0.1),
                  onPressed: () => Navigator.pop(context),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.linearToSrgbGamma(),
                  child: Image.network(
                    StoreProvider.of<AppState>(context).state.business.logo,
                    height: media.height * 0.05,
                  ),
                ),
                cartCounter > 0
                    ? Badge(
                        badgeColor: Color.fromRGBO(255, 99, 99, 1.0),
                        badgeContent: Text(
                          cartCounter.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        position: BadgePosition.bottomStart(),
                        child: CartIconAppBar(order: order),
                      )
                    : CartIconAppBar()
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                  child: Text(
                    StoreProvider.of<AppState>(context).state.business.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: media.height * 0.035,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 10.0),
                  child: Text(
                    "I nostri servizi",
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
                    child: StoreConnector<AppState, AppState>(
                        converter: (store) => store.state,
                        builder: (context, snapshot) {
                          List<ServiceState> serviceList = snapshot.serviceList.serviceListState;
                          return serviceList != null
                              ? serviceList.length > 0
                                  ? GridView.count(
                                      crossAxisCount: 1,
                                      childAspectRatio: 4.3,
                                      children: List.generate(serviceList.length, (index) {
                                        print("UI_U_service_list Numero " + serviceList.length.toString());
                                        return serviceList[index].visibility == 'Visible'
                                            ? OptimumServiceCardMedium(
                                                rightWidget1: Column(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.add_shopping_cart,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        order.business.name = snapshot.business.name;
                                                        order.business.id = snapshot.business.id_firestore;
                                                        order.user.name = snapshot.user.name;
                                                        order.user.id = snapshot.user.uid;
                                                        order.addItem(serviceList[index], snapshot.business.ownerId);
                                                        setState(() {
                                                          cartCounter++;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                                imageUrl: serviceList[index].thumbnail,
                                                mediaSize: media,
                                                serviceState: serviceList[index],
                                                onServiceCardTap: (serviceState) {},
                                              )
                                            : OptimumServiceCardMedium(
                                                greyScale: true,
                                                imageUrl: serviceList[index].thumbnail,
                                                mediaSize: media,
                                                serviceState: serviceList[index],
                                                onServiceCardTap: (serviceState) {},
                                              );
                                      }),
                                    )
                                  : Center(
                                      child: Text("Non ci sono servizi in questo business!"),
                                    )
                              : Center(
                                  child: Text("Non ci sono servizi in questo business!"),
                                );
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class CartIconAppBar extends StatelessWidget {
  const CartIconAppBar({
    Key key,
    @required this.order,
  }) : super(key: key);

  final OrderState order;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
        size: 35.0,
      ),
      onPressed: () {
        if (cartCounter > 0) {
          // dispatch the order
          StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
          // go to the cart page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UI_U_Cart()),
          );
        } else {
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Attenzione!"),
                    content: new Text("Il carrello è vuoto! Scegli prima un servizio dall'elenco sottostante."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
      },
    );
  }
}
