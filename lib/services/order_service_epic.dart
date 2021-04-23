import 'dart:convert';
import 'package:Buytime/reblox/model/app_state.dart';
import 'package:Buytime/reblox/model/business/business_state.dart';
import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:Buytime/reblox/model/statistics_state.dart';
import 'package:Buytime/reblox/model/user/snippet/user_snippet_state.dart';
import 'package:Buytime/reblox/reducer/order_list_reducer.dart';
import 'package:Buytime/reblox/reducer/order_reducer.dart';
import 'package:Buytime/reblox/reducer/statistics_reducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

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
              //.where("progress", isEqualTo: "paid")
              .where("businessId", isEqualTo: businessList[i].id_firestore)
              .where("date", isGreaterThanOrEqualTo: currentTime)
              .where("date", isLessThanOrEqualTo: period[1])
              .get();

          read++;

          ordersFirebaseDocs += ordersFirebase.docs.length;
          debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService Firestore request");
          /*ordersFirebase.docs.forEach((element) {
          if(event.userId != "any"){
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.stripe.u){
              orderStateList.add(orderState);
            }
          }
          else{
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.business.ownerId && orderState.businessId == store.state.business.id_firestore){
              orderStateList.add(orderState);
            }
          }
        });*/
          ordersFirebase.docs.forEach((element) {
            OrderState orderState = OrderState.fromJson(element.data());
            orderStateList.add(orderState);
          });
        }
        debugPrint("ORDER_SERVICE_EPIC - OrderListRequestService => OrderListService return list with " + orderStateList.length.toString());

        if(orderStateList.isEmpty)
          orderStateList.add(OrderState());

        statisticsState = store.state.statistics;
        int reads = statisticsState.orderListRequestServiceRead;
        int writes = statisticsState.orderListRequestServiceWrite;
        int documents = statisticsState.orderListRequestServiceDocuments;
        debugPrint('ORDER_SERVICE_EPIC - OrderListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        reads = reads + read;
        documents = documents + ordersFirebaseDocs;
        debugPrint('ORDER_SERVICE_EPIC - OrderListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
        statisticsState.orderListRequestServiceRead = reads;
        statisticsState.orderListRequestServiceWrite = writes;
        statisticsState.orderListRequestServiceDocuments = documents;

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
      /*ordersFirebase.docs.forEach((element) {
          if(event.userId != "any"){
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.stripe.u){
              orderStateList.add(orderState);
            }
          }
          else{
            OrderState orderState = OrderState.fromJson(element.data());
            if(orderState.progress == "paid" && orderState.user.id == store.state.business.ownerId && orderState.businessId == store.state.business.id_firestore){
              orderStateList.add(orderState);
            }
          }
        });*/
      ordersFirebase.docs.forEach((element) {
        OrderState orderState = OrderState.fromJson(element.data());
        orderStateList.add(orderState);
      });
      debugPrint("ORDER_SERVICE_EPIC - UserOrderListRequestService => OrderListService return list with " + orderStateList.length.toString());

      statisticsState = store.state.statistics;
      int reads = statisticsState.orderListRequestServiceRead;
      int writes = statisticsState.orderListRequestServiceWrite;
      int documents = statisticsState.orderListRequestServiceDocuments;
      debugPrint('ORDER_SERVICE_EPIC - UserOrderListRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      reads = reads + read;
      documents = documents + ordersFirebaseDocs;
      debugPrint('ORDER_SERVICE_EPIC - UserOrderListRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderListRequestServiceRead = reads;
      statisticsState.orderListRequestServiceWrite = writes;
      statisticsState.orderListRequestServiceDocuments = documents;

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
     DocumentSnapshot snapshot= await FirebaseFirestore.instance /// 1 READ - 1 DOC
         .collection("order").doc(event.orderStateId).get();

     orderState = OrderState.fromJson(snapshot.data());

     statisticsState = store.state.statistics;
     int reads = statisticsState.orderRequestServiceRead;
     int writes = statisticsState.orderRequestServiceWrite;
     int documents = statisticsState.orderRequestServiceDocuments;
     debugPrint('ORDER_SERVICE_EPIC - OrderRequestService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     ++reads;
     ++documents;
     debugPrint('ORDER_SERVICE_EPIC - OrderRequestService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
     statisticsState.orderRequestServiceRead = reads;
     statisticsState.orderRequestServiceWrite = writes;
     statisticsState.orderRequestServiceDocuments = documents;

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

class OrderCreateService implements EpicClass<AppState> {
  String stripeTestKey = "pk_test_51HS20eHr13hxRBpCZl1V0CKFQ7XzJbku7UipKLLIcuNGh3rp4QVsEDCThtV0l2AQ3jMtLsDN2zdC0fQ4JAK6yCOp003FIf3Wjz";
  String stripeKey = "pk_live_51HS20eHr13hxRBpCLHzfi0SXeqw8Efu911cWdYEE96BAV0zSOesvE83OiqqzRucKIxgCcKHUvTCJGY6cXRtkDVCm003CmGXYzy";
  StatisticsState statisticsState;
  String state = '';
  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
     return actions.whereType<CreateOrder>().asyncMap((event) async {
      OrderState orderState = event.orderState;
      // add needed data to the order state
      int write = 0;
      orderState.user = UserSnippet();
      orderState.user.id = store.state.user.uid;
      orderState.user.name = store.state.user.name;
      orderState.businessId = store.state.business.id_firestore;
      orderState.userId = store.state.user.uid;
      orderState.business.thumbnail = store.state.business.wide;
      store.state.cardListState.cardList.forEach((element) {
        if(element.selected){
          orderState.cardType = element.stripeState.stripeCard.brand;
          orderState.cardLast4Digit = element.stripeState.stripeCard.last4;
        }
      });
      // send document to orders collection
      var addedOrder = await FirebaseFirestore.instance.collection("order/").add(orderState.toJson());
      orderState.orderId = addedOrder.id;
      String addedOrderId = addedOrder.id;
      var url = Uri.https('europe-west1-buytime-458a1.cloudfunctions.net', '/StripePIOnOrder', {'orderId': '$addedOrderId', 'currency': 'EUR'});
      final http.Response response = await http.get(url);
      print("ORDER_SERVICE_EPIC - OrderCreateService => Order_service epic - response is done");
      print('ORDER_SERVICE_EPIC - OrderCreateService => RESPONSE: $response');

      if (response != null && response.body == "Error: could not handle the request\n") {
        // verify why this happens.
        var updatedOrder = await FirebaseFirestore.instance /// 1 WRITE
            .collection("order/").doc(addedOrder.id.toString()).update({
          'progress': "paid",
          'orderId': addedOrder.id
        });
        state = 'paid';
      } else {
        var jsonResponse;
        try{
          jsonResponse = jsonDecode(response.body);
        }catch(e){
          debugPrint('order_service_epic => ERROR: $e');
          state = 'failed';
        }
        /*var jsonResponse;
        if(response.body == 'error'){
          state = 'failed';
        }else{
          var jsonResponse = jsonDecode(response.body);
        }*/
        //jsonResponse = jsonDecode(response.body);
        if(jsonResponse!= null && response.body != "error") {
          print('ORDER_SERVICE_EPIC - OrderCreateService => JSON RESPONSE: $jsonResponse');
          // if an action is required, send the user to the confirmation link
          if (jsonResponse != null && jsonResponse["next_action_url"] != null ) {
            // final Stripe stripe = Stripe(
            //   stripeTestKey, // our publishable key
            //   stripeAccount: jsonResponse["stripeAccount"], // the connected account
            //   returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
            // );
            var clientSecret = jsonResponse["client_secret"];
            // var paymentIntentRes = await confirmPayment3DSecure(clientSecret, jsonResponse["payment_method_id"], stripe);
            // if (paymentIntentRes["status"] == "succeeded") {
            //   ++write;
            //   var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({ /// 1 WRITE
            //     'progress': "paid",
            //     'orderId': addedOrder.id
            //   });
            //   state = 'paid';
            //   //return SetOrderProgress("paid");
            // } else {
            //   state = 'failed';
            //   //return SetOrderProgress("failed");
            // }
          } else {
            ++write;
            var updatedOrder = await FirebaseFirestore.instance.collection("order/").doc(addedOrder.id.toString()).update({ /// 1 WRITE
              'progress': "paid",
              'orderId': addedOrder.id
            });
            state = 'paid';
            //return SetOrderProgress("paid");
          }
        }
        else {
          state = 'failed';
          //return SetOrderProgress("failed");
        }
      }

      statisticsState = store.state.statistics;
      int reads = statisticsState.orderCreateServiceRead;
      int writes = statisticsState.orderCreateServiceWrite;
      int documents = statisticsState.orderCreateServiceDocuments;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      writes = writes + write;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;

     }).expand((element) => [
       SetOrderProgress(state),
       UpdateStatistics(statisticsState),
     ]);
  }
}

class AddingStripePaymentMethodRequest implements EpicClass<AppState> {
  StatisticsState statisticsState;
  String state = '';
  http.Response response;

  @override
  Stream call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<AddingStripePaymentMethodWithNavigation>().asyncMap((event) async {
      String userId = event.userId;
      var stripeCustomerSetupIntentCreationReference = await FirebaseFirestore.instance.collection("stripeCustomer/" + userId + "_test/setupIntent").doc() ///TODO Remember _test
        .set({ ///1 WRITE
      'status': "create request"
    });
    // now http request to create the actual setupIntent
    //response = await http.post('https://europe-west1-buytime-458a1.cloudfunctions.net/createSetupIntent?userId=' + userId);
      var url = Uri.https('europe-west1-buytime-458a1.cloudfunctions.net', '/createSetupIntent', {'userId': '$userId'});
      response = await http.get(url);

      statisticsState = store.state.statistics;
      /*statisticsState = store.state.statistics;
      int reads = statisticsState.orderCreateServiceRead;
      int writes = statisticsState.orderCreateServiceWrite;
      int documents = statisticsState.orderCreateServiceDocuments;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService => BEFORE| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      ++writes;
      debugPrint('ORDER_SERVICE_EPIC - OrderCreateService =>  AFTER| READS: $reads, WRITES: $writes, DOCUMENTS: $documents');
      statisticsState.orderCreateServiceRead = reads;
      statisticsState.orderCreateServiceWrite = writes;
      statisticsState.orderCreateServiceDocuments = documents;*/

      debugPrint('order_service_epic: RESPONSE: ${response.statusCode}');

    }).expand((element) => [
      //SetOrderProgress(state),,
      response.statusCode == 200 ? AddedStripePaymentMethodAndNavigate() : AddedStripePaymentMethod(),
      UpdateStatistics(statisticsState),
      //response.statusCode == 200 ? NavigatePopAction() : AddedStripePaymentMethod(),

    ]);
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
