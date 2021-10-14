import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_reservable_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_reservable_reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux_epics/redux_epics.dart';

/// constructs the order based on the information in the store
OrderState configureOrder(OrderState orderStateFromEvent, AppState state) {
  OrderState orderState = orderStateFromEvent;
  // add needed data to the order state
  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  state.externalBusinessList.externalBusinessListState.forEach((eBL) {
    if (eBL.id_firestore == orderStateFromEvent.itemList.first.id_business) {
      isExternal = true;
      externalBusinessState = eBL;
    }
  });
  int write = 0;
  orderState.user = UserSnippet();
  orderState.user.id = state.user.uid;
  orderState.user.name = state.user.name;
  orderState.user.email = state.user.email;
  orderState.userId = state.user.uid;

  if (isExternal) {
    orderState.businessId = externalBusinessState.id_firestore;
    orderState.business.thumbnail = externalBusinessState.wide;
  } else {
    orderState.businessId = state.business.id_firestore;
    orderState.business.thumbnail = state.business.wide;
    if( orderState.businessId.isEmpty || orderState.businessId == '') {
      orderState.businessId = orderState.itemList.first.id_business;
      orderState.business.id = orderState.itemList.first.id_business;
    }
  }
  if (state.cardListState.cardList != null) {
    state.cardListState.cardList.forEach((element) {
      if (element.selected) {
        orderState.cardType = element.stripeState.stripeCard.brand;
        orderState.cardLast4Digit = element.stripeState.stripeCard.last4;
      }
    });
  } else {
    orderState.cardType = '';
    orderState.cardLast4Digit = '';
  }

  if( orderState.businessId.isEmpty || orderState.businessId == '') {
    debugPrint("configureOrder sicuramente dovrebbe funzionare ma il business id é vuoto anche qui " );
    orderState.businessId = orderState.itemList[0].id_business;
    orderState.business.id = orderState.itemList[0].id_business;
    debugPrint("configureOrder sicuramente dovrebbe funzionare " + orderState.businessId);
  }

  /// set the creation date
  orderState.creationDate = DateTime.now().toUtc();
  return orderState;
}

/// constructs the order based on the information in the store
OrderReservableState configureOrderReservable(OrderReservableState orderStateFromEvent, EpicStore<AppState> store) {
  OrderReservableState orderState = orderStateFromEvent;
  // add needed data to the order state
  bool isExternal = false;
  ExternalBusinessState externalBusinessState;
  store.state.externalBusinessList.externalBusinessListState.forEach((eBL) {
    if (eBL.id_firestore == orderStateFromEvent.itemList.first.id_business) {
      isExternal = true;
      externalBusinessState = eBL;
    }
  });
  int write = 0;
  orderState.user = UserSnippet();
  orderState.user.id = store.state.user.uid;
  orderState.user.name = store.state.user.name;
  orderState.user.email = store.state.user.email;
  orderState.userId = store.state.user.uid;

  ///TODO: Maneggiare store per tirare fuori orario chiusura della giornata
  List<dynamic> slotService = store.state.serviceState.serviceSlot;
  var closure = '--:--';
  DateTime current = DateTime.now();
  for (var i = 0; i < slotService.length; i++) {
    List<String> slotStopTimeArray = slotService[i].stopTime;
    for (var j = 0; j < slotStopTimeArray.length; j++) {
      DateTime loopTime = DateTime(2020, 02, 20, int.parse(slotStopTimeArray[j].split(":").first), int.parse(slotStopTimeArray[j].split(":").last));
      if (closure == '--:--') {
        current = loopTime;
        closure = '';
      } else {
        var diff = current.difference(loopTime).inMinutes;
        if (diff < 0) {
          current = loopTime;
        }
      }
    }
  }
  orderState.openUntil = closure == '' ? ((current.hour < 10 ? '0' + current.hour.toString() : current.hour.toString()) + ":" + (current.minute < 10 ? '0' + current.minute.toString() : current.minute.toString())) : closure;

  if (isExternal) {
    orderState.businessId = externalBusinessState.id_firestore;
    orderState.business.id = externalBusinessState.id_firestore;
    orderState.business.thumbnail = externalBusinessState.wide;
  } else {
    orderState.businessId = store.state.business.id_firestore;
    orderState.business.id = store.state.business.id_firestore;
    orderState.business.thumbnail = store.state.business.wide;

    store.state.serviceListSnippetListState.serviceListSnippetListState.forEach((element) {
      if(orderState.itemList.first.id_business == element.businessId){
        orderState.businessId = element.businessId;
        orderState.business.id = element.businessId;
        orderState.business.thumbnail = element.businessImage;
      }
    });
  }

  if(store.state.cardListState != null  && store.state.cardListState.cardList != null && store.state.cardListState.cardList.isNotEmpty) {
    store.state.cardListState.cardList.forEach((element) {
      if (element.selected) {
        orderState.cardType = element.stripeState.stripeCard.brand;
        orderState.cardLast4Digit = element.stripeState.stripeCard.last4;
      }
    });
  }

  if( orderState.businessId.isEmpty || orderState.businessId == '') {
    debugPrint("configureOrder sicuramente dovrebbe funzionare ma il business id é vuoto anche qui " );
    orderState.businessId = orderState.itemList[0].id_business;
    orderState.business.id = orderState.itemList[0].id_business;
    debugPrint("configureOrder sicuramente dovrebbe funzionare " + orderState.businessId);
  }

  /// set the creation date
  orderState.creationDate = DateTime.now().toUtc();
  return orderState;
}

OrderReservableState orderReservableInitialization(dynamic event, int i) {
  DateTime tmpDate = event.orderReservableState.itemList[i].date;
  tmpDate = DateTime(tmpDate.year, tmpDate.month, tmpDate.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second, DateTime.now().millisecond, DateTime.now().microsecond);
  return OrderReservableState(
    totalPromoDiscount: event.orderReservableState.totalPromoDiscount,
    carbonCompensation: event.orderReservableState.carbonCompensation,
    cancellationReason: event.orderReservableState.cancellationReason,
    cardLast4Digit: event.orderReservableState.cardLast4Digit,
    cardType: event.orderReservableState.cardType,
    confirmOrderWait: event.orderReservableState.confirmOrderWait,
    creationDate: event.orderReservableState.creationDate,
    position: event.orderReservableState.position,
    date: event.orderReservableState.itemList[i].date,
    itemList: [event.orderReservableState.itemList[i]],
    total: event.orderReservableState.itemList[i].price - (event.orderReservableState.totalPromoDiscount/event.orderReservableState.itemList.length),
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