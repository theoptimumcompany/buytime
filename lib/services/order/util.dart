import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:redux_epics/redux_epics.dart';

/// constructs the order based on the information in the store
OrderState configureOrder(OrderState orderStateFromEvent, EpicStore<AppState> store) {
  OrderState orderState = orderStateFromEvent;
  // add needed data to the order state
  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
    if(eBL.id_firestore == orderStateFromEvent.itemList.first.id_business){
      isExternal = true;
      externalBusinessState = eBL;
    }
  });
  int write = 0;
  orderState.user = UserSnippet();
  orderState.user.id = store.state.user.uid;
  orderState.user.name = store.state.user.name;
  orderState.userId = store.state.user.uid;

  if(isExternal){
    orderState.businessId = externalBusinessState.id_firestore;
    orderState.business.thumbnail = externalBusinessState.wide;
  }else{
    orderState.businessId = store.state.business.id_firestore;
    orderState.business.thumbnail = store.state.business.wide;
  }

  store.state.cardListState.cardList.forEach((element) {
    if(element.selected){
      orderState.cardType = element.stripeState.stripeCard.brand;
      orderState.cardLast4Digit = element.stripeState.stripeCard.last4;
    }
  });
  return orderState;
}

/// constructs the order based on the information in the store
OrderReservableState configureOrderReservable(OrderReservableState orderStateFromEvent, EpicStore<AppState> store) {
  OrderReservableState orderState = orderStateFromEvent;
  // add needed data to the order state
  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
    if(eBL.id_firestore == orderStateFromEvent.itemList.first.id_business){
      isExternal = true;
      externalBusinessState = eBL;
    }
  });
  int write = 0;
  orderState.user = UserSnippet();
  orderState.user.id = store.state.user.uid;
  orderState.user.name = store.state.user.name;
  orderState.userId = store.state.user.uid;

  if(isExternal){
    orderState.businessId = externalBusinessState.id_firestore;
    orderState.business.thumbnail = externalBusinessState.wide;
  }else{
    orderState.businessId = store.state.business.id_firestore;
    orderState.business.thumbnail = store.state.business.wide;
  }

  store.state.cardListState.cardList.forEach((element) {
    if(element.selected){
      orderState.cardType = element.stripeState.stripeCard.brand;
      orderState.cardLast4Digit = element.stripeState.stripeCard.last4;
    }
  });
  return orderState;
}

OrderReservableState orderReservableInitialization(dynamic event, int i) {
  return OrderReservableState(
    position: event.orderReservableState.position,
    date: event.orderReservableState.itemList[i].date,
    itemList: [event.orderReservableState.itemList[i]],
    total: event.orderReservableState.itemList[i].price,
    tip: event.orderReservableState.tip,
    tax: event.orderReservableState.tax,
    taxPercent: event.orderReservableState.taxPercent,
    amount: 1,
    progress: event.orderReservableState.progress,
    addCardProgress: event.orderReservableState.addCardProgress,
    navigate: event.orderReservableState.navigate,
    businessId: event.orderReservableState.businessId,
    userId: event.orderReservableState.userId,
    business: event.orderReservableState.business,
    user: event.orderReservableState.user,
    selected: [event.orderReservableState.selected[i]],
    cartCounter: event.orderReservableState.cartCounter,
    serviceId: event.orderReservableState.serviceId,
  );
}