import 'dart:convert';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/business/external_business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/stripe/stripe_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:Buytime/services/statistic/util.dart';
import 'package:Buytime/services/stripe_payment_service_epic.dart';
import 'package:Buytime/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import 'order/util.dart';

List<DateTime> getPeriod(DateTime dateTime){
  //String weekdayDate = DateFormat('E d M y').format(dateTime);
  String weekday = DateFormat('E').format(dateTime);

  int unix = dateTime.millisecondsSinceEpoch;

  //String period = '';
  List<DateTime> period = [];

  if('Mon' == weekday) {
    period = getStringPeriod(unix, 0, 6);
  }else if('Tue' == weekday){
    period = getStringPeriod(unix, 1, 5);
  }else if('Wed' == weekday){
    period = getStringPeriod(unix, 2, 4);
  }else if('Thu' == weekday){
    period = getStringPeriod(unix, 3, 3);
  }else if('Fri' == weekday){
    period = getStringPeriod(unix, 4, 2);
  }else if('Sat' == weekday){
    period = getStringPeriod(unix, 5, 1);
  }else{
    period = getStringPeriod(unix, 6, 0);
  }

  debugPrint('ORDER_SERVICE_EPIC => Period: $period');

  return period;
}

List<DateTime> getStringPeriod(int unix, startValue, endValue){
  int startUnix = unix - (86400000 * startValue);
  int endUnix =  unix + (86400000 * endValue);
  debugPrint('startUnix: $startUnix - endUnix: $endUnix');
  DateTime startStringUnix = DateTime.fromMillisecondsSinceEpoch(startUnix, isUtc: true);
  DateTime endStringUnix = DateTime.fromMillisecondsSinceEpoch(endUnix, isUtc: true);
  return [startStringUnix, endStringUnix];
}

class OrderListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<OrderState> orderStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  CATCHED ACTION");
     return actions.whereType<OrderListRequest>().asyncMap((event) async {
       //debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  USER ID: ${store.state.user.uid}");
       //debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  BUSINESS ID: ${store.state.business.id_firestore}");
        String userId = store.state.business.id_firestore;
        List<BusinessState> businessList = store.state.businessList.businessListState;
        DateTime currentTime = DateTime.now();
        currentTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, 0, 0, 0, 0, 0).toUtc();
        debugPrint('ORDER_SERVICE_EPIC => current Time: $currentTime');
        List<DateTime> period = getPeriod(currentTime);
        orderStateList = [];
        int ordersFirebaseDocs = 0;
        int read = 0;
        for(int i = 0; i < businessList.length; i++){
          debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  BUSINESS ID: ${businessList[i].id_firestore}");
          QuerySnapshot ordersFirebase = await FirebaseFirestore.instance.collection("order") /// 1 READ - ? DOC
              .where("businessId", isEqualTo: businessList[i].id_firestore)
              .where("date", isGreaterThanOrEqualTo: currentTime)
              .where("date", isLessThanOrEqualTo: period[1])
              .get();

          read++;

          ordersFirebaseDocs += ordersFirebase.docs.length;
          debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService Firestore request");
          ordersFirebase.docs.forEach((element) {
            OrderState orderState = OrderState.fromJson(element.data());
            orderStateList.add(orderState);
          });
        }
        debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService return list with " + orderStateList.length.toString());

        if(orderStateList.isEmpty)
          orderStateList.add(OrderState());
        statisticsComputation();
        ///Return
        //return new OrderListReturned(orderStateList);
     }).expand((element) => [
       OrderListReturned(orderStateList),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class UserOrderListRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  List<OrderState> orderStateList;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService =>  CATCHED ACTION");
    return actions.whereType<UserOrderListRequest>().asyncMap((event) async {
      //debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService =>  USER ID: ${store.state.user.uid}");
      debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService =>  BUSINESS ID: ${store.state.business.id_firestore}");

      DateTime currentTime = DateTime.now();
      //currentTime = new DateTime(currentTime.year, currentTime.month - 1, currentTime.day, 0, 0, 0, 0, 0).toUtc();
      debugPrint('order_service_epic => current Time: $currentTime');
      List<DateTime> period = getPeriod(currentTime);
      orderStateList = [];
      int ordersFirebaseDocs = 0;
      int read = 0;
      currentTime = currentTime.subtract(Duration(days: 15));
      //debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService =>  BUSINESS ID: ${businessList[i].id_firestore}");
      QuerySnapshot ordersFirebase = await FirebaseFirestore.instance.collection("order") /// 1 READ - ? DOC
          //.where("progress", isEqualTo: "paid")
          //.where("progress", whereIn: ['paid',"pending"])
          .where("businessId", isEqualTo: store.state.business.id_firestore)
          .where("userId", isEqualTo: store.state.user.uid)
          .where("date", isGreaterThanOrEqualTo: currentTime)
          .limit(50)
          .get();

      read++;

      ordersFirebaseDocs += ordersFirebase.docs.length;
      debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService => OrderListService Firestore request");
      ordersFirebase.docs.forEach((element) {
        OrderState orderState = OrderState.fromJson(element.data());
        orderStateList.add(orderState);
      });
      debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService => OrderListService return list with " + orderStateList.length.toString());
      statisticsComputation();

      ///Return
      //return new OrderListReturned(orderStateList);
    }).expand((element) => [
      OrderListReturned(orderStateList),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class OrderRequestService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  OrderState orderState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<OrderRequest>().asyncMap((event) async{
      debugPrint("ORDER_SERVICE_EPIC - OrderRequestService => OrderRequest requests document id:" + event.orderStateId);
     DocumentSnapshot snapshot= await FirebaseFirestore.instance.collection("order").doc(event.orderStateId).get();
     orderState = OrderState.fromJson(snapshot.data());
     statisticsComputation();
    }).expand((element) => [
      OrderRequestResponse(orderState),
      UpdateStatistics(statisticsState),
    ]);
  }
}

class OrderUpdateByManagerService implements EpicClass<AppState> {
  OrderState orderState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateOrderByManager>().asyncMap((event) async{
    //   if (event.serviceState.fileToUploadList != null) {
    //     uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
    //       return updateService(updatedServiceState);
    //     });
    //   }
    //   return updateService(event.serviceState);

      print("ORDER_SERVICE_EPIC - OrderUpdateService => ORDER ID: ${event.orderState.orderId}");

      orderState = event.orderState;

      await FirebaseFirestore.instance /// 1 WRITE
          .collection("order")
          .doc(event.orderState.orderId)
          .update(event.orderState.toJson());
     }).expand((element) => [
       UpdatedOrder(orderState)
    ]);
  }
}

class OrderUpdateService implements EpicClass<AppState> {
  OrderState orderState;
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<UpdateOrder>().asyncMap((event) async{
    //   if (event.serviceState.fileToUploadList != null) {
    //     uploadFiles(event.serviceState.fileToUploadList, event.serviceState).then((ServiceState updatedServiceState) {
    //       return updateService(updatedServiceState);
    //     });
    //   }
    //   return updateService(event.serviceState);

      /*print("ORDER_SERVICE_EPIC - OrderUpdateService => ORDER ID: ${event.orderState.orderId}");

      orderState = event.orderState;

      await FirebaseFirestore.instance /// 1 WRITE
          .collection("order")
          .doc(event.orderState.orderId)
          .update(event.orderState.toJson());*/
     }).expand((element) => [
       UpdatedOrder(orderState)
    ]);
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class OrderCreateNativeAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrderNativeAndPay>().asyncMap((event) async {
      /// add needed data to the order state
      OrderState orderState = configureOrder(event.orderState, store);
      if(event.paymentMethod != null) {
        /// send document to orders collection
        var addedOrder = await FirebaseFirestore.instance.collection("order/").add(orderState.toJson());
        /// update the order id locally
        orderState.orderId = addedOrder.id;
        /// add the payment method to the order sub collection on firebase
        var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderState.orderId + "/orderPaymentMethod").add({
          'paymentMethodId' : event.paymentMethod.id,
          'last4': event.paymentMethod.card.last4 ?? '',
          'brand': event.paymentMethod.card.brand ?? '',
          'type':  Utils.enumToString(event.paymentType),
          'country': event.paymentMethod.card.country  ?? 'US',
          'booking_id': store.state.booking.booking_id
        });
        StripePaymentService stripePaymentService = StripePaymentService();
        paymentResult = await stripePaymentService.processPaymentAsDirectCharge(orderState.orderId);
      }
      statisticsComputation();
     }).expand((element) {
       var actionArray = [];
       actionArray.add(CreatedOrder());
       actionArray.add(UpdateStatistics(statisticsState));
       if (paymentResult == "success") {
         actionArray.add(SetOrderProgress(Utils.enumToString(OrderStatus.paid)));
       } else {
         actionArray.add(SetOrderProgress(Utils.enumToString(OrderStatus.canceled)));
       }
       return actionArray;
     });
  }
}
/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class OrderCreateCardAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrderCardAndPay>().asyncMap((event) async {
      /// add needed data to the order state
      OrderState orderState = configureOrder(event.orderState, store);
      if(event.selectedCardPaymentMethodId != null && store.state.booking != null && store.state.booking.booking_id != null) {
        /// send document to orders collection
        var addedOrder = await FirebaseFirestore.instance.collection("order/").add(orderState.toJson());
        /// update the order id locally
        orderState.orderId = addedOrder.id;
        /// add the payment method to the order sub collection on firebase
        var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderState.orderId + "/orderPaymentMethod").add({
          'paymentMethodId' : event.selectedCardPaymentMethodId,
          'last4': event.last4 ?? '',
          'brand': event.brand ?? '',
          'type':  Utils.enumToString(event.paymentType),
          'country': event.country ?? 'US',
          'booking_id': store.state.booking.booking_id
        });
        StripePaymentService stripePaymentService = StripePaymentService();
        paymentResult = await stripePaymentService.processPaymentAsDirectCharge(orderState.orderId);
      }
      statisticsComputation();
     }).expand((element) {
       var actionArray = [];
       actionArray.add(CreatedOrder());
       actionArray.add(UpdateStatistics(statisticsState));
       if (paymentResult == "success") {
         actionArray.add(SetOrderProgress(Utils.enumToString(OrderStatus.paid)));
       } else {
         actionArray.add(SetOrderProgress(Utils.enumToString(OrderStatus.canceled)));
       }
       return actionArray;
     });
  }
}

