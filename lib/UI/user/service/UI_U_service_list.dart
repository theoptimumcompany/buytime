import 'dart:core';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/reducer/service/service_list_reducer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Buytime/UI/user/cart/UI_U_cart.dart';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/snippet/business_snippet_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/order/order_entry.dart';
import 'package:Buytime/reblox/model/service/service_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reusable/appbar/buytime_appbar.dart';
import 'package:Buytime/utils/globals.dart';
import 'package:Buytime/reusable/service/optimum_service_card_medium.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ServiceList extends StatefulWidget {
  BusinessState businessState;
  ServiceList(this.businessState);
  @override
  State<StatefulWidget> createState() => ServiceListState();
}

class ServiceListState extends State<ServiceList> {
  OrderState order = OrderState().toEmpty();

  bool startRequest = false;
  bool noActivity = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        //onInit: (store) => store.dispatch(ServiceListRequest(StoreProvider.of<AppState>(context).state.business.id_firestore, 'user')),
        onInit: (store){
          store.dispatch(ServiceListRequest(widget.businessState.id_firestore, 'user'));
        },
        builder: (context, snapshot) {
          order = snapshot.order.itemList != null ? (snapshot.order.itemList.length > 0 ? snapshot.order : OrderState().toEmpty()) : OrderState().toEmpty();
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: BuytimeAppbar(
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
                order.cartCounter > 0
                    ? Badge(
                        badgeColor: Color.fromRGBO(255, 99, 99, 1.0),
                        badgeContent: Text(
                          order.cartCounter.toString(),
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
                    AppLocalizations.of(context).ourServices,
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
                                        return serviceList[index].visibility == 'Active'
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
                                                        // order.addItem(serviceList[index], snapshot.business.ownerId, context);
                                                        if (!order.addingFromAnotherBusiness(serviceList[index].businessId)) {
                                                          order.addItem(serviceList[index], snapshot.business.ownerId, context);
                                                          order.cartCounter++;
                                                          StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                        } else {
                                                          showDialog(
                                                              context: context,
                                                              builder: (_) => AlertDialog(
                                                                title: Text(AppLocalizations.of(context).doYouWantToPerformAnotherOrder),
                                                                content: Text(AppLocalizations.of(context).youAreAboutToPerformAnotherOrder),
                                                                actions: <Widget>[MaterialButton(
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
                                                                        order.removeItem(order.itemList[i]);
                                                                      }
                                                                      order.itemList = [];
                                                                      order.cartCounter = 0;
                                                                      order.addItem(serviceList[index], snapshot.business.ownerId, context);
                                                                      order.cartCounter = 1;
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                  )
                                                                ],
                                                              ));
                                                        }
                                                        // order.cartCounter++;
                                                        // //StoreProvider.of<AppState>(context).dispatch(SetOrderCartCounter(order.cartCounter));
                                                        // StoreProvider.of<AppState>(context).dispatch(SetOrder(order));
                                                      },
                                                    )
                                                  ],
                                                ),
                                                imageUrl: serviceList[index].image1,
                                                mediaSize: media,
                                                serviceState: serviceList[index],
                                                onServiceCardTap: (serviceState) {},
                                              )
                                            : OptimumServiceCardMedium(
                                                greyScale: true,
                                                imageUrl: serviceList[index].image1,
                                                mediaSize: media,
                                                serviceState: serviceList[index],
                                                onServiceCardTap: (serviceState) {},
                                              );
                                      }),
                                    )
                                  : Center(
                                      child: Text(AppLocalizations.of(context).thereAreNoServicesInThisBusiness),
                                    )
                              : Center(
                                  child: Text(AppLocalizations.of(context).thereAreNoServicesInThisBusiness),
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
      key: Key('cart_key'),
      icon: const Icon(
        Icons.shopping_cart,
        color: Colors.white,
        size: 35.0,
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
    );
  }
}