/// an order always have to be created with a payment method attached in its subcollection
/// TODO: research if there is a way to make this two operations in an atomic way
class OrderCreateRoomAndPayService implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  String paymentResult = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrderRoomAndPay>().asyncMap((event) async {
      /// add needed data to the order state
      OrderState orderState = configureOrder(event.orderState, store);
      orderState.cardType = Utils.enumToString(PaymentType.room);
      /// send document to orders collection
      var addedOrder = await FirebaseFirestore.instance.collection("order/").add(orderState.toJson());
      /// update the order id locally
      orderState.orderId = addedOrder.id;
      /// add the payment method to the order sub collection on firebase
      var addedPaymentMethod = await FirebaseFirestore.instance.collection("order/" + orderState.orderId + "/orderPaymentMethod").add({
        'paymentMethodId' : '',
        'last4': '',
        'brand': '',
        'type':  Utils.enumToString(event.paymentType),
        'country': '',
        'bookingId': store.state.booking.booking_id
      });
      statisticsComputation();
     }).expand((element) {
       var actionArray = [];
       actionArray.add(CreatedOrder());
       actionArray.add(UpdateStatistics(statisticsState));
       actionArray.add(SetOrderProgress(Utils.enumToString(OrderStatus.toBePaidAtCheckout)));
       return actionArray;
     });
  }
}

class OrderDeleteService implements EpicClass<AppState> {
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<DeleteOrder>().asyncMap((event) {
//      return FirebaseFirestore.instance.collection('business').doc(store.state.business.id_firestore).collection('service').doc(serviceId).delete();
    });
  }
}
